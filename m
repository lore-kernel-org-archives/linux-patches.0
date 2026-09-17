Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941934E73AF;
	Thu, 17 Sep 2026 15:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658904; cv=none; b=p6AeTLORawKuhK8XdAWs8lwUM+1lXNJ0Tf+flkpvl3+3DyiV13BmWoKodmi6r9V+fJPljjwN1mnFm5z+gYiYGVJrUCP6Dk4GaYrvoLQeb12zseyGUzUOsCfuVkAw80+IgJPC3GmnJHOCnBymAVKpMxBnGrtvM8UahJuxcig59yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658904; c=relaxed/simple;
	bh=uwRqbCljPh6XiKEkw97Lrrjo6N88ECBTNrIrDkXW/9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YB6qJZ6wePfQY5HkfoGDu2tP+CDBJiIles3z7Spktij2lpZRIuj7FNjrjZgZ4+25wUTcmG107CerxyfEPbxA9f/b7rjfHvJOrip32gmLNfYJ+GSEfT75TpZnKOsUPnsPkM6GFcdLZN0DbIWHAAm7H+jaIgz7NBqq8i7b5oz/kcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DV/NNzDg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DV/NNzDg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF6C1F000FF;
	Thu, 17 Sep 2026 15:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658898;
	bh=vkhJLQWeu2DT3frw+dgtzZJz+wB80BW/GiH5JS0t9DM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DV/NNzDgIBdIHHTk6rsEmIYCj7bcceneu/3DODsWtkpFQ53rD4fz2/gWCOeI2xo0S
	 NBo2o+6rzOSSIWn6UNbNxKGvL3eY9/mBh9m6zzV4PM/xyFo3tjd7++AWc/761EJAi6
	 ztHChOLaTa4UjA7VNg70Bhwy8+E6jfPlABOXlNMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baul Lee <baul.lee@xbow.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 075/733] vxlan: mdb: Fix use-after-free in vxlan_mdb_remote_src_del()
Date: Thu, 17 Sep 2026 16:06:23 +0100
Message-ID: <20260917151352.743166091@linuxfoundation.org>
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

From: Baul Lee <baul.lee@xbow.com>

[ Upstream commit 4aa61c88b4e292e10abdfd791334b8272108d68a ]

vxlan_mdb_is_valid_source(), which validates MDBE_ATTR_SOURCE and every
MDBE_ATTR_SRC_LIST member, accepts the all-zeros address.

A source list is only accepted on a (*, G) entry, whose source is the
all-zeros address, and for each member of the list an (S, G) entry is
derived from it by substituting the source. Entries are keyed by a plain
memcmp() of struct vxlan_mdb_entry_key, so if MDBE_ATTR_SOURCE is present
and holds the all-zeros address and the source list holds it as well, the
derived (S, G) key is byte-identical to the (*, G) key and resolves to the
same entry. Omitting MDBE_ATTR_SOURCE is not equivalent, as the key is
then left with a zero address family.

vxlan_mdb_remote_src_del() removes the forwarding entry of a source before
freeing the source entry:

	vxlan_mdb_remote_src_fwd_del(vxlan, group, remote, &ent->addr);
	vxlan_mdb_remote_src_entry_del(ent);

With the keys aliased, the first call deletes the remote of the entry that
owns 'ent' instead of a separate (S, G) entry, and frees 'ent'. The second
call then runs on the freed entry, and its hlist_del() reads ->pprev and
->next out of it and writes through them.

Adding the (*, G) entry with NLM_F_REPLACE and no source list marks the
all-zeros source for deletion and reaches this from the sweep at the end
of vxlan_mdb_remote_srcs_replace().

  BUG: KASAN: slab-use-after-free in __vxlan_mdb_add+0x1cd/0xd70
  Read of size 8 at addr ffff888102852500 by task poc/84
   __vxlan_mdb_add+0x1cd/0xd70
   vxlan_mdb_add+0xc0/0x140
   rtnl_mdb_add+0x157/0x2a0
   rtnetlink_rcv_msg+0x207/0x5a0
  Allocated by task 84:
   __kmalloc_cache_noprof+0x153/0x360
   vxlan_mdb_remote_srcs_add+0x2eb/0x440
   __vxlan_mdb_add+0x803/0xd70
  Freed by task 84:
   kfree+0x14c/0x3b0
   vxlan_mdb_remote_del+0x129/0x1a0
   __vxlan_mdb_del+0x4f/0xe0
   vxlan_mdb_remote_src_fwd_del.isra.0+0x162/0x1b0
   __vxlan_mdb_add+0x1c5/0xd70

