Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD652469F
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:35:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF17C433C8;
	Mon, 28 Aug 2023 10:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218900;
	bh=FGEh7L7Cu1UtvwrHqggls9gTbL47jO3cxX28GT3qZls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rBCuCg+foFZo6HlicUSFJNn6qmXT5kYhr/z/OGg1+mvNNzwMICZgD6+4oGhpfztW4
	 gRpahrkr1+s8ztxdWwjez44s/ue8D13rheEUE0yMU8uiSN+XajtIIg7JoDpEeXBrUv
	 DEE0vaI80127d+HbG1DZFY8mQoMXF0Dmri3H/wWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Paterson <Chris.Paterson2@renesas.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 114/122] pinctrl: renesas: rzg2l: Fix NULL pointer dereference in rzg2l_dt_subnode_to_map()
Date: Mon, 28 Aug 2023 12:13:49 +0200
Message-ID: <20230828101200.217469741@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
References: <20230828101156.480754469@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 661efa2284bbc2338da0424e219603f034072c74 ]

Fix the below random NULL pointer crash during boot by serializing
pinctrl group and function creation/remove calls in
rzg2l_dt_subnode_to_map() with mutex lock.

Crash log:
    pc : __pi_strcmp+0x20/0x140
    lr : pinmux_func_name_to_selector+0x68/0xa4
    Call trace:
    __pi_strcmp+0x20/0x140
    pinmux_generic_add_function+0x34/0xcc
    rzg2l_dt_subnode_to_map+0x314/0x44c
    rzg2l_dt_node_to_map+0x164/0x194
    pinctrl_dt_to_map+0x218/0x37c
    create_pinctrl+0x70/0x3d8

While at it, add comments for bitmap_lock and lock.

Fixes: c4c4637eb57f ("pinctrl: renesas: Add RZ/G2L pin and gpio controller driver")
Tested-by: Chris Paterson <Chris.Paterson2@renesas.com>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20230815131558.33787-2-biju.das.jz@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rzg2l.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzg2l.c b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
index fd11d28e5a1e4..2a617832a7e60 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -11,6 +11,7 @@
 #include <linux/io.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
 #include <linux/pinctrl/pinconf-generic.h>
@@ -146,10 +147,11 @@ struct rzg2l_pinctrl {
 	struct gpio_chip		gpio_chip;
 	struct pinctrl_gpio_range	gpio_range;
 	DECLARE_BITMAP(tint_slot, RZG2L_TINT_MAX_INTERRUPT);
-	spinlock_t			bitmap_lock;
+	spinlock_t			bitmap_lock; /* protect tint_slot bitmap */
 	unsigned int			hwirq[RZG2L_TINT_MAX_INTERRUPT];
 
-	spinlock_t			lock;
+	spinlock_t			lock; /* lock read/write registers */
+	struct mutex			mutex; /* serialize adding groups and functions */
 };
 
 static const unsigned int iolh_groupa_mA[] = { 2, 4, 8, 12 };
@@ -359,11 +361,13 @@ static int rzg2l_dt_subnode_to_map(struct pinctrl_dev *pctldev,
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
@@ -377,6 +381,8 @@ static int rzg2l_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 		goto remove_group;
 	}
 
+	mutex_unlock(&pctrl->mutex);
+
 	maps[idx].type = PIN_MAP_TYPE_MUX_GROUP;
 	maps[idx].data.mux.group = name;
 	maps[idx].data.mux.function = name;
@@ -388,6 +394,8 @@ static int rzg2l_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 
 remove_group:
 	pinctrl_generic_remove_group(pctldev, gsel);
+unlock:
+	mutex_unlock(&pctrl->mutex);
 done:
 	*index = idx;
 	kfree(configs);
@@ -1501,6 +1509,7 @@ static int rzg2l_pinctrl_probe(struct platform_device *pdev)
 
 	spin_lock_init(&pctrl->lock);
 	spin_lock_init(&pctrl->bitmap_lock);
+	mutex_init(&pctrl->mutex);
 
 	platform_set_drvdata(pdev, pctrl);
 
-- 
2.40.1



