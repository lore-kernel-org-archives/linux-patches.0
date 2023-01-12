Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A51B79C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A8DC433D2;
	Thu, 12 Jan 2023 14:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533323;
	bh=AQWNBuMNnrs33WSKWv4yqd4FVJzhUTLHr1i3rZW8o7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wso/ciWS+hjkjTryZkA2fowjXspA3SatdMfki6SsqgqZKl941WiZpgn4Usxq2e+op
	 w7FgnOwWrtlCK1IlUnN75HsDMlx3F/ClYlBbXzG0yU7D1IqqVWOwhwl3JpuL/fzOV9
	 OZEV0uWUr5DOkJaTAzTkNwn8gj9hqo68Hsgw6kdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeng Heng <zengheng4@huawei.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 401/783] power: supply: fix residue sysfs file in error handle route of __power_supply_register()
Date: Thu, 12 Jan 2023 14:51:57 +0100
Message-Id: <20230112135542.897201374@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zeng Heng <zengheng4@huawei.com>

[ Upstream commit 5b79480ce1978864ac3f06f2134dfa3b6691fe74 ]

If device_add() succeeds, we should call device_del() when want to
get rid of it, so move it into proper jump symbol.

Otherwise, when __power_supply_register() returns fail and goto
wakeup_init_failed to exit, there is still residue device file in sysfs.
When attempt to probe device again, sysfs would complain as below:

sysfs: cannot create duplicate filename '/devices/platform/i2c/i2c-0/0-001c/power_supply/adp5061'
Call Trace:
 dump_stack_lvl+0x68/0x85
 sysfs_warn_dup.cold+0x1c/0x29
 sysfs_create_dir_ns+0x1b1/0x1d0
 kobject_add_internal+0x143/0x390
 kobject_add+0x108/0x170

Fixes: 80c6463e2fa3 ("power_supply: Fix Oops from NULL pointer dereference from wakeup_source_activate")
Signed-off-by: Zeng Heng <zengheng4@huawei.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/power_supply_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/power_supply_core.c b/drivers/power/supply/power_supply_core.c
index 280c54c23e37..be2cb925c115 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -1201,8 +1201,8 @@ __power_supply_register(struct device *parent,
 register_cooler_failed:
 	psy_unregister_thermal(psy);
 register_thermal_failed:
-	device_del(dev);
 wakeup_init_failed:
+	device_del(dev);
 device_add_failed:
 check_supplies_failed:
 dev_set_name_failed:
-- 
2.35.1



