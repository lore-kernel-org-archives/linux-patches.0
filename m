Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB2E8821
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:04:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87CBBC433EF;
	Fri, 10 Mar 2023 15:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460640;
	bh=/VOYS5xwVDhIWJkey/rUzl/YEKnYN6PZoTXll3g8k0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KdQ/J5Q5bp+cxbbSm8XhypYTsTMW9LxOMA2GL+2iiAoqkdU+rlx4KU2BH4z3PJ0qe
	 BZ4FCB7/kjAvkaEq4qTR9XXYDI2tJqVxExhE0gvm+jBiNwDEZ9dyrRio4fygVA4CZx
	 6ig04Tquk5fTa2/6yfuOeBuW5Q0Dcl0Fs1PuiHLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 5.10 402/529] remoteproc/mtk_scp: Move clk ops outside send_lock
Date: Fri, 10 Mar 2023 14:39:05 +0100
Message-Id: <20230310133823.615223123@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen-Yu Tsai <wenst@chromium.org>

commit e46ceea3148163166ef9b7bcac578e72dd30c064 upstream.

Clocks are properly reference counted and do not need to be inside the
lock range.

Right now this triggers a false-positive lockdep warning on MT8192 based
Chromebooks, through a combination of mtk-scp that has a cros-ec-rpmsg
sub-device, the (actual) cros-ec I2C adapter registration, I2C client
(not on cros-ec) probe doing i2c transfers and enabling clocks.

This is a false positive because the cros-ec-rpmsg under mtk-scp does
not have an I2C adapter, and also each I2C adapter and cros-ec instance
have their own mutex.

Move the clk operations outside of the send_lock range.

Fixes: 63c13d61eafe ("remoteproc/mediatek: add SCP support for mt8183")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230104083110.736377-1-wenst@chromium.org
[Fixed "Fixes:" tag line]
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/mtk_scp_ipi.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/remoteproc/mtk_scp_ipi.c
+++ b/drivers/remoteproc/mtk_scp_ipi.c
@@ -164,21 +164,21 @@ int scp_ipi_send(struct mtk_scp *scp, u3
 	    WARN_ON(len > sizeof(send_obj->share_buf)) || WARN_ON(!buf))
 		return -EINVAL;
 
-	mutex_lock(&scp->send_lock);
-
 	ret = clk_prepare_enable(scp->clk);
 	if (ret) {
 		dev_err(scp->dev, "failed to enable clock\n");
-		goto unlock_mutex;
+		return ret;
 	}
 
+	mutex_lock(&scp->send_lock);
+
 	 /* Wait until SCP receives the last command */
 	timeout = jiffies + msecs_to_jiffies(2000);
 	do {
 		if (time_after(jiffies, timeout)) {
 			dev_err(scp->dev, "%s: IPI timeout!\n", __func__);
 			ret = -ETIMEDOUT;
-			goto clock_disable;
+			goto unlock_mutex;
 		}
 	} while (readl(scp->reg_base + scp->data->host_to_scp_reg));
 
@@ -205,10 +205,9 @@ int scp_ipi_send(struct mtk_scp *scp, u3
 			ret = 0;
 	}
 
-clock_disable:
-	clk_disable_unprepare(scp->clk);
 unlock_mutex:
 	mutex_unlock(&scp->send_lock);
+	clk_disable_unprepare(scp->clk);
 
 	return ret;
 }


