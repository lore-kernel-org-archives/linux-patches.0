Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34EB8282E1;
	Tue, 12 Aug 2025 18:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021742; cv=none; b=XK0lHJscPfvqK1u531jEyGfIEXtU+9iBc+ao1TgKMDPr5HmvYnXz0SdMwOiC07ZUwP4BNgugOeKix+8Fe/zPrcDqIUPq71JRjI9k2JVstMCsf324ddBLqFqNosaWugv5MztkzKOaxdmqTTA7HyvNThl4v1grjDvoc7t2I1OIZ7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021742; c=relaxed/simple;
	bh=FH4r/zxnW7htRwxV+XJJzLt9WOozqFqQb5gZbY2JLMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Skh9/OP9ueg8Xk6/CRkRdxmankkZVXoyukUjLmCyDWTDPRreWvbruhIkMGreoWWCJgd+gKYrBdviK1Kx0wU/QNcxtn3yR+s2j0uzD3eCV0rOEX2NviPoQQuxfFXAVFiPJ6ciudKqX25qDx/dnl6wrWTlMUG4SpBFnGkMgijkL0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ax8fRECW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ax8fRECW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7EFC4CEF0;
	Tue, 12 Aug 2025 18:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021741;
	bh=FH4r/zxnW7htRwxV+XJJzLt9WOozqFqQb5gZbY2JLMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ax8fRECWynSnixht3pAWR9YWAjZsSDTBA1hJ6dJkKgSkWrAyR0/p8KNJX1h0hwstI
	 W5gKfXdSLOVRoz8/GjGJUCp0JECNQKlasKx26dOScebp7qdxKgLv4mZ8MYnWYS/b3P
	 mImCEcmPxoldz4MmOp8twE6ztC4NXxHd8CJ91jw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+398e1ee4ca2cac05fddb@syzkaller.appspotmail.com,
	Takamitsu Iwai <takamitz@amazon.co.jp>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 211/262] net/sched: taprio: enforce minimum value for picos_per_byte
Date: Tue, 12 Aug 2025 19:29:59 +0200
Message-ID: <20250812173002.135423107@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d162e2dd8602..a01d17d03bf5 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -41,6 +41,11 @@ static struct static_key_false taprio_have_working_mqprio;
 #define TXTIME_ASSIST_IS_ENABLED(flags) ((flags) & TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST)
 #define FULL_OFFLOAD_IS_ENABLED(flags) ((flags) & TCA_TAPRIO_ATTR_FLAG_FULL_OFFLOAD)
 #define TAPRIO_FLAGS_INVALID U32_MAX
+/* Minimum value for picos_per_byte to ensure non-zero duration
+ * for minimum-sized Ethernet frames (ETH_ZLEN = 60).
+ * 60 * 17 > PSEC_PER_NSEC (1000)
+ */
+#define TAPRIO_PICOS_PER_BYTE_MIN 17
 
 struct sched_entry {
 	/* Durations between this GCL entry and the GCL entry where the
@@ -1294,7 +1299,8 @@ static void taprio_start_sched(struct Qdisc *sch,
 }
 
 static void taprio_set_picos_per_byte(struct net_device *dev,
-				      struct taprio_sched *q)
+				      struct taprio_sched *q,
+				      struct netlink_ext_ack *extack)
 {
 	struct ethtool_link_ksettings ecmd;
 	int speed = SPEED_10;
@@ -1310,6 +1316,15 @@ static void taprio_set_picos_per_byte(struct net_device *dev,
 
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
@@ -1334,7 +1349,7 @@ static int taprio_dev_notifier(struct notifier_block *nb, unsigned long event,
 		if (dev != qdisc_dev(q->root))
 			continue;
 
-		taprio_set_picos_per_byte(dev, q);
+		taprio_set_picos_per_byte(dev, q, NULL);
 
 		stab = rtnl_dereference(q->root->stab);
 
@@ -1871,7 +1886,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	q->flags = err;
 
 	/* Needed for length_to_duration() during netlink attribute parsing */
-	taprio_set_picos_per_byte(dev, q);
+	taprio_set_picos_per_byte(dev, q, extack);
 
 	err = taprio_parse_mqprio_opt(dev, mqprio, extack, q->flags);
 	if (err < 0)
-- 
2.39.5



