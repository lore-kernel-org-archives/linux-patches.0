Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C025A53E16;
	Tue, 23 Jan 2024 00:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970362; cv=none; b=uAE60agWHIXDAz8GDcs41dtFc7X1PpXWUyWwUvD4wqiHywkhPllDJ+CHFSdJy4NSVV4C95RJ1qec9Td4xIpZE7cs27Ecdjkt3tsA71wYn/7cpHLBGGxU0RwbzQc2mZHZhvl9XBeg0wPJkoXCrA+zbgQrwhW4L+ELqYlrttm9Y8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970362; c=relaxed/simple;
	bh=ZH/GuiKptuW1sJBB3y4gF/wplO9sXZZgBLmdT6bmHs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iu8tF5eMqMyCN9yPSqWEE4wHxE5pqd5fXtcSVGdaQRMhkM/DotMfkXIx9R5CGr3oiagsh4QjriI6kpZG0G4YHLVJ2POsXshfEzSZfQfRp/gxZ5Qyh18l8ODtoWxHJg1xp+Qhpaln4l4oQmfuof5nKX0PjCukfcSpjECkXlhxJSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NgxlgQy5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NgxlgQy5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED681C433F1;
	Tue, 23 Jan 2024 00:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970362;
	bh=ZH/GuiKptuW1sJBB3y4gF/wplO9sXZZgBLmdT6bmHs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NgxlgQy5vfBDkeqrV8MUTN0wdYclzhcxAotDBzfZ5+6JJC8/dwTe/V4cFyg/2ev05
	 dtLpq8hwbNtDGOvui6r0yrAQsjCRBW6vUDVcJmpM/mbslbTnBi8x4z/J/oscPCJJJX
	 i6UUzs2pT1n5ugNOv0I4QZeAjsFdlHYx2mOKt6BM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orel Hagag <orelh@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Amit Cohen <amcohen@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 636/641] mlxsw: spectrum_acl_tcam: Fix stack corruption
Date: Mon, 22 Jan 2024 15:59:00 -0800
Message-ID: <20240122235838.176450847@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 483ae90d8f976f8339cf81066312e1329f2d3706 ]

When tc filters are first added to a net device, the corresponding local
port gets bound to an ACL group in the device. The group contains a list
of ACLs. In turn, each ACL points to a different TCAM region where the
filters are stored. During forwarding, the ACLs are sequentially
evaluated until a match is found.

One reason to place filters in different regions is when they are added
with decreasing priorities and in an alternating order so that two
consecutive filters can never fit in the same region because of their
key usage.

In Spectrum-2 and newer ASICs the firmware started to report that the
maximum number of ACLs in a group is more than 16, but the layout of the
register that configures ACL groups (PAGT) was not updated to account
for that. It is therefore possible to hit stack corruption [1] in the
rare case where more than 16 ACLs in a group are required.

Fix by limiting the maximum ACL group size to the minimum between what
the firmware reports and the maximum ACLs that fit in the PAGT register.

Add a test case to make sure the machine does not crash when this
condition is hit.

[1]
Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: mlxsw_sp_acl_tcam_group_update+0x116/0x120
[...]
 dump_stack_lvl+0x36/0x50
 panic+0x305/0x330
 __stack_chk_fail+0x15/0x20
 mlxsw_sp_acl_tcam_group_update+0x116/0x120
 mlxsw_sp_acl_tcam_group_region_attach+0x69/0x110
 mlxsw_sp_acl_tcam_vchunk_get+0x492/0xa20
 mlxsw_sp_acl_tcam_ventry_add+0x25/0xe0
 mlxsw_sp_acl_rule_add+0x47/0x240
 mlxsw_sp_flower_replace+0x1a9/0x1d0
 tc_setup_cb_add+0xdc/0x1c0
 fl_hw_replace_filter+0x146/0x1f0
 fl_change+0xc17/0x1360
 tc_new_tfilter+0x472/0xb90
 rtnetlink_rcv_msg+0x313/0x3b0
 netlink_rcv_skb+0x58/0x100
 netlink_unicast+0x244/0x390
 netlink_sendmsg+0x1e4/0x440
 ____sys_sendmsg+0x164/0x260
 ___sys_sendmsg+0x9a/0xe0
 __sys_sendmsg+0x7a/0xc0
 do_syscall_64+0x40/0xe0
 entry_SYSCALL_64_after_hwframe+0x63/0x6b

