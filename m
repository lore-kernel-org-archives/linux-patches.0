Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926AB21C187;
	Tue, 12 Aug 2025 19:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025655; cv=none; b=RKF34vs9Vi1Gmr2nJ9Je9alUPAgrLIzzni5qua7Cx8aQzJ8TniO5JV2hiRbl8pQtzw/PM5pRz00CV3nFU94IeT8liEIVL7Mu+QW3YlQ5sMpJE9q5HhkcqHqm1woOxtHLHUBDwZr0g+SWYmtv1885ukuSmGbPVsAImDNLUoDzE4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025655; c=relaxed/simple;
	bh=H9l/3bGjeZZVg/kd3rpl23mcP0YV4skb6PVzdksU/t0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YM0mT4stY8VzxoWDRz039LIJHyJRN9Xptmjax53IUHTCcJVGMDzSZoYFGC2ORClv7jNsRLyPJSnlgZ3H2NOZI5TBTHtJxbZHj1saH/JoKIUKYWw441W9iDpbdFzH3kI6+QE9vSP+ygz6AfeYnEXlIh5e2PuuM0eYHZVkinulpoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ab3WhQ3T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ab3WhQ3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C24C4CEF0;
	Tue, 12 Aug 2025 19:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025655;
	bh=H9l/3bGjeZZVg/kd3rpl23mcP0YV4skb6PVzdksU/t0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ab3WhQ3T1hIDnC88qJ7TEdQM+RrkA9txnXuTySTL5T9jFQtXc989ZA7V2VDhAd5x/
	 s94H2gP81gNvkp4s3BKyw2dFJ6QnNXX7LlEz86RwOb0K6uAfYxBV51IEC7gtE1cySn
	 bPYb4EU8LoLrQPBrcD7J/Vt8CJ90u2fWE6ui0orM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 105/480] netconsole: Only register console drivers when targets are configured
Date: Tue, 12 Aug 2025 19:45:13 +0200
Message-ID: <20250812174401.809630068@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit bc0cb64db1c765a81f69997d5a28f539e1731bc0 ]

The netconsole driver currently registers the basic console driver
unconditionally during initialization, even when only extended targets
are configured. This results in unnecessary console registration and
performance overhead, as the write_msg() callback is invoked for every
log message only to return early when no matching targets are found.

Optimize the driver by conditionally registering console drivers based
on the actual target configuration. The basic console driver is now
registered only when non-extended targets exist, same as the extended
console. The implementation also handles dynamic target creation through
the configfs interface.

This change eliminates unnecessary console driver registrations,
redundant write_msg() callbacks for unused console types, and associated
lock contention and target list iterations. The optimization is
particularly beneficial for systems using only the most common extended
console type.

Fixes: e2f15f9a79201 ("netconsole: implement extended console support")
Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20250609-netcons_ext-v3-1-5336fa670326@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netconsole.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index 176935a8645f..a35b1fd4337b 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -86,10 +86,10 @@ static DEFINE_SPINLOCK(target_list_lock);
 static DEFINE_MUTEX(target_cleanup_list_lock);
 
 /*
- * Console driver for extended netconsoles.  Registered on the first use to
- * avoid unnecessarily enabling ext message formatting.
+ * Console driver for netconsoles.  Register only consoles that have
+ * an associated target of the same type.
  */
-static struct console netconsole_ext;
+static struct console netconsole_ext, netconsole;
 
 struct netconsole_target_stats  {
 	u64_stats_t xmit_drop_count;
@@ -97,6 +97,11 @@ struct netconsole_target_stats  {
 	struct u64_stats_sync syncp;
 };
 
+enum console_type {
+	CONS_BASIC = BIT(0),
+	CONS_EXTENDED = BIT(1),
+};
+
 /* Features enabled in sysdata. Contrary to userdata, this data is populated by
  * the kernel. The fields are designed as bitwise flags, allowing multiple
  * features to be set in sysdata_fields.
@@ -491,6 +496,12 @@ static ssize_t enabled_store(struct config_item *item,
 		if (nt->extended && !console_is_registered(&netconsole_ext))
 			register_console(&netconsole_ext);
 
+		/* User might be enabling the basic format target for the very
+		 * first time, make sure the console is registered.
+		 */
+		if (!nt->extended && !console_is_registered(&netconsole))
+			register_console(&netconsole);
+
 		/*
 		 * Skip netpoll_parse_options() -- all the attributes are
 		 * already configured via configfs. Just print them out.
@@ -1690,8 +1701,8 @@ static int __init init_netconsole(void)
 {
 	int err;
 	struct netconsole_target *nt, *tmp;
+	u32 console_type_needed = 0;
 	unsigned int count = 0;
-	bool extended = false;
 	unsigned long flags;
 	char *target_config;
 	char *input = config;
@@ -1707,9 +1718,10 @@ static int __init init_netconsole(void)
 			}
 			/* Dump existing printks when we register */
 			if (nt->extended) {
-				extended = true;
+				console_type_needed |= CONS_EXTENDED;
 				netconsole_ext.flags |= CON_PRINTBUFFER;
 			} else {
+				console_type_needed |= CONS_BASIC;
 				netconsole.flags |= CON_PRINTBUFFER;
 			}
 
@@ -1728,9 +1740,10 @@ static int __init init_netconsole(void)
 	if (err)
 		goto undonotifier;
 
-	if (extended)
+	if (console_type_needed & CONS_EXTENDED)
 		register_console(&netconsole_ext);
-	register_console(&netconsole);
+	if (console_type_needed & CONS_BASIC)
+		register_console(&netconsole);
 	pr_info("network logging started\n");
 
 	return err;
@@ -1760,7 +1773,8 @@ static void __exit cleanup_netconsole(void)
 
 	if (console_is_registered(&netconsole_ext))
 		unregister_console(&netconsole_ext);
-	unregister_console(&netconsole);
+	if (console_is_registered(&netconsole))
+		unregister_console(&netconsole);
 	dynamic_netconsole_exit();
 	unregister_netdevice_notifier(&netconsole_netdev_notifier);
 
-- 
2.39.5



