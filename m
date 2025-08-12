Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20E92D2391;
	Tue, 12 Aug 2025 19:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026717; cv=none; b=Y7JVOi5ll51XrSy1HkhI4OMh4miExV27bgsC0XM1xRIWOi31T0zPsl8zCQHqcm5NArT6J0HmPTcX09mziweqazZbM5HHhondBoE6L0kbtqJqIOuMHLQxChKrYxkYskAlDC9kYqygn+E9Tvl8XK2WV5LUPFTvR9QOCZTphwx5ipg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026717; c=relaxed/simple;
	bh=wtnG3s0vWX67ME73ZO/W+S5aP0F+u9WDDxxqLxYckY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HpZoTUkUg01zl+WLpNS5wOQYbGO5YwPVBxWpmCq8nNbeQFJdHb0E72GUfnlmgMZrv8SPuoewp2rpjBg2ZiUjfqcTFqAUnyISJ2s/ncAaHSbivzVyHcZo4T+MEsWorOWJhD6FbQhof+fvzqGL3y7vVVdeCYvUASiOzLD9VMiu7D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AuDWMTVz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AuDWMTVz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6026CC4CEF0;
	Tue, 12 Aug 2025 19:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026716;
	bh=wtnG3s0vWX67ME73ZO/W+S5aP0F+u9WDDxxqLxYckY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AuDWMTVzeH2MLNwxrpBvLJZtzfQApWYAfJZ+Kb/G/YYKtbXjSnv3PB4lgIOWeaoHZ
	 FAXOuWrcpVBnILklQjM0e7id9BxBdoomeAEiZFMJv9CQ1H6KnUG62Cubt35KMaEJz/
	 CxOtCw2IdrNomUugkKsUmanOGceaClCCH98kj6ZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+398e1ee4ca2cac05fddb@syzkaller.appspotmail.com,
	Takamitsu Iwai <takamitz@amazon.co.jp>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 402/480] net/sched: taprio: enforce minimum value for picos_per_byte
Date: Tue, 12 Aug 2025 19:50:10 +0200
Message-ID: <20250812174414.013078583@linuxfoundation.org>
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

From: Takamitsu Iwai <takamitz@amazon.co.jp>

[ Upstream commit ae8508b25def57982493c48694ef135973bfabe0 ]

Syzbot reported a WARNING in taprio_get_start_time().

When link speed is 470,589 or greater, q->picos_per_byte becomes too
small, causing length_to_duration(q, ETH_ZLEN) to return zero.

This zero value leads to validation failures in fill_sched_entry() and
parse_taprio_schedule(), allowing arbitrary values to be assigned to
entry->interval and cycle_time. As a result, sched->cycle can become zero.

Since SPEED_800000 is the largest defined speed in
include/uapi/linux/ethtool.h, this issue can occur in realistic scenarios.

To ensure length_to_duration() returns a non-zero value for minimum-sized
Ethernet frames (ETH_ZLEN = 60), picos_per_byte must be at least 17
(60 * 17 > PSEC_PER_NSEC which is 1000).

This patch enforces a minimum value of 17 for picos_per_byte when the
calculated value would be lower, and adds a warning message to inform
users that scheduling accuracy may be affected at very high link speeds.

Fixes: fb66df20a720 ("net/sched: taprio: extend minimum interval restriction to entire cycle too")
Reported-by: syzbot+398e1ee4ca2cac05fddb@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=398e1ee4ca2cac05fddb
Signed-off-by: Takamitsu Iwai <takamitz@amazon.co.jp>
Link: https://patch.msgid.link/20250728173149.45585-1-takamitz@amazon.co.jp
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_taprio.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 2b14c81a87e5..85d84f39e220 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -43,6 +43,11 @@ static struct static_key_false taprio_have_working_mqprio;
 #define TAPRIO_SUPPORTED_FLAGS \
 	(TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST | TCA_TAPRIO_ATTR_FLAG_FULL_OFFLOAD)
 #define TAPRIO_FLAGS_INVALID U32_MAX
+/* Minimum value for picos_per_byte to ensure non-zero duration
+ * for minimum-sized Ethernet frames (ETH_ZLEN = 60).
+ * 60 * 17 > PSEC_PER_NSEC (1000)
+ */
+#define TAPRIO_PICOS_PER_BYTE_MIN 17
 
 struct sched_entry {
 	/* Durations between this GCL entry and the GCL entry where the
@@ -1284,7 +1289,8 @@ static void taprio_start_sched(struct Qdisc *sch,
 }
 
 static void taprio_set_picos_per_byte(struct net_device *dev,
-				      struct taprio_sched *q)
+				      struct taprio_sched *q,
+				      struct netlink_ext_ack *extack)
 {
 	struct ethtool_link_ksettings ecmd;
 	int speed = SPEED_10;
@@ -1300,6 +1306,15 @@ static void taprio_set_picos_per_byte(struct net_device *dev,
 
 skip:
 	picos_per_byte = (USEC_PER_SEC * 8) / speed;
+	if (picos_per_byte < TAPRIO_PICOS_PER_BYTE_MIN) {
+		if (!extack)
+			pr_warn("Link speed %d is too high. Schedule may be inaccurate.\n",
+				speed);
+		NL_SET_ERR_MSG_FMT_MOD(extack,
+				       "Link speed %d is too high. Schedule may be inaccurate.",
+				       speed);
+		picos_per_byte = TAPRIO_PICOS_PER_BYTE_MIN;
+	}
 
 	atomic64_set(&q->picos_per_byte, picos_per_byte);
 	netdev_dbg(dev, "taprio: set %s's picos_per_byte to: %lld, linkspeed: %d\n",
@@ -1324,7 +1339,7 @@ static int taprio_dev_notifier(struct notifier_block *nb, unsigned long event,
 		if (dev != qdisc_dev(q->root))
 			continue;
 
-		taprio_set_picos_per_byte(dev, q);
+		taprio_set_picos_per_byte(dev, q, NULL);
 
 		stab = rtnl_dereference(q->root->stab);
 
@@ -1848,7 +1863,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	q->flags = taprio_flags;
 
 	/* Needed for length_to_duration() during netlink attribute parsing */
-	taprio_set_picos_per_byte(dev, q);
+	taprio_set_picos_per_byte(dev, q, extack);
 
 	err = taprio_parse_mqprio_opt(dev, mqprio, extack, q->flags);
 	if (err < 0)
-- 
2.39.5



