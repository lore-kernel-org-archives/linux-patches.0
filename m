Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EDB3B4E8E;
	Mon, 23 Mar 2026 15:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278361; cv=none; b=XFOPKITpE31vEtmnw1sl7WHj1S+TcHrwTii5NH5xNxizsoq/VXpzHqHQ1sICVE3X40mdwjO88jYjbVeF1oAwzcE7bvptrjSMxgGRuAhGzK3eUI0HULZH0eOPCVkz+zwwm7AST4o2fOFvcPhdMxp/ItAeQZMvEd0uLGSgGNu5NOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278361; c=relaxed/simple;
	bh=XKkFS/Ph/EfsTPpPTXVVJ7As++2OOxBDsggtSe/Uk50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZ2y+PAqSM4d/MlFGZDVNVSSzQk403OpUqXICSDBJfSH5ChbglHptp2VWs7Uv6+Ow3R4cP0LoE6fO5eBlpqZvEQWFA3JB9SJTU751QrsKI3CrwZ5VE1RVw1SrL2S3slmuSELoWQhTSeaa5RZOAYN1hJV7rGlamFP1Jds3CROZ+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YCTpCM1J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YCTpCM1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF54C2BC9E;
	Mon, 23 Mar 2026 15:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278361;
	bh=XKkFS/Ph/EfsTPpPTXVVJ7As++2OOxBDsggtSe/Uk50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YCTpCM1JsOSQo1lX6lEKwMzrBm9dBY/lgnNibq7SB/q9BFeolJrr20m8kEUo3WHQ/
	 AFCPi1oKjvH03lscA3iGxRkCzQImWnxAkcaDMkWIigkz/ktf4CU6CtOX+9tKz574nE
	 Hz4xHzXPAMjIwuEkhb8SKsN/3809BnmWbMp4vxpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 230/567] net: sfp: re-implement ignoring the hardware TX_FAULT signal
Date: Mon, 23 Mar 2026 14:42:30 +0100
Message-ID: <20260323134539.524711093@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit e184e8609f8c1cd9fef703f667245b6ebd89c2ed ]

Re-implement how we ignore the hardware TX_FAULT signal. Rather than
having a separate boolean for this, use a bitmask of the hardware
signals that we wish to ignore. This gives more flexibility in the
future to ignore other signals such as RX_LOS.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Tested-by: Christian Marangi <ansuelsmth@gmail.com>
Link: https://lore.kernel.org/r/E1qnfXc-008UDY-91@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 87d126852158 ("net: sfp: improve Huawei MA5671a fixup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index ff438be4c186e..5d1456e1449fb 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -257,6 +257,7 @@ struct sfp {
 	unsigned int state_hw_drive;
 	unsigned int state_hw_mask;
 	unsigned int state_soft_mask;
+	unsigned int state_ignore_mask;
 	unsigned int state;
 
 	struct delayed_work poll;
@@ -280,7 +281,6 @@ struct sfp {
 	unsigned int rs_state_mask;
 
 	bool have_a2;
-	bool tx_fault_ignore;
 
 	const struct sfp_quirk *quirk;
 
@@ -347,7 +347,7 @@ static void sfp_fixup_long_startup(struct sfp *sfp)
 
 static void sfp_fixup_ignore_tx_fault(struct sfp *sfp)
 {
-	sfp->tx_fault_ignore = true;
+	sfp->state_ignore_mask |= SFP_F_TX_FAULT;
 }
 
 // For 10GBASE-T short-reach modules
@@ -800,7 +800,8 @@ static void sfp_soft_start_poll(struct sfp *sfp)
 
 	mutex_lock(&sfp->st_mutex);
 	// Poll the soft state for hardware pins we want to ignore
-	sfp->state_soft_mask = ~sfp->state_hw_mask & mask;
+	sfp->state_soft_mask = ~sfp->state_hw_mask & ~sfp->state_ignore_mask &
+			       mask;
 
 	if (sfp->state_soft_mask & (SFP_F_LOS | SFP_F_TX_FAULT) &&
 	    !sfp->need_poll)
@@ -2325,7 +2326,7 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 	sfp->module_t_start_up = T_START_UP;
 	sfp->module_t_wait = T_WAIT;
 
-	sfp->tx_fault_ignore = false;
+	sfp->state_ignore_mask = 0;
 
 	if (sfp->id.base.extended_cc == SFF8024_ECC_10GBASE_T_SFI ||
 	    sfp->id.base.extended_cc == SFF8024_ECC_10GBASE_T_SR ||
@@ -2348,6 +2349,8 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 
 	if (sfp->quirk && sfp->quirk->fixup)
 		sfp->quirk->fixup(sfp);
+
+	sfp->state_hw_mask &= ~sfp->state_ignore_mask;
 	mutex_unlock(&sfp->st_mutex);
 
 	return 0;
@@ -2848,10 +2851,7 @@ static void sfp_check_state(struct sfp *sfp)
 	mutex_lock(&sfp->st_mutex);
 	state = sfp_get_state(sfp);
 	changed = state ^ sfp->state;
-	if (sfp->tx_fault_ignore)
-		changed &= SFP_F_PRESENT | SFP_F_LOS;
-	else
-		changed &= SFP_F_PRESENT | SFP_F_LOS | SFP_F_TX_FAULT;
+	changed &= SFP_F_PRESENT | SFP_F_LOS | SFP_F_TX_FAULT;
 
 	for (i = 0; i < GPIO_MAX; i++)
 		if (changed & BIT(i))
-- 
2.51.0



