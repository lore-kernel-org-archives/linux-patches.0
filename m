Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056105;
	b=OYFt0Rk7vRxlblb6HG4ZzWi0x81QwV3pBeVJ6hePcbPLtlq2UV4x3kJ7ns0Fvz4kfkQu
	 BpFa1pGruQrCRl4GndkFSIBqtw0fsYhMSs5ooTK6uuDAQFtup7TBIi4Uut/YVQYgmkYCJ
	 XHrZcZZPiHw5KST4X67bKDLpx+EXGtTKQn7xTGWLOIGJF6A+YysK/YGb1cns45rjzko/6
	 lrivhxBPhzcODk0yIiy6B1zDE72YJvSXaG4DieWJnSKOcnv5ZAzURRnZ/Roulp3Cf72Wf
	 MqRfpel/Md+JhjChz9/HbUos8j0J2N2xRlCQyddRW9Y5Wh1iZP+3dZIGz54/5CBUOJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056105;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uSp//ih1H40auEYl1f+33dlwRJ1Q2hwfgSrjIWdlwns=;
	b=YBxjFqv2TqJ1iwPtyXVv2TNvnFs+F4VMaKduS5wmOWmVGBDigdZlFNVX0hgQJftLELEP
	 SucreaX8VizLpZqxh9AWOlZo6bQ0bKBgS8TojZcd8IcZTu4opgGZIcVqCjkltEUdyNyAy
	 yyP+Q1Mweocm0YD7J9EA4Uyjvb4vlh9oyKDJzKTUfV+mSUlthpsoGElHguon6rUVqwCTR
	 x+hhkv/I+qs4R9XqTY+L4CF2jWqy8cL+VLzPFNgPtlkMpSlFlofl+dQbnsfwzdbD2MyTl
	 xYsdTNNW38Gclxlom4SRprMw+i2nIHCuVtqZHquCR5MOTaO5Lw0+JoWzeTXDMw4VQTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WY7VYfdQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416C0606A31C;
	Thu, 19 Nov 2026 02:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WY7VYfdQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EE2A1F000C4;
	Thu, 19 Nov 2026 02:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056105;
	bh=uSp//ih1H40auEYl1f+33dlwRJ1Q2hwfgSrjIWdlwns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WY7VYfdQ/86oUtihF52RNza59/7pG5EGlxQNlNv+YOzsTF1zUN1oRieVLTkmcO6AG
	 PBMGDfNFyvN64L2vCzLhTBBYD/ddOqfQqZfv9nOm0ucsg/6ukagAQmFmG+oTcNERjx
	 V0L28X3PS2foAVu14AHZe6J0jPOg/rpzJf6vo0rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1870/2214] net: alacritech: fix dma_free_coherent() in error path
Date: Wed, 18 Nov 2026 15:59:06 +0100
Message-ID: <20261118150126.100780740@linuxfoundation.org>
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
index 1fc9a1cd3ef8f..7135b8f40c644 100644
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



