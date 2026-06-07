Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04AE4204E;
	Sun,  7 Jun 2026 10:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827033; cv=none; b=JB1BX26dJAk7idsUbEkN3F4LrRoet/iAbSQKCM9V6jMFGv+AuYHoRvXyKROw6kfj3fx6C0mlkVmvoa+35cFtF8cfyYwGnC+iPImkg0cIgH6yJEpa2e/jjCc1fTB7fP3xGRbPypbFdQdF7frl3/PMY3Xn0sliw/BZWKHGvxit73Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827033; c=relaxed/simple;
	bh=Em2ZzgOBlPFCIrjOFLlJRKv0xXHXxVCadgYHa6nDHHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ujiq/UiObDImLKyH0BiM4BgoNWAIenTHSDzV9AIzpPQ47gSGhzjKbq574nyRuEtx3r34nRfr+s0tE2RUwV1yYf+yruXgdA6tCy8gw+ZOI4s3kdby2JLs0iwB9d92c9Psw4aMECFR2tQ6lhNvB4CvgyttuhbKHZEBlPC1N/PM9uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dwm068iM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dwm068iM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315F01F00893;
	Sun,  7 Jun 2026 10:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827032;
	bh=aKhJ3lQTUWKuChJ0XKF4M6EaK8s4RrrsejnJ9r5WCYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dwm068iM/o2SKsG6vjE7wDDaoIO/d4t/5MJl1jI7LQr9WZzFBUmr7V0NzFsaMfIVw
	 rg2SDdyuqA4fSNQWmjIF26sfxRFGzHkK8eRF/g3b4NeuF+kiSR8wHdqZv6w5HhWnFy
	 sR0S+UyGyEaKzNtK9QDTxQ1QLq3vnUQ1vzKpSItw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Danielle Ratson <danieller@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 050/332] ethtool: module: check fw_flash_in_progress under rtnl_lock
Date: Sun,  7 Jun 2026 11:56:59 +0200
Message-ID: <20260607095729.960635399@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 504eaefa44c8dec50f7499edcb36d24f3aefab2a ]

ethnl_set_module_validate() inspects module_fw_flash_in_progress
but validate is meant for _input_ validation, not state validation.
rtnl_lock is not held, yet. Move the check into ethnl_set_module().

Fixes: 32b4c8b53ee7 ("ethtool: Add ability to flash transceiver modules' firmware")
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
Link: https://patch.msgid.link/20260522231312.1710836-5-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/module.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ethtool/module.c b/net/ethtool/module.c
index ce4ce514edca89..373326e49d150e 100644
--- a/net/ethtool/module.c
+++ b/net/ethtool/module.c
@@ -120,12 +120,6 @@ ethnl_set_module_validate(struct ethnl_req_info *req_info,
 	if (!tb[ETHTOOL_A_MODULE_POWER_MODE_POLICY])
 		return 0;
 
-	if (req_info->dev->ethtool->module_fw_flash_in_progress) {
-		NL_SET_ERR_MSG(info->extack,
-			       "Module firmware flashing is in progress");
-		return -EBUSY;
-	}
-
 	if (!ops->get_module_power_mode || !ops->set_module_power_mode) {
 		NL_SET_ERR_MSG_ATTR(info->extack,
 				    tb[ETHTOOL_A_MODULE_POWER_MODE_POLICY],
@@ -148,6 +142,12 @@ ethnl_set_module(struct ethnl_req_info *req_info, struct genl_info *info)
 
 	ops = dev->ethtool_ops;
 
+	if (dev->ethtool->module_fw_flash_in_progress) {
+		NL_SET_ERR_MSG(info->extack,
+			       "Module firmware flashing is in progress");
+		return -EBUSY;
+	}
+
 	power_new.policy = nla_get_u8(tb[ETHTOOL_A_MODULE_POWER_MODE_POLICY]);
 	ret = ops->get_module_power_mode(dev, &power, info->extack);
 	if (ret < 0)
-- 
2.53.0