Fixes: c3ab435466d5 ("mlxsw: spectrum: Extend to support Spectrum-2 ASIC")
Reported-by: Orel Hagag <orelh@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/2d91c89afba59c22587b444994ae419dbea8d876.1705502064.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlxsw/spectrum_acl_tcam.c        |  2 +
 .../drivers/net/mlxsw/spectrum-2/tc_flower.sh | 56 ++++++++++++++++++-
 2 files changed, 57 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
index 7d1e91196e94..50ea1eff02b2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
@@ -1564,6 +1564,8 @@ int mlxsw_sp_acl_tcam_init(struct mlxsw_sp *mlxsw_sp,
 	tcam->max_groups = max_groups;
 	tcam->max_group_size = MLXSW_CORE_RES_GET(mlxsw_sp->core,
 						  ACL_MAX_GROUP_SIZE);
+	tcam->max_group_size = min_t(unsigned int, tcam->max_group_size,
+				     MLXSW_REG_PAGT_ACL_MAX_NUM);
 
 	err = ops->init(mlxsw_sp, tcam->priv, tcam);
 	if (err)
diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/tc_flower.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/tc_flower.sh
index 7bf56ea161e3..616d3581419c 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/tc_flower.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/tc_flower.sh
@@ -11,7 +11,7 @@ ALL_TESTS="single_mask_test identical_filters_test two_masks_test \
 	multiple_masks_test ctcam_edge_cases_test delta_simple_test \
 	delta_two_masks_one_key_test delta_simple_rehash_test \
 	bloom_simple_test bloom_complex_test bloom_delta_test \
-	max_erp_entries_test"
+	max_erp_entries_test max_group_size_test"
 NUM_NETIFS=2
 source $lib_dir/lib.sh
 source $lib_dir/tc_common.sh
@@ -1033,6 +1033,60 @@ max_erp_entries_test()
 		"max chain $chain_failed, mask $mask_failed"
 }
 
+max_group_size_test()
+{
+	# The number of ACLs in an ACL group is limited. Once the maximum
+	# number of ACLs has been reached, filters cannot be added. This test
+	# verifies that when this limit is reached, insertion fails without
+	# crashing.
+
+	RET=0
+
+	local num_acls=32
+	local max_size
+	local ret
+
+	if [[ "$tcflags" != "skip_sw" ]]; then
+		return 0;
+	fi
+
+	for ((i=1; i < $num_acls; i++)); do
+		if [[ $(( i % 2 )) == 1 ]]; then
+			tc filter add dev $h2 ingress pref $i proto ipv4 \
+				flower $tcflags dst_ip 198.51.100.1/32 \
+				ip_proto tcp tcp_flags 0x01/0x01 \
+				action drop &> /dev/null
+		else
+			tc filter add dev $h2 ingress pref $i proto ipv6 \
+				flower $tcflags dst_ip 2001:db8:1::1/128 \
+				action drop &> /dev/null
+		fi
+
+		ret=$?
+		[[ $ret -ne 0 ]] && max_size=$((i - 1)) && break
+	done
+
+	# We expect to exceed the maximum number of ACLs in a group, so that
+	# insertion eventually fails. Otherwise, the test should be adjusted to
+	# add more filters.
+	check_fail $ret "expected to exceed number of ACLs in a group"
+
+	for ((; i >= 1; i--)); do
+		if [[ $(( i % 2 )) == 1 ]]; then
+			tc filter del dev $h2 ingress pref $i proto ipv4 \
+				flower $tcflags dst_ip 198.51.100.1/32 \
+				ip_proto tcp tcp_flags 0x01/0x01 \
+				action drop &> /dev/null
+		else
+			tc filter del dev $h2 ingress pref $i proto ipv6 \
+				flower $tcflags dst_ip 2001:db8:1::1/128 \
+				action drop &> /dev/null
+		fi
+	done
+
+	log_test "max ACL group size test ($tcflags). max size $max_size"
+}
+
 setup_prepare()
 {
 	h1=${NETIFS[p1]}
-- 
2.43.0



