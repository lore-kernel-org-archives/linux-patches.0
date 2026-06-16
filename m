Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6773E35C1B7;
	Tue, 16 Jun 2026 16:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628092; cv=none; b=PKnO5tFpdg2oXiBlv7YigNDZ8gnRLTBrKafW0Er1HMUNBuZCwQ1g7D9e02mXVEae7MKH72nWs+VB6tB1JscoiO8bZtWlQ1KRnCblU7010U8wT6fF/lx77HQCAOXK1ZLCUBXMzuDb3UfSArGBUsE0VmSAGGBSFvVu3J3zsqJA9wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628092; c=relaxed/simple;
	bh=KFL2K6G6aZ5y30XZQ8Kf4guPVk7hroApxup75y1SFx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SgQuQiFW6fGeWsCSA/H+PgSBnYfWuc83gmBk+KI+frk9UC1Llo6heKfVVFsTLMX76DuGT/E91abH7xIWVIRRgprVMuoc6YMFMhFMBxsVHLBchWTrg+6E5UJRBmV5TYnt87+48NQNIO2pio80EA7Mphr9wWqv9rFQ6jR8EEEidTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fie7Zrim; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fie7Zrim"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0ED1F000E9;
	Tue, 16 Jun 2026 16:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628091;
	bh=h6ulStZ8pU1VKc2Njh9Q2tr7fG16P08UXDSL5/nvBfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fie7ZrimJBeuA6YXUdafxC7u2LTTIZMRYOqBglqTkj/VF8TmB1TUev7snWX69B13S
	 1ogmwthdV5YZzoRrBkSuG5ru2x6mutdzPBnzWWBQqECo9M72G1a40DMWQXcQGtB6dk
	 WTwn/+Vk1rapCCfcQgi6JzZQsR3CTRkAI7y1WDVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Frank Li <Frank.Li@nxp.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/452] gpio: mxc: fix irq_high handling
Date: Tue, 16 Jun 2026 20:24:16 +0530
Message-ID: <20260616145119.404003706@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit dac917ed5aead741004db8d0d5151dd577802df8 ]

If port->irq_high is -1 (fsl,imx21-gpio compatible) and gpio_idx is >= 16
enable_irq_wake() is called with -1 which is wrong.

Fixes: 5f6d1998adeb ("gpio: mxc: release the parent IRQ in runtime suspend")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260526063504.25916-1-alexander.stein@ew.tq-group.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mxc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
index 3cdc2b218a86af..a8ab78ae7fa30c 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -473,7 +473,7 @@ static int mxc_gpio_probe(struct platform_device *pdev)
 		 * the handler is needed only once, but doing it for every port
 		 * is more robust and easier.
 		 */
-		port->irq_high = -1;
+		port->irq_high = 0;
 		port->mx_irq_handler = mx2_gpio_irq_handler;
 	} else
 		port->mx_irq_handler = mx3_gpio_irq_handler;
-- 
2.53.0



