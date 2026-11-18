Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038118;
	b=i79ybNi/Mcs6OYdDyiqCr+KP3usJvb8xeIf1XGyuQBu86+A5ZsuDZ1Wf3UOgnnMzYEES
	 ycZtriyHjLR6+/PcdgWwKcvHmeKewI+94CCnBMwzEjptbVc6PrZoD1+DWac7VCkk0WTXh
	 iO4DT/OxR/MdR2fjwDM0/caOEuj2ihoN5fAKzzMGmHsyfGDmdetgh0yB9dWCdIpii16iq
	 2y2Mn4tLPqUmTqCE9kX63plMZRjhKUB8GakVTxj+fUtTZvya0wPGaJcAB8pLrahNfT6U/
	 rbvJL7W8+2lPAOvnrBnDOgFyiqdoGomh6Btwqe1TpSQRKRCBd/PA1h0blgIFk+PN/yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038118;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C6F9aNn7au3Xw0V14ykhk9aynpAWgobr8iwuK3A7bZ8=;
	b=fBN/X+NODS1vkTmigrMhUpV/soh42hABxM+J3XjAP/IM/StEq4+zRFjMixvAe3P2zxL2
	 duyFQBl7JF6XZMidkr4aVBgO379DH/brrCriAPenGzXfbBBB3C0M2+FaGhdeAi+S5pJI2
	 76Ck9EhfoSLbulS9hjylcvXOV64oP/lmlGx9EH+LyMZmzWohRi3GUU/VV53sgYxAQF7DZ
	 xY1IWE60PPD6HlRl4MjK6Vc4IusplPBd+UNEdJ0ovx24+aufwsclWaLvszDW8bVZJCASY
	 tVVE/NrDIei59abORhJw2vUGvk/Age1jDoqrIqJb4ezkPCyYtL2ZPciqBTLTDzcz4Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jfwiq2mJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02F5606A325;
	Wed, 18 Nov 2026 21:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jfwiq2mJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BF41F000C5;
	Wed, 18 Nov 2026 21:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038118;
	bh=C6F9aNn7au3Xw0V14ykhk9aynpAWgobr8iwuK3A7bZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jfwiq2mJFU6E4epv34dC47BylnFRR/PqYPUAKwZDNtTncHGFvpspYq2GS3iOCBfu4
	 o3oxQqCp2yrqj1PZ8CoVnOAC+2a3/VEFo73NNe6zOtluFSB1yoE8lB1aoHHvy7zT90
	 imyxubhcxkIg1ajQTJZzEkA0goNme8lgEz8PrJ2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1632/3318] media: ene_ir: Ensure teardown is done in the correct order
Date: Wed, 18 Nov 2026 15:37:34 +0100
Message-ID: <20261118150410.705340300@linuxfoundation.org>
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

From: Sean Young <sean@mess.org>

[ Upstream commit ae6cfbad7ca346b78f4cdac38438bbfaed8c18a0 ]

The timer can be re-armed from the irq, so ensure that the timers are
deleted after the irq and that we only free the rc device once we are
sure that the irq has been silenced.

Fixes: dccc0c3ddf8f ("media: rc: fix race between unregister and urb/irq callbacks")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Young <sean@mess.org>
Acked-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[ sashal: adapted timer_delete_sync() removal to the existing del_timer_sync() call ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/ene_ir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index 9140e4f28c995..f5fd6bd4d7363 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -1106,15 +1106,15 @@ static void ene_remove(struct pnp_dev *pnp_dev)
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



