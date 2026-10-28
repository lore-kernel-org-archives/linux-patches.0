Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215111;
	b=TI71F9LkbGLv7efTJa5WWa9vgjp+pK1keDsPLDL1Z1AGWBmlYeLH+GVrePo8+rASA3gL
	 sGASqPfhy57QtGCYXq8js2D8Q3jCWbwWI6cSHKYzMKe/n+Xchz+uhdfzhtt7U10ztTCMD
	 JW5ybmw8ecOEoBMisGNo2msboT45Dm8IeHUzw7tqA9E8uP4Ani/SoPqFKTz8MZ4JgFQVZ
	 GtD4LhuEPh2dYhopFAnsxmsf9ntxYGB5K28NXIMFvra6ern//GUdimbCBy1yzKtPgrL3F
	 kEnRN2CqHET86vu2fWKWFIVowcs2gmAdQLgf7nSKcjdn2vF7XsdU0zlftA6RVe91+Dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215111;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z1k8pn0EBdb+4f1A6ATAdNHEMYrq7ahjxlYPV4o/qRs=;
	b=ecTvb3nPER5yDmo0GM0PaI5QzctTQPNTe1/68fZyPEypepuVv2sitP3/6YzoFwYf7jcT
	 fufL6gmt11AI5JwXRW8TrX+dJcyHhWJNw/rieJ+pzWUEAUFopOldNBbToPWph8fJOYe9H
	 NXV48GigR9Z5KsjJo0Z7GrUp5wNiq2iw76BZMc3QQUtYjdK85w+Lc8HPNJRj7dLuQeh6b
	 7NjLD4xSDGWAJtlApWd8c/qCbGysSYfs9Bq2gzS+8U6xJfcUekHKbI+jNyWqXAygOAKG/
	 En1tYVrCcdZGOlGkuB5EptfALouyEcTqygGLyKvBnm9CSgtpcM9yRMKRCrsCigmldvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CwDo1UEY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D2B606A31C;
	Wed, 28 Oct 2026 19:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CwDo1UEY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46ECF1F01829;
	Wed, 28 Oct 2026 19:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215110;
	bh=z1k8pn0EBdb+4f1A6ATAdNHEMYrq7ahjxlYPV4o/qRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CwDo1UEY9GSFoWpRcifx+qoJNqlIr8wsZl13yyFBeQsUoR74NA+22Ytl3XlchOyFq
	 /qBWhFcPc4zWGfi6VB7GIrFdFYw5JgTuva18muUet58yPAX8fkWIsIelfExp6eoSWn
	 eKFcllB3OlnhVeMDRDSfpfaNaH/HQphEbD+mSfLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yun Zhou <yun.zhou@windriver.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1097/1887] gpio: mvebu: fix NULL pointer dereference in suspend/resume
Date: Wed, 28 Oct 2026 17:53:13 +0100
Message-ID: <20261028170524.369206623@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yun Zhou <yun.zhou@windriver.com>

[ Upstream commit b9ad50d7505ebd48282ec3630258dc820fc85c81 ]

mvebu_pwm_suspend() and mvebu_pwm_resume() are called for all GPIO
banks during suspend/resume, but not all banks have PWM functionality.
GPIO banks without PWM have mvchip->mvpwm set to NULL.

Calling mvebu_pwm_suspend() with mvpwm == NULL causes a NULL pointer
dereference when it tries to access mvpwm->blink_select.

  Unable to handle kernel NULL pointer dereference at virtual address 00000020 when write
  [00000020] *pgd=00000000
  Internal error: Oops: 815 [#1] PREEMPT ARM
  Modules linked in:
  CPU: 0 UID: 0 PID: 406 Comm: sh Not tainted 6.12.74-rt12-yocto-standard-g4e96f98fb7db-dirty #353
  Hardware name: Marvell Armada 370/XP (Device Tree)
  PC is at regmap_mmio_read+0x38/0x54
  LR is at regmap_mmio_read+0x38/0x54
  pc : [<c05fd2ac>]    lr : [<c05fd2ac>]    psr: 200f0013
  sp : f0c11d10  ip : 00000000  fp : c100d2f0
  r10: c14fb854  r9 : 00000000  r8 : 00000000
  r7 : c1799c00  r6 : 00000020  r5 : 00000020  r4 : c179c7c0
  r3 : f0a231a0  r2 : 00000020  r1 : 00000020  r0 : 00000000
  Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
  Control: 10c5387d  Table: 135ec059  DAC: 00000051
  Call trace:
   regmap_mmio_read from _regmap_bus_reg_read+0x78/0xac
   _regmap_bus_reg_read from _regmap_read+0x60/0x154
   _regmap_read from regmap_read+0x3c/0x60
   regmap_read from mvebu_gpio_suspend+0xa4/0x14c
   mvebu_gpio_suspend from dpm_run_callback+0x54/0x180
   dpm_run_callback from device_suspend+0x124/0x630
   device_suspend from dpm_suspend+0x124/0x270
   dpm_suspend from dpm_suspend_start+0x64/0x6c
   dpm_suspend_start from suspend_devices_and_enter+0x140/0x8e8
   suspend_devices_and_enter from pm_suspend+0x2fc/0x308
   pm_suspend from state_store+0x6c/0xc8
   state_store from kernfs_fop_write_iter+0x10c/0x1f8
   kernfs_fop_write_iter from vfs_write+0x270/0x468
   vfs_write from ksys_write+0x70/0xf0
   ksys_write from ret_fast_syscall+0x0/0x54

Add a NULL check for mvchip->mvpwm before calling the PWM
suspend/resume functions.

Fixes: 757642f9a584 ("gpio: mvebu: Add limited PWM support")
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Link: https://patch.msgid.link/20260608084334.2960803-1-yun.zhou@windriver.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mvebu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index c38d28de2e620..f58f835d0acb3 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -1002,7 +1002,7 @@ static int mvebu_gpio_suspend(struct platform_device *pdev, pm_message_t state)
 		BUG();
 	}
 
-	if (IS_REACHABLE(CONFIG_PWM))
+	if (IS_REACHABLE(CONFIG_PWM) && mvchip->mvpwm)
 		mvebu_pwm_suspend(mvchip);
 
 	return 0;
@@ -1054,7 +1054,7 @@ static int mvebu_gpio_resume(struct platform_device *pdev)
 		BUG();
 	}
 
-	if (IS_REACHABLE(CONFIG_PWM))
+	if (IS_REACHABLE(CONFIG_PWM) && mvchip->mvpwm)
 		mvebu_pwm_resume(mvchip);
 
 	return 0;
-- 
2.53.0



