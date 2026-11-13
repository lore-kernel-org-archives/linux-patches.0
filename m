Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590663;
	b=Stn35Y1g66KorXs6ovbHNZmhtj+8S0U8rd40TSTWF5t6zlteiD2JnSGCc2hm56WAbp0c
	 ISJVGXrvkC7DQt8F45hm5mS2PFoXXayPCtgsxQm1HHsKnCQdpUTdRH40gKi39pwj3IoEH
	 baCktZaAhawc5wLYwXwO45qKtdeYwUmPNj06Zz4VimB/sL7RMgl+ErcpUHRC4ml3EESiT
	 B+rfrJmRZKqGrUeM/sRaPGDTAb+CGObEC3w7byPUyHqHyyb4dZ9pwg4npk8k3o1SYj64O
	 D8R75fd76F53PhlPXNtZrcJxLvMl/vXfmrw7W5eMLDdKhXQR6FjCLXf+AlvOurOJelg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590663;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T1jhj5BXFQTa9HmRhVymYhKVI5YAcLdsOFNHCnl23tM=;
	b=Me4KLFhIxs1fdFwS7no3sreHP3sUFk/kImtzcZe42DFosouSquaw3bZhduniIhbrCr3T
	 4Yf9WB3+hMPA7OQOe0sCLG/thKyIjJXFxLi13NppFFbKerGo5/VT/9cYc/guYMpZfMWEY
	 ab4NZcPks1b4V849aabtL7hD90HdJmnr5KFBe22nhLVkBB/JVUbyZ1jZc8ZQ0OVnqRkT/
	 j/BR7RGUbLvM29lUguAD4lxlHtDc+lqm/rBHS5BQCx+zBFre4tDefAOFZ7tOQO28OqJH1
	 zVeQoN7k16KbHVKka6X2Pf7X1BfON/mWh9wmcay9kXYfJ4uo2v+HB1Bb7j//OJFQlOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WqtpYFk9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28873606B204;
	Fri, 13 Nov 2026 17:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WqtpYFk9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8DBB1F000C4;
	Fri, 13 Nov 2026 17:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590663;
	bh=T1jhj5BXFQTa9HmRhVymYhKVI5YAcLdsOFNHCnl23tM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WqtpYFk96M07/0r5Mt8yDtFwPNhkXLzu9dFKLuVXmsARzLVB5g+0PoK82Ehxk89Y3
	 f6h/kNX6kTC9BE0krQ0t6XFAOuWq5EywOgxOOxMyvJwzk+gIcIH8LzWoTElt5Y8Xgb
	 vcN0+ZR40AjEz0w+49wUTXYN7KBaoOkdC22AGM30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 580/686] media: rockchip: rga: quiesce IRQ before releasing m2m state
Date: Fri, 13 Nov 2026 10:51:53 -0500
Message-ID: <20261113153841.425177246@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index f0bbd161fa92f..f956f2fb222a1 100644
--- a/drivers/media/platform/rockchip/rga/rga.c
+++ b/drivers/media/platform/rockchip/rga/rga.c
@@ -782,6 +782,7 @@ static int rga_probe(struct platform_device *pdev)
 		ret = irq;
 		goto err_put_clk;
 	}
+	rga->irq = irq;
 
 	ret = devm_request_irq(rga->dev, irq, rga_isr, 0,
 			       dev_name(rga->dev), rga);
@@ -879,8 +880,9 @@ static void rga_remove(struct platform_device *pdev)
 
 	v4l2_info(&rga->v4l2_dev, "Removing\n");
 
-	v4l2_m2m_release(rga->m2m_dev);
 	video_unregister_device(rga->vfd);
+	devm_free_irq(rga->dev, rga->irq, rga);
+	v4l2_m2m_release(rga->m2m_dev);
 	v4l2_device_unregister(&rga->v4l2_dev);
 
 	pm_runtime_disable(rga->dev);
diff --git a/drivers/media/platform/rockchip/rga/rga.h b/drivers/media/platform/rockchip/rga/rga.h
index 2db10acecb405..0a15ec9aa8aae 100644
--- a/drivers/media/platform/rockchip/rga/rga.h
+++ b/drivers/media/platform/rockchip/rga/rga.h
@@ -82,6 +82,7 @@ struct rockchip_rga {
 	struct device *dev;
 	struct regmap *grf;
 	void __iomem *regs;
+	int irq;
 	struct clk_bulk_data *clks;
 	int num_clks;
 	struct rockchip_rga_version version;
-- 
2.53.0



