Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8AC18732F;
	Thu,  5 Sep 2024 09:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529911; cv=none; b=TBtE5pMkedgGdVegfevy3ExUYqsarklR0NgtQxGb+D5ErY5Tww6wxP6ALDgJCfkcZPo1ZFH1dnFhf2DCVaOhjgIB6BwoUG6uKwzO5frVH1BI59wAwQV8/Nvz99rH4bOmURG9UwuBLhuXLCiK3pt91fothQQ4mXhPIlCMI0PeuSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529911; c=relaxed/simple;
	bh=V18sXFBVJa8T/CaVmE2SLTZqz898N0d96CkxwUxTTX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W8TrDYFibgMDWPyQ+hjvdfZFizdpTlL0gb0ifDIks6j82TI4ArX2Alk9bQ4Paif/bOtjOpfj6NPtWN7EWOLptU8HiIrm8xBOKza9Fp6Pi/HsjliN2MtBEV7AU+rBSslvMDtgRpIPel69QTkrqeGciKKpmr38ySuSsP89y9mk4uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gYnmL5Zo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gYnmL5Zo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FBF8C4CEC3;
	Thu,  5 Sep 2024 09:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529910;
	bh=V18sXFBVJa8T/CaVmE2SLTZqz898N0d96CkxwUxTTX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gYnmL5ZoR2msiuVcH6fSI7eeIfdU29HA5YhG6uebyVZmKlUrpj79S/kyjMxW9RyaX
	 M5DQkP2mCEzMCW1IQXEm1Wyz0YzSvrF8PfcCEhQfHZNIUp/87M45G5jiSyRdSsGpAc
	 ABF6F8eg3j45OXxSrCYBZLE9+AjlFwfa2UbsaxSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?L=C3=A9o=20DUBOIN?= <lduboin@freebox.fr>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 180/184] pinctrl: core: reset gpio_device in loop in pinctrl_pins_show()
Date: Thu,  5 Sep 2024 11:41:33 +0200
Message-ID: <20240905093739.357048701@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Léo DUBOIN <lduboin@freebox.fr>

[ Upstream commit 9dfbcf2fc566c0be2de1c7685f29effd25696b75 ]

We were not resetting the pointer to the associated gpio_device once
we are done displaying a pin's information.

This meant that once we reached the end of a gpio-range, if there
were pins right after it that did not belong to any known range,
they would be associated with the previous range's gpio device.

This resulted in those pins appearing as <4294966783:old_gdev> instead
of the expected <0:?> (due to gpio_num being -1).

Signed-off-by: Léo DUBOIN <lduboin@freebox.fr>
Link: https://lore.kernel.org/r/c40d0634abefa19e689ffd450e0f48a8d63c4fc4.1714049455.git.lduboin@freebox.fr
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 4438f3b4b5ef..60f866f1e6d7 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -1670,6 +1670,7 @@ static int pinctrl_pins_show(struct seq_file *s, void *what)
 		seq_printf(s, "pin %d (%s) ", pin, desc->name);
 
 #ifdef CONFIG_GPIOLIB
+		gdev = NULL;
 		gpio_num = -1;
 		list_for_each_entry(range, &pctldev->gpio_ranges, node) {
 			if ((pin >= range->pin_base) &&
-- 
2.43.0



