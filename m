Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208969;
	b=ZBJFVSMVbBU0cdsLvntTW5bFEfiAgfIWfteKHL5RllMgQzvy9UUULY8W3D4jKE/2vhns
	 0Nvf5Swn5XOjEcYjkUWC5qORa32WPvhzl/E7VDtnP12G5Bpd6YZcXxcJVfOUponOwu7xw
	 xxsPgbUCrLEsdkWQZu5rl+g1/BCXRTibLytKLFXWE3nlarT/ZxotAC8Ii+LFz3WQYG+DM
	 8NO21sHNYYN6CHtQJOGJYTWYaDrA7Iw64Mh75eOGw+5h/pfStnpqt5sTW9nsxrKvOF8ZJ
	 XUxyU0+BhVi360QKpcOZEvbFJG9VapARGW6jU5EE9O4wKwnNmeC5EmrMLYvDxZOpW6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208969;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O0cprCkpGavbyhHR8ZSTZh6Byajm33hRrxrToVjgdTc=;
	b=amzztHA9SjvNPCedox5sfzwmMU9uuC2EjsDuz+mo0pG8uCcs59F0klht1JoT+GnEqc29
	 hTEh0bupSqY4V4ZETM1WcTpGa2JkkRtFHO97XKoERUoe+iCaahZl3eb1YlIEjXljafqlu
	 ZbbgXcbgixDyky61ckas+rwv5VwXZCJdWACjrgJgUTjDbz8V2Js/S2ZEHJ5gT7VEMfF2D
	 KP5rqizeCYeqqnaWq6rOHniAKhkhSncwkPGs/sh+cyCQz6iL+N4K/Utkfrfs+zw6dWJyp
	 Evbl84StJjjtbqlk/VVRngX17qjWfZYSDT05JjRxWDKLVk4T//6a/BMXuVcuVJsvjkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aqjFqkjN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8815E606A31D;
	Wed, 28 Oct 2026 17:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aqjFqkjN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF56F1F01825;
	Wed, 28 Oct 2026 17:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208968;
	bh=O0cprCkpGavbyhHR8ZSTZh6Byajm33hRrxrToVjgdTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aqjFqkjNjVs/RT1gQduBpOhMnwKLbGDZCiAc/25kwEcmj2M9+13BRn+K2sj/4S5oE
	 Tz0BskLD8P8/VLiUSj4DF8xKO+8Z5a43hqvv87gxxRKTSeSe2xZec6jJeRASYWnoKM
	 sdB3cPdc/4zqMUBIKDIUTfDrVMNGG5LlLoz2UUeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rik van Riel <riel@surriel.com>,
	Zi Yan <ziy@nvidia.com>,
	Jinjiang Tu <tujinjiang@huawei.com>,
	Dave Jones <davej@codemonkey.org.uk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 306/516] fs: Free any excess xarray nodes in clear_inode()
Date: Wed, 28 Oct 2026 17:57:38 +0100
Message-ID: <20261028170010.738894591@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit ee3f011250104129893d8e9599147e457d4d7280 ]

For many years we've had a hard to hit leak of xarray nodes.  Hugh
documented it well in commit 786b31121a2c.  Recently people and
syzbot have found ways to force it to happen with madvise.  Rather
than fix the leaks where they happen, just call xa_destroy() which
has the side-effect of cycling the i_pages lock.

Cc: Rik van Riel <riel@surriel.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Link: https://lore.kernel.org/all/20260121062243.1893129-1-tujinjiang@huawei.com/
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Link: https://patch.msgid.link/20260623192850.1595958-1-willy@infradead.org
Reviewed-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/inode.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 320b70ce79a72..40cc72fe37f99 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -556,14 +556,19 @@ EXPORT_SYMBOL(__remove_inode_hash);
 void clear_inode(struct inode *inode)
 {
 	/*
-	 * We have to cycle the i_pages lock here because reclaim can be in the
-	 * process of removing the last page (in __delete_from_page_cache())
-	 * and we must not free the mapping under it.
+	 * We have to cycle the i_pages lock here because reclaim
+	 * can be in the process of removing the last page (in
+	 * __delete_from_page_cache()) and we must not free the mapping
+	 * under it.  We also remove nodes which are empty; these
+	 * can occur in two different ways.  The first is that radix
+	 * tree expansion can fail partway and the second is that THP
+	 * collapse_file() can allocate some temporary nodes and not
+	 * clean them up.
 	 */
-	xa_lock_irq(&inode->i_data.i_pages);
+	xa_destroy(&inode->i_data.i_pages);
+
 	BUG_ON(inode->i_data.nrpages);
 	BUG_ON(inode->i_data.nrexceptional);
-	xa_unlock_irq(&inode->i_data.i_pages);
 	BUG_ON(!list_empty(&inode->i_data.private_list));
 	BUG_ON(!(inode->i_state & I_FREEING));
 	BUG_ON(inode->i_state & I_CLEAR);
-- 
2.53.0



