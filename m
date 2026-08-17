Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5433043E9FB;
	Mon, 17 Aug 2026 13:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974305; cv=none; b=kSZBoDeQ1uIeuCT6Xt+aKL4OWWaBNZ3GkzPqPYyHRBs/9sjHaSKx38vxL8I6w4sNoRLQLYNNmYM6HMZcRKkPtlC/tsYStR9vX9oWZzVfO8ZvC0roROJcddV2WfM991agQkjWzKS9trmYLI2+dOxPr4y62dB9r0mjqatmiL2MgQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974305; c=relaxed/simple;
	bh=szPX8B0ajqS7Kp+KD0VtkiGy+mTiKOci7wu+jBY18zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GBVDWhDJZN10253qWAFE1h6YwYtJ9NFoEU91aZMqhftlW7qhVkO9x/8U7V9ttzrh2UjMVcLOiARPQ47nuAYxM9RV8CT1poaf0jeBrqDT6hFbM4CeoG9SpODdenTu3MgFI2VSl3vQyi6ZSplBPfwn/0OFij9/sDJeWdjHbEqyBMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nmrfVVME; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nmrfVVME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 873011F00A3D;
	Mon, 17 Aug 2026 13:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974292;
	bh=0Idxh/X/CYIZb0iZoiRwQ0+YDvSJv6e0Bek6chwslpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nmrfVVME1CByExIFHayusMPRntFfbBaApUKuEZCdrWBuwG7bJaugkauKY7lzeKcZN
	 15mcmiJaAVuTrJPSiynPNqIYxBySCY3zrRuPuXuWkZR9FK49/k3WFzso9tUPWwOwji
	 BAcGtBIvriPPA3BiQYvYVm4c5Fs3egZMw/ZUg6zM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Ilya Maximets <i.maximets@ovn.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 154/271] net: openvswitch: reallocate update replies for mismatched IDs
Date: Mon, 17 Aug 2026 15:31:19 +0200
Message-ID: <20260817132543.255080186@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiling Zou <zhilinz@nebusec.ai>

commit 5d1c224dd914579524a183a514c12b95095d12ce upstream.

ovs_flow_cmd_new() preallocates the optional reply skb before it takes
ovs_mutex and before it knows which existing flow will be updated.

That is normally fine because the skb is sized from the request flow
identifier.  That identifier also becomes the inserted flow's identifier.
For updates, however, a request with a UFID may miss the UFID lookup and
then fall back to the flow key lookup.  That lookup can legitimately find
an existing key-identified flow.  UFIDs are optional and the flow key is
the primary identifier.

For echoed replies, ovs_flow_cmd_fill_info() writes the matched flow's
identifier, not the request identifier used for the preallocation.  A short
request UFID can therefore leave too little room for the key identifier.
The fill can then fail with -EMSGSIZE and hit the BUG_ON(error < 0) in the
update path.

Once the update target has been resolved, reallocate the reply skb if the
matched flow needs a larger reply than the request identifier allowed.  Do
this before replacing the actions so the request can still fail cleanly if
the rare extra allocation fails.

Fixes: 74ed7ab9264c ("openvswitch: Add support for unique flow IDs.")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
Link: https://patch.msgid.link/f7bbd3c30ce81a39156e226b3872d73abed21d2f.1785644623.git.zhilinz@nebusec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/datapath.c |   29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1113,9 +1113,8 @@ static int ovs_flow_cmd_new(struct sk_bu
 			error = -EEXIST;
 			goto err_unlock_ovs;
 		}
-		/* The flow identifier has to be the same for flow updates.
-		 * Look for any overlapping flow.
-		 */
+
+		/* Look for any overlapping flow. */
 		if (unlikely(!ovs_flow_cmp(flow, &match))) {
 			if (ovs_identifier_is_key(&flow->id))
 				flow = ovs_flow_tbl_lookup_exact(&dp->table,
@@ -1127,6 +1126,30 @@ static int ovs_flow_cmd_new(struct sk_bu
 				goto err_unlock_ovs;
 			}
 		}
+
+		if (unlikely(reply)) {
+			size_t cur, req;
+
+			cur = ovs_flow_cmd_msg_size(acts, &new_flow->id,
+						    ufid_flags);
+			req = ovs_flow_cmd_msg_size(acts, &flow->id,
+						    ufid_flags);
+			if (cur < req) {
+				struct sk_buff *resized;
+
+				resized = ovs_flow_cmd_alloc_info(acts,
+								  &flow->id,
+								  info, false,
+								  ufid_flags);
+				if (IS_ERR(resized)) {
+					error = PTR_ERR(resized);
+					goto err_unlock_ovs;
+				}
+				kfree_skb(reply);
+				reply = resized;
+			}
+		}
+
 		/* Update actions. */
 		old_acts = ovsl_dereference(flow->sf_acts);
 		rcu_assign_pointer(flow->sf_acts, acts);


