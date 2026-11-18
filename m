Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019800;
	b=hbHc3L457EGWx2nYA9RHne5J0NlpfeEh80R8orvRhPg8i4jBWDuadgdp+b+U9jkEFIGV
	 rd7o7EradfxM2P8BphmRo0yPFf6ClwikirU1EJUcD5H6agwTZvjU5j69PEHw5HaiUkKex
	 hiALGYXiC7mBHNyTO+MHmsemodGLIPqslEbrQckbLBsuJmXTlpcrd12wOTY6rXKJCPy0g
	 S6zCLV5A9Rn/Cip+CDv1tYbCpbqvNSKs8dJ6iyJdDgvPv6WkCn3ntm48HwXJB8hs7Tpy2
	 PpqMDF/rayyipYBi4bfYCf/GqJDNuhLs6CHQPwIzfBZClAp4vSVBXmwWmSIc99twzBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019800;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eEBL+6+aWZWLbbt0KIdQkgT8WatnW+NyyBjw1qh/D5s=;
	b=xz8nFVoYpz/nYx+WYcq94RvnkRbzhvfnLM8b49nmZVFBBc+iv6opW4Tjl0s+eKm5vG/M
	 B+MDb/Ws6ElGSkfcm7aMo5penszjkC8gBHhAlOcT56fnblA+b3DJYWyzAHwNhj256W3jj
	 4u0aSf8paOwChCy1mEeuV0uImiNMS0fPA0pvrTT6fY115T/9STQz6HT9DI4zrIaFEzusN
	 tdlSbuvMjsSmlY1GOhMjtnSRqplNcFb4BEA19AOJpRcnfaFMcoepcQ1KuwRVFozBOlbWL
	 /BVPj8363Afc00YtV2Dk+dOpRufI8BW6muL9NdmszIm2DoZi6NthQO2953E5UrYLbvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jbeYi3ED;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7721F606A325;
	Wed, 18 Nov 2026 16:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jbeYi3ED
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92361F000C4;
	Wed, 18 Nov 2026 16:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019800;
	bh=eEBL+6+aWZWLbbt0KIdQkgT8WatnW+NyyBjw1qh/D5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jbeYi3EDvlMAuFrNVQ1pB0N8VyjOpmdqucoVCO9cQBC+i3+DSzs4hf+k7VVmWJjBz
	 atyr6FgfevzTWiwC/3Xk3tRGXZb0OAGKeJEHRwvME72iydwj9an9frHZ/Lp+/Jx/9/
	 ZBCiSEjV47h8XAcMdO09wmWaVNOrQNJ+B8vA73xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1725/2651] net: alacritech: fix dma_free_coherent() in error path
Date: Wed, 18 Nov 2026 15:49:25 +0100
Message-ID: <20261118150349.729813023@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index c1949ca060ca8..311a9d1d90715 100644
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



