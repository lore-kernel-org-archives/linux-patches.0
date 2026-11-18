Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048232;
	b=xB1IAZSUtzcRyl3PGbjQEC3qcBaluF+HqS3sThIveWO3JEKmZ+J6NlJ/aeR4Ox4JpL9D
	 S80pSYTKIQpRuuh6xJB2I157GIZZ6ZzPHtmAEXAzdNO8zyiMXn6aTGAWW0q/56RZkvHHc
	 KsxaLRuESDg9LctU/VGI7RAvIcwQfo2A2WIukWqNaneKSExZDTBNITW15k4rjvp6SIIvl
	 YXE3lHN49o/3dcgBzZBztEX7blxaCVGAMcpg+DK+d1sm2bgTGGnC1xseD5UZrJ0DN24mL
	 Pgg3YTlh6R/gV/ggx9jqQFS7ew8yPm7kXEThtzpoeJyMFwEiUbA916xMqQ6uBysTXTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048232;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2Uh1npWhERx2UauoECtvrTq9sYzNtuzaEwCc+AXXmOU=;
	b=CYykSoSUu3mKdPPBF/wZbE6sNtIdTHlCc0NSc70kyAHa6cgQldoLaeInjr0X1FhMS7CE
	 crYA0LB/yUbARBqGPH9CSovF8qWC1b3RA68mRQgfmzCegvaPB8jB4ExGOB0VBIZheeuQN
	 jm/rPKZuUcbHHZRIT+P7DWwz7wEnxdpzAzkGjQsMhNbydeLs+VI6Mq8B9WqL2Ndogzia5
	 MgJ6XXWc0wU7NhQIBGcEX72G7T7MwEzl/9Lk5wytuYKmGnXVEYygiYRuq1x2CypTLbZqP
	 NJs5LCfLyX2TzjTMpQ555Rgm9g4b844HRV+S3TBhnTMDyCmj7aJvuHtTROK2xrBOVgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ddYhIhUq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31F8606A320;
	Thu, 19 Nov 2026 00:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ddYhIhUq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5921F000C5;
	Thu, 19 Nov 2026 00:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048232;
	bh=2Uh1npWhERx2UauoECtvrTq9sYzNtuzaEwCc+AXXmOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ddYhIhUqTpFqBvs6KBWp7rnngjU3HX96YRbSQp0nGC1KEgycz6s2ym/1Mcv1AWzJj
	 GmEnkctodpfQ3wVNvdJCqJBQvSpe/GYyLxmHF5Gi2KsDon07rrR23+q8eHQikD2cas
	 5m1RX2l280xJHj7OViMy3C7tiizRxKx4LRp2/RH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1921/2857] ntfs3: Convert attr_wof_frame_info() to use a folio
Date: Wed, 18 Nov 2026 15:49:15 +0100
Message-ID: <20261118150310.376529301@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit c091354d6bf60ec606d4c0772459ea2f3bbee271 ]

This involves converting all users of offs_page to offs_folio, but
it's worth it because we get rid of a lot of hidden calls to
compound_head().  We continue to use order-0 folios here, and convert
back to a struct page to call ntfs_bio_pages().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Stable-dep-of: ad39d8d90fa0 ("fs/ntfs3: take run_lock when freeing offs_folio in ni_decompress_file")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrib.c  | 27 ++++++++++++++-------------
 fs/ntfs3/frecord.c | 12 ++++++------
 fs/ntfs3/ntfs_fs.h |  2 +-
 3 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index c037f5307657a..8cf7ca39f9637 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -1393,7 +1393,7 @@ int attr_wof_frame_info(struct ntfs_inode *ni, struct ATTRIB *attr,
 	u32 voff;
 	u8 bytes_per_off;
 	char *addr;
-	struct page *page;
+	struct folio *folio;
 	int i, err;
 	__le32 *off32;
 	__le64 *off64;
@@ -1438,18 +1438,18 @@ int attr_wof_frame_info(struct ntfs_inode *ni, struct ATTRIB *attr,
 
 	wof_size = le64_to_cpu(attr->nres.data_size);
 	down_write(&ni->file.run_lock);
-	page = ni->file.offs_page;
-	if (!page) {
-		page = alloc_page(GFP_KERNEL);
-		if (!page) {
+	folio = ni->file.offs_folio;
+	if (!folio) {
+		folio = folio_alloc(GFP_KERNEL, 0);
+		if (!folio) {
 			err = -ENOMEM;
 			goto out;
 		}
-		page->index = -1;
-		ni->file.offs_page = page;
+		folio->index = -1;
+		ni->file.offs_folio = folio;
 	}
-	lock_page(page);
-	addr = page_address(page);
+	folio_lock(folio);
+	addr = folio_address(folio);
 
 	if (vbo[1]) {
 		voff = vbo[1] & (PAGE_SIZE - 1);
@@ -1465,7 +1465,8 @@ int attr_wof_frame_info(struct ntfs_inode *ni, struct ATTRIB *attr,
 	do {
 		pgoff_t index = vbo[i] >> PAGE_SHIFT;
 
-		if (index != page->index) {
+		if (index != folio->index) {
+			struct page *page = &folio->page;
 			u64 from = vbo[i] & ~(u64)(PAGE_SIZE - 1);
 			u64 to = min(from + PAGE_SIZE, wof_size);
 
@@ -1478,10 +1479,10 @@ int attr_wof_frame_info(struct ntfs_inode *ni, struct ATTRIB *attr,
 			err = ntfs_bio_pages(sbi, run, &page, 1, from,
 					     to - from, REQ_OP_READ);
 			if (err) {
-				page->index = -1;
+				folio->index = -1;
 				goto out1;
 			}
-			page->index = index;
+			folio->index = index;
 		}
 
 		if (i) {
@@ -1519,7 +1520,7 @@ int attr_wof_frame_info(struct ntfs_inode *ni, struct ATTRIB *attr,
 	*ondisk_size = off[1] - off[0];
 
 out1:
-	unlock_page(page);
+	folio_unlock(folio);
 out:
 	up_write(&ni->file.run_lock);
 	return err;
diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index fa443144f6d1a..41a92cca03b0b 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -124,10 +124,10 @@ void ni_clear(struct ntfs_inode *ni)
 	else {
 		run_close(&ni->file.run);
 #ifdef CONFIG_NTFS3_LZX_XPRESS
-		if (ni->file.offs_page) {
+		if (ni->file.offs_folio) {
 			/* On-demand allocated page for offsets. */
-			put_page(ni->file.offs_page);
-			ni->file.offs_page = NULL;
+			folio_put(ni->file.offs_folio);
+			ni->file.offs_folio = NULL;
 		}
 #endif
 	}
@@ -2471,9 +2471,9 @@ int ni_decompress_file(struct ntfs_inode *ni)
 
 	/* Clear cached flag. */
 	ni->ni_flags &= ~NI_FLAG_COMPRESSED_MASK;
-	if (ni->file.offs_page) {
-		put_page(ni->file.offs_page);
-		ni->file.offs_page = NULL;
+	if (ni->file.offs_folio) {
+		folio_put(ni->file.offs_folio);
+		ni->file.offs_folio = NULL;
 	}
 	mapping->a_ops = &ntfs_aops;
 
diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
index 34179fba57db8..1cfaeefa762da 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -379,7 +379,7 @@ struct ntfs_inode {
 			struct rw_semaphore run_lock;
 			struct runs_tree run;
 #ifdef CONFIG_NTFS3_LZX_XPRESS
-			struct page *offs_page;
+			struct folio *offs_folio;
 #endif
 		} file;
 	};
-- 
2.53.0



