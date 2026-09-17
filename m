Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383A3358D27;
	Thu, 17 Sep 2026 15:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659532; cv=none; b=TRku9vFQVCyvclCjE2trY8jc5NbYQzoXOtSZ1y9Yg/4SlQgsExA/J6d4ttmO/uUhfBhM47XJUwRLqlslsP3wTVPEBPSpFxjs1qNiJhCLqoWc+4+5jIu4im1r7wu5OqMIrRr06to/KQTMRPXTXHfHquMKOhJn7nm5X7h3Jf3U8SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659532; c=relaxed/simple;
	bh=FgCWKk9bwheamEE/CCYND8EDXr1X/DXM2TU8MV3erhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XW9nXJTH5RC4Md57YDP3o1UctMLe/rQmYLZkNUpPlouMqoRadgwmWAgpg6U7s4+u10Xr3yYOLXx5h/gt+my9WdUkfHgSAqyTM6b12egweDFySV3TUkmgjhU+LtmgN2ymWKnXkPkbzx7WH+xbQOIIvUwYZl858T/vuLYiH42y+DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jLY6V5Ix; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jLY6V5Ix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A85E1F0089A;
	Thu, 17 Sep 2026 15:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659525;
	bh=inSB4QJt0Il01cliMnu4IwwZVeiji5hD0tLfis77eI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jLY6V5IxbYSDQHlZG8z2u9rmcrCB1fFuC2YFIWBzCqnTG+SIbKMe00dnYZK3IrWYE
	 Axh0OU9ooZRApTJFxwIs6TVLc5jiPd2Jyzp/XXXRkDydN6Hbia1LI52L3kAY0FDjIS
	 /3UMztE/kWDd6J4TbHQCYNWbrUVFqwBF5YXsB1Oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Seungwon Bae <qotmddnjs@ajou.ac.kr>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 284/733] vxlan: reject dynamic fdb entries that reference a nexthop id
Date: Thu, 17 Sep 2026 16:09:52 +0100
Message-ID: <20260917151358.461553776@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seungwon Bae <qotmddnjs@ajou.ac.kr>

[ Upstream commit 98fc57d167446b95b4e719815fe79edef93f8e7a ]

The commit cited in the Fixes tag allowed VXLAN FDB entries to point to
FDB nexthops so that overlay traffic could be load balanced across
multiple VTEPs. Such entries can only be configured from user space,
cannot be learned and cannot roam. They only make sense with a user space
control plane such as E-VPN where data plane learning is disabled.

Despite that, the VXLAN driver does not currently prevent such entries
from being configured with the "dynamic" flag. The per-nexthop FDB list
is only protected by the per-device hash lock, which is not sufficient
when two VXLAN devices point to the same FDB nexthop and therefore share
the list. Aging runs in softirq context without RTNL, so an entry deleted
by one device can race with an addition or deletion from the other,
leading to list corruption:

  list_del corruption. next->prev should be ffff8881069d9548, but was
  dead000000000122. (next=ffff8881069d9448)
  WARNING: CPU: 0 PID: 90 at lib/list_debug.c:65
  __list_del_entry_valid_or_report+0x1aa/0x210
  ...
   vxlan_fdb_destroy+0x5b8/0xad0
   vxlan_cleanup+0x328/0x450
   call_timer_fn+0x2a/0x1c0
   run_timer_softirq+0x18c/0x210
  BUG: KASAN: slab-use-after-free in vxlan_fdb_destroy

Fix this by rejecting the bogus configuration of dynamic FDB entries that
point to FDB nexthops, both when created and when an existing entry is
updated. As such, the per-nexthop FDB list is only ever mutated under the
RTNL lock. Add test cases to make sure that this does not regress in the
future.

Fixes: 1274e1cc4226 ("vxlan: ecmp support for mac fdb entries")
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Seungwon Bae <qotmddnjs@ajou.ac.kr>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260902155956.296699-1-qotmddnjs@ajou.ac.kr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c              | 11 ++++++++
 tools/testing/selftests/net/fib_nexthops.sh | 28 +++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 44ea8499e7877..1d76e1dbc41f2 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -996,6 +996,12 @@ static int vxlan_fdb_update_existing(struct vxlan_dev *vxlan,
 		return -EOPNOTSUPP;
 	}
 
