Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F2F196D8C;
	Thu,  6 Jun 2024 14:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683242; cv=none; b=TySsc0kgrmqCb42QKa/UE7IvDzCl5gDkttAQ6ewzHfBBtnQ9xc9SQH3SvzNOOWhvv2lW398KXnG+c5T2vEuEH6GYpuLniJZe8LGJD5K8+d07klb/p/wRMN77BUrAvsBEGRyTBPYBXznwzoJKcDjPGx+nznnSlaEvu/B/3piwmg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683242; c=relaxed/simple;
	bh=dGOiNvSNb8Rhd5/hoyvaiIwEWc/ImeVpIfQ0SF2+Rbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VLbpo2Tq23l8n75msDtDVSgL/LjSM+oja97tuVF4jYFF9uf6taEhWdbRCOWVcJq9mQeENDAzCIuv3bG4+dUWf98yD6n00es15byAShYP+5DChJmq/+LiTcKyTHfqhyfYHDosA1V+qEc3L//ltMpwDNu24vX35/zp/8WzfSlIxgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G+KNb2CP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G+KNb2CP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74565C2BD10;
	Thu,  6 Jun 2024 14:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683242;
	bh=dGOiNvSNb8Rhd5/hoyvaiIwEWc/ImeVpIfQ0SF2+Rbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G+KNb2CP4FWp2s0grNKnY4krqimw5ZqW9n9hNqV1eG3zGeLiF8THaMkzJVPac3qjN
	 7YWrs20SWVijGpImViABSSq9C/yX3bg23mHvrQhgjK08wXT50pJFV/HWAyXWFLZEnz
	 4S+6ub6054AHEZ4hnj8A83KSAYIBiDlQqzDDPiEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 187/744] gfs2: Convert gfs2_internal_read to folios
Date: Thu,  6 Jun 2024 15:57:39 +0200
Message-ID: <20240606131738.429073357@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit be7f6a6b0bca708999eef4f8e9f2b128c73b9e17 ]

Change gfs2_internal_read() to use folios.  Convert sizes to size_t.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: d98779e68772 ("gfs2: Fix potential glock use-after-free on unmount")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/aops.c  | 34 ++++++++++++++++------------------
 fs/gfs2/inode.h |  4 ++--
 2 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index c26d48355cc27..48dc35caa60b4 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -479,31 +479,29 @@ static int gfs2_read_folio(struct file *file, struct folio *folio)
  *
  */
 
-int gfs2_internal_read(struct gfs2_inode *ip, char *buf, loff_t *pos,
-                       unsigned size)
+ssize_t gfs2_internal_read(struct gfs2_inode *ip, char *buf, loff_t *pos,
+			   size_t size)
 {
 	struct address_space *mapping = ip->i_inode.i_mapping;
 	unsigned long index = *pos >> PAGE_SHIFT;
-	unsigned offset = *pos & (PAGE_SIZE - 1);
-	unsigned copied = 0;
-	unsigned amt;
-	struct page *page;
+	size_t copied = 0;
 
 	do {
-		page = read_cache_page(mapping, index, gfs2_read_folio, NULL);
-		if (IS_ERR(page)) {
-			if (PTR_ERR(page) == -EINTR)
+		size_t offset, chunk;
+		struct folio *folio;
+
+		folio = read_cache_folio(mapping, index, gfs2_read_folio, NULL);
+		if (IS_ERR(folio)) {
+			if (PTR_ERR(folio) == -EINTR)
 				continue;
-			return PTR_ERR(page);
+			return PTR_ERR(folio);
 		}
-		amt = size - copied;
-		if (offset + size > PAGE_SIZE)
-			amt = PAGE_SIZE - offset;
-		memcpy_from_page(buf + copied, page, offset, amt);
-		put_page(page);
-		copied += amt;
-		index++;
-		offset = 0;
+		offset = *pos + copied - folio_pos(folio);
+		chunk = min(size - copied, folio_size(folio) - offset);
+		memcpy_from_folio(buf + copied, folio, offset, chunk);
+		index = folio_next_index(folio);
+		folio_put(folio);
+		copied += chunk;
 	} while(copied < size);
 	(*pos) += size;
 	return size;
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index c8c5814e7295d..75e662949f04d 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -13,8 +13,8 @@
 #include "util.h"
 
 bool gfs2_release_folio(struct folio *folio, gfp_t gfp_mask);
-extern int gfs2_internal_read(struct gfs2_inode *ip,
-			      char *buf, loff_t *pos, unsigned size);
+extern ssize_t gfs2_internal_read(struct gfs2_inode *ip,
+				  char *buf, loff_t *pos, size_t size);
 extern void gfs2_set_aops(struct inode *inode);
 
 static inline int gfs2_is_stuffed(const struct gfs2_inode *ip)
-- 
2.43.0



