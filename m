Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031613;
	b=r88E0jQzpJ3d2MBKLcOXHghrwsLNYp6v8/IvHDjTEbNeTak/ESmOtO8yI1KCEs+hTlxM
	 pPvsosjNjdlIkchHDXJxk8tz/jorMcqw1HhqHbWWVSZDqhBTLlyg1DoSNPkjWxrBU/fvt
	 1K7gDPjqpFiDwLWcbIB+jXv4/wiinXlX6tgD5Dlv1a6hsaats8ZLX1Sk6jC4pcTPHT8GB
	 xrOimfv70bXqpmc1gW6dbmdnUuh3FwwnBL43OjUcMKQ9FVPA3wXbKV6jP1hvhcP7dlMEJ
	 8BrxSBTLf7mbkVIetWdBaXEk97VKR6LZoQOeyV6xi8xb4IttfilHZl8U1Cu+uSPZRzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031613;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kspranxBicNpbA+7pwX2jqP808DvxY7irxJA7eS5Ap8=;
	b=HzdP6ZQvHQdpQZ/pt9Oow4weBFTbgB8sq3SfUx83fqkXmjVGvQkrr7t9ql6XorLJVHv0
	 v1rj+W7uY9uo0OzprLTVDIUsIolvzKxBV23sa95+w7NsgbfcBr4/LJ/8SWb8R+e8/tQUG
	 LRtMZjqqDrefCCHZNvhN3Ffz8n2ARKn/92NUZA2QLX5Ar1yV3ibrxk39vV/O7EOADKKAZ
	 ah9BWJjncRPQj41gRiQ3y/Gs7ZYHbXX19LZJbqLRQkjXdzfvKdA0U2j9q9oxVmiZW7PpT
	 Sj//yk0l7hL7r1sDSryDu4OU79tqO/k5SEJyDyrfeQc7jV5es5wDEzmqYNXyzxRV0MQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HBILdD0j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFEE606A335;
	Wed, 18 Nov 2026 19:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HBILdD0j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7E61F000C6;
	Wed, 18 Nov 2026 19:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031612;
	bh=kspranxBicNpbA+7pwX2jqP808DvxY7irxJA7eS5Ap8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HBILdD0jZykuB9aPk0O6NWS9ycBV/plg6KTytmiFqJfCxqXQsaFnqmjvfX5F1zBTO
	 JJS4lI1x4oDMZnb6Gidx5iDC0ZhNJc/FC0I1W4M0NNPg8qS9QdgpqbS3+s+B4PqPhh
	 u9FsiHxBX2Nn3smyjwu8BmfVvff7mqJEGQww9NVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1120/1756] ntfs: Do not kmap pages used for reading from disk
Date: Wed, 18 Nov 2026 15:54:07 +0100
Message-ID: <20261118150054.706432700@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 014dcf2e50422..38d352b70e147 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -2684,7 +2684,6 @@ int ni_read_frame(struct ntfs_inode *ni, u64 frame_vbo, struct page **pages,
 		}
 		pages_disk[i] = pg;
 		lock_page(pg);
-		kmap(pg);
 	}
 
 	/* Read 'ondisk_size' bytes from disk. */
@@ -2743,7 +2742,6 @@ int ni_read_frame(struct ntfs_inode *ni, u64 frame_vbo, struct page **pages,
 	for (i = 0; i < npages_disk; i++) {
 		pg = pages_disk[i];
 		if (pg) {
-			kunmap(pg);
 			unlock_page(pg);
 			put_page(pg);
 		}
@@ -2838,7 +2836,6 @@ int ni_write_frame(struct ntfs_inode *ni, struct page **pages,
 		}
 		pages_disk[i] = pg;
 		lock_page(pg);
-		kmap(pg);
 	}
 
 	/* To simplify compress algorithm do vmap for source and target pages. */
@@ -2919,7 +2916,6 @@ int ni_write_frame(struct ntfs_inode *ni, struct page **pages,
 	for (i = 0; i < pages_per_frame; i++) {
 		pg = pages_disk[i];
 		if (pg) {
-			kunmap(pg);
 			unlock_page(pg);
 			put_page(pg);
 		}
-- 
2.53.0



