Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAAE48A2BC;
	Wed, 23 Sep 2026 14:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174438; cv=none; b=KiPRTTms7kPCZ2b5dWsmbtM/f0lHHfefUwoSXvZwo1wtqUS0wGPNcz9jIqs4i+38pPCD97LRI5ZGugD82Gz8yc5ghi3Lm4D5A+M5GH+mK2qD/O7wDHv94N4W+8W4ZHglb2b9B7fR3AiSspqYiwoVdpnX1vC11My5m85fn+lZ2no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174438; c=relaxed/simple;
	bh=od2kW0n0+uUFrj5Ga4rKpb5LW8ce/gQjcIgQngcFD6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jeqI2brynosZvNkTVwdTBqoNe7mgnfqMZF8dyzuKekc2OXQ+e+ZGHwyZdZl8jjvhY7ES6P8XoVQMAQQWkSH6OocX9LbpxOKqm5xY5VzsEP+0CdaC5FuxJ20vyH4tiIeIp8qoWjyA0I6js+E9/4SRLcYeS6NQ/y6kILRQmPZZ1H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EdmyMlkI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EdmyMlkI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0FC1F000FF;
	Wed, 23 Sep 2026 14:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174437;
	bh=ttFsNnkeOnCp+tXhh7lY+NrpriN2BuXX07G4R2TnjVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EdmyMlkIR4vpdWnpkTgLWFOh4r3sndhY0wofNTkIpLOHnfnszJ98Q7C0cvAftVvqF
	 x7c7IeRuYGVsB+BEM9tbPO8WeCPkiY1k4DLV7gZy9bbaZU7aUqT/wbS9jo8Ruwl1VU
	 BToReXVslt7hVkVlYwY22gajVhRoavTr8kbBwUMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 115/398] gpio: virtuser: skip free_irq when no IRQ is installed
Date: Wed, 23 Sep 2026 16:03:09 +0200
Message-ID: <20260923140646.424830462@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 50fd0ada8d37587223001600933270b59cb30e19 ]

Disabling interrupt monitoring uses atomic_xchg() to clear the stored IRQ.
When monitoring is already disabled, atomic_xchg() returns 0. It must not
be passed to free_irq().

The bug is reproducible on an x86_64 QEMU guest with
CONFIG_GPIO_VIRTUSER=y and CONFIG_GPIO_SIM=y. Configure a live
gpio-virtuser device through configfs. Its input lookup must refer to a
live gpio-sim bank, such as key gpio-sim-test with offset 0. The
consumer's dev_name attribute is shown as <dev> below; then run:

    echo 0 > /sys/kernel/debug/gpio-virtuser/<dev>/gpiod:input:0/interrupts

On an unpatched kernel, this reaches gpio_virtuser_interrupts_set() with
ld->irq still at its initial value 0, and free_irq() reports:

    Trying to free already-free IRQ 0

The same reproducer completes without the warning on the patched kernel.

Fixes: 91581c4b3f29 ("gpio: virtuser: new virtual testing driver for the GPIO API")
Assisted-by: LLM
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260914051537.15320-1-runyu.xiao@seu.edu.cn
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-virtuser.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-virtuser.c b/drivers/gpio/gpio-virtuser.c
index 1901b4ba558f0..ce7ada0f17981 100644
--- a/drivers/gpio/gpio-virtuser.c
+++ b/drivers/gpio/gpio-virtuser.c
@@ -697,7 +697,8 @@ static int gpio_virtuser_interrupts_set(void *data, u64 val)
 		atomic_set(&ld->irq, irq);
 	} else {
 		irq = atomic_xchg(&ld->irq, 0);
-		free_irq(irq, ld);
+		if (irq)
+			free_irq(irq, ld);
 	}
 
 	return 0;
-- 
2.53.0



