Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D64BA56
	for <patches@lists.linux.dev>; Thu, 13 Apr 2023 22:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63885C433A0;
	Thu, 13 Apr 2023 22:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1681425517;
	bh=vbdX/dqmOVMZruNpFyND398jkZY5rXuYcUVR0aNvnBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qssvJRf3K0pi3IuIBrMMpDzmw12YfJrKrGRAhNS5fEnV5xcLGOJpgWpu1mm+z4JBa
	 nLcAMKWksxGJgqIM4JX6/ysp5DQiEUZtwjWGVhWnyfiEDG/wchVW6QXcdI+R+5/mYH
	 yHYU5YMJjF8ASWdeVkNCEaqBsoCCMjP7LVqOS00k1zO80+5hXKjBRYZFDHaalUoVO/
	 LcFz/CL4ErwL9HsuJutzVYiEqP6XEoTX29tA+Lyz2z0c3AtLLINfOQQIDKJYjSk2Na
	 /2M/Uy9XS2avnRCte4sAX0sbsKyVJ6lIDyjzGh6ermTSk6SGadFjGclQLCbfBR8NOK
	 4/m6pL95N4g0Q==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jishnu Prakash <quic_jprakash@quicinc.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 6/6] spmi: Add a check for remove callback when removing a SPMI driver
Date: Thu, 13 Apr 2023 15:38:34 -0700
Message-ID: <20230413223834.4084793-7-sboyd@kernel.org>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
In-Reply-To: <20230413223834.4084793-1-sboyd@kernel.org>
References: <20230413223834.4084793-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jishnu Prakash <quic_jprakash@quicinc.com>

When removing a SPMI driver, there can be a crash due to NULL pointer
dereference if it does not have a remove callback defined. This is
one such call trace observed when removing the QCOM SPMI PMIC driver:

 dump_backtrace.cfi_jt+0x0/0x8
 dump_stack_lvl+0xd8/0x16c
 panic+0x188/0x498
 __cfi_slowpath+0x0/0x214
 __cfi_slowpath+0x1dc/0x214
 spmi_drv_remove+0x16c/0x1e0
 device_release_driver_internal+0x468/0x79c
 driver_detach+0x11c/0x1a0
 bus_remove_driver+0xc4/0x124
 driver_unregister+0x58/0x84
 cleanup_module+0x1c/0xc24 [qcom_spmi_pmic]
 __do_sys_delete_module+0x3ec/0x53c
 __arm64_sys_delete_module+0x18/0x28
 el0_svc_common+0xdc/0x294
 el0_svc+0x38/0x9c
 el0_sync_handler+0x8c/0xf0
 el0_sync+0x1b4/0x1c0

If a driver has all its resources allocated through devm_() APIs and
does not need any other explicit cleanup, it would not require a
remove callback to be defined. Hence, add a check for remove callback
presence before calling it when removing a SPMI driver.

Signed-off-by: Jishnu Prakash <quic_jprakash@quicinc.com>
Link: https://lore.kernel.org/r/1671601032-18397-2-git-send-email-quic_jprakash@quicinc.com
Fixes: 6f00f8c8635f ("mfd: qcom-spmi-pmic: Use devm_of_platform_populate()")
Fixes: 5a86bf343976 ("spmi: Linux driver framework for SPMI")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/spmi/spmi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spmi/spmi.c b/drivers/spmi/spmi.c
index 5705151013b3..7313d4c18a04 100644
--- a/drivers/spmi/spmi.c
+++ b/drivers/spmi/spmi.c
@@ -350,7 +350,8 @@ static void spmi_drv_remove(struct device *dev)
 	const struct spmi_driver *sdrv = to_spmi_driver(dev->driver);
 
 	pm_runtime_get_sync(dev);
-	sdrv->remove(to_spmi_device(dev));
+	if (sdrv->remove)
+		sdrv->remove(to_spmi_device(dev));
 	pm_runtime_put_noidle(dev);
 
 	pm_runtime_disable(dev);
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

