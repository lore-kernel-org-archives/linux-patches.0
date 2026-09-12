Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F6324CEEA;
	Sat, 12 Sep 2026 09:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204615; cv=none; b=ZLOxnfepv7YT4fwMaj7AfaK1R7j0Cim7jTVbsiHF4FauMHfdEXomrXFfHdAhNsyHKohAtqRZrod2HEdzt1WrOXKndAXoGAC/612CXnslxDyBpqLrptFZn4bubn/Zgn3dMRBs6Z2yQFfJdEfe0ZU7vYJCQb7f0rWjL1F5np5Vy9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204615; c=relaxed/simple;
	bh=sGx2qnupzW/jNLwNxFEw7CNGPw/RXbg6QEDh6307iYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c9CGxLVExA/sHf+H9MEGVEoiGH0U2e8xMxdoi6SfNatXcGlN1YcBvUAIq6+F7aUqmxGyDwBVly5aPaND4S6H3ZseQ75o03dMLwNZA8zaCOVC7ZX6VsChBb7DlulXDs30W7vlp12ja/n0wDwrMZkHUohkO5/3/Lhnt3LRu3n0K/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AEYBaB5C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AEYBaB5C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C4F1F000FF;
	Sat, 12 Sep 2026 09:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204613;
	bh=fDZajIrJdx3+blbypP3f6QOLnU4ENcDGZqQsp0lsJSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AEYBaB5CFkHCPOUdWqdwCN8VHoLdN/2eiRcBp/8HJD2EmSyJKTLz3RP7fnJz0Ehjh
	 s86n5KXpWNO337Fu9C0kqGwxt69EWfy2FRpYAbQCpx13DmA1pAxubDDe8QAWiCymF6
	 5GDTnpCWbT/PCfqOw4S8aUlwPXo9CiRtp01mK56k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1606/1815] ntfs: Use zero_user_segment() in handle_bounds_compressed_page()
Date: Sat, 12 Sep 2026 08:55:56 +0200
Message-ID: <20260912065726.694766193@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 8a81803f87504ffd735f2a77f1299eadf2cbdf32 ]

This fixes handle_bounds_compressed_page() on highmem memory
as page_address() does not work on memory which has been kmap_local(),
only on kmap() memory.

Fixes: 495e90fa3348 ("ntfs: update attrib operations")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/compress.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
index 8078041b87968..f03fae63c199d 100644
--- a/fs/ntfs/compress.c
+++ b/fs/ntfs/compress.c
@@ -109,16 +109,16 @@ static inline void handle_bounds_compressed_page(struct page *page,
 
 	if ((pos + PAGE_SIZE > initialized_size) &&
 			(initialized_size < i_size)) {
-		u8 *kp = page_address(page);
-		unsigned int kp_ofs;
+		size_t offset;
 
 		ntfs_debug("Zeroing page region outside initialized size.");
-		if (pos >= initialized_size) {
-			clear_page(kp);
-			return;
-		}
-		kp_ofs = initialized_size & ~PAGE_MASK;
-		memset(kp + kp_ofs, 0, PAGE_SIZE - kp_ofs);
+		if (pos >= initialized_size)
+			offset = 0;
+		else
+			offset = offset_in_page(initialized_size);
+		zero_user_segment(page, offset, PAGE_SIZE);
+	} else {
+		flush_dcache_page(page);
 	}
 }
 
@@ -223,7 +223,6 @@ static int ntfs_decompress(struct page *dest_pages[], int completed_pages[],
 				 */
 				handle_bounds_compressed_page(dp, i_size,
 						initialized_size);
-				flush_dcache_page(dp);
 				kunmap_local(page_address(dp));
 				SetPageUptodate(dp);
 				unlock_page(dp);
@@ -759,7 +758,6 @@ int ntfs_read_compressed_block(struct folio *folio)
 				 */
 				handle_bounds_compressed_page(page, i_size,
 						initialized_size);
-				flush_dcache_page(page);
 				kunmap_local(page_address(page));
 				SetPageUptodate(page);
 				unlock_page(page);
-- 
2.53.0



