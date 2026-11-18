Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046927;
	b=YrawTiQAy7TaCnZ2LgeJqAoRXTlmgAm8MRUdGrUGIt4oyE5+Ou8Og7HtTma57SJCTYtU
	 6hE/x5Zt1g/wwkap863Rh86Xu9VLJmV0At0VSjrY/rmOKX2KJ/xyd+dOhWNH8ZqDFCcJQ
	 N6XXDvrPZ/m/tjoPruV5wiLrTrkAGE0a7HFKXKUJE8Ly2tzLlmKVdufw+LNa9ENMT3Idu
	 wxu3Pam3KNFSkk/XddaWGtV4iNyBK95jKItKpe9S2a7PzQmwo0uzbH9XPscsrZAaM9XK+
	 pmFaePRP6yT/MygMkU3SzBLKYhFDhe+oZtBL3kBZ+QchGrGvcajP+BCyqHGuueuEDWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046927;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pvAhVidWPVv+J3pSdMu3W+tefhzRex3KrIKmlrJxS4E=;
	b=pr9bSWHCUEnoH89lwTk5mgMT/l7k2LGDVfnfbkOfDxsu6BXHJWzOCFLHOr0Bei++And6
	 s8TNmbQx+UWONAP6VThVE/vr6WiDzk91acoUdsox9qoflXMCktvv1Cx/Q8qJ/kccuII3x
	 5CTLCZ3qKusNhnS9ejxK0Xg0OxaAIYcBmY8wOYbWGhs/WQG9s6i7Sto0LwIpLTpR3znLs
	 KfMsS3ITEmADQu15+mCjmvlJdtYTY8uLcmnmRFHX/phixdi7WgwKaIj5tuF36WQn/Vidy
	 VocSJzLbQMJcNNB9KBGzRS/joXFWrVuVJNCdtTZeAvB2KkbGZYiymik0snUuIQRc5Eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iH82mpxL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8935606A325;
	Thu, 19 Nov 2026 00:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iH82mpxL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49AD91F000C4;
	Thu, 19 Nov 2026 00:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046926;
	bh=pvAhVidWPVv+J3pSdMu3W+tefhzRex3KrIKmlrJxS4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iH82mpxLYujdQb8QM5ajFgfyMCH1BibJ9q/LadrRBMNWTpeZ3khdwnx49pG7Ey/48
	 1AHMp1zTJO+mgCVgnupPnN4yFRkaU8n4Yk6Rmx8kepG62WcALT2t+uvAimD2zInZ/1
	 KnCaXeWcjJPQAsP2F0neV4j8pu4rB00drrUjOQjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1455/2857] media: rockchip: rga: quiesce IRQ before releasing m2m state
Date: Wed, 18 Nov 2026 15:41:29 +0100
Message-ID: <20261118150253.709361829@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7cc80e11d9d00..595873bbf0137 100644
--- a/drivers/media/platform/rockchip/rga/rga.c
+++ b/drivers/media/platform/rockchip/rga/rga.c
@@ -773,6 +773,7 @@ static int rga_probe(struct platform_device *pdev)
 		ret = irq;
 		goto err_put_clk;
 	}
+	rga->irq = irq;
 
 	ret = devm_request_irq(rga->dev, irq, rga_isr, 0,
 			       dev_name(rga->dev), rga);
@@ -884,8 +885,9 @@ static int rga_remove(struct platform_device *pdev)
 
 	v4l2_info(&rga->v4l2_dev, "Removing\n");
 
-	v4l2_m2m_release(rga->m2m_dev);
 	video_unregister_device(rga->vfd);
+	devm_free_irq(rga->dev, rga->irq, rga);
+	v4l2_m2m_release(rga->m2m_dev);
 	v4l2_device_unregister(&rga->v4l2_dev);
 
 	pm_runtime_disable(rga->dev);
diff --git a/drivers/media/platform/rockchip/rga/rga.h b/drivers/media/platform/rockchip/rga/rga.h
index 0825622526c7b..a940919d4394a 100644
--- a/drivers/media/platform/rockchip/rga/rga.h
+++ b/drivers/media/platform/rockchip/rga/rga.h
@@ -69,6 +69,7 @@ struct rockchip_rga {
 	struct device *dev;
 	struct regmap *grf;
 	void __iomem *regs;
+	int irq;
 	struct clk_bulk_data *clks;
 	int num_clks;
 	struct rockchip_rga_version version;
-- 
2.53.0



