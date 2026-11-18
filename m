Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026379;
	b=WP39znzz+nOknpPBnTDJAInRPxWI/VwDtWVv21u5J4x86k1f7v61IqRR0QLnkGoLiBcR
	 3uiro/SbrOYRUO6KVprTEzMqL1bYusOI7b4M61xTRz8uLlfs93JjWYNNiZ9VnYy9wRCwk
	 8LgKhpWD71j8KOW08fpEWmCVD+/KzkjheFD453tNG94VITFlA8E3pcltPZJFNOBOkimh+
	 odM41MzMuNjrMwjGS7PYpoZYLGGGvpb00wlztvONeFwnLP9y/1QYQZU72EU1C+kIExwxL
	 puzDU1t8V1l1I5mkm8S92XT2C/maAgyjYhnNENhvxrghzoXVIWRUB4NdS0rV2eeBH3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026379;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yDc9nftTeCbvsxI1vyBVKeh2/L1gtsNuGQc48Bi2R9c=;
	b=nwoVhKaG9MGoHezUUqTcU1hXU28jD+wUOFJyZaIqz5TvQe8E+9JMicD4dsBjzLn1PgI1
	 9GOOLBavIEvH8vDarRLofQGw4VflFFYuZ+20XEXZLIIBQBNBN8Z8uf4EE4favT9SfvEVD
	 0TUm/dSYTGzZLumymQaatTO0fdABStJXuuKDtp9oItfqheUDV7XOOWQJfQEm+jAQAi1t0
	 UY4BSp1c27K2WWuRxqFc5z9uw3nM3CgEEYLJnMkblJFUl+5WClNgAEJ/n0VnNLaSFywfB
	 U/SLwM2LUATEIy+RysBYCpnvPyTibF6EjIx+LdMj8LEb7x6rC275Nqq2L3a33Aw8LMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bKKH3PrR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60306606A336;
	Wed, 18 Nov 2026 18:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bKKH3PrR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5821F000C8;
	Wed, 18 Nov 2026 18:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026379;
	bh=yDc9nftTeCbvsxI1vyBVKeh2/L1gtsNuGQc48Bi2R9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bKKH3PrRHQFxQ8nbZQiwZYQRkieas3UUv57ZfLDXPNE4n5JW7zDUeVaYUoRHxfEN2
	 xt4M741nN1q5iOGJvXKneXa/+JKOIpWl+Lz6xYbY+5XWu+Rk1QSXcOEn8SLyexDdXr
	 vleFIRJoyo1QcPXCnKMTaCGk4fhuaO2vdaHSoDgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1413/2151] net: alacritech: fix dma_free_coherent() in error path
Date: Wed, 18 Nov 2026 15:52:28 +0100
Message-ID: <20261118150213.444065415@linuxfoundation.org>
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

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 05b5019b01fb9443b09ae4ed34af1135a80a84c8 ]

In slic_init_stat_queue(), a series of coherent buffers is allocated
with the length size. The size is then stored in stq->mem_size for
normal deallocation. However, in the error path, stq->mem_size is also
used but is not initialized. This error may leave the freed buffers
mapped, leaking a resource and allowing the device to access freed
memory.

Change the length in error path to size.

Fixes: 60c140df15db ("net: ethernet: slicoss: add slicoss gigabit ethernet driver")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261006140912.50828-2-fourier.thomas@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/alacritech/slicoss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/alacritech/slicoss.c b/drivers/net/ethernet/alacritech/slicoss.c
index f62851708d4f3..4b4f44a5c6cc0 100644
--- a/drivers/net/ethernet/alacritech/slicoss.c
+++ b/drivers/net/ethernet/alacritech/slicoss.c
@@ -813,7 +813,7 @@ static int slic_init_stat_queue(struct slic_device *sdev)
 
 free_descs:
 	while (i--) {
-		dma_free_coherent(&sdev->pdev->dev, stq->mem_size,
+		dma_free_coherent(&sdev->pdev->dev, size,
 				  stq->descs[i] - stq->addr_offset[i],
 				  stq->paddr[i] - stq->addr_offset[i]);
 	}
-- 
2.53.0



