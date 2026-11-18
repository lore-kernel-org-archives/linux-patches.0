Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048241;
	b=bK+xF7k5yJiFNWcPXIV1i+nUbbSw+WPr56EMYEkszJyuAbNPINrlBHtxSCVYSSQiqOs5
	 ieGGqv7+haZvQ6j+2K9T78SDdtBrzyg6Ckd7iihsO32OdtaNMSsUgyvtMMJLBRzGIZSNO
	 t3iVttqe3ZHGyf589872aWgXv9vV6uB9fyixl/ZTaZTZ5zsOup78YoZoVzAx4Ajs+ITMG
	 buGn+x+eTIuKIx2OLEKAtzLDOm+YIgnidnhZB/PGk7G6g8tYKg0Drhng5N4vv65ok7/bc
	 x8dxCLaES/0xSgdKO851cz6tc6kRzqxCzaBVy0ocj09tfO5rR64wlE8YA+XFEmNTj4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048241;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fWz1HKQEhT+pgzHEnMxIjYKnN0XASghbGDb9j7wbCXE=;
	b=UiDoRa4R0Y6pq820IeMLnpwOK7WeQ3zJoJm0x5sVLnDSMJI9F21928cudMbx1uFSQciX
	 HAwgL6q+YUCukzvLAaIjT1OYGrFw0UI4Jylxm1krmY5Tzz4gvSn6nitaor/1Ac/rvQ/sh
	 Qg+A815pjsRdQidiS/nZt0/fh/Isd8TtTwFQwxXd3RggYGvOVrL1SNY8sea7bKLi4PdYq
	 48o7uYhinJEstvzeDEtFYON/VcrVUadFN3KH2rzYFctlMSQCtPXY+CZNpgXpFG8Iq6lK7
	 CX5Z51Y7ajZ+3Q9YsUnDb6wvQQZGR0i+G3E0lBvYm21J4NUKNlfk8r/cPsl/rBZdICg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="U6uRs/eB";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533EC606A32F;
	Thu, 19 Nov 2026 00:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U6uRs/eB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6A01F000C5;
	Thu, 19 Nov 2026 00:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048241;
	bh=fWz1HKQEhT+pgzHEnMxIjYKnN0XASghbGDb9j7wbCXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U6uRs/eBzFAbxlIKBm28AsIUcjYy4hWgFhedRQomx1OkSui/I8KAv/a3O1MNPGYQs
	 y9j/7pAOkqq/qKdRRhuBg0P5DkntNnGcnYqFoZ97Ph7/M2Jotm4ckp61zWeUJdEku9
	 nmmxQ/lpKGz/PI59f9jF9CFgd0cQqxk0M9jLOWJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1924/2857] ntfs: Do not kmap page cache pages for compression
Date: Wed, 18 Nov 2026 15:49:18 +0100
Message-ID: <20261118150310.484174901@linuxfoundation.org>
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
index aba6783dc64f2..9a7e1099d34b1 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -2577,9 +2577,6 @@ int ni_read_frame(struct ntfs_inode *ni, u64 frame_vbo, struct page **pages,
 	 * To simplify decompress algorithm do vmap for source
 	 * and target pages.
 	 */
-	for (i = 0; i < pages_per_frame; i++)
-		kmap(pages[i]);
-
 	frame_size = pages_per_frame << PAGE_SHIFT;
 	frame_mem = vmap(pages, pages_per_frame, VM_MAP, PAGE_KERNEL);
 	if (!frame_mem) {
@@ -2835,7 +2832,6 @@ int ni_read_frame(struct ntfs_inode *ni, u64 frame_vbo, struct page **pages,
 out:
 	for (i = 0; i < pages_per_frame; i++) {
 		pg = pages[i];
-		kunmap(pg);
 		SetPageUptodate(pg);
 	}
 
@@ -2922,9 +2918,6 @@ int ni_write_frame(struct ntfs_inode *ni, struct page **pages,
 		goto out1;
 	}
 
-	for (i = 0; i < pages_per_frame; i++)
-		kmap(pages[i]);
-
 	/* Map in-memory frame for read-only. */
 	frame_mem = vmap(pages, pages_per_frame, VM_MAP, PAGE_KERNEL_RO);
 	if (!frame_mem) {
@@ -2990,11 +2983,7 @@ int ni_write_frame(struct ntfs_inode *ni, struct page **pages,
 
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



