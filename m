Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727D311C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:22:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D540C433C9;
	Mon, 28 Aug 2023 10:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218167;
	bh=vlg0mHjDJV3G9NRGtUaKcnnYRt8tmrDqwl63YMu2Fqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J3thaody/2vUGF0vWSLVPXz3DaRg+cDL1FPNQfU75sWmajgFfNsjUKMrpUS/OTrLo
	 /jxpFugit3gO2jIpl+A/ODW0SrbhgfZJtmIfgOKkCxNwDJDFOJ6QzJY/mMJuVmlbeI
	 mNEJdfGO+FDvoHB3kIOG5JQI1SZbkRlJ2pMKiQs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 120/129] pinctrl: renesas: rzv2m: Fix NULL pointer dereference in rzv2m_dt_subnode_to_map()
Date: Mon, 28 Aug 2023 12:13:19 +0200
Message-ID: <20230828101201.377965526@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>
References: <20230828101157.383363777@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit f982b9d57e7f834138fc908804fe66f646f2b108 ]

Fix the below random NULL pointer crash during boot by serializing
pinctrl group and function creation/remove calls in
rzv2m_dt_subnode_to_map() with mutex lock.

Crash logs:
    pc : __pi_strcmp+0x20/0x140
    lr : pinmux_func_name_to_selector+0x68/0xa4
    Call trace:
    __pi_strcmp+0x20/0x140
    pinmux_generic_add_function+0x34/0xcc
    rzv2m_dt_subnode_to_map+0x2e4/0x418
    rzv2m_dt_node_to_map+0x15c/0x18c
    pinctrl_dt_to_map+0x218/0x37c
    create_pinctrl+0x70/0x3d8

While at it, add a comment for lock.

Fixes: 92a9b8252576 ("pinctrl: renesas: Add RZ/V2M pin and gpio controller driver")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20230815131558.33787-3-biju.das.jz@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rzv2m.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzv2m.c b/drivers/pinctrl/renesas/pinctrl-rzv2m.c
index 35b23c1a5684d..9146101ea9e2f 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzv2m.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzv2m.c
@@ -14,6 +14,7 @@
 #include <linux/gpio/driver.h>
 #include <linux/io.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/of_device.h>
 #include <linux/spinlock.h>
 
@@ -123,7 +124,8 @@ struct rzv2m_pinctrl {
 	struct gpio_chip		gpio_chip;
 	struct pinctrl_gpio_range	gpio_range;
 
-	spinlock_t			lock;
+	spinlock_t			lock; /* lock read/write registers */
+	struct mutex			mutex; /* serialize adding groups and functions */
 };
 
 static const unsigned int drv_1_8V_group2_uA[] = { 1800, 3800, 7800, 11000 };
@@ -322,11 +324,13 @@ static int rzv2m_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 		name = np->name;
 	}
 
+	mutex_lock(&pctrl->mutex);
+
 	/* Register a single pin group listing all the pins we read from DT */
 	gsel = pinctrl_generic_add_group(pctldev, name, pins, num_pinmux, NULL);
 	if (gsel < 0) {
 		ret = gsel;
-		goto done;
+		goto unlock;
 	}
 
 	/*
@@ -340,6 +344,8 @@ static int rzv2m_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 		goto remove_group;
 	}
 
+	mutex_unlock(&pctrl->mutex);
+
 	maps[idx].type = PIN_MAP_TYPE_MUX_GROUP;
 	maps[idx].data.mux.group = name;
 	maps[idx].data.mux.function = name;
@@ -351,6 +357,8 @@ static int rzv2m_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 
 remove_group:
 	pinctrl_generic_remove_group(pctldev, gsel);
+unlock:
+	mutex_unlock(&pctrl->mutex);
 done:
 	*index = idx;
 	kfree(configs);
@@ -1071,6 +1079,7 @@ static int rzv2m_pinctrl_probe(struct platform_device *pdev)
 	}
 
 	spin_lock_init(&pctrl->lock);
+	mutex_init(&pctrl->mutex);
 
 	platform_set_drvdata(pdev, pctrl);
 
-- 
2.40.1



