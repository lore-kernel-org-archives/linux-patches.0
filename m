Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA1C4F212;
	Mon, 11 Dec 2023 18:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LXNbo6Cz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6783C433C8;
	Mon, 11 Dec 2023 18:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702318932;
	bh=CnHNX5J823QljD9IiWuOSWKG/OGjMN8XyZBpzSL+48E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LXNbo6CzdE3o0yaw4OiS8kzHTMn3p/GweRDkWCzqDeNm1hxwyGl6HLxQ2O2BjA1z1
	 AuSKPf5sxqL5WEyPC8HBL8U9woV3g1//LH8kLSOWYQWu8XFWiY9ax2Qczdb0qBe10F
	 UvrC/sZCEuQOGylFjCd4c4+2vg+ZADsjM8q34Okg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH 4.14 23/25] genetlink: add CAP_NET_ADMIN test for multicast bind
Date: Mon, 11 Dec 2023 19:21:14 +0100
Message-ID: <20231211182009.541366657@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182008.665944227@linuxfoundation.org>
References: <20231211182008.665944227@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

This is a partial backport of upstream commit 4d54cc32112d ("mptcp:
avoid lock_fast usage in accept path"). It is only a partial backport
because the patch in the link below was erroneously squash-merged into
upstream commit 4d54cc32112d ("mptcp: avoid lock_fast usage in accept
path"). Below is the original patch description from Florian Westphal:

"
genetlink sets NL_CFG_F_NONROOT_RECV for its netlink socket so anyone can
subscribe to multicast messages.

rtnetlink doesn't allow this unconditionally,  rtnetlink_bind() restricts
bind requests to CAP_NET_ADMIN for a few groups.

This allows to set GENL_UNS_ADMIN_PERM flag on genl mcast groups to
mandate CAP_NET_ADMIN.

This will be used by the upcoming mptcp netlink event facility which
exposes the token (mptcp connection identifier) to userspace.
"

Link: https://lore.kernel.org/mptcp/20210213000001.379332-8-mathew.j.martineau@linux.intel.com/
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/genetlink.h |    1 +
 net/netlink/genetlink.c |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -14,6 +14,7 @@
  */
 struct genl_multicast_group {
 	char			name[GENL_NAMSIZ];
+	u8			flags;
 };
 
 struct genl_ops;
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -959,11 +959,43 @@ static struct genl_family genl_ctrl __ro
 	.netnsok = true,
 };
 
+static int genl_bind(struct net *net, int group)
+{
+	const struct genl_family *family;
+	unsigned int id;
+	int ret = 0;
+
+	genl_lock_all();
+
+	idr_for_each_entry(&genl_fam_idr, family, id) {
+		const struct genl_multicast_group *grp;
+		int i;
+
+		if (family->n_mcgrps == 0)
+			continue;
+
+		i = group - family->mcgrp_offset;
+		if (i < 0 || i >= family->n_mcgrps)
+			continue;
+
+		grp = &family->mcgrps[i];
+		if ((grp->flags & GENL_UNS_ADMIN_PERM) &&
+		    !ns_capable(net->user_ns, CAP_NET_ADMIN))
+			ret = -EPERM;
+
+		break;
+	}
+
+	genl_unlock_all();
+	return ret;
+}
+
 static int __net_init genl_pernet_init(struct net *net)
 {
 	struct netlink_kernel_cfg cfg = {
 		.input		= genl_rcv,
 		.flags		= NL_CFG_F_NONROOT_RECV,
+		.bind		= genl_bind,
 	};
 
 	/* we'll bump the group number right afterwards */


