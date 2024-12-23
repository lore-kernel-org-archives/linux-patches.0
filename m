Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6B48827;
	Mon, 23 Dec 2024 16:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970521; cv=none; b=IUQlSOzUIDjhveh5d8+3ZvPBdwwUMUHS4JYyTJWq4RQquuCBTCgrX0+Qrpprt4Uq6NHWy4gkrqv5R7GjVBivRZgX3Fg/yTvW0e46vbCVYlDbjLsJBAhXvrPVxquHSK1zbyjtzZbaPLdzYeR0HrBtiVwkXnSvkl8toqSHVrF3qFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970521; c=relaxed/simple;
	bh=xv8IoLiCmkK1nTTfzEX5pelM5UqQKym006fgRBIrwB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fsZh6zs1n/VT9NAclcCn9yjD9ZhMXL7XJAiargcmO1tU3dX7+rJQEhWK7H5uaL0V02o46Cc+cR5vGATnPn6W8hIeoNDR+bb3A/QuJ7AuiPsYJWsWO3aYEmSXAz/kYqBRB2F4+qEieRF70fetfCaqfXhR7AP4lk6W+JAMR3QraNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1rKBygtX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1rKBygtX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753EAC4CED3;
	Mon, 23 Dec 2024 16:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970520;
	bh=xv8IoLiCmkK1nTTfzEX5pelM5UqQKym006fgRBIrwB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1rKBygtX1Ts4sJDSomBOJj3nwFpBTlzusq/iNnDuQzBncs9wITB55+0SqgW4yMCAR
	 vWIknpZdavDua1Mji4vJptREnwnQ5k47dHnF58d/lETgbGRo31zfp4ZEz479SvxF96
	 TNKUl73mEJF56y8excQaPCVTBP8OpiDb61/FFL7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
	Alex Markuze <amarkuze@redhat.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.6 108/116] ceph: improve error handling and short/overflow-read logic in __ceph_sync_read()
Date: Mon, 23 Dec 2024 16:59:38 +0100
Message-ID: <20241223155403.746316379@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Markuze <amarkuze@redhat.com>

commit 9abee475803fab6ad59d4f4fc59c6a75374a7d9d upstream.

This patch refines the read logic in __ceph_sync_read() to ensure more
predictable and efficient behavior in various edge cases.

- Return early if the requested read length is zero or if the file size
  (`i_size`) is zero.
- Initialize the index variable (`idx`) where needed and reorder some
  code to ensure it is always set before use.
- Improve error handling by checking for negative return values earlier.
- Remove redundant encrypted file checks after failures. Only attempt
  filesystem-level decryption if the read succeeded.
- Simplify leftover calculations to correctly handle cases where the
  read extends beyond the end of the file or stops short.  This can be
  hit by continuously reading a file while, on another client, we keep
  truncating and writing new data into it.
- This resolves multiple issues caused by integer and consequent buffer
  overflow (`pages` array being accessed beyond `num_pages`):
  - https://tracker.ceph.com/issues/67524
  - https://tracker.ceph.com/issues/68980
  - https://tracker.ceph.com/issues/68981

Cc: stable@vger.kernel.org
Fixes: 1065da21e5df ("ceph: stop copying to iter at EOF on sync reads")
Reported-by: Luis Henriques (SUSE) <luis.henriques@linux.dev>
Signed-off-by: Alex Markuze <amarkuze@redhat.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/file.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -976,7 +976,7 @@ ssize_t __ceph_sync_read(struct inode *i
 	if (ceph_inode_is_shutdown(inode))
 		return -EIO;
 
-	if (!len)
+	if (!len || !i_size)
 		return 0;
 	/*
 	 * flush any page cache pages in this range.  this
@@ -996,7 +996,7 @@ ssize_t __ceph_sync_read(struct inode *i
 		int num_pages;
 		size_t page_off;
 		bool more;
-		int idx;
+		int idx = 0;
 		size_t left;
 		struct ceph_osd_req_op *op;
 		u64 read_off = off;
@@ -1068,7 +1068,14 @@ ssize_t __ceph_sync_read(struct inode *i
 		else if (ret == -ENOENT)
 			ret = 0;
 
-		if (ret > 0 && IS_ENCRYPTED(inode)) {
+		if (ret < 0) {
+			ceph_osdc_put_request(req);
+			if (ret == -EBLOCKLISTED)
+				fsc->blocklisted = true;
+			break;
+		}
+
+		if (IS_ENCRYPTED(inode)) {
 			int fret;
 
 			fret = ceph_fscrypt_decrypt_extents(inode, pages,
@@ -1097,7 +1104,7 @@ ssize_t __ceph_sync_read(struct inode *i
 		ceph_osdc_put_request(req);
 
 		/* Short read but not EOF? Zero out the remainder. */
-		if (ret >= 0 && ret < len && (off + ret < i_size)) {
+		if (ret < len && (off + ret < i_size)) {
 			int zlen = min(len - ret, i_size - off - ret);
 			int zoff = page_off + ret;
 
@@ -1107,13 +1114,11 @@ ssize_t __ceph_sync_read(struct inode *i
 			ret += zlen;
 		}
 
-		idx = 0;
-		if (ret <= 0)
-			left = 0;
-		else if (off + ret > i_size)
-			left = i_size - off;
+		if (off + ret > i_size)
+			left = (i_size > off) ? i_size - off : 0;
 		else
 			left = ret;
+
 		while (left > 0) {
 			size_t plen, copied;
 
@@ -1131,12 +1136,6 @@ ssize_t __ceph_sync_read(struct inode *i
 		}
 		ceph_release_page_vector(pages, num_pages);
 
-		if (ret < 0) {
-			if (ret == -EBLOCKLISTED)
-				fsc->blocklisted = true;
-			break;
-		}
-
 		if (off >= i_size || !more)
 			break;
 	}


