Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A95A429803;
	Mon, 17 Aug 2026 14:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978080; cv=none; b=BP0YG96vEmtn9Oz0lj2SnvI039ogRdLKvXkwWrupiLr/QPfITND/Sz+TIlWnwkRNQpsQQx0ZG6FFiEEGzmnSJDeRcShD85Rs1ccgdyI0OCIKgajpwc4zGZVDJz+/SC9O6NwOKTy6mQccRenakuDFZbb9zQ0uE24eufDVuggJ/PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978080; c=relaxed/simple;
	bh=R6lsnUSGA298/A4ooeexFB4jautTrmxZqVW9ZOwG+Vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mdhlUDeNEhqzn1OnOHcPfSCwEu4NMWGRPKVAn/BnlLdXB9s0sZ1mJK7ydGK0jFHbifJnVZkdyw66JlkhhjumAMB5Miz+/UpUNHzC3rEay2ZaDtCKxYDmmhETqsi2OPT3BPByjkPWAZl08efblyStoODth2LjBjhpn/VXQZG431g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZgwqYBQH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZgwqYBQH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F8B1F000E9;
	Mon, 17 Aug 2026 14:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978079;
	bh=vKcj8IvJQXWQF2m3nNVa19DG9sfTOLqH3Z5QG2FPBSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZgwqYBQH7ycmPS3YuXL0R0jqjQVEglZYKCnnZwwGAYHdGRzE04qBZipiwWPJeuxZW
	 oYTFtCq8EHoLW7gZd17rpEWIPyBGiGl/UomDNwKErBzFjE17MSjHCJY1FoogQ8hOx0
	 05ILpsqosydS1hXvh/qgYcCJ2Qwnd7fUv6lvdXX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Ilya Maximets <i.maximets@ovn.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 095/181] net: openvswitch: reallocate update replies for mismatched IDs
Date: Mon, 17 Aug 2026 15:33:09 +0200
Message-ID: <20260817132539.196453175@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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
@@ -1083,9 +1083,8 @@ static int ovs_flow_cmd_new(struct sk_bu
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
@@ -1097,6 +1096,30 @@ static int ovs_flow_cmd_new(struct sk_bu
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


