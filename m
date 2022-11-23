Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873C31C26
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:06:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A2EC433C1;
	Wed, 23 Nov 2022 09:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194364;
	bh=UqqAFhJHYuv9ZiGESkPL/MSim00a1cSb9ehfY9t3srM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uGrBV/SX6DoPpvRGNdOs1D5GOfP0N79bvUylKIYEph8YTpbtLSqeh1/TwFZ60De+t
	 Pvcgp3DPvB1/vRHUvlDsjC7RL2subFIhtVmF0hOn4ouEqVWFXjweoAPe2seiZ+Gswm
	 jvQ3wMQeS/bksZfj/GfJQ5hAdfuWVv8sAQAaJ48Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	Shawn Guo <shawn.guo@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 057/114] serial: imx: Add missing .thaw_noirq hook
Date: Wed, 23 Nov 2022 09:50:44 +0100
Message-Id: <20221123084554.161719377@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084551.864610302@linuxfoundation.org>
References: <20221123084551.864610302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shawn Guo <shawn.guo@linaro.org>

[ Upstream commit 4561d8008a467cb05ac632a215391d6b787f40aa ]

The following warning is seen with non-console UART instance when
system hibernates.

[   37.371969] ------------[ cut here ]------------
[   37.376599] uart3_root_clk already disabled
[   37.380810] WARNING: CPU: 0 PID: 296 at drivers/clk/clk.c:952 clk_core_disable+0xa4/0xb0
...
[   37.506986] Call trace:
[   37.509432]  clk_core_disable+0xa4/0xb0
[   37.513270]  clk_disable+0x34/0x50
[   37.516672]  imx_uart_thaw+0x38/0x5c
[   37.520250]  platform_pm_thaw+0x30/0x6c
[   37.524089]  dpm_run_callback.constprop.0+0x3c/0xd4
[   37.528972]  device_resume+0x7c/0x160
[   37.532633]  dpm_resume+0xe8/0x230
[   37.536036]  hibernation_snapshot+0x288/0x430
[   37.540397]  hibernate+0x10c/0x2e0
[   37.543798]  state_store+0xc4/0xd0
[   37.547203]  kobj_attr_store+0x1c/0x30
[   37.550953]  sysfs_kf_write+0x48/0x60
[   37.554619]  kernfs_fop_write_iter+0x118/0x1ac
[   37.559063]  new_sync_write+0xe8/0x184
[   37.562812]  vfs_write+0x230/0x290
[   37.566214]  ksys_write+0x68/0xf4
[   37.569529]  __arm64_sys_write+0x20/0x2c
[   37.573452]  invoke_syscall.constprop.0+0x50/0xf0
[   37.578156]  do_el0_svc+0x11c/0x150
[   37.581648]  el0_svc+0x30/0x140
[   37.584792]  el0t_64_sync_handler+0xe8/0xf0
[   37.588976]  el0t_64_sync+0x1a0/0x1a4
[   37.592639] ---[ end trace 56e22eec54676d75 ]---

On hibernating, pm core calls into related hooks in sequence like:

    .freeze
    .freeze_noirq
    .thaw_noirq
    .thaw

With .thaw_noirq hook being absent, the clock will be disabled in a
unbalanced call which results the warning above.

    imx_uart_freeze()
        clk_prepare_enable()
    imx_uart_suspend_noirq()
        clk_disable()
    imx_uart_thaw
        clk_disable_unprepare()

Adding the missing .thaw_noirq hook as imx_uart_resume_noirq() will have
the call sequence corrected as below and thus fix the warning.

    imx_uart_freeze()
        clk_prepare_enable()
    imx_uart_suspend_noirq()
        clk_disable()
    imx_uart_resume_noirq()
        clk_enable()
    imx_uart_thaw
        clk_disable_unprepare()

Fixes: 09df0b3464e5 ("serial: imx: fix endless loop during suspend")
Reviewed-by: Martin Kaiser <martin@kaiser.cx>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Link: https://lore.kernel.org/r/20221012121353.2346280-1-shawn.guo@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/imx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index aeda1fe71eeb..819f340a8a7a 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -2510,6 +2510,7 @@ static const struct dev_pm_ops imx_uart_pm_ops = {
 	.suspend_noirq = imx_uart_suspend_noirq,
 	.resume_noirq = imx_uart_resume_noirq,
 	.freeze_noirq = imx_uart_suspend_noirq,
+	.thaw_noirq = imx_uart_resume_noirq,
 	.restore_noirq = imx_uart_resume_noirq,
 	.suspend = imx_uart_suspend,
 	.resume = imx_uart_resume,
-- 
2.35.1



