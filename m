Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591452;
	b=zBqh3nK2xaxJo7DoypjKgoJck4/mCIX4QoUOvL3WUec0+ZkdC3AePEPEqgBRSDQYtODq
	 KeWUeMbU4NxuVoMZCH7uTOntZSxIf0BsRC3iC8VoidQPElaC014oUjeeGQMsl9F4n9glq
	 3wFAAubd/LdM1xCMW4cX4df0sb332lXGh+5PBwKvgTph6hQ235urbWyiip4U5bxoDNUU4
	 8qrnLl5k2J6hG/N882PXkFwjL2kll8NOBVkYUT1FhCWVUI0tAR1oSk/LGLUiQjSm80U6h
	 xSEPD8aOh9YWr+oHUEbVYpxU2k7su3MhZZTTWC9EYlQg86T4FVvy7UJvMsb+DVvrcRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591452;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zc47DgNpA7IbruGSuUQrgRSmxuXWQDPnn0IzlQL+sUk=;
	b=0bps3IzFO6q3adOyvzydvI8sl11GftI+cwGPNaNDv5kWPlnZCvQURBYlnwXrT++vP1lE
	 uflaCcm40NHUNdY66erJxq85vAtei5eoGeZdHyC0ADpO5nFbD5XDwkWywF84Y88PGnaeI
	 L5W2X7SCk1Hz8CkQc/x0kpTlgUNpcCE4WObSogDOrmWAf+JfbnUY3fQt2e+Ldp+5xpkBA
	 rf+6fzPp/ZdXwgcU7K6Hh+DhR9myW+ucGBNOxJ5wbA8FS3ippmJXeyeX9TH1ICmxv4kQV
	 oQoqhcrcbb3sfu+sJD887EJtUtiHAlerQk+a2mLhob/hLfWIZ3pOSHKR2VkztFgz6wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rct4xDy2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08254607C352;
	Fri, 13 Nov 2026 17:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rct4xDy2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8AA51F000C4;
	Fri, 13 Nov 2026 17:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591451;
	bh=zc47DgNpA7IbruGSuUQrgRSmxuXWQDPnn0IzlQL+sUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rct4xDy2/eB/sVhd6ONLPkSEe5Ir8ukYKuCA/o5Qu10smxWQ3SD+v9y2Oy0lZFKeJ
	 qv2dz58j6CP/VdzPW8VB8sP9PtaEzMqEIbtEi8h/smcHl9n6vQVjv+mp/ZtfGg7OEK
	 cLF0+uJ5CogQDOsglEANNa1LkAE7DcB9LCiDLh7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 540/670] media: rockchip: rga: quiesce IRQ before releasing m2m state
Date: Fri, 13 Nov 2026 10:51:44 -0500
Message-ID: <20261113153830.194554560@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit a875c43dd95ee4f9c4e3e5ae1cb8362cc6d7817d ]

rga_remove() releases the m2m state before the IRQ is freed. The IRQ is
devm-managed and is only released once rga_remove() returns, so rga_isr()
can still run while the m2m device state is being torn down.

Store the IRQ number in struct rockchip_rga, unregister the video device
first, and free the IRQ before releasing the m2m state so the handler
cannot run against the freed state.

Fixes: f7e7b48e6d79 ("[media] rockchip/rga: v4l2 m2m support")
Cc: stable@vger.kernel.org
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rockchip/rga/rga.c | 4 +++-
 drivers/media/platform/rockchip/rga/rga.h | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/rockchip/rga/rga.c b/drivers/media/platform/rockchip/rga/rga.c
index 7b2842d959255..dd512785649a9 100644
--- a/drivers/media/platform/rockchip/rga/rga.c
+++ b/drivers/media/platform/rockchip/rga/rga.c
@@ -784,6 +784,7 @@ static int rga_probe(struct platform_device *pdev)
 		ret = irq;
 		goto err_put_clk;
 	}
+	rga->irq = irq;
 
 	ret = devm_request_irq(rga->dev, irq, rga_isr, 0,
 			       dev_name(rga->dev), rga);
@@ -881,8 +882,9 @@ static void rga_remove(struct platform_device *pdev)
 
 	v4l2_info(&rga->v4l2_dev, "Removing\n");
 
-	v4l2_m2m_release(rga->m2m_dev);
 	video_unregister_device(rga->vfd);
+	devm_free_irq(rga->dev, rga->irq, rga);
+	v4l2_m2m_release(rga->m2m_dev);
 	v4l2_device_unregister(&rga->v4l2_dev);
 
 	pm_runtime_disable(rga->dev);
diff --git a/drivers/media/platform/rockchip/rga/rga.h b/drivers/media/platform/rockchip/rga/rga.h
index 6c3c9f3f71584..8f0185d592104 100644
--- a/drivers/media/platform/rockchip/rga/rga.h
+++ b/drivers/media/platform/rockchip/rga/rga.h
@@ -77,6 +77,7 @@ struct rockchip_rga {
 	struct device *dev;
 	struct regmap *grf;
 	void __iomem *regs;
+	int irq;
 	struct clk_bulk_data *clks;
 	int num_clks;
 	struct rockchip_rga_version version;
-- 
2.53.0



