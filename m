Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEADD415F0B;
	Fri,  4 Sep 2026 05:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499969; cv=none; b=FhrIdHZN/PejndtEV7GxQHfmth2JiVlDWnWyrv/EDUwzESPtPjnFplV4EBzD3zXYQloYJ0Diq9lxxSnchzdj/sijzCN4OXg++VW3h0+7cAhC06JIzuFSpTPlU18TUiQIRomVogifg8o/s0UPGQFuco0yiE27Auj/2Ix/z3n9eXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499969; c=relaxed/simple;
	bh=ekbfQfaRvjJTYy+1hCuXlwLh7udpE2RQmj1wh9ktQQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T4qIQ3Ac09PB67CQ1p1lhQOrZrPrQPe//HxwKPr+aricQ3VzbhTzzFBOoEPXBa24ZRTZeJkObRq6DGWV8ucuddv4nDZUYYb7FQGCUoyZ1czLyAr8SdHPJzHMSm8vYLD77R2ms024UXeBP87E2MUYysSeqMA2Db7ZYCWzxs0t4Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UzE0elkc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UzE0elkc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2108F1F00A3E;
	Fri,  4 Sep 2026 05:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499967;
	bh=bPn0mE02mOmj9JtoszxhQo5tHuZQrEApElL/goCdXok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UzE0elkcn57dxW/w4r8KhaPzR/RR8HjeeXTwYVMQvCYUYHzW/ph9GzehmnBnJRHiF
	 xsfVsYDfi+BHSLqqYXVspbhPe+ludJ1gN6x0leIeURRfoTYUlcxFX5T4lOeio51aTM
	 PgJl/GXQ1Zlc4hIHIG58Je99qjpTfMpLUmThQPNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 605/713] net: openvswitch: fix flow mask use-after-free on flow deletion
Date: Fri,  4 Sep 2026 06:59:33 +0200
Message-ID: <20260904045817.388248100@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Ilya Maximets <i.maximets@ovn.org>

commit 4e30317ff67a2eb12b4d890d39f72fd7e7117d48 upstream.

The commit in the Fixes tag below made so flow->mask free is scheduled
via RCU right after it is removed from the flow table.  The pointer
stays in the flow structure and it can be accessible while in the same
RCU critical section.  This is done to avoid requiring ovs_mutex for
the ovs_flow_free().

However, while removing the flow during processing of CMD_DEL, we do
not take RCU read lock before the removal, and ovs_flow_cmd_fill_info()
uses the flow->mask pointer afterwards.  The RCU read lock is taken,
but it's already late at that point.  The comment on that line
acknowledges that the lock is cosmetic and doesn't serve a real purpose.

This leads to use-after-free if the RCU grace period passes between
removal and the filling.  It is a short race window, but it is there
and can lead to a real crash in case memory allocation for the info
takes a bit longer:

 BUG: KASAN: slab-use-after-free in __ovs_nla_put_key
             net/openvswitch/flow_netlink.c:1996
 BUG: KASAN: slab-use-after-free in ovs_nla_put_key+0x2463/0x2e30
             net/openvswitch/flow_netlink.c:2250
 Read of size 4 at addr ffff88801ee89970 by task ovs_flow_del_ec/9487

 Call Trace:
  <TASK>
  __ovs_nla_put_key net/openvswitch/flow_netlink.c:1996
  ovs_nla_put_key+0x2463/0x2e30 net/openvswitch/flow_netlink.c:2250
  ovs_flow_cmd_fill_info+0x420/0x9c0 net/openvswitch/datapath.c:930
  ovs_flow_cmd_del+0x53a/0x970 net/openvswitch/datapath.c:1467
  ...
  netlink_rcv_skb+0x156/0x420 net/netlink/af_netlink.c:2556
  </TASK>

 Allocated by task 9487:
  mask_alloc net/openvswitch/flow_table.c:967
  flow_mask_insert net/openvswitch/flow_table.c:1012
  ovs_flow_tbl_insert+0xea2/0x1a90 net/openvswitch/flow_table.c:1084
  ovs_flow_cmd_new+0x7e3/0xd90 net/openvswitch/datapath.c:1086
  ...
  netlink_rcv_skb+0x156/0x420 net/netlink/af_netlink.c:2556

 Freed by task 9485:
  rcu_free_sheaf+0x1e/0x100 mm/slub.c:5978
  rcu_do_batch kernel/rcu/tree.c:2645
  rcu_core+0x59c/0x10c0 kernel/rcu/tree.c:2897
  handle_softirqs+0x1e4/0x9a0 kernel/softirq.c:622
  ...
  instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1062

