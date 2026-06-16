Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E9D257827;
	Tue, 16 Jun 2026 17:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632552; cv=none; b=eF0SOt5s970USkoR1uIe1bcVsgEptFLMEJo4JaN7+lPRf7UlpDsDftceaOt8HLHHyilBy0FQuml/mOKRz1jNU45SSFV/b2cdfLa7Ung/Ga9h50Mld109xZFI9Xl5IJx9x7q5tzIpbeX8LXnX9E580TWq2wbGh4hxSugWiaPLumw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632552; c=relaxed/simple;
	bh=+AFzyfZVXTXui6/chBu/Wp59NSAKHyXiTfXlG7HSlRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbQ0cRZtiubH7cqxjWy5siXMMoFH4KotIbkgzDBv8fggmW+K4NfjYBCnM0ImcOZUSl2KaOnrmb93tdo3BKIjQQlVq14gcH2CpH1t+iKk5RBE2QfDMsZVxwl71selC3aXSWxO4rA7waKqV5nOBsIfhjwrmH4QCMzcaQ+eBraouHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VFpXL9db; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VFpXL9db"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A851F000E9;
	Tue, 16 Jun 2026 17:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632550;
	bh=W5RPdIwidTNQzlihX+V0RFdEaS4Kn3OvMrJ31i22Vo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VFpXL9dbEBECYqjkQekF19gqbmsKtOgAcIBJxQ24Gz9Fjtm5gPYFpoJHSxu3Eeyt9
	 ktPdyUnAf2Uya0bn8IA5g9NH6cOnz+l+qX1wXkVeKyVZxVOSixPKfuRVinbjNeo6cV
	 EDgypP5ZXOtNdr/aQ5hC9ZUyPFdtzpCNJxyGt/Wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Mat Martineau <martineau@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 432/522] genetlink: Use internal flags for multicast groups
Date: Tue, 16 Jun 2026 20:29:39 +0530
Message-ID: <20260616145146.176350677@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 
 struct genl_ops;
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -181,7 +181,7 @@ out:
 }
 
 static const struct genl_multicast_group dropmon_mcgrps[] = {
-	{ .name = "events", .cap_sys_admin = 1 },
+	{ .name = "events", .flags = GENL_MCAST_CAP_SYS_ADMIN, },
 };
 
 static void send_dm_alert(struct work_struct *work)
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1313,7 +1313,7 @@ bool mptcp_pm_nl_is_backup(struct mptcp_
 static const struct genl_multicast_group mptcp_pm_mcgrps[] = {
 	[MPTCP_PM_CMD_GRP_OFFSET]	= { .name = MPTCP_PM_CMD_GRP_NAME, },
 	[MPTCP_PM_EV_GRP_OFFSET]        = { .name = MPTCP_PM_EV_GRP_NAME,
-					    .flags = GENL_UNS_ADMIN_PERM,
+					    .flags = GENL_MCAST_CAP_NET_ADMIN,
 					  },
 };
 
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1431,10 +1431,10 @@ static int genl_bind(struct net *net, in
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


