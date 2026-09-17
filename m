Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E4A4E36D9;
	Thu, 17 Sep 2026 18:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671149; cv=none; b=oNAkVEOvaE0O/Ux4w8ELtrg/qFokE5Rw6S5GIsA0S061PdyqHWP3qG7H0/ddHMVVEVgsOb98qHJmOWrl6IFxeyhZRoX1jbzBfWHsIayKIpy32BQbzcX1zDAM93DGYSh4fUw/22fplyfnNmuc4I+WmW0Jf/sGFzzYdhsQzPfKMXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671149; c=relaxed/simple;
	bh=veGI0aJOYltmogqamMSsM9Mm+PdGSKZXyR55ZU/gszU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YqAmbR0/1M4QTrdTW1CmrpS+rclhqSH9Vq1VTiCj9SA9PSn2IvqN/sHnfUhQOp6X2dkcXMt6h8c1R4Z0LXlgSGwrZBNo6uH+g6SH3J6PAX08A8/82z/p2wf33FCcy/p6vePExZaGbvrfKtgeAZF9KLljSqeBrW2AjWhmqQRoJSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sHBtoyuk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sHBtoyuk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ADF51F00893;
	Thu, 17 Sep 2026 18:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671147;
	bh=ioZtzl6Th25nihgTe2din/og7K5bySgFufTiy0ZTS/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sHBtoyuklR2sTi3xHwinc3tiqAnpWnedUo7hXhU1MZhvDjIWWLq03ABqdTY3jdaNe
	 U3qpNqoE1omxdK+MKvWjroVcvN6SZYKn5AlFBslEqPbxM58hvXdpZxdmzyPrr8qPRb
	 IT78u6IzbRXAbQ/Ycnd3evu+Ozs0tjs1zPEgSH+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 0845/1102] net: openvswitch: fix use-after-free of the flow table mask array
Date: Thu, 17 Sep 2026 16:13:08 +0100
Message-ID: <20260917151601.742274462@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
@@ -259,11 +259,13 @@ static int tbl_mask_array_realloc(struct
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
 


