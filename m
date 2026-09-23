Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3723F53A39F;
	Wed, 23 Sep 2026 14:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174527; cv=none; b=U4I0hAGnqv69XUjn3RpV8viVMOiY771q0KwjfJ9N2YFvkvNFQjdFLsRtHSE9D76VV8KoJ9IxqGGUqHbfecEoMqMEK8nJh+8Hy9SLMwpGJPj8Y5AZU4WJ7eLsk/oTi3F4SrkaChE9XXGziXZq75qtixiIHoXf+X3O2TKCtzH3ong=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174527; c=relaxed/simple;
	bh=gXiEnzh90+usk3tOHxnMYiUJ7CYSxA6OqOKCEyLNybk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L5ZOKhfrqtYO5wCSGpn9go/hTDeyzZATUjWamLUXqSz2XHTXNo21NRGspzhUh/zXGXNAfexgPoSfrG5nfoIlD6a1dDYJa7rcN/XBE+yCjhaHQTF2V6O+39nScgMGYzlkXmMhcnrJmpY3p67wu4dfcLAGzqJ2BUAHs6V7ZsNnkaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vwql9MRg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vwql9MRg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523611F000FF;
	Wed, 23 Sep 2026 14:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174525;
	bh=fxeW3wG9WSk3vBsuzJhr9IJ9ujxe05IApIz8IJ3VQA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vwql9MRgESlcBuJHGuvxXpZqIhwYgZ86WtSQ/jze1/SePNjRf9/Jb1lSLTpMMMLts
	 B3c5QeaiHEwS0FeV/r601ZVq9Puc1rmxogc3FxUVt2qLKcNKCbFHbKAxCsii0P8dEG
	 CqSYmDBlYO56UtpLzxs9DBQp/UVi1if60sMRoQ8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 100/398] neighbour: Enforce min/max to NDTPA_INTERVAL_PROBE_TIME_MS.
Date: Wed, 23 Sep 2026 16:02:54 +0200
Message-ID: <20260923140646.029010975@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 6d79b223ec44ada58ad37db42f539b60985a7722 ]

NDTPA_INTERVAL_PROBE_TIME_MS sets .type and .min but misses
.validation_type, so no validation is applied:

  # ynl --family rt-neigh --do setneightbl \
  --json '{"name": "arp_cache", "parms": {"interval-probe-time-ms": 0}}'

  # ynl --family rt-neigh --dump getneightbl --output-json | \
  jq '.[] | select(.name == "arp_cache" and has("config"))
          | .parms["interval-probe-time-ms"]'
  0

Moreover, nla_get_msecs() uses msecs_to_jiffies(), and u64 is
silently cast to u32, so a larger value can bypass the min check:

  e.g. 4294967296 == 0x100000000

  # ynl --family rt-neigh --do setneightbl \
  --json '{"name": "arp_cache", "parms": {"interval-probe-time-ms": 4294967296}}'

  # ynl --family rt-neigh --dump getneightbl --output-json | \
  jq '.[] | select(.name == "arp_cache" and has("config"))
          | .parms["interval-probe-time-ms"]'
  0

msecs_to_jiffies() returns MAX_JIFFY_OFFSET if the value is
larger than INT_MAX.  Also, INT_MAX ms overflows int NEIGH_VAR()
when HZ > 1000 (Alpha, MIPS), and passing a negative integer to
queue_delayed_work(unsigned long delay) causes sign extension,
which wraps around the expiry time to the past, resulting in it
being handled as 0 delay in the timer wheel.

Let's use NLA_POLICY_FULL_RANGE() and limit the max to 1 day.

The same max check is applied to sysctl as well.

Note that this controls the probe interval for NTF_MANAGED
entries, so the max of 1 day is unlikely to break any
deployments.

Fixes: 211da42eaa45 ("net, neigh: introduce interval_probe_time_ms for periodic probe")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260909233143.2401847-3-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/rt-neigh.yaml |  3 +++
 Documentation/networking/ip-sysctl.rst    |  2 +-
 net/core/neighbour.c                      | 17 +++++++++++++----
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/Documentation/netlink/specs/rt-neigh.yaml b/Documentation/netlink/specs/rt-neigh.yaml
index 2f568a6231c93..e366e958234e4 100644
--- a/Documentation/netlink/specs/rt-neigh.yaml
+++ b/Documentation/netlink/specs/rt-neigh.yaml
@@ -341,6 +341,9 @@ attribute-sets:
       -
         name: interval-probe-time-ms
         type: u64
+        checks:
+          min: 1
+          max: 86400000
 
 operations:
   enum-model: directional
diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 7a637e87005fe..e13131770fa0c 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -230,7 +230,7 @@ neigh/default/unres_qlen - INTEGER
 
 neigh/default/interval_probe_time_ms - INTEGER
 	The probe interval for neighbor entries with NTF_MANAGED flag,
-	the min value is 1.
+	the min value is 1, and the max value is 86400000 (1 day).
 
 	Default: 5000
 
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index dabd368eaa4e7..4c018170edfeb 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2353,6 +2353,13 @@ static const struct nla_policy nl_neightbl_policy[NDTA_MAX+1] = {
 	[NDTA_PARMS]		= { .type = NLA_NESTED },
 };
 
+#define NTBL_PARM_MS_MAX	(24 * 60 * 60 * MSEC_PER_SEC)
+
+static const struct netlink_range_validation nl_ntbl_parm_ms_range = {
+	.min = 1,
+	.max = NTBL_PARM_MS_MAX,
+};
+
 static const struct nla_policy nl_ntbl_parm_policy[NDTPA_MAX+1] = {
 	[NDTPA_IFINDEX]			= { .type = NLA_U32 },
 	[NDTPA_QUEUE_LEN]		= { .type = NLA_U32 },
@@ -2369,7 +2376,8 @@ static const struct nla_policy nl_ntbl_parm_policy[NDTPA_MAX+1] = {
 	[NDTPA_ANYCAST_DELAY]		= { .type = NLA_U64 },
 	[NDTPA_PROXY_DELAY]		= { .type = NLA_U64 },
 	[NDTPA_LOCKTIME]		= { .type = NLA_U64 },
-	[NDTPA_INTERVAL_PROBE_TIME_MS]	= { .type = NLA_U64, .min = 1 },
+	[NDTPA_INTERVAL_PROBE_TIME_MS]	= NLA_POLICY_FULL_RANGE(NLA_U64,
+								&nl_ntbl_parm_ms_range),
 };
 
 static int neightbl_set(struct sk_buff *skb, struct nlmsghdr *nlh,
@@ -3641,12 +3649,13 @@ static int neigh_proc_dointvec_ms_jiffies_positive(const struct ctl_table *ctl,
 						   void *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table tmp = *ctl;
-	int ret;
+	int ret, min, max;
 
-	int min = msecs_to_jiffies(1);
+	min = msecs_to_jiffies(1);
+	max = msecs_to_jiffies(NTBL_PARM_MS_MAX);
 
 	tmp.extra1 = &min;
-	tmp.extra2 = NULL;
+	tmp.extra2 = &max;
 
 	ret = proc_dointvec_ms_jiffies_minmax(&tmp, write, buffer, lenp, ppos);
 	neigh_proc_update(ctl, write);
-- 
2.53.0



