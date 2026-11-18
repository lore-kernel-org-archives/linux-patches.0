Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055065;
	b=BXSfJXji6LyrFadhj2kNY0ONhsSCJ32H/oGIlq6Ib6/nTdGl0JaqWfB5AZRbAwHyw3tj
	 gC5rnjnXIZbELk2qdhOASmwc/XP426tMProwNZedmKDF/ao1m6lRc4nYuz0jvZ4XQJONV
	 WSm9A7YZv7CbJOuKDyEaIZGpVDxTlUaCh6KuZ4GEFofTmFETVSrouTscpYicHTMBowPdq
	 JW3lm+qTXjmItAJbS+GuTNPrmToF00bTIJUW3M9JSVEfjPRIj2iWkHKiBFGaABaSAakyI
	 odfKY2uPRRbT4MwSAYAvoyU+bGLnkVzhsl4emPKUjJ5ujJwgrXEawFjdugIOtZ8LXUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055065;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aSLVcnXK0wDdV3K496oYBDGOImOmch1S2B9t/eR/cbE=;
	b=zxWqdHuQv4C2twQmQK8dGbzLdg7FQ/0GuNxrqiZ2ghhFeBXIKmhJdcIlmNCrgCUpUSSH
	 Qu7jKhopb6l1K2CqcZEh56WZ9iClUmESvuyYikn6Fc8OgA3/DlvypR8fcw9PlaLPsMQy5
	 KPlFY8nRYz9EIZ16g0ZKbgjraQGPWEHa/Hcplq2SMyxwG+NyzeR4GxFKiqEk6R9jR2GXy
	 PRUPaPNnKk2Dnq2tsxepA/MXe/pvq9tEnbfWOOgq3e/QeLIP6eePBDr/QsgilgNnqVxq7
	 ZROdKOselgyb6bXiCo4tPnSCcUism//TtAUzzuILX1O6hS++crftJ1EccDp6gt25Qdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="uptWc/TT";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483E1606A31C;
	Thu, 19 Nov 2026 02:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uptWc/TT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E161F000C4;
	Thu, 19 Nov 2026 02:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055065;
	bh=aSLVcnXK0wDdV3K496oYBDGOImOmch1S2B9t/eR/cbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uptWc/TTeC4vNDLrHQ/2KRJpVmqNu8AwTKPyn8zkF9JeM4YVPb6QuQPzExmNW50iE
	 K8GM3rFje2IZWalCQE7gzNOKf4KXzU93fHFeKyLMeRPWHdCcrsPfLIDn47QHNQ3zyf
	 4ObOWmup2Usq+GyuAgRRSfZziRV80vqBde3Qwv1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1497/2214] ntfs: Do not kmap page cache pages for compression
Date: Wed, 18 Nov 2026 15:52:53 +0100
Message-ID: <20261118150111.517657604@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 953b79a7a124c3dae86544cea581a5bc7655aa13 ]

These pages are accessed through vmap; they are not accessed
by calling page_address(), so they do not need to be kmapped.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Stable-dep-of: a32e893a077a ("fs/ntfs3: zero frame pages on read error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index b3dbe21f48409..07e6ebe736da3 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -2446,9 +2446,6 @@ int ni_read_frame(struct ntfs_inode *ni, u64 frame_vbo, struct page **pages,
 	 * To simplify decompress algorithm do vmap for source
 	 * and target pages.
 	 */
-	for (i = 0; i < pages_per_frame; i++)
-		kmap(pages[i]);
-
 	frame_size = pages_per_frame << PAGE_SHIFT;
 	frame_mem = vmap(pages, pages_per_frame, VM_MAP, PAGE_KERNEL);
 	if (!frame_mem) {
@@ -2704,7 +2701,6 @@ int ni_read_frame(struct ntfs_inode *ni, u64 frame_vbo, struct page **pages,
 out:
 	for (i = 0; i < pages_per_frame; i++) {
 		pg = pages[i];
-		kunmap(pg);
 		SetPageUptodate(pg);
 	}
 
@@ -2791,9 +2787,6 @@ int ni_write_frame(struct ntfs_inode *ni, struct page **pages,
 		goto out1;
 	}
 
-	for (i = 0; i < pages_per_frame; i++)
-		kmap(pages[i]);
-
 	/* Map in-memory frame for read-only. */
 	frame_mem = vmap(pages, pages_per_frame, VM_MAP, PAGE_KERNEL_RO);
 	if (!frame_mem) {
@@ -2859,11 +2852,7 @@ int ni_write_frame(struct ntfs_inode *ni, struct page **pages,
 
 out3:
 	vunmap(frame_mem);
-
 out2:
-	for (i = 0; i < pages_per_frame; i++)
-		kunmap(pages[i]);
-
 	vunmap(frame_ondisk);
 out1:
 	for (i = 0; i < pages_per_frame; i++) {
-- 
2.53.0



