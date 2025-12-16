Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53E330EF80;
	Tue, 16 Dec 2025 11:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885404; cv=none; b=YlAc5pZF3LFO+FKLULBtt8WaCDZt8eSio1UYhEyB3Pn+L9Vws0teQjYYtr/aesa76mig9IQWehti0kstRU0iwloe53QzYcSluNQsjlt34jFbl5D5fl5L1vxl9sBEpWZ5ytI5DetPxeqxUaAOoLdHARvQTJbBi1IoaBdK38myZPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885404; c=relaxed/simple;
	bh=BM8c+ZWpf5Si8yAUDMFKIPbvVYwu+GlHd8JEVvw3Cmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=daSS1I+eTW/cMpYmizRYWkN2XzC2aP+6iwkP+YbLni2KBS2dQhuc56iX3rdM7pr4QnXfH/JGdnwP76b9Xy6rzcPQyYOxYhMwnf7g0jAMA3fmcO7iNkRfKnw25p+ydUpi7bih1YxRNHd+n4Mb5LIO0M06ljTcGWIh9zBZAIBUTmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MCLJ3MMf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MCLJ3MMf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E9DC4CEF1;
	Tue, 16 Dec 2025 11:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885404;
	bh=BM8c+ZWpf5Si8yAUDMFKIPbvVYwu+GlHd8JEVvw3Cmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MCLJ3MMf1q076qXrgkMyiufmA8QiQ+FECZoU54vc2/mQD/1V/jI9vp90TyXTK4uWc
	 IsvAPhuQd7S0N3BCU/o/rnhwCYyD8dgG06041t5oJOqJnpMOwi9FAcIcIMQYDWmR39
	 CzYZt+wsHlthn94zPL+f/5aA1qfvQAsbuG6jno6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 128/507] pinctrl: stm32: fix hwspinlock resource leak in probe function
Date: Tue, 16 Dec 2025 12:09:29 +0100
Message-ID: <20251216111350.168478286@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 823c8fe758e2c..d9a2d20a7e6b2 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -1671,7 +1671,7 @@ int stm32_pctl_probe(struct platform_device *pdev)
 		if (hwlock_id == -EPROBE_DEFER)
 			return hwlock_id;
 	} else {
-		pctl->hwlock = hwspin_lock_request_specific(hwlock_id);
+		pctl->hwlock = devm_hwspin_lock_request_specific(dev, hwlock_id);
 	}
 
 	spin_lock_init(&pctl->irqmux_lock);
-- 
2.51.0



