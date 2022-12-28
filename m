Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E96E1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:50:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6FC9C433D2;
	Wed, 28 Dec 2022 15:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242657;
	bh=5+ZQXrFg6ZmJxZDs0YrFxEzV/Yh9SfNFj2b9O/xjFBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FTyXxsAZM5+dTf8GPI12G677HSs5hB9GYPWeddc1LHMlcW11YadoJGYx32CjjFb2s
	 sUYeoZcznQdA2Y8RpNA31HuX5d57FZyoFiHOT/X7WZurJERVyrUtuiV7MudITZzsXB
	 RkbvAvOKfd3dQ1QzPOZJSXhjQZLeKetC443gC6lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@nxp.com>,
	Mirela Rabulea <mirela.rabulea@nxp.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 630/731] media: imx-jpeg: Disable useless interrupt to avoid kernel panic
Date: Wed, 28 Dec 2022 15:42:17 +0100
Message-Id: <20221228144314.788806079@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit c3720e65c9013a7b2a5dbb63e6bf6d74a35dd894 ]

There is a hardware bug that the interrupt STMBUF_HALF may be triggered
after or when disable interrupt.
It may led to unexpected kernel panic.
And interrupt STMBUF_HALF and STMBUF_RTND have no other effect.
So disable them and the unused interrupts.

meanwhile clear the interrupt status when disable interrupt.

Signed-off-by: Ming Qian <ming.qian@nxp.com>
Reviewed-by: Mirela Rabulea <mirela.rabulea@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/imx-jpeg/mxc-jpeg-hw.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/imx-jpeg/mxc-jpeg-hw.c b/drivers/media/platform/imx-jpeg/mxc-jpeg-hw.c
index 718b7b08f93e..8936d5ce886c 100644
--- a/drivers/media/platform/imx-jpeg/mxc-jpeg-hw.c
+++ b/drivers/media/platform/imx-jpeg/mxc-jpeg-hw.c
@@ -76,12 +76,14 @@ void print_wrapper_info(struct device *dev, void __iomem *reg)
 
 void mxc_jpeg_enable_irq(void __iomem *reg, int slot)
 {
-	writel(0xFFFFFFFF, reg + MXC_SLOT_OFFSET(slot, SLOT_IRQ_EN));
+	writel(0xFFFFFFFF, reg + MXC_SLOT_OFFSET(slot, SLOT_STATUS));
+	writel(0xF0C, reg + MXC_SLOT_OFFSET(slot, SLOT_IRQ_EN));
 }
 
 void mxc_jpeg_disable_irq(void __iomem *reg, int slot)
 {
 	writel(0x0, reg + MXC_SLOT_OFFSET(slot, SLOT_IRQ_EN));
+	writel(0xFFFFFFFF, reg + MXC_SLOT_OFFSET(slot, SLOT_STATUS));
 }
 
 void mxc_jpeg_sw_reset(void __iomem *reg)
-- 
2.35.1



