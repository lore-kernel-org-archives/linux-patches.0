Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F090614A4E6;
	Tue, 20 Feb 2024 21:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464554; cv=none; b=A3oifos/HMrgTdtqeB6EHJ8obWtzfrwtFknkz+e0E2fwKfj2X4LkdA8rugabkLKZINi9oxVuhzSCE+QTbt4tLbQ/d0tQcSRlqWX4ECUNmdGQU1hmArKlOeZn1oITBv/onRdVksgWnXDxy21c2z1oAUIUE85r4lY9UCnCm3vjO98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464554; c=relaxed/simple;
	bh=HZ3X7Qel492Q9R/R7BDASir41sgLe0tM2/FukQuR1Q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rI0L7islW/+Cn3bMA2kUM9r/zasWb6PFgZHOVNDDw0CHQpY8Om4KDPokrNp0UAwlEFJCTfMuLpfrvJqPdhqRa9FSb6UG2S1ZSCdA/Ns9BLmqVKB3ZMLqlHU4ilcT/s9clBxfMOso59Nx/SBcFGsatfcBurM19g4SnPyXL0RJWhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TLjOyLy3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TLjOyLy3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CA8C433F1;
	Tue, 20 Feb 2024 21:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464553;
	bh=HZ3X7Qel492Q9R/R7BDASir41sgLe0tM2/FukQuR1Q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TLjOyLy35AqjlTqnDo5wnvecnsfADYGQgsTQuAMriPacKMbUEdhFeT7mok85xo7g/
	 TmGcLEkpO7QVi3/YcmqIE1DLMD0YaZ9CyvJR78awohl/9iVVLZbRXjjWW5Qz8Smlsq
	 Wm0KKkJeM2E3G7L0y6EOKxfA40/wvBWIrucAR9TU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 030/309] dpll: fix possible deadlock during netlink dump operation
Date: Tue, 20 Feb 2024 21:53:09 +0100
Message-ID: <20240220205634.129360261@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Pirko <jiri@nvidia.com>

[ Upstream commit 53c0441dd2c44ee93fddb5473885fd41e4bc2361 ]

Recently, I've been hitting following deadlock warning during dpll pin
dump:

[52804.637962] ======================================================
[52804.638536] WARNING: possible circular locking dependency detected
[52804.639111] 6.8.0-rc2jiri+ #1 Not tainted
[52804.639529] ------------------------------------------------------
[52804.640104] python3/2984 is trying to acquire lock:
[52804.640581] ffff88810e642678 (nlk_cb_mutex-GENERIC){+.+.}-{3:3}, at: netlink_dump+0xb3/0x780
[52804.641417]
               but task is already holding lock:
[52804.642010] ffffffff83bde4c8 (dpll_lock){+.+.}-{3:3}, at: dpll_lock_dumpit+0x13/0x20
[52804.642747]
               which lock already depends on the new lock.

[52804.643551]
               the existing dependency chain (in reverse order) is:
[52804.644259]
               -> #1 (dpll_lock){+.+.}-{3:3}:
[52804.644836]        lock_acquire+0x174/0x3e0
[52804.645271]        __mutex_lock+0x119/0x1150
[52804.645723]        dpll_lock_dumpit+0x13/0x20
[52804.646169]        genl_start+0x266/0x320
[52804.646578]        __netlink_dump_start+0x321/0x450
[52804.647056]        genl_family_rcv_msg_dumpit+0x155/0x1e0
[52804.647575]        genl_rcv_msg+0x1ed/0x3b0
[52804.648001]        netlink_rcv_skb+0xdc/0x210
[52804.648440]        genl_rcv+0x24/0x40
[52804.648831]        netlink_unicast+0x2f1/0x490
[52804.649290]        netlink_sendmsg+0x36d/0x660
[52804.649742]        __sock_sendmsg+0x73/0xc0
[52804.650165]        __sys_sendto+0x184/0x210
[52804.650597]        __x64_sys_sendto+0x72/0x80
[52804.651045]        do_syscall_64+0x6f/0x140
[52804.651474]        entry_SYSCALL_64_after_hwframe+0x46/0x4e
[52804.652001]
               -> #0 (nlk_cb_mutex-GENERIC){+.+.}-{3:3}:
[52804.652650]        check_prev_add+0x1ae/0x1280
[52804.653107]        __lock_acquire+0x1ed3/0x29a0
[52804.653559]        lock_acquire+0x174/0x3e0
[52804.653984]        __mutex_lock+0x119/0x1150
[52804.654423]        netlink_dump+0xb3/0x780
[52804.654845]        __netlink_dump_start+0x389/0x450
[52804.655321]        genl_family_rcv_msg_dumpit+0x155/0x1e0
[52804.655842]        genl_rcv_msg+0x1ed/0x3b0
[52804.656272]        netlink_rcv_skb+0xdc/0x210
[52804.656721]        genl_rcv+0x24/0x40
[52804.657119]        netlink_unicast+0x2f1/0x490
[52804.657570]        netlink_sendmsg+0x36d/0x660
[52804.658022]        __sock_sendmsg+0x73/0xc0
[52804.658450]        __sys_sendto+0x184/0x210
[52804.658877]        __x64_sys_sendto+0x72/0x80
[52804.659322]        do_syscall_64+0x6f/0x140
[52804.659752]        entry_SYSCALL_64_after_hwframe+0x46/0x4e
[52804.660281]
               other info that might help us debug this:

[52804.661077]  Possible unsafe locking scenario:

[52804.661671]        CPU0                    CPU1
[52804.662129]        ----                    ----
[52804.662577]   lock(dpll_lock);
[52804.662924]                                lock(nlk_cb_mutex-GENERIC);
[52804.663538]                                lock(dpll_lock);
[52804.664073]   lock(nlk_cb_mutex-GENERIC);
[52804.664490]

