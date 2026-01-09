Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4200E359708;
	Fri,  9 Jan 2026 12:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961694; cv=none; b=r5/rnWb+7z7AcB9WYNxr71AjLor3dJMKEdx9ykDtd52qag9flVqYqhhzWYJ8e1e+JXZkNsz3yyzg4Czrct1Go5bHiqD6mnxB/KIgSxRyTb3sxFMJqvn+Z1GhPVRhaA0brQITtjnYs4qMwR5cHdgPMQXxLWx3IRIcPPkXlv+YomI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961694; c=relaxed/simple;
	bh=lTei2P0XuWBsDHXlattFAeufdZcgoYWcnwXWfMDiQIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mXI4nefkojE/fgKUV/N/z+FIp9WGo4+6Ec8V+bbF0Id1BLd643frw+XvDmvDJuug8HyF4tZiOmZZ88B5mJh74hgGwfLUqO4DTiupMX+0MGvnndKzeaGMlY3QilBuD/mCPNTu5KFPkHo/VvPTwG89untlW/J7XqQsUoUeuXBnrZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uzTg9cqn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uzTg9cqn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA04DC4CEF1;
	Fri,  9 Jan 2026 12:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961694;
	bh=lTei2P0XuWBsDHXlattFAeufdZcgoYWcnwXWfMDiQIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uzTg9cqnfD+eAZ9pGquvY/MV3zn88neiYjSsAbDwsIBwFxRLe5pxQU5Ca+EdBgA56
	 WTE8YJCQRdubkmi5Lot16GBsf/vItoY+vUh+RySJKG11VPS4nap7X5zciDrYI9MhFG
	 ov7Izs/PLwYBmcZsKeJk9Fb33fgUh3PHKLu6JsLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 071/634] pinctrl: stm32: fix hwspinlock resource leak in probe function
Date: Fri,  9 Jan 2026 12:35:49 +0100
Message-ID: <20260109112120.115486393@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 661eb0c1f7972..2b8b7d3eec9b1 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -1554,7 +1554,7 @@ int stm32_pctl_probe(struct platform_device *pdev)
 		if (hwlock_id == -EPROBE_DEFER)
 			return hwlock_id;
 	} else {
-		pctl->hwlock = hwspin_lock_request_specific(hwlock_id);
+		pctl->hwlock = devm_hwspin_lock_request_specific(dev, hwlock_id);
 	}
 
 	spin_lock_init(&pctl->irqmux_lock);
-- 
2.51.0



