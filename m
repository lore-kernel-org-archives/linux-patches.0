Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8469450C2A4;
	Wed, 30 Sep 2026 17:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788400; cv=none; b=u5yTSgktgg4x2VhfG18yP+kTKpKi8L6J0LH6AA7z16kpSrYg5874hdGt6/wEnWyRqjRPT/bvxe3OVPJkzKdj9rcdjRRLdH/6sXmym2hU6YA2CvRZdMed9l6N+VLiXSn6MGkFT6TwUCl7bCaHtT6l5t1blIIGGAOa4KtQTJpdkEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788400; c=relaxed/simple;
	bh=k8tbjoidGnlE28DlkLQ8QQnPilwXkr2z0hHl8T/ZCRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OhjrIVdaVJ6WstxfstXeUJqe1caQ4aklYpRP6NWfCky9BQJG1a1EXjtkU7MpvPmEdY53u1/0D1mvlqlUaJ2qY2JdlEdhfOr7aUGzqXKLR+hgOuAc/xIvHf83p+pLtYYWWgOaBxg32z64UuwrugrTndQH5qGD0QfdasdV9lI4Kgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jvk4VhF0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jvk4VhF0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90101F000FF;
	Wed, 30 Sep 2026 17:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788399;
	bh=yJC914sId3l9oirmguQrTA4+f4HAGFKonSZ73GG2/RU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jvk4VhF0heOq/iO/cC9ygLjPxg5nNwY+HYOIPY/TqD/PEflC7FE0GW0/vGJcCMGcW
	 XhNXC8FQNhHFy7Xsb4sW1j3EPZQHiSG16TGLzOHSPufPPWPNKbd48zB5/BgZvktx3T
	 fnbrfk6w5cEjD+f8K4OnYQtPCkNPeeYz8+AEyzkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 109/877] gpio: virtuser: skip free_irq when no IRQ is installed
Date: Wed, 30 Sep 2026 17:17:00 +0200
Message-ID: <20260930152417.091345312@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
index ff1977b269914..5de9cee51fd08 100644
--- a/drivers/gpio/gpio-virtuser.c
+++ b/drivers/gpio/gpio-virtuser.c
@@ -698,7 +698,8 @@ static int gpio_virtuser_interrupts_set(void *data, u64 val)
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



