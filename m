Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062912;
	b=t51UMFRAxFlpl5AXmsp+Ally2jxVVpINa7tWdHD+owLqkKCnRJeRBdS0AVxWCr8D/903
	 ypX6zLUG+Rps9fUfHncTA8kztQdFRzzRGtBqKLfNIwlTtukXl/D6n07+QGcUILWLr0+my
	 Xjrhbzmvts7Up8YHr/5lhffpB5tdm2sL8N7IDSHYGDw1yyUD9MiHa2aYxe4OfiAHptTfr
	 yzwrriEtoYLy5QN68AVOsSYMZJRfp1uMwU3kOpUdJ4g3uJ+bkaCYrCqumndg/IP7CiBnt
	 DrqtqjlN6dP4zqHz0kbDfgnr5l0GYaFMm452WV/qdGj2QYEL8yd8sPa33QRosZO6GSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062912;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OdAsuUWDHUNivUQI+XaIm6rsyRHZkq4rq8gBQl1hgY8=;
	b=rfuQmywIQahj552xl+exgc38XWOIwi2RJS2E2izuha6Tm1K9mPyi77jy7Dhp9Et1T1+C
	 4sVPn4QHwrxD2ocvsXtP7KwuUkmAu33bUbUFa4Uy+lNS5/Dc+NmPo+t1eoxntgGhyQZxg
	 i5JjTb5MCZbn+HZRIcpW98atUoX8PEtTM3DpfJyyrxeoNiCTJVAYqAg3m0IdxiuYXBhpb
	 XiRufsHCtG9DPUqa1p14bA+y98SfEuWmyFMUd3Teh8wAnvqq0Ylbtr205j/EmdJAL/7U8
	 OcqzEtQrhR1cSYlsF0wSoGkcaKp1DmtXb/5ZaFfiX7+WZjPwiitY5d8lKkNOcv8HU8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lopmidwd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD48F606A32F;
	Sat,  7 Nov 2026 14:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lopmidwd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDE51F008A1;
	Sat,  7 Nov 2026 14:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062911;
	bh=OdAsuUWDHUNivUQI+XaIm6rsyRHZkq4rq8gBQl1hgY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lopmidwdfw4bXREia9O4Lnl/WUNTryxawpqmXy4zgVXkBAWmn3O44CatPNW5oyae4
	 qLSR0rmSuc6QF6eomnHbTxJQqZ/36is1ASCZM2EzVDXDsexhus7TR0r0KSg7rsNwM1
	 gZUpz4JXx+w8lITHonz4A9RBI4UlOCQi6L9+8S1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 180/869] media: ene_ir: Ensure teardown is done in the correct order
Date: Sat,  7 Nov 2026 08:47:42 -0500
Message-ID: <20261107134858.252602639@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Sean Young <sean@mess.org>

[ Upstream commit ae6cfbad7ca346b78f4cdac38438bbfaed8c18a0 ]

The timer can be re-armed from the irq, so ensure that the timers are
deleted after the irq and that we only free the rc device once we are
sure that the irq has been silenced.

Fixes: dccc0c3ddf8f ("media: rc: fix race between unregister and urb/irq callbacks")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Young <sean@mess.org>
Acked-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/ene_ir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index 136fc4192265d..7598b623e4e84 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -1103,15 +1103,15 @@ static void ene_remove(struct pnp_dev *pnp_dev)
 	unsigned long flags;
 
 	rc_unregister_device(dev->rdev);
-	timer_delete_sync(&dev->tx_sim_timer);
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



