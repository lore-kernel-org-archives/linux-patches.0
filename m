Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026371;
	b=EfYFTXrvhBw4V9xcgg9bXXrGzu3SZV4WuhMhLs5KeznII8kIsrJifLPAY9BbEAJSh+uS
	 h6WS3m0+csQPNzIR9XIYpy/7zwwvszhOGT3CH/SRPuL3aib/nmBKujI6f6pV9xkaUSz2M
	 /WNFIofFCVcuSPzCqYW9f/nFmT/aYFGdmfZ8rgUbEvMnQOF5/RVTPVkOyNGz1KXC9D7k0
	 eD9z76PuIPFhaVOnozFuRfmgJXcg4A5d01IVi4e1I+SICQrBiAES6xr09L8qYWUUYGSrx
	 rryCpvfk9cGMpCbwKNjFrGb8EB0iARsXRZ9bi8NCB3kWi52xsviYwPyOcVGkxQHmLMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026371;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RUy1vNc6uor86aifyH5VQNYmcOhpXM3KQDOOA78cyJc=;
	b=MDEYuGy7mG7G24gugGrfAUIWFYvA041DAWVUg3d265e/jOLM7XBjvNeoeUrRBq8uPQ1/
	 VSysg7WUqfV243nfblxDlKbsX7i0zkHjlquJeIz7aD+5qeoBXBTYjb9F3uzdSmmSJ1srj
	 qwRYzGs8yWcMMZRiFZDe6NiFKwCAQ9f2UBXGDZ0F/sjE1NEpRcPiFxlZBfi3kHrBQKYxo
	 C2qSZP0oa7ETHQPG7RwrxUK+MK2ZTrNidKP7E4SFAoCYBsgTzboJNvKWqTHfNv8mlJ1iG
	 BgeGzB6ZfgKb1g0ojOstTaZ8K9pvcxQs3SjK04itQ5/0Cs83am7uhRkYhe9+JlZyZ7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KyZyfUav;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE10606A325;
	Wed, 18 Nov 2026 18:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KyZyfUav
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E151F000C4;
	Wed, 18 Nov 2026 18:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026371;
	bh=RUy1vNc6uor86aifyH5VQNYmcOhpXM3KQDOOA78cyJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KyZyfUavkRsa94vdTUQOyLL3VDfilizPcv91qzhg7BfwD2USliO86/DGaI/60jOHZ
	 Z9TcwHjcaVf+IL8BUhEyleD3aNyHLn9zikKQBKYosWXhcUpPicR5n6rwdJ4cR4mXsj
	 +kg4D8+xrxaNpQ2Kz59FsrCGHNW3jxVp+eTO+leg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1410/2151] ntfs: Do not kmap pages used for reading from disk
Date: Wed, 18 Nov 2026 15:52:25 +0100
Message-ID: <20261118150213.339330477@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 14656154d26cf244d063477a03606775eec19780 ]

These pages are accessed through DMA and vmap; they are not accessed
by calling page_address(), so they do not need to be kmapped.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Stable-dep-of: 80218408836f ("fs/ntfs3: do not mark frame pages uptodate on read error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 81b536a268633..af3a49283e6e7 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -2627,7 +2627,6 @@ int ni_read_frame(struct ntfs_inode *ni, u64 frame_vbo, struct page **pages,
 		}
 		pages_disk[i] = pg;
 		lock_page(pg);
-		kmap(pg);
 	}
 
 	/* Read 'ondisk_size' bytes from disk. */
@@ -2686,7 +2685,6 @@ int ni_read_frame(struct ntfs_inode *ni, u64 frame_vbo, struct page **pages,
 	for (i = 0; i < npages_disk; i++) {
 		pg = pages_disk[i];
 		if (pg) {
-			kunmap(pg);
 			unlock_page(pg);
 			put_page(pg);
 		}
@@ -2782,7 +2780,6 @@ int ni_write_frame(struct ntfs_inode *ni, struct page **pages,
 		}
 		pages_disk[i] = pg;
 		lock_page(pg);
-		kmap(pg);
 	}
 
 	/* To simplify compress algorithm do vmap for source and target pages. */
@@ -2863,7 +2860,6 @@ int ni_write_frame(struct ntfs_inode *ni, struct page **pages,
 	for (i = 0; i < pages_per_frame; i++) {
 		pg = pages_disk[i];
 		if (pg) {
-			kunmap(pg);
 			unlock_page(pg);
 			put_page(pg);
 		}
-- 
2.53.0



