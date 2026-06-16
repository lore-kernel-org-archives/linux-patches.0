Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ADDC37DEBF;
	Tue, 16 Jun 2026 16:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626815; cv=none; b=rnnBRFylt9O87WjaT9k0xJ2nXKqOA/8J9e9Gm4FjEMEoZiwI/eI9lBBTBvrAGBIfAEqHp/PqzTSDloqD/k9/kQC+e6tpigWB7CcExD0CIxjlj1QirWGNfS9dKkAiB+pFQMqzMul5UctDLnsPRaN06F6HqiQUo19j7VR+Q2Uf6+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626815; c=relaxed/simple;
	bh=h+ytZGWiZ+gQ/H5vp5Zm643PWECdwAm7WZoi4f+modg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3hoFAuDUTGMgO0dXp/Og0dZghr/h7tVUzvj1DX6W8gSJpjL3LqlvWzUWy3RAKgoxlhCDgqYCXGTx8xESOv+nimDX0KiByzXM1vkRXQqH04DctVHlriNPX7aJS+23zLrMJ62XJ6a0ZmaGYMMDZMfscxEFfhswC4ypWAM2ppf3JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f2xvWzny; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f2xvWzny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DABFA1F000E9;
	Tue, 16 Jun 2026 16:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626813;
	bh=o3kDLsyA4fpg/53ZHufsRotFBJyC4OOEOIKegqH7CKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f2xvWznytQJV3RMSGp5LIQMiiukSRZC8r/6S93zDtLpfky2zytxz0B6U0//bGjfA6
	 c8X4e7ZHB0B2TaxEB7tJxSps2Q1zyygjp47MIPdEPIiHxJfDmz7PidGPe5J3izZufj
	 TQHR/Gq9imQsTxFSBwQWVjwxm3odhCfwumz+30d4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yun Zhou <yun.zhou@windriver.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 076/261] gpio: mvebu: fix NULL pointer dereference in suspend/resume
Date: Tue, 16 Jun 2026 20:28:34 +0530
Message-ID: <20260616145048.619852023@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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
index 8cfd3a89c0184d..c85ab356bc72a9 100644
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



