Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F8E32B138;
	Tue, 16 Jun 2026 17:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630102; cv=none; b=Wm8nYqUpLWUZPJ/cGQ9gtmYw/CBOosE++NXGCMtPP5AuHyEMVfdVHQdN+lbMcwD4DZiwHrivROWCb9csHx3zUoVk5fH4SLtz5VihpiuxmXt/3qbrQdq2QrMSoinKHAw/rCteGqoVVHTnQAw7euYIl+l6LEDX/OZkCZvQW/KcJMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630102; c=relaxed/simple;
	bh=PKIdn1X+dqW66YFy5729Te1hmqKyHJ0CBgIIUIuuxSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YXP1RlZRpt/x5oF6O5nrVgMY+uUz7YMHKacNxFPJ9E3r8bcQy+jjkMfVtKwSTNdjpPMHGFtgF3Z72RWZTGSKG5S9QnmhBHzlb/VI/AYU3+12fY7hh3GPWRC5lYkR462nK9QOXohbWPu4n4ceFAw4myKbQWqpno7kOIUfkwr845M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lWi7BD7h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lWi7BD7h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B10E31F000E9;
	Tue, 16 Jun 2026 17:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630100;
	bh=Tg/0+AsdXBgilY5m0VrmmvoHtgKT2uWpg6CiMbKwtMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lWi7BD7hrVb/KCmFx7Vsk/I0568B9YzF19n9NeSsqjcCI5oHyUcFkIqwwf9APinZp
	 gkvxPiRBQe3M99yRZey3XCFfgMw31FD3KRFKFNpWdYqGdn+15llwcSwfa2qER7F4ks
	 +dNPgzr+PilIsUrvlNM4IfWuHembZcx7JeyPOKds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Mat Martineau <martineau@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 378/452] genetlink: Use internal flags for multicast groups
Date: Tue, 16 Jun 2026 20:30:05 +0530
Message-ID: <20260616145136.828999549@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit cd4d7263d58ab98fd4dee876776e4da6c328faa3 ]

As explained in commit e03781879a0d ("drop_monitor: Require
'CAP_SYS_ADMIN' when joining "events" group"), the "flags" field in the
multicast group structure reuses uAPI flags despite the field not being
exposed to user space. This makes it impossible to extend its use
without adding new uAPI flags, which is inappropriate for internal
kernel checks.

Solve this by adding internal flags (i.e., "GENL_MCAST_*") and convert
the existing users to use them instead of the uAPI flags.

Tested using the reproducers in commit 44ec98ea5ea9 ("psample: Require
'CAP_NET_ADMIN' when joining "packets" group") and commit e03781879a0d
("drop_monitor: Require 'CAP_SYS_ADMIN' when joining "events" group").

No functional changes intended.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: d1ebfce2c1d1 ("smb: client: require net admin for CIFS SWN netlink")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/genetlink.h |    9 ++++++---
 net/core/drop_monitor.c |    2 +-
 net/mptcp/pm_netlink.c  |    2 +-
 net/netlink/genetlink.c |    4 ++--
 net/psample/psample.c   |    2 +-
 5 files changed, 11 insertions(+), 8 deletions(-)

--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -8,16 +8,19 @@
 
 #define GENLMSG_DEFAULT_SIZE (NLMSG_DEFAULT_SIZE - GENL_HDRLEN)
 
+/* Binding to multicast group requires %CAP_NET_ADMIN */
+#define GENL_MCAST_CAP_NET_ADMIN	BIT(0)
+/* Binding to multicast group requires %CAP_SYS_ADMIN */
+#define GENL_MCAST_CAP_SYS_ADMIN	BIT(1)
+
 /**
  * struct genl_multicast_group - generic netlink multicast group
  * @name: name of the multicast group, names are per-family
- * @flags: GENL_* flags (%GENL_ADMIN_PERM or %GENL_UNS_ADMIN_PERM)
- * @cap_sys_admin: whether %CAP_SYS_ADMIN is required for binding
+ * @flags: GENL_MCAST_* flags
  */
 struct genl_multicast_group {
 	char			name[GENL_NAMSIZ];
 	u8			flags;
-	u8			cap_sys_admin:1;
 };
 
 struct genl_split_ops;
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -183,7 +183,7 @@ out:
 }
 
 static const struct genl_multicast_group dropmon_mcgrps[] = {
-	{ .name = "events", .cap_sys_admin = 1 },
+	{ .name = "events", .flags = GENL_MCAST_CAP_SYS_ADMIN, },
 };
 
 static void send_dm_alert(struct work_struct *work)
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1328,7 +1328,7 @@ bool mptcp_pm_nl_is_backup(struct mptcp_
 static const struct genl_multicast_group mptcp_pm_mcgrps[] = {
 	[MPTCP_PM_CMD_GRP_OFFSET]	= { .name = MPTCP_PM_CMD_GRP_NAME, },
 	[MPTCP_PM_EV_GRP_OFFSET]        = { .name = MPTCP_PM_EV_GRP_NAME,
-					    .flags = GENL_UNS_ADMIN_PERM,
+					    .flags = GENL_MCAST_CAP_NET_ADMIN,
 					  },
 };
 
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1683,10 +1683,10 @@ static int genl_bind(struct net *net, in
 			continue;
 
 		grp = &family->mcgrps[i];
-		if ((grp->flags & GENL_UNS_ADMIN_PERM) &&
+		if ((grp->flags & GENL_MCAST_CAP_NET_ADMIN) &&
 		    !ns_capable(net->user_ns, CAP_NET_ADMIN))
 			ret = -EPERM;
-		if (grp->cap_sys_admin &&
+		if ((grp->flags & GENL_MCAST_CAP_SYS_ADMIN) &&
 		    !ns_capable(net->user_ns, CAP_SYS_ADMIN))
 			ret = -EPERM;
 
--- a/net/psample/psample.c
+++ b/net/psample/psample.c
@@ -32,7 +32,7 @@ enum psample_nl_multicast_groups {
 static const struct genl_multicast_group psample_nl_mcgrps[] = {
 	[PSAMPLE_NL_MCGRP_CONFIG] = { .name = PSAMPLE_NL_MCGRP_CONFIG_NAME },
 	[PSAMPLE_NL_MCGRP_SAMPLE] = { .name = PSAMPLE_NL_MCGRP_SAMPLE_NAME,
-				      .flags = GENL_UNS_ADMIN_PERM },
+				      .flags = GENL_MCAST_CAP_NET_ADMIN, },
 };
 
 static struct genl_family psample_nl_family __ro_after_init;


