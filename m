Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A74E4E0B66;
	Wed, 30 Sep 2026 16:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786270; cv=none; b=E9EI5Zpi2Eix1lUV9w5/PKTlszZlZnhFa9dioMbnR6aJECGGi1+O/KEOZFJIeCuaBnV0R0WRZKbQt3PrGoh42Ki6+ORmZHnAXSbML/kXVxmoRJYaZ/MY6Qk0ZEHWXUVlkwbzBELSwCdBX/F9Wz0TsZGIHYzUuPO4OA62wyY7Oq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786270; c=relaxed/simple;
	bh=sLZGxVU9HWdEpEmI2fTfXaBXXEdsDmKxDu5cSkrwI2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZcL273ysAPlytZALuFRdeuhgl+bJSfUXveIf6+sNoazoIkf1Z7nOG+2B9DNOLHcpJoJT+RmzISULRBm1YvzYQ8Ab9QhpJpkNUeUoAUiiYRe4SyfU2O8CjhNFHxKGiqDZ04jL1kB7w9rkCPWZ/6r3VgYJ0ELrL5IEw3M09F+dTVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SOHKW3To; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SOHKW3To"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1591F000FF;
	Wed, 30 Sep 2026 16:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786268;
	bh=9MBN6U408W9o5TDoXOXfLs7RAegrYyJAOEy3R+eNC7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SOHKW3Ton6eNvVP+EECTCecsoElOxkMRsBcnxA+PMgF+AjO9u3aLv/v+7r3ywQWMh
	 mB5zVXFQBro+ixjE5ngjmNz9r0XkGHBqcyZdKUBVd0MpTPvCyAKGhyxRGTyAVq87zZ
	 g6h3ofhFO/1eLn8ySxRJogep7T9XPEk1Q8ZtJlis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 802/982] sh: push-switch: Reorder cleanup operations to avoid use-after-free bug
Date: Wed, 30 Sep 2026 17:25:38 +0200
Message-ID: <20260930152433.982276644@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 246f80a0b17f8f582b2c0996db02998239057c65 ]

The original code puts flush_work() before timer_shutdown_sync()
in switch_drv_remove(). Although we use flush_work() to stop
the worker, it could be rescheduled in switch_timer(). As a result,
a use-after-free bug can occur. The details are shown below:

      (cpu 0)                    |      (cpu 1)
switch_drv_remove()              |
 flush_work()                    |
  ...                            |  switch_timer // timer
                                 |   schedule_work(&psw->work)
 timer_shutdown_sync()           |
 ...                             |  switch_work_handler // worker
 kfree(psw) // free              |
                                 |   psw->state = 0 // use

This patch puts timer_shutdown_sync() before flush_work() to
mitigate the bugs. As a result, the worker and timer will be
stopped safely before the deallocate operations.

Fixes: 9f5e8eee5cfe ("sh: generic push-switch framework.")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Link: https://lore.kernel.org/r/20230802033737.9738-1-duoming@zju.edu.cn
Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>

[ Backport to 6.1.y: use timer_shutdown_sync(), already available here,
  so the timer cannot rearm before the queued work is flushed. ]
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sh/drivers/push-switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sh/drivers/push-switch.c b/arch/sh/drivers/push-switch.c
index 2813140fd92bb..6ecba5f521eb6 100644
--- a/arch/sh/drivers/push-switch.c
+++ b/arch/sh/drivers/push-switch.c
@@ -101,8 +101,8 @@ static int switch_drv_remove(struct platform_device *pdev)
 		device_remove_file(&pdev->dev, &dev_attr_switch);
 
 	platform_set_drvdata(pdev, NULL);
+	timer_shutdown_sync(&psw->debounce);
 	flush_work(&psw->work);
-	del_timer_sync(&psw->debounce);
 	free_irq(irq, pdev);
 
 	kfree(psw);
-- 
2.53.0



