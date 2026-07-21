Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811C1436BC6;
	Tue, 21 Jul 2026 19:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663862; cv=none; b=U2vydvX2z14GffNfm+EVUnzbyO3NdjsErBfjsQ9ic2QDCE+OvBwOBNfFVgbkQzcLz3QvxuAYaKrbx8Gl72UcQSaVuzycuk0K2QidmUP1Mk77tsSeIKPTQx4GgS+9ATUoaD3XHYMJQNAw0AVQDfcks6ulp29Wgw1KXXOTBVIRbtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663862; c=relaxed/simple;
	bh=XBjuDnhT4pA0l1b1v+2Lny030djbz8I8eezuud1bv1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G5zSpj21ArbOdaYsPIG+BvkYAbYeZznYDOnT6cKEWj5rXRk4K/nseL87mxpS36aETWi9uaIDUCZ1QP4oD8kCw5oqL6OcEYHQyAUzF7myLugoQ6KpErVIm/iuu5ncwNDtdMzYWP4q7ZoVudDGvUe3UQBamf7EO9/RQUSLy9sG9tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q7IIhrQO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q7IIhrQO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA4FE1F000E9;
	Tue, 21 Jul 2026 19:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663861;
	bh=AQodMFzlmY7wKm+ZsOPGPqf1BtDYF6ToVt10PdeMPik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q7IIhrQOrJlE1JMoWWH0iT3lpEPj959th+V/sCY3XkGt5dZ1frXh9ffFihJG028Tr
	 RnFmlTxZUDvHatATpOaPFM/D49E57DxXOvHsCkPIlWe4yMLU8qXzjDJxgzCIF/8v7U
	 wTC7fjIdZMTjHsU0FgqeHjXsFlhQDSqs6hZbCi8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaewon Yang <yong010301@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.12 0984/1276] tpm: Make the TPM character devices non-seekable
Date: Tue, 21 Jul 2026 17:23:47 +0200
Message-ID: <20260721152508.035897100@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaewon Yang <yong010301@gmail.com>

commit f20d61c22bcaf172d6790b6500e3838e532e71c8 upstream.

The TPM character devices expose a sequential command/response
interface, but their open handlers leave FMODE_PREAD and FMODE_PWRITE
enabled.

After a command leaves a response pending, pread(fd, buf, 16, 0x1400)
passes 0x1400 as *off to tpm_common_read(). The transfer length is
bounded by response_length, but the offset is used unchecked when
forming data_buffer + *off. A sufficiently large offset therefore causes
an out-of-bounds heap read through copy_to_user() and, if the copy
succeeds, an out-of-bounds zero-write through the following memset().

Positional I/O does not provide coherent semantics for this interface.
An arbitrary pread offset cannot represent how much of a response has
been consumed sequentially. The write callback always stores a command
at the start of data_buffer, while pwrite() does not update file->f_pos
and can leave the sequential read cursor stale.

Call nonseekable_open() from both open handlers. This removes
FMODE_PREAD and FMODE_PWRITE, causing positional reads and writes to
fail with -ESPIPE before reaching the TPM callbacks, and explicitly
marks the files non-seekable. Normal read() and write() continue to use
the existing sequential f_pos cursor, leaving the response state machine
unchanged.

Tested on Linux 6.12 with KASAN and a swtpm TPM2 device:

 - sequential partial reads returned the complete response
 - pread() and preadv() with offset 0x1400 returned -ESPIPE
 - pwrite() and pwritev() with offset zero returned -ESPIPE
 - the pending response remained intact after the rejected operations
 - a subsequent normal command/response cycle completed normally
 - no KASAN report was produced.

Fixes: 9488585b21be ("tpm: add support for partial reads")
Link: https://lore.kernel.org/all/20260710090217.191289-1-yong010301@gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Jaewon Yang <yong010301@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm-dev.c   |    2 +-
 drivers/char/tpm/tpmrm-dev.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/char/tpm/tpm-dev.c
+++ b/drivers/char/tpm/tpm-dev.c
@@ -36,7 +36,7 @@ static int tpm_open(struct inode *inode,
 
 	tpm_common_open(file, chip, priv, NULL);
 
-	return 0;
+	return nonseekable_open(inode, file);
 
  out:
 	clear_bit(0, &chip->is_open);
--- a/drivers/char/tpm/tpmrm-dev.c
+++ b/drivers/char/tpm/tpmrm-dev.c
@@ -29,7 +29,7 @@ static int tpmrm_open(struct inode *inod
 
 	tpm_common_open(file, chip, &priv->priv, &priv->space);
 
-	return 0;
+	return nonseekable_open(inode, file);
 }
 
 static int tpmrm_release(struct inode *inode, struct file *file)


