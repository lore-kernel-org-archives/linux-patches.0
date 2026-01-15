Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5092874E6;
	Thu, 15 Jan 2026 17:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497401; cv=none; b=u7NuV7KU7sRqKBma/k1A4cY33uh/Wye/JyBmcodDjIUirU0Od7j+TIqT3mHbkciwPmEILV09qv+tPrax6nnNmlhrPDsE0JeKGDvAwehl04/9dy8pS0+8Vp4cqYTzARKDx9vIzMo+qddxYp9rU1p/6f/CEiZZttAWv2PiDkvDRXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497401; c=relaxed/simple;
	bh=axFEBiuJq/2HEf2VO+AMSdD34//QSGX3dwIx84WF4UU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SPqysqYLrsFKac/IYGGM7qxWZPBIBgjOntM6yGP3phPHcVnyOidkdA8Ld3tkSzJFFcKjoMev0AhmWO8wIDnLgtU3+MPaAMd1MUdzhRO4rKc6FJgLEJm/JjILm9ZSyDk2YAyvg1Uh7pqD5ZQe8pqF0pAsGBnDvuMhpuFC3sPi1cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wq1hGSBx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wq1hGSBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA2BC116D0;
	Thu, 15 Jan 2026 17:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497401;
	bh=axFEBiuJq/2HEf2VO+AMSdD34//QSGX3dwIx84WF4UU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wq1hGSBxSCF2FwUWI93mNBNPNTwZT7zOCtNm+BRg/To6bpyP6eRJExz1ZRzrLJ4Qf
	 9Lz56eT3EGXJH3JCrKfRkNWs0T50y1mJfcDiP1kGyDZfl/hB+9w8Njhtg3whgypKUb
	 YLTTTn/Cox7UtXSVYxtiUXHaR8O/QvOfQi7RgZ0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/554] pinctrl: stm32: fix hwspinlock resource leak in probe function
Date: Thu, 15 Jan 2026 17:42:07 +0100
Message-ID: <20260115164248.454447003@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 002679f79ed605e543fbace465557317cd307c9a ]

In stm32_pctl_probe(), hwspin_lock_request_specific() is called to
request a hwspinlock, but the acquired lock is not freed on multiple
error paths after this call. This causes resource leakage when the
function fails to initialize properly.

Use devm_hwspin_lock_request_specific() instead of
hwspin_lock_request_specific() to automatically manage the hwspinlock
resource lifecycle.

Fixes: 97cfb6cd34f2 ("pinctrl: stm32: protect configuration registers with a hwspinlock")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Antonio Borneo <antonio.borneo@foss.st.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/stm32/pinctrl-stm32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c b/drivers/pinctrl/stm32/pinctrl-stm32.c
index 821ec5a97551d..e8afed94fccc1 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -1490,7 +1490,7 @@ int stm32_pctl_probe(struct platform_device *pdev)
 		if (hwlock_id == -EPROBE_DEFER)
 			return hwlock_id;
 	} else {
-		pctl->hwlock = hwspin_lock_request_specific(hwlock_id);
+		pctl->hwlock = devm_hwspin_lock_request_specific(dev, hwlock_id);
 	}
 
 	spin_lock_init(&pctl->irqmux_lock);
-- 
2.51.0



