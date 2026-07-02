Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7766A3659F9;
	Thu,  2 Jul 2026 16:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010707; cv=none; b=t8B1TFZc4gwe8vw2cHCE/XazZEMC/6NLI+w/ByAbep8fF0heByZFS+IASdYszfhsd4kBaUy4jKEdEUXWNn+TKhgz/+QSsjk1PjL8IvRJtRLk7krdswERB+5snLyDVCxg9Bnqi6JOTh4v3Z0kICPqNIjFV1pbNXhsf62AYVdSVks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010707; c=relaxed/simple;
	bh=iDAIjeNFQp6xUizqyDLGCZKszsXwmG2C3ykrkycvUHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNLw6086UppIn/TvNPSFcEshp6LRVHyp7mjL80dLzvxhHAbBWTFh43bTUgPnBFgPtdVm6HXAy2t1Iu9Jtme3ZFcobbva1Cf+Y2L+QH4VyPVWKeumqo97wLp7KBF87KKM4wyjI+4LJuBlgJGf9BiBosnzgb2OLxB6Ek6BTrZEuXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ExbAsst; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ExbAsst"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B991F000E9;
	Thu,  2 Jul 2026 16:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010706;
	bh=zP/Uqyx8LRE3NvkywlhnoHZclbzKbRj4VedrG0O958E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ExbAsstomB+33D2zAIHSssd929k+9ekjA4NhuSwhAm11wtuekeoKqR7eVSZbQ3nU
	 72+h6GSUwkqdvOcYuh8n0wyyVMTAmDsqxpzcC4qQX7Yajz7jInlOcFxMcMO+gmhY4q
	 2GhSV3xhdg8Al1AqcFsBV/+bd8JlVD5puP4WhuhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang Li <liali@redhat.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 204/204] bonding: do not set usable_slaves for broadcast mode
Date: Thu,  2 Jul 2026 18:21:01 +0200
Message-ID: <20260702155122.937278923@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

commit 45fc134bcfadde456639c1b1e206e6918d69a553 upstream.

After commit e0caeb24f538 ("net: bonding: update the slave array for broadcast mode"),
broadcast mode will also set all_slaves and usable_slaves during
bond_enslave(). But if we also set updelay, during enslave, the
slave init state will be BOND_LINK_BACK. And later
bond_update_slave_arr() will alloc usable_slaves but add nothing.
This will cause bond_miimon_inspect() to have ignore_updelay
always true. So the updelay will be always ignored. e.g.

[    6.498368] bond0: (slave veth2): link status definitely down, disabling slave
[    7.536371] bond0: (slave veth2): link status up, enabling it in 0 ms
[    7.536402] bond0: (slave veth2): link status definitely up, 10000 Mbps full duplex

To fix it, we can either always call bond_update_slave_arr() on every
place when link changes. Or, let's just not set usable_slaves for
broadcast mode.

Fixes: e0caeb24f538 ("net: bonding: update the slave array for broadcast mode")
Reported-by: Liang Li <liali@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20260304-b4-bond_updelay-v1-1-f72eb2e454d0@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -5191,13 +5191,18 @@ static void bond_set_slave_arr(struct bo
 {
 	struct bond_up_slave *usable, *all;
 
-	usable = rtnl_dereference(bond->usable_slaves);
-	rcu_assign_pointer(bond->usable_slaves, usable_slaves);
-	kfree_rcu(usable, rcu);
-
 	all = rtnl_dereference(bond->all_slaves);
 	rcu_assign_pointer(bond->all_slaves, all_slaves);
 	kfree_rcu(all, rcu);
+
+	if (BOND_MODE(bond) == BOND_MODE_BROADCAST) {
+		kfree_rcu(usable_slaves, rcu);
+		return;
+	}
+
+	usable = rtnl_dereference(bond->usable_slaves);
+	rcu_assign_pointer(bond->usable_slaves, usable_slaves);
+	kfree_rcu(usable, rcu);
 }
 
 static void bond_reset_slave_arr(struct bonding *bond)


