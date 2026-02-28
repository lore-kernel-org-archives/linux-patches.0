Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A48C3A2AF7
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302665; cv=none; b=ql70XD3bhW/F4K7qYgJSiqNQQHjxNezwQKPoiTgpifKZ0wc6PRdjKDuhIwC5XGxaX5EPTn8MHZOym5dv5+q4vgGuRf/iGPfEjXbyAhi0mWViwtkvjFCQ1A8L00SPKgxaBbQZv7uH8wwjoAJgdY1mqaWtCMAgEqB+b4f6QRIrtZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302665; c=relaxed/simple;
	bh=aO1/EUD093wC92H8SIaty24mU8lmKiEEoGAKCQn0e4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AqyKYHTv4N+r94fxYtAigLoj51rkEc7kzmlns0S+cRvGBng5dwgqyFdxheQb3P+5fn0dwgiLqIYuziW73cwykyG0KVWW73O/jCw21QJG1/eqhtH3XZv/7C0CVFBipgl48zurVxfKZl22d9BM/V3CKLShLsDNDokk/9E0kYRON+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jRVLBSsf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jRVLBSsf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD217C116D0;
	Sat, 28 Feb 2026 18:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302665;
	bh=aO1/EUD093wC92H8SIaty24mU8lmKiEEoGAKCQn0e4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jRVLBSsfWXPEnCef/5okoaPsZmLFQMvF8uvhcyjB0ecwa9IA+HUVumYeJ4XRAWqFx
	 ylgpaXzj9BI8KOnWZ1ApN91AU/YybzVHIB0oZz87SJwFwkHOtq6M/YVIUR3V9Hz9/n
	 7kwVCLkTJq0FsjEVihiZQ3xtQNCWcZuwdUoj4z+l+TZ13ZmEuVxpBNfNiJBz8rIFbb
	 OXf2dovxQiBSuKwdbGgYxt49AUVBG7IEDHfiDTd16vMD0mlkcqP4oM2U8CTbxM1uVK
	 65y/z7WFXe0eMCowBirNhIDA+G6ToX95B4KhO0J5WAn31+WuSCzkWjlIO4oKUG0d4N
	 dhT6R44//TQZg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/147] gfs2: Add wrapper for iomap_file_buffered_write
Date: Sat, 28 Feb 2026 13:15:19 -0500
Message-ID: <20260228181736.1605592-11-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 2eb7509a05443048fb4df60b782de3f03c6c298b ]

Add a wrapper around iomap_file_buffered_write.  We'll add code for when
the operation needs to be retried here later.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: faddeb848305 ("gfs2: Fix use-after-free in iomap inline data write path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/file.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index ec5000e13bb70..0ef9bf81fde0a 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -888,6 +888,20 @@ static ssize_t gfs2_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	return written ? written : ret;
 }
 
+static ssize_t gfs2_file_buffered_write(struct kiocb *iocb, struct iov_iter *from)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file_inode(file);
+	ssize_t ret;
+
+	current->backing_dev_info = inode_to_bdi(inode);
+	ret = iomap_file_buffered_write(iocb, from, &gfs2_iomap_ops);
+	current->backing_dev_info = NULL;
+	if (ret > 0)
+		iocb->ki_pos += ret;
+	return ret;
+}
+
 /**
  * gfs2_file_write_iter - Perform a write to a file
  * @iocb: The io context
@@ -939,9 +953,7 @@ static ssize_t gfs2_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 			goto out_unlock;
 
 		iocb->ki_flags |= IOCB_DSYNC;
-		current->backing_dev_info = inode_to_bdi(inode);
-		buffered = iomap_file_buffered_write(iocb, from, &gfs2_iomap_ops);
-		current->backing_dev_info = NULL;
+		buffered = gfs2_file_buffered_write(iocb, from);
 		if (unlikely(buffered <= 0)) {
 			if (!ret)
 				ret = buffered;
@@ -955,7 +967,6 @@ static ssize_t gfs2_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		 * the direct I/O range as we don't know if the buffered pages
 		 * made it to disk.
 		 */
-		iocb->ki_pos += buffered;
 		ret2 = generic_write_sync(iocb, buffered);
 		invalidate_mapping_pages(mapping,
 				(iocb->ki_pos - buffered) >> PAGE_SHIFT,
@@ -963,13 +974,9 @@ static ssize_t gfs2_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		if (!ret || ret2 > 0)
 			ret += ret2;
 	} else {
-		current->backing_dev_info = inode_to_bdi(inode);
-		ret = iomap_file_buffered_write(iocb, from, &gfs2_iomap_ops);
-		current->backing_dev_info = NULL;
-		if (likely(ret > 0)) {
-			iocb->ki_pos += ret;
+		ret = gfs2_file_buffered_write(iocb, from);
+		if (likely(ret > 0))
 			ret = generic_write_sync(iocb, ret);
-		}
 	}
 
 out_unlock:
-- 
2.51.0

