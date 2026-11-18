Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039734;
	b=a9yExpnttelLT6Ia78ksrT1reYI471bzjc2jAGjpjf01omJPkC2C9JE+Nf8OkGWNLZlY
	 H2zpxW9LgyGz7J9Xusuixi1Sct3PNFd1ydRaMdn4KnlkpkIMqaAq6EUt78VBSBjMaBXtV
	 AgjT85GaAvSvx5yu2gtdyF+jKLC0QjLHeHkpbIaoz7AFUobEpqWKGTddPqQwvZUY3zF26
	 PBhTxjwKpLx08Z218ApbvK+sl4w+7Syka22iqT+aKrBY4y/gNqCTaEz0opDCIFzAZc5+A
	 OCmuwxv9I9dc/HY/8Z28tvACOVs0W4iw2FMkziDikJUdW6UXVw35TTL4XXMhQ0dhsFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039734;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2cegOGqCFFVIfzv32Dk2gu21S9J7/WhV1yR3VTPtLSw=;
	b=XkKnRndc6+GpcneQsItAUvQzopyQdFU9rfOZFwjLbnbRCXmFgtG4hw8zSj8ui85AATGt
	 v+/peB+uxAOOJxaAmvKjxpkzZjRgIPmE0mV00UyjlQLwQsjzgtID+TN1YfGt3OlH80Ytx
	 Cm3Z5OsXlWR2YInF02x3N87V/DHnVgkcJja+9x0J5MqCy2KQO5GDeJHC8si9GCfS2FdpW
	 ES7qmDNs+90o0v2Gvxr/8CPa2EVn0SoQwh7nv6vbgBCwKIVLDPhPszQG7fqeDHYhEx3HV
	 yA8OMpKm19JdKmYVCWgslUAsJb7nBCZEjM6Yg0apP7/wcRwpAUz3V/QjQ4U9dH0x/sQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ih27dDYU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72B2606A32C;
	Wed, 18 Nov 2026 22:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ih27dDYU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182871F000C4;
	Wed, 18 Nov 2026 22:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039734;
	bh=2cegOGqCFFVIfzv32Dk2gu21S9J7/WhV1yR3VTPtLSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ih27dDYUXH1qNdaCIvZNNycIh60ESr8WpaTBFTFf11fJ1tvDnaQhhCJZqbMKA4SaA
	 GKTQpHkWEywbtpm+oHl7Uq4KMsN3ZfogVj3/ttW+APfgnI5efZDFxLRpUKaU2Tsgia
	 EAHyVRS9uPbU3YjJcHfjlRZgrt8y5EHm+cg+dL8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2206/3318] ntfs: Do not kmap page cache pages for compression
Date: Wed, 18 Nov 2026 15:47:08 +0100
Message-ID: <20261118150428.103381074@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index efe20e6b8d078..32317e127f5a9 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -2501,9 +2501,6 @@ int ni_read_frame(struct ntfs_inode *ni, u64 frame_vbo, struct page **pages,
 	 * To simplify decompress algorithm do vmap for source
 	 * and target pages.
 	 */
-	for (i = 0; i < pages_per_frame; i++)
-		kmap(pages[i]);
-
 	frame_size = pages_per_frame << PAGE_SHIFT;
 	frame_mem = vmap(pages, pages_per_frame, VM_MAP, PAGE_KERNEL);
 	if (!frame_mem) {
@@ -2760,7 +2757,6 @@ int ni_read_frame(struct ntfs_inode *ni, u64 frame_vbo, struct page **pages,
 out:
 	for (i = 0; i < pages_per_frame; i++) {
 		pg = pages[i];
-		kunmap(pg);
 		SetPageUptodate(pg);
 	}
 
@@ -2847,9 +2843,6 @@ int ni_write_frame(struct ntfs_inode *ni, struct page **pages,
 		goto out1;
 	}
 
-	for (i = 0; i < pages_per_frame; i++)
-		kmap(pages[i]);
-
 	/* Map in-memory frame for read-only. */
 	frame_mem = vmap(pages, pages_per_frame, VM_MAP, PAGE_KERNEL_RO);
 	if (!frame_mem) {
@@ -2915,11 +2908,7 @@ int ni_write_frame(struct ntfs_inode *ni, struct page **pages,
 
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



