Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591352;
	b=t+ivrzRidKNbdKlsKM4hlobsVyjJOeBNd09F/kMOtigYWsfb0ZQwFn4CjchfxIQraAeA
	 702yH/uPC/ZwLKREbFjMixoCCfd4Y8xv2V70+Xn24HYDPzDaogadBMFGl4kvO6dFBMWL6
	 XsXWBAGCgqWXWeCF9M/AAahtJdtYVnqwD5jRAXebkijfBPRbBjoDsITt+Shect6w/vzsB
	 ZBeZYBfvYdOlp0gith1jz/RKLisdY4CrCkEebSn+IhQRy6jLvMJrqhpMlkxs4QJa/sRHK
	 RYlSNyRyULmjYEvVEBhGr1cBhf6LhxKr9cxO/Xjb8ci28JBjWMt5sYYQ9Nf/kjF77yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591352;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O28wxl4bl+i5UlhxSDTuuga1G4pdcQICXHd+QLIEX4c=;
	b=rESb+zzlcWcaAgktFu8R7/ZPoicP/6U7svP2GX4ycPF8MihxTYwTBTtnsYVhnAg/30lO
	 hfNDgLekx35j79RtxKcYBPYD7NC3AKKDuyDAy6m6d9i0W5tJw+G+QE9qCad7j9s/zcbVt
	 lBXAi+14srDAtdiYtRO+U2JMRX3jRFiV9aYmUbbU0aPhUPO6tQuPpVpaKMSoyplftO5Te
	 Hy2/vYavHVBdOzaolutSkiQX0gBKpZ+2EysP3Oqx5j3hP+fGkzoxe2lMUVgMJlc2S0eiK
	 kiehTfRNjcYFPvMQQvceyPB3sb4Ajib6GlINSvTIEYrGeiDe9vfi23VDTdGEUtQGXlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yvee2csq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1BA606CEE8;
	Fri, 13 Nov 2026 17:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yvee2csq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3BA1F000C4;
	Fri, 13 Nov 2026 17:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591352;
	bh=O28wxl4bl+i5UlhxSDTuuga1G4pdcQICXHd+QLIEX4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yvee2csqZRpkiew6DpU5Ik8d9J/r/pJy8Vouv8/4IEmY+oVoy/pN4GkhIXYnSibOx
	 AC7eVgl3TyVZ8EsiiZvqEdn5GqH72fOMc85UndzirjqYRFEucDF/Dg3pGwu6U4F0OY
	 8mwG2kkVAmPiELKYBEtBb/meUL6Pw7ZdNiXyWz9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 458/670] media: ene_ir: Ensure teardown is done in the correct order
Date: Fri, 13 Nov 2026 10:50:22 -0500
Message-ID: <20261113153827.428864895@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Sean Young <sean@mess.org>

[ Upstream commit ae6cfbad7ca346b78f4cdac38438bbfaed8c18a0 ]

The timer can be re-armed from the irq, so ensure that the timers are
deleted after the irq and that we only free the rc device once we are
sure that the irq has been silenced.

Fixes: dccc0c3ddf8f ("media: rc: fix race between unregister and urb/irq callbacks")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Young <sean@mess.org>
Acked-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[ sashal: Adjusted the removal hunk to match del_timer_sync() instead of timer_delete_sync(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/ene_ir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index 3fd51a41c3b2b..70e28bd4bdb93 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -1103,15 +1103,15 @@ static void ene_remove(struct pnp_dev *pnp_dev)
 	unsigned long flags;
 
 	rc_unregister_device(dev->rdev);
-	del_timer_sync(&dev->tx_sim_timer);
 	spin_lock_irqsave(&dev->hw_lock, flags);
 	ene_rx_disable(dev);
 	ene_rx_restore_hw_buffer(dev);
 	spin_unlock_irqrestore(&dev->hw_lock, flags);
 
-	rc_free_device(dev->rdev);
 	free_irq(dev->irq, dev);
+	timer_delete_sync(&dev->tx_sim_timer);
 	release_region(dev->hw_io, ENE_IO_SIZE);
+	rc_free_device(dev->rdev);
 	kfree(dev);
 }
 
-- 
2.53.0



