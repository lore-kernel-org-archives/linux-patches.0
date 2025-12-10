Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A726126A0A7;
	Wed, 10 Dec 2025 07:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765351920; cv=none; b=hr3cNRP0/wtLOqOWFa+lbQ8uY5zwLva46SiGKAbwUgaxI+D2Yw3e6++8Q7CCiNNc1iFlLHqs/dSWnCTb+Ae1ePinLlIMPylprf/ImQ16yUYA+Wy9uP7yUJYjQyQsbt/HuVeJale9UeRupvPSUB/ZzC6N9MjiqFR0W0CvRPDehzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765351920; c=relaxed/simple;
	bh=R7GuYolVgF7zuyHcJ0Ntz9vCbLNdSd2rFedpkT6k7yY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sF5qMg9UX0nZqae7k0VlW0WCXd4c/OOKr6IQTgX9+cdstWcK0ViXP09zNKkmnKf12i+VKVKyYKcBq2GkOxS38zy4XYxkZJgbu/pUowdKEEnDmFzTLpzgI/qnTt150RS6IdAj3F6l6Q4nBMuPryVinmfbavQb7A3v8PwQVaFIviU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=onQcc3vw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="onQcc3vw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D63C4CEF1;
	Wed, 10 Dec 2025 07:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765351920;
	bh=R7GuYolVgF7zuyHcJ0Ntz9vCbLNdSd2rFedpkT6k7yY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=onQcc3vwKm/vPfWtedk3nyCM9QrY6EOokKPnJWGkuevPDfMzzgLzZDJmnQfdAn+92
	 hZKeWGBHiBX7Vp/ozjxzwteuYDaQp5ltTi2MO892/0fzQ1337Zu+7dGaJHQtC8zODh
	 9fACXMoELFMS4Rug5L6VGsKPFcWn7leCzbYMWXuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prasad Sodagudi <prasad.sodagudi@oss.qualcomm.com>,
	Praveen Talari <praveen.talari@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 31/49] pinctrl: qcom: msm: Fix deadlock in pinmux configuration
Date: Wed, 10 Dec 2025 16:30:01 +0900
Message-ID: <20251210072948.936250433@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072948.125620687@linuxfoundation.org>
References: <20251210072948.125620687@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Praveen Talari <praveen.talari@oss.qualcomm.com>

[ Upstream commit 1c2e70397b4125022dba80f6111271a37fb36bae ]

Replace disable_irq() with disable_irq_nosync() in msm_pinmux_set_mux()
to prevent deadlock when wakeup IRQ is triggered on the same
GPIO being reconfigured.

The issue occurs when a wakeup IRQ is triggered on a GPIO and the IRQ
handler attempts to reconfigure the same GPIO's pinmux. In this scenario,
msm_pinmux_set_mux() calls disable_irq() which waits for the currently
running IRQ handler to complete, creating a circular dependency that
results in deadlock.

Using disable_irq_nosync() avoids waiting for the IRQ handler to
complete, preventing the deadlock condition while still properly
disabling the interrupt during pinmux reconfiguration.

Suggested-by: Prasad Sodagudi <prasad.sodagudi@oss.qualcomm.com>
Signed-off-by: Praveen Talari <praveen.talari@oss.qualcomm.com>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-msm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
index 5532328097894..27eb585bf42df 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -214,7 +214,7 @@ static int msm_pinmux_set_mux(struct pinctrl_dev *pctldev,
 	 */
 	if (d && i != gpio_func &&
 	    !test_and_set_bit(d->hwirq, pctrl->disabled_for_mux))
-		disable_irq(irq);
+		disable_irq_nosync(irq);
 
 	raw_spin_lock_irqsave(&pctrl->lock, flags);
 
-- 
2.51.0