The issue as follows: __netlink_dump_start() calls control->start(cb)
with nlk->cb_mutex held. In control->start(cb) the dpll_lock is taken.
Then nlk->cb_mutex is released and taken again in netlink_dump(), while
dpll_lock still being held. That leads to ABBA deadlock when another
CPU races with the same operation.

Fix this by moving dpll_lock taking into dumpit() callback which ensures
correct lock taking order.

Fixes: 9d71b54b65b1 ("dpll: netlink: Add DPLL framework base functions")
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Link: https://lore.kernel.org/r/20240207115902.371649-1-jiri@resnulli.us
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/dpll.yaml |  4 ----
 drivers/dpll/dpll_netlink.c           | 20 ++++++--------------
 drivers/dpll/dpll_nl.c                |  4 ----
 drivers/dpll/dpll_nl.h                |  2 --
 4 files changed, 6 insertions(+), 24 deletions(-)

diff --git a/Documentation/netlink/specs/dpll.yaml b/Documentation/netlink/specs/dpll.yaml
index cf8abe1c0550..2b4c4bcd8361 100644
--- a/Documentation/netlink/specs/dpll.yaml
+++ b/Documentation/netlink/specs/dpll.yaml
@@ -374,8 +374,6 @@ operations:
             - type
 
       dump:
-        pre: dpll-lock-dumpit
-        post: dpll-unlock-dumpit
         reply: *dev-attrs
 
     -
@@ -462,8 +460,6 @@ operations:
             - phase-adjust
 
       dump:
-        pre: dpll-lock-dumpit
-        post: dpll-unlock-dumpit
         request:
           attributes:
             - id
diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
index 7cc99d627942..c8c2e836193a 100644
--- a/drivers/dpll/dpll_netlink.c
+++ b/drivers/dpll/dpll_netlink.c
@@ -1171,6 +1171,7 @@ int dpll_nl_pin_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 	unsigned long i;
 	int ret = 0;
 
+	mutex_lock(&dpll_lock);
 	xa_for_each_marked_start(&dpll_pin_xa, i, pin, DPLL_REGISTERED,
 				 ctx->idx) {
 		if (!dpll_pin_available(pin))
@@ -1190,6 +1191,8 @@ int dpll_nl_pin_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 		}
 		genlmsg_end(skb, hdr);
 	}
+	mutex_unlock(&dpll_lock);
+
 	if (ret == -EMSGSIZE) {
 		ctx->idx = i;
 		return skb->len;
@@ -1345,6 +1348,7 @@ int dpll_nl_device_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 	unsigned long i;
 	int ret = 0;
 
+	mutex_lock(&dpll_lock);
 	xa_for_each_marked_start(&dpll_device_xa, i, dpll, DPLL_REGISTERED,
 				 ctx->idx) {
 		hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid,
@@ -1361,6 +1365,8 @@ int dpll_nl_device_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 		}
 		genlmsg_end(skb, hdr);
 	}
+	mutex_unlock(&dpll_lock);
+
 	if (ret == -EMSGSIZE) {
 		ctx->idx = i;
 		return skb->len;
@@ -1411,20 +1417,6 @@ dpll_unlock_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
 	mutex_unlock(&dpll_lock);
 }
 
-int dpll_lock_dumpit(struct netlink_callback *cb)
-{
-	mutex_lock(&dpll_lock);
-
-	return 0;
-}
-
-int dpll_unlock_dumpit(struct netlink_callback *cb)
-{
-	mutex_unlock(&dpll_lock);
-
-	return 0;
-}
-
 int dpll_pin_pre_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
 		      struct genl_info *info)
 {
diff --git a/drivers/dpll/dpll_nl.c b/drivers/dpll/dpll_nl.c
index eaee5be7aa64..1e95f5397cfc 100644
--- a/drivers/dpll/dpll_nl.c
+++ b/drivers/dpll/dpll_nl.c
@@ -95,9 +95,7 @@ static const struct genl_split_ops dpll_nl_ops[] = {
 	},
 	{
 		.cmd	= DPLL_CMD_DEVICE_GET,
-		.start	= dpll_lock_dumpit,
 		.dumpit	= dpll_nl_device_get_dumpit,
-		.done	= dpll_unlock_dumpit,
 		.flags	= GENL_ADMIN_PERM | GENL_CMD_CAP_DUMP,
 	},
 	{
@@ -129,9 +127,7 @@ static const struct genl_split_ops dpll_nl_ops[] = {
 	},
 	{
 		.cmd		= DPLL_CMD_PIN_GET,
-		.start		= dpll_lock_dumpit,
 		.dumpit		= dpll_nl_pin_get_dumpit,
-		.done		= dpll_unlock_dumpit,
 		.policy		= dpll_pin_get_dump_nl_policy,
 		.maxattr	= DPLL_A_PIN_ID,
 		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DUMP,
diff --git a/drivers/dpll/dpll_nl.h b/drivers/dpll/dpll_nl.h
index 92d4c9c4f788..f491262bee4f 100644
--- a/drivers/dpll/dpll_nl.h
+++ b/drivers/dpll/dpll_nl.h
@@ -30,8 +30,6 @@ dpll_post_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
 void
 dpll_pin_post_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
 		   struct genl_info *info);
-int dpll_lock_dumpit(struct netlink_callback *cb);
-int dpll_unlock_dumpit(struct netlink_callback *cb);
 
 int dpll_nl_device_id_get_doit(struct sk_buff *skb, struct genl_info *info);
 int dpll_nl_device_get_doit(struct sk_buff *skb, struct genl_info *info);
-- 
2.43.0



