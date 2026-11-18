Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031624;
	b=czXazL/3iurYbYRncq9vgaRodFENEBsMTQ2Q3UdKkHOQCQyDAf1y7OEU1nsu9DQY+oX0
	 pOn7/Hn7JTx3wVgzkEnfmNe+Ev9dI2TfSLxI3PddH3kIHiKyYZb9RglYkn3IsMpNGrc3I
	 IFtTtGRBVTwE+qIg6vNaevKSypHd8DwAj/G0+lhUMwwJbQHmYB5EZd3PPEfrKnshH9Xjk
	 RhgOpz0AVZndgkrOrR33EA50K/ZP0onNA35P6qFxCnMBg40tBWx3k0MxgKjSOC+5xCz9G
	 I2E5MGt5XoIJbBMKFtk4amijDXds4K7BEdjxHRDrhhiybT4Lj0M4NQNxWpTstkyCISw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031624;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r6EBqcea1OhCyv1lP3RQdq3cNJQWmrhLeLUuM9RmliY=;
	b=kBdFTmXCTtcBtp/6/6Ht7hkV2RPJmHFMm3Q7L4oTkuT62aEvaQsckuNwyeEp5ANuTZEI
	 VAaAmAOxhWODJFajCP6YD8FVYNvKj7ip1zis+jFuu097A0hvB/0XMEyApmC97EmAx51MW
	 hhi6uV+iiOqs0QtC2tk37N3N/bBO/l4o5NbXM/HT59csRZ6xEKMw12QE9r0Sq3Ii8iL06
	 E7PUFIDeQw6tIj4+LXhs5PFmw22NHsz3bFTY1zSShwV08cwyBdNBFijvNF5jmKs0bWO1K
	 Vxc5A/neZPJUmdhj69ZFsmtl/TiTPQ+zC22vHbGjfl+G0BNZKDxb9fC6OwuSCkkqiMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XwfTWIVK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25467606A31C;
	Wed, 18 Nov 2026 19:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XwfTWIVK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 765551F000C4;
	Wed, 18 Nov 2026 19:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031624;
	bh=r6EBqcea1OhCyv1lP3RQdq3cNJQWmrhLeLUuM9RmliY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XwfTWIVKmKnSEtBjfvYa0NOZAadnvJKHrlp761c42mqQModwhwQtJm8RUwbyR9G6l
	 P/n2t4hHRyu3MeWjNn4WF6v5o0pU9dGDl3bsKssRX6K285xHjLAN1gcbr0liUyJltD
	 as/+nIvwdJZlu/JAEpehiXf8IdYhXG+oqKJwD0SU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1123/1756] net: alacritech: fix dma_free_coherent() in error path
Date: Wed, 18 Nov 2026 15:54:10 +0100
Message-ID: <20261118150054.813576079@linuxfoundation.org>
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



