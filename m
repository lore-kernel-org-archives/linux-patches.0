Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041380;
	b=PYjV9FFwsDn60Ec0EuLk+0ek8Cv38tpKr72zO2xIZEobBXVfvHCitWnpNFrABhKZkoIT
	 Xv59irTk5u0MT6Sg4dLITy+Ri5BDCnHuEe00TyibejBMw/E2DKnpjNQ2q4UovFHkPZAM1
	 GxLVd0Hnq9lJvG2EyomBNLB4/Yg6NpBXWMK18wezdfPbSs/lfrF8NPFepfZiwRMWQ6o1V
	 4uzHIY6/EfJ52REHi7GyUG4vAgUC0926Ys7IldlXTlCyH7xgQca9sfnn9osP47F2lmclU
	 PkN2RPIrDNME8D2Rry0hCzXEodnAZN0lQJJC8u+JvgkrLOhU0ecK1fTgiGzVULCxBWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041380;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1e715JdMhGcJcrPHID9XvJgRGYasXeqhgyLUSKzkQnE=;
	b=VGb0RWfXw97LFJXf1cn5pCR0DqdFaYk35XPfsaOeQt0WUAO/4ZmGV9fDvG/ULbPs5WcV
	 zhuPZ+pbTnG3t2lTij0XhMkVb+vtTHSh9WetC3vX5bxO4YowgzcZPZNjHwwPOUuZSJ0rR
	 5VZoN119g11O7rlWUpcYQ5pm8rtj1E5aGr8DYY48q/HC8CMfv3z7fa+h2hYfafvW9RXRG
	 K71+Z60v5aXWzWNVuJ17hlY/JONRkwIc/ccZ75QYSzL7WUKsvEovnr+mmvvpH4j+/tn7T
	 f8EhAV1gfV6Yka2dy0/+jss7wP525ZcpHavjVentgECvX4jvVaLQ0m0F44IZbeiKrmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="m/ccWS1V";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654B2606A32F;
	Wed, 18 Nov 2026 22:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m/ccWS1V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B3B01F000C4;
	Wed, 18 Nov 2026 22:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041380;
	bh=1e715JdMhGcJcrPHID9XvJgRGYasXeqhgyLUSKzkQnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m/ccWS1VzhuyRIe4g/RDT34D7ucaFpztie7Xo6huDACn7zH3+478OOBajLmO0qxze
	 PvvnzCjBmE/7U2Tkb/vRhtkffddRTp8HnlwAZxd4nUfMNu1jh2M7nFJwOAATFsX9V7
	 25OMoB/Ay0EQeVMmzJU+BoGVxkBA+sKlIoxAI5Qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2792/3318] net: alacritech: fix dma_free_coherent() in error path
Date: Wed, 18 Nov 2026 15:56:54 +0100
Message-ID: <20261118150444.445061441@linuxfoundation.org>
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
index 78231c85234d0..2042bf8993029 100644
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



