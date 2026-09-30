Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7080345EDD;
	Wed, 30 Sep 2026 18:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791682; cv=none; b=Jw7qCyx0Kd88Qlb1pYNWpRxDKKw5PCxYMatwV6skq4q0Ld1BxdTN9XBKOrHry1i/P2gHDrJRwook3VdXzCpcOFwQ7cPxcuko3gmeVAwPwzdi0D2TdDNPTeY92wVMDVCEM8/UuLCrPcPaAYrLdnbdd5cinM7+sJ0R6qndZQQ09ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791682; c=relaxed/simple;
	bh=JWqgt3J0Ii86Y+Bke0bhJstmhOtbA3PqCzQ5OftEEIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QhgdtsEeMeFnHjen1W8kJU/8jjWutjelrJ5ZnSCRYzH9/giu/qKqicA874bV3GA3qE5510wB9d/aUWmkh5wusFg9U4F1bEfL0ODSxHzA+hKcUuI7XsJe8FUwfN3Nz5ouKPv6z83K2oVRwchzAncJv867hv/n+aqwwFA6Nzko5Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vJ4beqvW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vJ4beqvW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5BA1F000FF;
	Wed, 30 Sep 2026 18:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791681;
	bh=3oWGF+A/2S4SwQUKYvmE6HP9OByJzCIa0g4iwZZLbRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vJ4beqvWLDsFQmhjB+BmvkoOn3Oe7xmvMdijE5nUQKBKfIRbsYwTtZZjOeaolyNPE
	 9YZFAESx09K+UeF50FBPmMG6OPoDjPkb6PHaiDwJFSizLD6zUDJCj8CNHL6JX/KXv1
	 H+46FdQXJP9sekyLsSYCgPHwK6HUXKMac7Rrk4xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 388/752] net: openvswitch: fix use-after-free of the flow table mask array
Date: Wed, 30 Sep 2026 17:24:18 +0200
Message-ID: <20260930152406.672788339@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Norbert Szetei <norbert@doyensec.com>

commit ba4ba11ed6eb8972c69070417fc27b48deb002e8 upstream.

tbl_mask_array_realloc() retires the old mask_array before it stops being
reachable:

	old = ovsl_dereference(tbl->mask_array);
	if (old) {
		...
		call_rcu(&old->rcu, mask_array_rcu_cb);
	}

	rcu_assign_pointer(tbl->mask_array, new);

call_rcu() only waits for read-side critical sections already in flight.
tbl->mask_array still points at old between the call_rcu() and the
rcu_assign_pointer(), so a reader entering ovs_flow_tbl_lookup_stats() in
that window picks up old in a fresh critical section that the pending
grace period does not cover.

tbl_mask_array_realloc() runs in process context under ovs_mutex, so the
window is preemptible and can outlast the grace period. Then
mask_array_rcu_cb() frees old before the swap runs:

  BUG: KASAN: slab-use-after-free in flow_lookup.constprop.0+0x2bf/0x2f0
  Read of size 8 at addr ffff888020b3e018 by task poc/741
   flow_lookup.constprop.0+0x2bf/0x2f0
   ovs_flow_tbl_lookup_stats+0x4a3/0x5c0
   ovs_dp_process_packet+0x19c/0x710
   ovs_vport_receive+0x243/0x390
   internal_dev_xmit+0x81/0x170
  Freed by task 728:
   kfree+0x16a/0x4e0
   rcu_core+0x853/0x1030

Publish the new array before retiring the old one. The kfree_rcu() that
call_rcu() replaced ran after the swap.

Fixes: eac87c413bf9 ("net: openvswitch: reorder masks array based on usage")
Cc: stable@vger.kernel.org
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
Acked-by: Eelco Chaudron echaudro@redhat.com
Link: https://patch.msgid.link/DE115F9C-2545-423E-A702-986FC952FD62@doyensec.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/flow_table.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -261,11 +261,13 @@ static int tbl_mask_array_realloc(struct
 			if (ovsl_dereference(old->masks[i]))
 				new->masks[new->count++] = old->masks[i];
 		}
-		call_rcu(&old->rcu, mask_array_rcu_cb);
 	}
 
 	rcu_assign_pointer(tbl->mask_array, new);
 
+	if (old)
+		call_rcu(&old->rcu, mask_array_rcu_cb);
+
 	return 0;
 }
 