The MDB operations are netns-scoped, so an unprivileged user can perform
them in a new user and network namespace.

Reject the all-zeros address in vxlan_mdb_is_valid_source(), which covers
both call sites. A (*, G) entry is expressed by omitting the source, so
nothing legitimate is refused.

Discovered by XBOW, triaged by Baul Lee <baul.lee@xbow.com>

Fixes: a3a48de5eade ("vxlan: mdb: Add MDB control path support")
Signed-off-by: Baul Lee <baul.lee@xbow.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20260826173604.90158-1-baul.lee@xbow.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_mdb.c                 | 8 ++++++++
 tools/testing/selftests/net/test_vxlan_mdb.sh | 6 ++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/vxlan/vxlan_mdb.c b/drivers/net/vxlan/vxlan_mdb.c
index d71e1925ecfdb..841f42ffecb9a 100644
--- a/drivers/net/vxlan/vxlan_mdb.c
+++ b/drivers/net/vxlan/vxlan_mdb.c
@@ -354,6 +354,10 @@ static bool vxlan_mdb_is_valid_source(const struct nlattr *attr, __be16 proto,
 			NL_SET_ERR_MSG_MOD(extack, "IPv4 multicast source address is not allowed");
 			return false;
 		}
+		if (ipv4_is_zeronet(nla_get_in_addr(attr))) {
+			NL_SET_ERR_MSG_MOD(extack, "IPv4 all-zeros source address is not allowed");
+			return false;
+		}
 		break;
 #if IS_ENABLED(CONFIG_IPV6)
 	case htons(ETH_P_IPV6): {
@@ -368,6 +372,10 @@ static bool vxlan_mdb_is_valid_source(const struct nlattr *attr, __be16 proto,
 			NL_SET_ERR_MSG_MOD(extack, "IPv6 multicast source address is not allowed");
 			return false;
 		}
+		if (ipv6_addr_any(&src)) {
+			NL_SET_ERR_MSG_MOD(extack, "IPv6 all-zeros source address is not allowed");
+			return false;
+		}
 		break;
 	}
 #endif
diff --git a/tools/testing/selftests/net/test_vxlan_mdb.sh b/tools/testing/selftests/net/test_vxlan_mdb.sh
index 58da5de99ac45..f9600aabd4a29 100755
--- a/tools/testing/selftests/net/test_vxlan_mdb.sh
+++ b/tools/testing/selftests/net/test_vxlan_mdb.sh
@@ -685,6 +685,9 @@ star_g_common()
 	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 grp $grp permanent filter_mode exclude source_list $grp dst $vtep_ip src_vni 10010"
 	log_test $? 255 "Invalid source in source list"
 
+	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 grp $grp permanent filter_mode exclude source_list $all_zeros_grp dst $vtep_ip src_vni 10010"
+	log_test $? 255 "All-zeros source in source list"
+
 	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 grp $grp permanent source_list $src1 dst $vtep_ip src_vni 10010"
 	log_test $? 255 "Source list without filter mode"
 }
@@ -784,6 +787,9 @@ sg_common()
 	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 grp $grp src $grp permanent dst $vtep_ip src_vni 10010"
 	log_test $? 255 "(S, G) with an invalid source list"
 
+	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 grp $grp src $all_zeros_grp permanent dst $vtep_ip src_vni 10010"
+	log_test $? 255 "(S, G) with an all-zeros source"
+
 	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 grp $all_zeros_grp src $src permanent dst $vtep_ip src_vni 10010"
 	log_test $? 255 "All-zeros group with source"
 }
-- 
2.53.0



