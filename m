Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0B232BF21;
	Fri,  9 Jan 2026 11:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959381; cv=none; b=IIbQ4CdpsBvElHdn7ci8pPWby/FFkdh65NiYcb6zOIzcPx3T6UTFkWHfPqggCgsk3j3IB1DbCN5OWvhaXrZTW8To3iMZjqQ7Zepo3iG7Dild01JwtZgymyRy5moiFgiU4ueoduWKr1aGTtVtF1SduK8okszQRQ6qYWwYWRur2EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959381; c=relaxed/simple;
	bh=1VvFJ+lyE4gcFnZOynfydiEzidfCW7cX4/aHHPeAYHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aR0y8Mph6nAmRrL4hjy2EllwdkIaeFzphCeWjFjHm0H9wxG6Z22bOALL725/w+RhLCbZQKJ3R9kL0gqIbvNb/zxnbiKe8t2QDkbEZGI8FZ4WjpSTWxCuAuqmuaQcuJ5N2V/703XVcAVbcE8o5ZoEMvakxvFnbGcbhWFqk1tVg3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+a0KizM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+a0KizM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58333C4CEF1;
	Fri,  9 Jan 2026 11:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959381;
	bh=1VvFJ+lyE4gcFnZOynfydiEzidfCW7cX4/aHHPeAYHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q+a0KizMN46CJ4yzlOtFWbuAidfEcNHFvrmSVJjOtlOyoHYS1mkyBF91DolREGtrm
	 MRB+jIsbpwywxGaQnR0WkmVmm8+phrWSRvLUcLZGMT9Ni6c/3+jwrR5L7FoTiNthZq
	 fkBN7M/OpUj2+CreWUjunny5l679uYoGWT8+xPus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prasad Sodagudi <prasad.sodagudi@oss.qualcomm.com>,
	Praveen Talari <praveen.talari@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/737] pinctrl: qcom: msm: Fix deadlock in pinmux configuration
Date: Fri,  9 Jan 2026 12:32:50 +0100
Message-ID: <20260109112135.167205217@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
index 13dc8bc1d0cff..688f3d01f4af8 100644
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



