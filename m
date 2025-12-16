Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2792341645;
	Tue, 16 Dec 2025 11:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884110; cv=none; b=bwVtK+v5eJlNaIq04Ql+jLtLW8N9bfNCl4ywZiG97UpyLQhsP8ZNzMNQ82jMUF81ijrQO1OP/BRKcNh79WPM4UHBIWpiqooip03tF5kj6NEjHL+P4TQH+RbACqNDJdlZj+KdRLASApwZfqN8Agb1PYKAfNnVdP00vBrNCsyVFPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884110; c=relaxed/simple;
	bh=gCtcisgC1MxkzfqkrgfQ1xyUBuE+XYmj3ptszrk706Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kbN2TzrEdTiwkpJ+3XjW21M378uW8Z+2AQOZ7XbO1ECJBL9fhxPZFMkhHT1NHmGfFfJNNhh2JAIQ7Hvco2T3EgqBk8/cDnhCGHMTCw4PibA2Pgz6LYRh7Y7mtRwGkuuCLK9y9B5C9oP7X+Bg3N9lMbGFqCLqs5i+wvVxrei8AjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rLJCcfR+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rLJCcfR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B10C4CEF5;
	Tue, 16 Dec 2025 11:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884110;
	bh=gCtcisgC1MxkzfqkrgfQ1xyUBuE+XYmj3ptszrk706Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rLJCcfR+arWBt4VXFy5qyVg1yd9syJUmreNE9J6imautNfosVin5kZxIvhKeAzZJX
	 WQ2poeADBkCn/YewzF1qpWr+9s7zASuiBZnhvyvcedFaJe5Dxu81hSUkgbsBHh/gMv
	 odxr/DKHaYVethN3skWDX9L3gqB3KOiV5WPTsSjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 093/354] pinctrl: stm32: fix hwspinlock resource leak in probe function
Date: Tue, 16 Dec 2025 12:11:00 +0100
Message-ID: <20251216111324.291176311@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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
index 2659a854a514e..857ce101fab0c 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -1537,7 +1537,7 @@ int stm32_pctl_probe(struct platform_device *pdev)
 		if (hwlock_id == -EPROBE_DEFER)
 			return hwlock_id;
 	} else {
-		pctl->hwlock = hwspin_lock_request_specific(hwlock_id);
+		pctl->hwlock = devm_hwspin_lock_request_specific(dev, hwlock_id);
 	}
 
 	spin_lock_init(&pctl->irqmux_lock);
-- 
2.51.0