ovs_flow_tbl_remove() must be called after the ovs_flow_cmd_fill_info()
to avoid this race.  This also helps with cleaning up the forced cast
and the cosmetic RCU read lock.  Before the commit in the Fixes tag the
order did not matter as long as the flow object itself was not freed.

A wider RCU critical section could be another option, but we have a
GFP_KERNEL allocation in the way.

Reported by Trend Micro's Zero Day Initiative as ZDI-CAN-32042.

Fixes: 56c19868e115 ("openvswitch: Make flow mask removal symmetric.")
Cc: stable@vger.kernel.org
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Link: https://patch.msgid.link/20260815005915.1097270-1-i.maximets@ovn.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/datapath.c |   45 +++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1472,33 +1472,34 @@ static int ovs_flow_cmd_del(struct sk_bu
 		goto unlock;
 	}
 
-	ovs_flow_tbl_remove(&dp->table, flow);
-	ovs_unlock();
-
-	reply = ovs_flow_cmd_alloc_info((const struct sw_flow_actions __force *) flow->sf_acts,
+	reply = ovs_flow_cmd_alloc_info(ovsl_dereference(flow->sf_acts),
 					&flow->id, info, false, ufid_flags);
-	if (likely(reply)) {
-		if (!IS_ERR(reply)) {
-			rcu_read_lock();	/*To keep RCU checker happy. */
-			err = ovs_flow_cmd_fill_info(flow, ovs_header->dp_ifindex,
-						     reply, info->snd_portid,
-						     info->snd_seq, 0,
-						     OVS_FLOW_CMD_DEL,
-						     ufid_flags);
-			rcu_read_unlock();
-			if (WARN_ON_ONCE(err < 0)) {
-				kfree_skb(reply);
-				goto out_free;
-			}
+	if (IS_ERR(reply)) {
+		netlink_set_err(sock_net(skb->sk)->genl_sock, 0, 0,
+				PTR_ERR(reply));
+		reply = NULL;
+	}
 
-			ovs_notify(&dp_flow_genl_family, reply, info);
-		} else {
-			netlink_set_err(sock_net(skb->sk)->genl_sock, 0, 0,
-					PTR_ERR(reply));
+	if (likely(reply)) {
+		err = ovs_flow_cmd_fill_info(flow, ovs_header->dp_ifindex,
+					     reply, info->snd_portid,
+					     info->snd_seq, 0,
+					     OVS_FLOW_CMD_DEL, ufid_flags);
+		if (WARN_ON_ONCE(err < 0)) {
+			kfree_skb(reply);
+			reply = NULL;
 		}
 	}
+	/* Removal has to happen after ovs_flow_cmd_fill_info(), as it uses
+	 * the flow->mask that can be scheduled to be freed by the
+	 * ovs_flow_tbl_remove() and we're not holding the RCU read lock.
+	 */
+	ovs_flow_tbl_remove(&dp->table, flow);
+	ovs_unlock();
+
+	if (likely(reply))
+		ovs_notify(&dp_flow_genl_family, reply, info);
 
-out_free:
 	ovs_flow_free(flow, true);
 	return 0;
 unlock:


