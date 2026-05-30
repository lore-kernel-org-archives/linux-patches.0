Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7B83B1EC0;
	Sat, 30 May 2026 17:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163206; cv=none; b=VNIcrsqI2cqJiKcvOZOWlvZIVg1D3YqXnvlPLx8rml4xc1pEhCxXIVXwwvzgreb1lqizDarwrLkCF+Q12N+w0MJt8oGib2D7krmkFQz3ZyRfIv3giFasKb7QFhIMDEWssDVQ4GZLX7mTwQpgmwDSqolMmuJQEXLniAXs6UuJts8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163206; c=relaxed/simple;
	bh=l9gIQo2h2eFCxjsZQdQE8iOeO3klFaAcSC8rUi8FenQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CcXh5QJF+CZCgBAGBMU9C9pQqtxItmgzobIYAnvapy4yotKA8q7Rm093Dn6pBHKzbkSLSPi/pQ19PN6z1kCsmkB8oCxDF0umSZbnDM0j3uURLqYIRui/qhSEqfeSpXfkP+Ej6peAkGLrA9aU3BMpIIFEav0691E7DUgJ4qQD0O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mp69TBpz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mp69TBpz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D80D1F00893;
	Sat, 30 May 2026 17:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163205;
	bh=gsHyBu+U1LFB9EyGEdacvZBaNNBIHXdGMoijWoZgIkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mp69TBpzJYbegC+g0x5CK4EoH1MDLp1AnvriHGSBUKRFVy98AReL5gLoweHJJMhjA
	 ftWNG2Hnyxu84SG9O8HjcVXeteEUBoBuOfJpEXoGnNK6hiwi4n986a9DbiehH83hnk
	 LlL/x4+t/MQxYeSjAZwoPvsQM0FhQyxNevtgg6NA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Tyllis Xu <LivelyCarpet87@gmail.com>
Subject: [PATCH 5.15 188/776] ibmasm: fix OOB reads in command_file_write due to missing size checks
Date: Sat, 30 May 2026 17:58:22 +0200
Message-ID: <20260530160245.359107578@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyllis Xu <livelycarpet87@gmail.com>

commit 0eb09f737428e482a32a2e31e5e223f2b35a71d3 upstream.

The command_file_write() handler allocates a kernel buffer of exactly
count bytes and copies user data into it, but does not validate the
buffer against the dot command protocol before passing it to
get_dot_command_size() and get_dot_command_timeout().

Since both the allocation size (count) and the header fields (command_size,
data_size) are independently user-controlled, an attacker can cause
get_dot_command_size() to return a value exceeding the allocation,
triggering OOB reads in get_dot_command_timeout() and an out-of-bounds
memcpy_toio() that leaks kernel heap memory to the service processor.

Fix with two guards: reject writes smaller than sizeof(struct
dot_command_header) before allocation, then after copying user data
reject commands where the buffer is smaller than the total size declared
by the header (sizeof(header) + command_size + data_size). This ensures
all subsequent header and payload field accesses stay within the buffer.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Tyllis Xu <LivelyCarpet87@gmail.com>
Link: https://patch.msgid.link/20260314165355.548119-1-LivelyCarpet87@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/ibmasm/ibmasmfs.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/misc/ibmasm/ibmasmfs.c
+++ b/drivers/misc/ibmasm/ibmasmfs.c
@@ -303,6 +303,8 @@ static ssize_t command_file_write(struct
 		return -EINVAL;
 	if (count == 0 || count > IBMASM_CMD_MAX_BUFFER_SIZE)
 		return 0;
+	if (count < sizeof(struct dot_command_header))
+		return -EINVAL;
 	if (*offset != 0)
 		return 0;
 
@@ -319,6 +321,11 @@ static ssize_t command_file_write(struct
 		return -EFAULT;
 	}
 
+	if (count < get_dot_command_size(cmd->buffer)) {
+		command_put(cmd);
+		return -EINVAL;
+	}
+
 	spin_lock_irqsave(&command_data->sp->lock, flags);
 	if (command_data->command) {
 		spin_unlock_irqrestore(&command_data->sp->lock, flags);


