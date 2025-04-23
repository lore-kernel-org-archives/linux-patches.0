Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E3226A082;
	Wed, 23 Apr 2025 15:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422144; cv=none; b=IbB919iOTqNlaKSW/B7WmkL+ob3sdMVqOkPDcsH6zyqHDDbWRmYL7EsF1Y1AwAeNngKPzFh0VDC3emcxI5f2wvE3H3z9Kr92VFpB6K1Is/YjuyWkKbIAUatkDR1Rvn6Xj2XOuzchvdkcbdGrfTewD/hpTst8o+ezwU9AIi7iLvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422144; c=relaxed/simple;
	bh=N/1RudE0Gfna3LlpXm00dTWMlh8OmN3Mu390VLsSbbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TTfa20kKMoXD7HIhCi4IhhQknk1lIinXutijS+tSq7fIf/qkLk5FsbnwA/M2YtoO2xo3miZu1kFk3DMwFXWZ9/HUOUy7EqrQIjL+q6YGyorvscLYRV3VOx3qs+SNmySsUQlpl1XiooupQeFEGLmbhg+k9JV/PNhf6fg3blNLaoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D4I/+w9b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D4I/+w9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90527C4CEE2;
	Wed, 23 Apr 2025 15:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422143;
	bh=N/1RudE0Gfna3LlpXm00dTWMlh8OmN3Mu390VLsSbbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D4I/+w9bkRSGsOPbj0tSKpj4bSnvhchdo0e413urIv1FQ+SicDggZhKeK+rWviAgE
	 O+hU5WNTMJxJjqmz7VV+rvcvK62XqtO5Nc44LNPOx5eVaLooKDzOB2bUJa4BSfJ3uZ
	 h/9bSd+fydzkKJ3L6HBe6MY6OzLys/FmbO8M7454=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 286/393] net: dsa: clean up FDB, MDB, VLAN entries on unbind
Date: Wed, 23 Apr 2025 16:43:02 +0200
Message-ID: <20250423142655.159577195@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 7afb5fb42d4950f33af2732b8147c552659f79b7 ]

As explained in many places such as commit b117e1e8a86d ("net: dsa:
delete dsa_legacy_fdb_add and dsa_legacy_fdb_del"), DSA is written given
the assumption that higher layers have balanced additions/deletions.
As such, it only makes sense to be extremely vocal when those
assumptions are violated and the driver unbinds with entries still
present.

But Ido Schimmel points out a very simple situation where that is wrong:
https://lore.kernel.org/netdev/ZDazSM5UsPPjQuKr@shredder/
(also briefly discussed by me in the aforementioned commit).

Basically, while the bridge bypass operations are not something that DSA
explicitly documents, and for the majority of DSA drivers this API
simply causes them to go to promiscuous mode, that isn't the case for
all drivers. Some have the necessary requirements for bridge bypass
operations to do something useful - see dsa_switch_supports_uc_filtering().

Although in tools/testing/selftests/net/forwarding/local_termination.sh,
we made an effort to popularize better mechanisms to manage address
filters on DSA interfaces from user space - namely macvlan for unicast,
and setsockopt(IP_ADD_MEMBERSHIP) - through mtools - for multicast, the
fact is that 'bridge fdb add ... self static local' also exists as
kernel UAPI, and might be useful to someone, even if only for a quick
hack.

It seems counter-productive to block that path by implementing shim
.ndo_fdb_add and .ndo_fdb_del operations which just return -EOPNOTSUPP
in order to prevent the ndo_dflt_fdb_add() and ndo_dflt_fdb_del() from
running, although we could do that.

Accepting that cleanup is necessary seems to be the only option.
Especially since we appear to be coming back at this from a different
angle as well. Russell King is noticing that the WARN_ON() triggers even
for VLANs:
https://lore.kernel.org/netdev/Z_li8Bj8bD4-BYKQ@shell.armlinux.org.uk/

What happens in the bug report above is that dsa_port_do_vlan_del() fails,
then the VLAN entry lingers on, and then we warn on unbind and leak it.

This is not a straight revert of the blamed commit, but we now add an
informational print to the kernel log (to still have a way to see
that bugs exist), and some extra comments gathered from past years'
experience, to justify the logic.

Fixes: 0832cd9f1f02 ("net: dsa: warn if port lists aren't empty in dsa_port_teardown")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20250414212930.2956310-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/dsa.c | 38 +++++++++++++++++++++++++++++++++++---
 1 file changed, 35 insertions(+), 3 deletions(-)

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index ccbdb98109f80..399675c5fcc7f 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -1483,12 +1483,44 @@ static int dsa_switch_parse(struct dsa_switch *ds, struct dsa_chip_data *cd)
 
 static void dsa_switch_release_ports(struct dsa_switch *ds)
 {
+	struct dsa_mac_addr *a, *tmp;
 	struct dsa_port *dp, *next;
+	struct dsa_vlan *v, *n;
 
 	dsa_switch_for_each_port_safe(dp, next, ds) {
-		WARN_ON(!list_empty(&dp->fdbs));
-		WARN_ON(!list_empty(&dp->mdbs));
-		WARN_ON(!list_empty(&dp->vlans));
+		/* These are either entries that upper layers lost track of
+		 * (probably due to bugs), or installed through interfaces
+		 * where one does not necessarily have to remove them, like
+		 * ndo_dflt_fdb_add().
+		 */
+		list_for_each_entry_safe(a, tmp, &dp->fdbs, list) {
+			dev_info(ds->dev,
+				 "Cleaning up unicast address %pM vid %u from port %d\n",
+				 a->addr, a->vid, dp->index);
+			list_del(&a->list);
+			kfree(a);
+		}
+
+		list_for_each_entry_safe(a, tmp, &dp->mdbs, list) {
+			dev_info(ds->dev,
+				 "Cleaning up multicast address %pM vid %u from port %d\n",
+				 a->addr, a->vid, dp->index);
+			list_del(&a->list);
+			kfree(a);
+		}
+
+		/* These are entries that upper layers have lost track of,
+		 * probably due to bugs, but also due to dsa_port_do_vlan_del()
+		 * having failed and the VLAN entry still lingering on.
+		 */
+		list_for_each_entry_safe(v, n, &dp->vlans, list) {
+			dev_info(ds->dev,
+				 "Cleaning up vid %u from port %d\n",
+				 v->vid, dp->index);
+			list_del(&v->list);
+			kfree(v);
+		}
+
 		list_del(&dp->list);
 		kfree(dp);
 	}
-- 
2.39.5



