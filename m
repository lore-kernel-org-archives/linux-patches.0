Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E056B36D4E1;
	Wed, 30 Sep 2026 18:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791680; cv=none; b=Yx+rZZ4kwokFy1cTBZQuRMu1GgLOQOCXnSgNePJe9j/0rG1w+ZnHfaf/+xq66MAMzVXHrhV0yPwb9A/0HsLnMgGS14W5uoa5XPJyNzT1F+Mab0HdITneeTl0jcS2lwQD3vCXa+UWxkZAn3/D9cBjMnaguMmcjWhzDH9GuD1fw8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791680; c=relaxed/simple;
	bh=hA3zAzbfshLLUKS5GS3KV4xhh1ZpAgotZCnPdfBCoqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T1YrHt83ll+H/I0DlO1l7uA7MXTqESkfEkpNMyOZltpsG7i24/2nhZB1MpWizc+nSC1GeMkHeywcZlftjETQV+5UzLy7E09NeIX+jaJN5vJQ6mumgbVoqiuna9esyVXXMX9H+yTwH7lk0Hz4YrXttl0pK0rgB9/fThJyTFtP4+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dPkR8Rz7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dPkR8Rz7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB361F000FF;
	Wed, 30 Sep 2026 18:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791678;
	bh=ZwoTRJ+bmCSmYeop7qsowIH4tbt2jRnHTm2xYha5H3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dPkR8Rz7izJCCNpjNKSapJ3d8rCVQzVQ74/OvukaHd+2jVkV6gatreLU4UhtertQN
	 d78G8oJYYgcgeclX5kR36SXmZAhJr2aCfkzAI8oeZ8qqzawHBzsGRkMQfOSudTQ1Wr
	 8tfsrFV4HurN67E/Ye2MYpgtp5IlLoafLoHmpiDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fourie Zhang <fouriezhang@tencent.com>,
	Jiri Benc <jbenc@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 387/752] net: mpls: clear inner_protocol when the last label is popped
Date: Wed, 30 Sep 2026 17:24:17 +0200
Message-ID: <20260930152406.651410971@linuxfoundation.org>
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

From: Fourie Zhang <littleddfu@gmail.com>

commit 78a86d75a70e1e227711c72865c59b1422d0a5ae upstream.

skb_mpls_push() records the pre-encapsulation network header once, gated
on !skb->inner_protocol. skb_mpls_pop() never clears that record, so it
outlives the encapsulation it describes.

Open vSwitch can then re-push MPLS onto a packet whose
inner_network_header still points at the older, deeper offset: push a
label, pop every label, recirculate (ovs_flow_key_update() re-derives
key->eth.type and resets network_header, but leaves inner_*), then push
again. ovs_fragment() trusts the record:

	skb->network_header = skb->inner_network_header;

so skb_network_offset() goes negative. The bound check is signed:

	if (skb_network_offset(skb) > MAX_L2_LEN)

a negative offset passes it, and prepare_frag() widens the value:

	unsigned int hlen = skb_network_offset(skb);
	memcpy(&data->l2_data, skb->data, hlen);

which is a ~4GiB memcpy out of a 30-byte per-CPU buffer.

Reproduced on v7.3-rc1. RDX is the truncated length, (unsigned int)(-8):

  BUG: unable to handle page fault for address: ffffe8ffffc16000
  #PF: supervisor write access in kernel mode
  Oops: 0002 [#1] SMP KASAN NOPTI
  RIP: 0010:memcpy+0x8/0x20
  RDX: 00000000fffffff8 RSI: ffff888105d732db RDI: ffffe8ffffc16000
   prepare_frag+0x3df/0x4e0
   ovs_fragment+0x589/0x7e0
   do_output+0x4ce/0x5e0
   do_execute_actions+0x55d2/0x7b30
   ovs_execute_actions+0xea/0x450

Same root-cause shape as commit 975b5b067f52 ("ipv6: sr: restore network
header before routing and forwarding"): a stale network header offset
reaching a consumer that widens it. Here it originates in the MPLS
push/pop path.

Clear inner_protocol once the packet is no longer MPLS, so a later push
re-records the current header. net/sched/act_mpls.c is the only other
skb_mpls_pop() caller and gets the same fix; sch_frag.c saves and
restores inner_protocol around fragmentation in the same way OVS does.

Fixes: 48d2ab609b6b ("net: mpls: Fixups for GSO")
Cc: stable@vger.kernel.org
Signed-off-by: Fourie Zhang <fouriezhang@tencent.com>
Acked-by: Jiri Benc <jbenc@redhat.com>
Link: https://patch.msgid.link/20260902092719.2874481-1-fouriezhang@tencent.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6096,6 +6096,13 @@ int skb_mpls_pop(struct sk_buff *skb, __
 	}
 	skb->protocol = next_proto;
 
+	/* The last label is gone, so the inner header recorded by
+	 * skb_mpls_push() no longer describes this packet. Drop it, or a
+	 * later push keeps the stale offset.
+	 */
+	if (!eth_p_mpls(next_proto))
+		skb->inner_protocol = 0;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(skb_mpls_pop);


