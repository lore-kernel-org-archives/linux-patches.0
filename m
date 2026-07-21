Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84EA4417D67;
	Tue, 21 Jul 2026 19:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661241; cv=none; b=e/waZIiilj6ev1AQVbQjwCL6/i/PUWQAR8CpedQqvd2Mr9DEUHlOFE3pGia2H8HuuTNGBxWZlVo/WHzoVracoVOqwYwxCp/nzVdtb7PLUR52ihjlqf65kJmVmW9jrCmK9eWfeN4jl3eZwOYE69AbzKNkQPebWb9iQYdXQVzSw4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661241; c=relaxed/simple;
	bh=1z+8X/Bfi/hTgkelSUnWVMSY0jZfFSbkjabbw5xuvQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/RVEy1eFKIJ0scAfHutGf7F6VZoQ4e45Lco8emqqBcNP0zWbQPlAYJw+dR0XQf3TPvSP9vOTZY+ArMSg1WCbn/L/41K6EZQzoKTYltDdX+ILN8b1N1PQg/Xn8A24WGrpR5vknZRQm78SrONareQDyTIaRVmuDbOU/uU/4BZbV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F8zO2F+4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F8zO2F+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB7231F000E9;
	Tue, 21 Jul 2026 19:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661240;
	bh=24iEizFDyiBdr1uPf0tfcHpnPk2wLgdUtegjzs4zWnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F8zO2F+4aJSYUCfoh5g0xNPMpU57PMJk1uPQSLEGl6DyVxBk1pAFtALUNeHHpobBW
	 gAj2Anp06xddBeagORehbL1XSJ35oPtas9CDWb6iRNEFQazqGaH1FWGws9+1SudXim
	 U4KcTYRki0uUOrOoiylR5AZ0wn/IKEcMZfHb1niU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Xiang Mei <xmei5@asu.edu>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Weiming Shi <bestswngs@gmail.com>
Subject: [PATCH 7.1 1282/2077] geneve: validate inner network offset in geneve_gro_complete()
Date: Tue, 21 Jul 2026 17:15:55 +0200
Message-ID: <20260721152623.054061662@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit cbb0d30a1ad6fc9439b1dc9b4f5a7a9140d3b11f ]

Even with both paths gated on gs->gro_hint, geneve_gro_complete()
re-derives the inner dispatch type and length from the packet and the
current gs->gro_hint, independently of geneve_gro_receive(). The two can
disagree if gs->gro_hint flips under a concurrent geneve_quiesce()/
geneve_unquiesce() (sk_user_data is NULL across a synchronize_net()), or if
the re-read option bytes differ from the ones receive parsed.

geneve_gro_receive() already records the inner network header position in
NAPI_GRO_CB()->inner_network_offset. Have geneve_gro_complete() compute the
offset it is about to dispatch at, adding ETH_HLEN in the ETH_P_TEB case
where eth_gro_complete() steps over the inner MAC header, and bail out if
it lands past inner_network_offset.

Use a lower bound rather than exact equality: between gh_len and the inner
L3 header, geneve_gro_receive() may also have pulled an inner VLAN tag
(vlan_gro_receive() advances the recorded offset past it), which only moves
inner_network_offset further out. A valid frame therefore always satisfies
inner_nh <= inner_network_offset, while a gh_len inflated by a hint
gro_receive() did not honour dispatches past the validated inner header,
i.e. the out-of-bounds completion. Only the latter is rejected.

Fixes: fd0dd796576e ("geneve: use GRO hint option in the RX path")
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Co-developed-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Link: https://patch.msgid.link/20260618032622.484720-2-xmei5@asu.edu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/geneve.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index a48f6c52f12695..c760c0655c8a16 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -956,6 +956,20 @@ static int geneve_gro_complete(struct sock *sk, struct sk_buff *skb,
 	type = gh->proto_type;
 	geneve_sk_gro_hint_off(sk, gh, &type, &gh_len);
 
+	/* Bail out if we are about to dispatch past the inner network header
+	 * gro_receive() validated. An inner VLAN tag only pushes
+	 * inner_network_offset out, so use a lower bound.
+	 */
+	if (skb->encapsulation) {
+		unsigned int inner_nh = nhoff + gh_len;
+
+		if (type == htons(ETH_P_TEB))
+			inner_nh += ETH_HLEN;
+
+		if (unlikely(inner_nh > NAPI_GRO_CB(skb)->inner_network_offset))
+			return -EINVAL;
+	}
+
 	/* since skb->encapsulation is set, eth_gro_complete() sets the inner mac header */
 	if (likely(type == htons(ETH_P_TEB)))
 		return eth_gro_complete(skb, nhoff + gh_len);
-- 
2.53.0



