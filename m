Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EFD415F1A;
	Tue, 21 Jul 2026 18:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660356; cv=none; b=a4iIZ19t18jCsskBf6zOxAsM3HViCcghqaskifIlMZb8fsvd4uH81q50hm7beaw7UMMngycCqxHjyheDeKei3KhDqXhI/Pkx7EXdPsgWdPmDh57bQLXs5NLrvL5JhzGn8B8cvdmyf71PIloPHzQP8kAdyf0j8QLFmfe5ZZIYS9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660356; c=relaxed/simple;
	bh=NhX6RRucpkF7mB0JmxR0yFwVFSlqb8Axni0Ct4WH+RY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NMwGexvoNK0LH0iGWSUF33Gvi3K6PMJXGrHivgoNbvUvhDS3M/Oq3KN8WnESnBSDuc6icuMpmIxa6expttbzu7/rO6Kh25ng7l6ZaoNpOlQxVa9rbGopkYDLyfn/onw1FUZr//kYTe/z8/PxB5mlFiEQFduQ6qtOHeiIjZKakg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JFwEXtP7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JFwEXtP7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64AAE1F00A3E;
	Tue, 21 Jul 2026 18:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660350;
	bh=HAz+y+1ydw9hGS4eXxNwXvS03dpXusaLV0+jaiqCGpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JFwEXtP7Dda/wUW95ez5AeS8HDXmlZPuz0Wix7Y7TTS3wVL6w4twFRsEXjDg8i/jQ
	 cg0OIAFXR5SzRdNQVl/nnORzltkM/r19Ag6KyJnH4NL+a4EC6bnj7xnR+LmEYtWAAC
	 iqpYR99aWxUHsxDSeSeD4NJdPcl/oJhsPc6pSFUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mihai Brodschi <m.brodschi@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0920/2077] ntfs3: Allocate iomap inline_data using alloc_page
Date: Tue, 21 Jul 2026 17:09:53 +0200
Message-ID: <20260721152614.512685096@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mihai Brodschi <m.brodschi@gmail.com>

[ Upstream commit 70d3855594cf6e8791970714b65cac3202d6160e ]

This fixes a BUG reported in iomap_write_end_inline:
iomap_inline_data_valid checks that the inline_data fits within
a page. If the inline_data is allocated with kmemdup there's no
guarantee that it's page-aligned, so the check sometimes fails.
Allocate it with alloc_page to ensure it's page-aligned.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221446
Fixes: 099ef9ab9203 ("fs/ntfs3: implement iomap-based file operations")
Signed-off-by: Mihai Brodschi <m.brodschi@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrib.c | 10 +++++++---
 fs/ntfs3/inode.c  |  4 ++--
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index e61c5bf7e27e44..ff0bf45759480b 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -1004,6 +1004,7 @@ int attr_data_get_block_locked(struct ntfs_inode *ni, CLST vcn, CLST clen,
 	struct ATTRIB *attr, *attr_b;
 	struct ATTR_LIST_ENTRY *le, *le_b;
 	struct mft_inode *mi, *mi_b;
+	struct page *page;
 	CLST hint, svcn, to_alloc, evcn1, next_svcn, asize, end, vcn0;
 	CLST alloc, evcn;
 	unsigned fr;
@@ -1042,10 +1043,13 @@ int attr_data_get_block_locked(struct ntfs_inode *ni, CLST vcn, CLST clen,
 		*lcn = RESIDENT_LCN;
 		*len = data_size;
 		if (res && data_size) {
-			*res = kmemdup(resident_data(attr_b), data_size,
-				       GFP_KERNEL);
-			if (!*res)
+			page = alloc_page(GFP_KERNEL);
+			if (!page) {
 				err = -ENOMEM;
+			} else {
+				*res = page_address(page);
+				memcpy(*res, resident_data(attr_b), data_size);
+			}
 		}
 		goto out;
 	}
diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 42af1abe17f883..031f85fd53d4e8 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -801,7 +801,7 @@ static int ntfs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 
 	if (lcn == RESIDENT_LCN) {
 		if (offset >= clen) {
-			kfree(res);
+			__free_page(virt_to_page(res));
 			if (flags & IOMAP_REPORT) {
 				/* special code for report. */
 				return -ENOENT;
@@ -921,7 +921,7 @@ static int ntfs_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 
 out:
 	if (iomap->type == IOMAP_INLINE) {
-		kfree(iomap->private);
+		__free_page(virt_to_page(iomap->private));
 		iomap->private = NULL;
 	}
 
-- 
2.53.0