+	if (rcu_access_pointer(f->nh) &&
+	    !(state & (NUD_PERMANENT | NUD_NOARP))) {
+		NL_SET_ERR_MSG(extack, "Cannot make a nexthop fdb dynamic");
+		return -EOPNOTSUPP;
+	}
+
 	/* Do not allow an externally learned entry to take over an entry added
 	 * by the user.
 	 */
@@ -1257,6 +1263,11 @@ static int vxlan_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 	if (err)
 		return err;
 
+	if (nhid && !(ndm->ndm_state & (NUD_PERMANENT | NUD_NOARP))) {
+		NL_SET_ERR_MSG(extack, "A nexthop fdb cannot be dynamic");
+		return -EINVAL;
+	}
+
 	if (vxlan->default_dst.remote_ip.sa.sa_family != ip.sa.sa_family)
 		return -EAFNOSUPPORT;
 
diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index ac868a7316946..daceb1ec592ab 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -522,6 +522,20 @@ ipv6_fdb_grp_fcnal()
 	run_cmd "$BRIDGE fdb add 02:02:00:00:00:14 dev vx10 nhid 61 self"
 	log_test $? 255 "Fdb mac add with nexthop"
 
+	# fdb entries with a nexthop group cannot be aged out
+	run_cmd "$BRIDGE fdb add 02:02:00:00:00:15 dev vx10 nhid 102 self static"
+	log_test $? 0 "Fdb mac add with nexthop group and static state"
+
+	run_cmd "$BRIDGE fdb add 02:02:00:00:00:16 dev vx10 nhid 102 self dynamic"
+	log_test $? 255 "Fdb mac add with nexthop group and dynamic state"
+
+	run_cmd "$BRIDGE fdb add 02:02:00:00:00:17 dev vx10 nhid 102 self"
+	run_cmd "$BRIDGE fdb replace 02:02:00:00:00:17 dev vx10 dst 2001:db8:91::11 self dynamic"
+	log_test $? 255 "Fdb mac replace with nexthop group and dynamic state"
+
+	run_cmd "$BRIDGE fdb append 02:02:00:00:00:17 dev vx10 dst 2001:db8:91::11 self dynamic"
+	log_test $? 255 "Fdb mac append with nexthop group and dynamic state"
+
 	run_cmd "$IP -6 ro add 2001:db8:101::1/128 nhid 66"
 	log_test $? 2 "Route add with fdb nexthop"
 
@@ -622,6 +636,20 @@ ipv4_fdb_grp_fcnal()
 	run_cmd "$BRIDGE fdb add 02:02:00:00:00:14 dev vx10 nhid 12 self"
 	log_test $? 255 "Fdb mac add with nexthop"
 
+	# fdb entries with a nexthop group cannot be aged out
+	run_cmd "$BRIDGE fdb add 02:02:00:00:00:15 dev vx10 nhid 102 self static"
+	log_test $? 0 "Fdb mac add with nexthop group and static state"
+
+	run_cmd "$BRIDGE fdb add 02:02:00:00:00:16 dev vx10 nhid 102 self dynamic"
+	log_test $? 255 "Fdb mac add with nexthop group and dynamic state"
+
+	run_cmd "$BRIDGE fdb add 02:02:00:00:00:17 dev vx10 nhid 102 self"
+	run_cmd "$BRIDGE fdb replace 02:02:00:00:00:17 dev vx10 dst 10.0.0.3 self dynamic"
+	log_test $? 255 "Fdb mac replace with nexthop group and dynamic state"
+
+	run_cmd "$BRIDGE fdb append 02:02:00:00:00:17 dev vx10 dst 10.0.0.3 self dynamic"
+	log_test $? 255 "Fdb mac append with nexthop group and dynamic state"
+
 	run_cmd "$IP ro add 172.16.0.0/22 nhid 16"
 	log_test $? 2 "Route add with fdb nexthop"
 
-- 
2.53.0



