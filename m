Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D98B184535;
	Tue, 30 Jul 2024 16:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357822; cv=none; b=iygL6K6yINN6mkRq7/U5j/fjvWVb6+RRdRrkzw/A8bfH8/OYx2d8s3cahA2+RCNzrtNIzmzy4/DMT7b5TCFHwktARGmpRScgecYFVCITN32ScNrEpAIDvZmWktwAbFcvbWYUU+84A/cAA/kN0yDdowX2pAWc0rx2T/0sQbpVRwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357822; c=relaxed/simple;
	bh=EOBvejiKcCC1RIr3q7oedUAuiq+0YXsOGLW/9CAfwO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCLXvdOJ5BPZQBAxG0r7IRiHfsmbDe1b7OWV2u3qQzuQAqd0EzcfkzNTzQqrukFLo/9FELL3HbUFhRM5gUvhXdjJ2ebOSPBuT+/6HQzZNfFHVCyoh1VCnv563js0xar/vadbfCOk4RlQgGCXK2NseNEbblSUDS7TX2ufb/eWWBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oC8JqQdO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oC8JqQdO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5429FC4AF0E;
	Tue, 30 Jul 2024 16:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357821;
	bh=EOBvejiKcCC1RIr3q7oedUAuiq+0YXsOGLW/9CAfwO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oC8JqQdOoY9M+7Z7U1yJCpbt+CHmwp26LrPB+vzwzQSw50fft/H0nIlPubs1QOidF
	 hSeezyrreGKr2neA+M6bGfD8boQV0WbOcepsJsbswln6TGHU0IXb6xXBwxtzKwFTRm
	 numnYcy5kaZi3LrdA6CKlOlYiAIfok8xRe68sJEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Barry Song <v-songbaohua@oppo.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.1 330/440] f2fs: fix to force buffered IO on inline_data inode
Date: Tue, 30 Jul 2024 17:49:23 +0200
Message-ID: <20240730151628.706811641@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit 5c8764f8679e659c5cb295af7d32279002d13735 upstream.

It will return all zero data when DIO reading from inline_data inode, it
is because f2fs_iomap_begin() assign iomap->type w/ IOMAP_HOLE incorrectly
for this case.

We can let iomap framework handle inline data via assigning iomap->type
and iomap->inline_data correctly, however, it will be a little bit
complicated when handling race case in between direct IO and buffered IO.

So, let's force to use buffered IO to fix this issue.

Cc: stable@vger.kernel.org
Reported-by: Barry Song <v-songbaohua@oppo.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -812,6 +812,8 @@ static bool f2fs_force_buffered_io(struc
 		return true;
 	if (f2fs_compressed_file(inode))
 		return true;
+	if (f2fs_has_inline_data(inode))
+		return true;
 
 	/* disallow direct IO if any of devices has unaligned blksize */
 	if (f2fs_is_multi_device(sbi) && !sbi->aligned_blksize)


