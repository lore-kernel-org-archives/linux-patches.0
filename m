Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FBB79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:45:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15829C433C1;
	Wed, 30 Nov 2022 18:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833919;
	bh=liv0uv/qYZiBmHFuk7x7CwdoVa0zdhjuZoPRszxiNOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dd+QDxwnk/JrKyXbrqlEhAzRF6C0oPLaw/U+RkMmTw71eLdMSZHaqdFONLDIcO0LA
	 UKbRTa7cm+EOAxqY6sRWtZb6THGl4qZtPAnHIos54ON/hvB6SKto+3fJS+BE4jzzYP
	 AArBBsDGUXjOawKA5Z1IdiNnaotdi2M3W4PY9i+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 063/289] regulator: rt5759: fix OOB in validate_desc()
Date: Wed, 30 Nov 2022 19:20:48 +0100
Message-Id: <20221130180545.558579739@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 7920e0fbced429ab18ad4402e3914146a6a0921b ]

I got the following OOB report:

 BUG: KASAN: slab-out-of-bounds in validate_desc+0xba/0x109
 Read of size 8 at addr ffff888107db8ff0 by task python3/253
 Call Trace:
  <TASK>
  dump_stack_lvl+0x67/0x83
  print_report+0x178/0x4b0
  kasan_report+0x90/0x190
  validate_desc+0xba/0x109
  gpiod_set_value_cansleep+0x40/0x5a
  regulator_ena_gpio_ctrl+0x93/0xfc
  _regulator_do_enable.cold.61+0x89/0x163
  set_machine_constraints+0x140a/0x159c
  regulator_register.cold.73+0x762/0x10cd
  devm_regulator_register+0x57/0xb0
  rt5759_probe+0x3a0/0x4ac [rt5759_regulator]

The desc used in validate_desc() is passed from 'reg_cfg.ena_gpiod',
which is not initialized. Fix this by initializing 'reg_cfg' to 0.

Fixes: 7b36ddb208bd ("regulator: rt5759: Add support for Richtek RT5759 DCDC converter")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221116092943.1668326-1-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/rt5759-regulator.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/rt5759-regulator.c b/drivers/regulator/rt5759-regulator.c
index 6b96899eb27e..8488417f4b2c 100644
--- a/drivers/regulator/rt5759-regulator.c
+++ b/drivers/regulator/rt5759-regulator.c
@@ -243,6 +243,7 @@ static int rt5759_regulator_register(struct rt5759_priv *priv)
 	if (priv->chip_type == CHIP_TYPE_RT5759A)
 		reg_desc->uV_step = RT5759A_STEP_UV;
 
+	memset(&reg_cfg, 0, sizeof(reg_cfg));
 	reg_cfg.dev = priv->dev;
 	reg_cfg.of_node = np;
 	reg_cfg.init_data = of_get_regulator_init_data(priv->dev, np, reg_desc);
-- 
2.35.1



