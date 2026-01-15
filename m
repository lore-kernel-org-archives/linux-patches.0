Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FBF12D7DED;
	Thu, 15 Jan 2026 17:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498930; cv=none; b=FIa7JVQFfO5NN8I2q93y3lvQUoT4l/p1YdJCjS855LHmUUTv5bXbY5G7qJcDtgePUTLrQLvURWGRcM6WsJ7MrOJof/8rP9aHYmZK9g3oU1dfN5GiO/Cb6CQSAR+q1EAhp9K113pXXexphnkWRxPRWy0HmNGjMSsc7xR0Hfum9PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498930; c=relaxed/simple;
	bh=vls6bn0BebndsqCnsUA+5bSg6Njri4NJ3slRJz21Qo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AxVKzVlnyOqLaPTWwpUXOquxW3YGjQ2PwNKZXWL3EP7Pd7HLHtxnPQJsPcll+LgJnNerctcqcw+yzYJibxVU+J8XWDBNU7EMbBblib3zzOZuUQkuOgFzwUhPdhNoHKmNV3HYXboq2tPRy8RUiNpu8SxjoGwmCJvwwWfrGwpzldQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aRfSMX8t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aRfSMX8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C088BC116D0;
	Thu, 15 Jan 2026 17:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498930;
	bh=vls6bn0BebndsqCnsUA+5bSg6Njri4NJ3slRJz21Qo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aRfSMX8tDDY6uiNFv9ERNC5Xm6PFXf+nhWMkdvy/XGTkCk2zffBd769KVPZotUI9I
	 oBS0EkhEu5m2Ge3VBi1fSBfpE8D6PDyrMIc0FoEN8h8e1l5upkgOsscoTmEl1EWdMk
	 cQmyyOJO+XMl+gYxTjV/4boTdzuDz9552YTE2B1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 047/451] pinctrl: stm32: fix hwspinlock resource leak in probe function
Date: Thu, 15 Jan 2026 17:44:08 +0100
Message-ID: <20260115164232.600360166@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6b6fdb7116590..0094ccb4c63c8 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -1494,7 +1494,7 @@ int stm32_pctl_probe(struct platform_device *pdev)
 		if (hwlock_id == -EPROBE_DEFER)
 			return hwlock_id;
 	} else {
-		pctl->hwlock = hwspin_lock_request_specific(hwlock_id);
+		pctl->hwlock = devm_hwspin_lock_request_specific(dev, hwlock_id);
 	}
 
 	spin_lock_init(&pctl->irqmux_lock);
-- 
2.51.0



