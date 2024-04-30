Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B10A12C487;
	Tue, 30 Apr 2024 10:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474638; cv=none; b=YOhHanApM+H3yIKThV4mm6RNNk+TxhgKurO1iFr1iDaDScJxDVRnWhZJv/rGbi88IzsWW39N+F5RzTQL6zQBqP+Eao0KHIQXbXgEVlW7Pri/sr825asnqggneYYCI4cMbSsAbhT+GD9MpDKVMchP1ov7Pu4K7jUojjDDTUEQqLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474638; c=relaxed/simple;
	bh=x5Jl3xLbesGWvOpBXk1EQLYwpIi10keyqcWo2LhEjcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ucb0FEmvkzO3ruhyPXDN/yiVY++n+0HVoGqbtlYbjOXezblDqcdi074QUwxR4p3ZtckLTj/H+XKavNBfuLMBxf11nMVO3vN43WXK0UX+kD/k0WifMeDsrrKv6e9e3+HVXvjs/i6O7vpBXQw+TbfB7LdUCL8gWiunvpdi+ekUq80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m4ub7JCW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m4ub7JCW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1565CC2BBFC;
	Tue, 30 Apr 2024 10:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474638;
	bh=x5Jl3xLbesGWvOpBXk1EQLYwpIi10keyqcWo2LhEjcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m4ub7JCWS7bU6bJbzEF4l/kMyE9jjEEHePbEh0cmQ+jjdrfv+8PGSjR6RURObOdvZ
	 nVvBoxy3IN4peGZ0uYWRA+BJvBuGIpOj0LiCfaMrVIpAIhdnVIcjL9R0z3aG1ZfjET
	 qSw3rYX6g1DVlP3hNT0vvPmdkyPCBxXJzF84x7ZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 216/228] phy: ti: tusb1210: Resolve charger-det crash if charger psy is unregistered
Date: Tue, 30 Apr 2024 12:39:54 +0200
Message-ID: <20240430103110.038218517@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit bf6e4ee5c43690e4c5a8a057bbcd4ff986bed052 ]

The power_supply frame-work is not really designed for there to be
long living in kernel references to power_supply devices.

Specifically unregistering a power_supply while some other code has
a reference to it triggers a WARN in power_supply_unregister():

	WARN_ON(atomic_dec_return(&psy->use_cnt));

Folllowed by the power_supply still getting removed and the
backing data freed anyway, leaving the tusb1210 charger-detect code
with a dangling reference, resulting in a crash the next time
tusb1210_get_online() is called.

Fix this by only holding the reference in tusb1210_get_online()
freeing it at the end of the function. Note this still leaves
a theoretical race window, but it avoids the issue when manually
rmmod-ing the charger chip driver during development.

Fixes: 48969a5623ed ("phy: ti: tusb1210: Add charger detection")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240406140821.18624-1-hdegoede@redhat.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/ti/phy-tusb1210.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/phy/ti/phy-tusb1210.c b/drivers/phy/ti/phy-tusb1210.c
index b4881cb344759..c23eecc7d1800 100644
--- a/drivers/phy/ti/phy-tusb1210.c
+++ b/drivers/phy/ti/phy-tusb1210.c
@@ -65,7 +65,6 @@ struct tusb1210 {
 	struct delayed_work chg_det_work;
 	struct notifier_block psy_nb;
 	struct power_supply *psy;
-	struct power_supply *charger;
 #endif
 };
 
@@ -231,19 +230,24 @@ static const char * const tusb1210_chargers[] = {
 
 static bool tusb1210_get_online(struct tusb1210 *tusb)
 {
+	struct power_supply *charger = NULL;
 	union power_supply_propval val;
-	int i;
+	bool online = false;
+	int i, ret;
 
-	for (i = 0; i < ARRAY_SIZE(tusb1210_chargers) && !tusb->charger; i++)
-		tusb->charger = power_supply_get_by_name(tusb1210_chargers[i]);
+	for (i = 0; i < ARRAY_SIZE(tusb1210_chargers) && !charger; i++)
+		charger = power_supply_get_by_name(tusb1210_chargers[i]);
 
-	if (!tusb->charger)
+	if (!charger)
 		return false;
 
-	if (power_supply_get_property(tusb->charger, POWER_SUPPLY_PROP_ONLINE, &val))
-		return false;
+	ret = power_supply_get_property(charger, POWER_SUPPLY_PROP_ONLINE, &val);
+	if (ret == 0)
+		online = val.intval;
+
+	power_supply_put(charger);
 
-	return val.intval;
+	return online;
 }
 
 static void tusb1210_chg_det_work(struct work_struct *work)
@@ -467,9 +471,6 @@ static void tusb1210_remove_charger_detect(struct tusb1210 *tusb)
 		cancel_delayed_work_sync(&tusb->chg_det_work);
 		power_supply_unregister(tusb->psy);
 	}
-
-	if (tusb->charger)
-		power_supply_put(tusb->charger);
 }
 #else
 static void tusb1210_probe_charger_detect(struct tusb1210 *tusb) { }
-- 
2.43.0



