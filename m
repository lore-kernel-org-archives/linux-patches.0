Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05305344DBD;
	Sat, 12 Sep 2026 17:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232739; cv=none; b=L4utRPfCc7claugnx9VMCQ1S/KmgGWsCYzPwQFTSeaw94AHgMkz9zKhRRe4y+9K0avj5YiSoad8oEPSojsQDTNSQ1LKbAKqeXe2IPAJh1yEUO0wcnDd2hEh14cOJ3Cmz3oyUbjLliY7vWAZy3517LS7Ov4Ra+l4YisWUCMTVa6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232739; c=relaxed/simple;
	bh=tcLOhs+7wZISa2PShDYr5D3M6ZILHBcCUEDijEItZn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABuQBXIKMIJVgS+Rk1RILYJjkYuNyYsaxl4hx7J4ZqJhCaV2q/eycRqwOgoao1X/Bb0bKeCn/LSh9H+XY2vK8JW59FS8aIuYYJJx7heIfzrGreEGwFblEzT6ee+LOxH3bayZz/rQq5A4GaheaCLtTSMTwsqnvts7mzOZSpeFAh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ceKC72ax; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ceKC72ax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087561F000FF;
	Sat, 12 Sep 2026 17:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232737;
	bh=Qi3O7DbfiWSXQzda7toL7HDKB6cxadvzxBUnrv+ptOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ceKC72axN7FfopqjZP27zlmGjRzbq/ySHM71TPm5l/M4Y+v5GXC/BTQr9CMXXqUem
	 pxJt+q0BAPQg6x9S2e2lPXFEEveDlGkVqlhKjDsJY2PXc8ymSGZ6o2G0l9JJo0zvQi
	 iIqW7XKXTkCDHQ2VtEzh/tD9+4eDmBupili0xyYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 5.15 069/935] ecryptfs: pass packet set buffer size to parser
Date: Sat, 12 Sep 2026 08:51:39 +0200
Message-ID: <20260912065528.420400609@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Yichong Chen <chenyichong@uniontech.com>

commit 2602b79c5b3e2f6fce12e38a670f8e3fda4e46a2 upstream.

ecryptfs_parse_packet_set() receives a pointer into the file header, but
it calculates the remaining packet buffer size from PAGE_SIZE - 8.  For
version 1 headers the packet set starts later in the header, so this can
overstate the available buffer.

Pass the actual packet set buffer length from the caller and calculate
per-packet limits from the remaining bytes in that buffer.  Recompute the
remaining length after consuming a tag 3 packet before parsing the
following tag 11 packet.

Fixes: 237fead61998 ("[PATCH] ecryptfs: fs/Makefile and fs/Kconfig")
Cc: <stable@vger.kernel.org>
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Signed-off-by: Tyler Hicks <code@tyhicks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ecryptfs/crypto.c          |    2 +-
 fs/ecryptfs/ecryptfs_kernel.h |    3 ++-
 fs/ecryptfs/keystore.c        |   23 ++++++++++++++++++++---
 3 files changed, 23 insertions(+), 5 deletions(-)

--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1306,7 +1306,7 @@ static int ecryptfs_read_headers_virt(ch
 	} else
 		set_default_header_data(crypt_stat);
 	rc = ecryptfs_parse_packet_set(crypt_stat, (page_virt + offset),
-				       ecryptfs_dentry);
+				       PAGE_SIZE - offset, ecryptfs_dentry);
 out:
 	return rc;
 }
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -590,7 +590,8 @@ int ecryptfs_generate_key_packet_set(cha
 				     size_t *len, size_t max);
 int
 ecryptfs_parse_packet_set(struct ecryptfs_crypt_stat *crypt_stat,
-			  unsigned char *src, struct dentry *ecryptfs_dentry);
+			  unsigned char *src, size_t src_size,
+			  struct dentry *ecryptfs_dentry);
 int ecryptfs_truncate(struct dentry *dentry, loff_t new_length);
 ssize_t
 ecryptfs_getxattr_lower(struct dentry *lower_dentry, struct inode *lower_inode,
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -1743,6 +1743,7 @@ out:
  * ecryptfs_parse_packet_set
  * @crypt_stat: The cryptographic context
  * @src: Virtual address of region of memory containing the packets
+ * @src_size: Size of the packet set buffer
  * @ecryptfs_dentry: The eCryptfs dentry associated with the packet set
  *
  * Get crypt_stat to have the file's session key if the requisite key
@@ -1753,7 +1754,7 @@ out:
  * conditions.
  */
 int ecryptfs_parse_packet_set(struct ecryptfs_crypt_stat *crypt_stat,
-			      unsigned char *src,
+			      unsigned char *src, size_t src_size,
 			      struct dentry *ecryptfs_dentry)
 {
 	size_t i = 0;
@@ -1777,7 +1778,11 @@ int ecryptfs_parse_packet_set(struct ecr
 	 * added the our &auth_tok_list */
 	next_packet_is_auth_tok_packet = 1;
 	while (next_packet_is_auth_tok_packet) {
-		size_t max_packet_size = ((PAGE_SIZE - 8) - i);
+		size_t max_packet_size;
+
+		if (i >= src_size)
+			break;
+		max_packet_size = src_size - i;
 
 		switch (src[i]) {
 		case ECRYPTFS_TAG_3_PACKET_TYPE:
@@ -1792,12 +1797,16 @@ int ecryptfs_parse_packet_set(struct ecr
 				goto out_wipe_list;
 			}
 			i += packet_size;
+			if (i > src_size) {
+				rc = -EIO;
+				goto out_wipe_list;
+			}
 			rc = parse_tag_11_packet((unsigned char *)&src[i],
 						 sig_tmp_space,
 						 ECRYPTFS_SIG_SIZE,
 						 &tag_11_contents_size,
 						 &tag_11_packet_size,
-						 max_packet_size);
+						 src_size - i);
 			if (rc) {
 				ecryptfs_printk(KERN_ERR, "No valid "
 						"(ecryptfs-specific) literal "
@@ -1809,6 +1818,10 @@ int ecryptfs_parse_packet_set(struct ecr
 				goto out_wipe_list;
 			}
 			i += tag_11_packet_size;
+			if (i > src_size) {
+				rc = -EIO;
+				goto out_wipe_list;
+			}
 			if (ECRYPTFS_SIG_SIZE != tag_11_contents_size) {
 				ecryptfs_printk(KERN_ERR, "Expected "
 						"signature of size [%d]; "
@@ -1836,6 +1849,10 @@ int ecryptfs_parse_packet_set(struct ecr
 				goto out_wipe_list;
 			}
 			i += packet_size;
+			if (i > src_size) {
+				rc = -EIO;
+				goto out_wipe_list;
+			}
 			crypt_stat->flags |= ECRYPTFS_ENCRYPTED;
 			break;
 		case ECRYPTFS_TAG_11_PACKET_TYPE:


