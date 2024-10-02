Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9F319F411;
	Wed,  2 Oct 2024 14:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878607; cv=none; b=jz8md19wPMkGXKkFBe2c02GHgBPZSiGw4hw7Pr7VaqKcT3KsB6uIuf9VHsjrUuXrelN3bE3hEqnpnwAwGPnL1VXeKbD8EgReDEPjAl6xng2Ts44dGBPRdd9u8Ob6R2O8RI1OzSGAPd4a/1OQbJmZhI9klvqyWL848bP+vl0wFX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878607; c=relaxed/simple;
	bh=vwVP8mgAZBHZzsNnIMvjQgSuPKnnDGe1eA1z3vuyhJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jdm4BHh/PakkucZ7haRQBj389MIG0T193y+8QurAfNreWUQB8i6X77367xFZp482j8HNeX2bqmSoSpD+Zu5LKmID8BRp6NrmdrL5ZBcif+SEhquh8AhvVNnPnfY2FMWz94o7ZgKcEqJdzv9nRZugy19jtWDJpgUjReffieMUSHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hnG7iOIt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hnG7iOIt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74BA6C4CEC2;
	Wed,  2 Oct 2024 14:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878606;
	bh=vwVP8mgAZBHZzsNnIMvjQgSuPKnnDGe1eA1z3vuyhJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hnG7iOIt9GPQDihjmb21Bt8fl+wnw6cleEBJAJ+K6kutrsNV+0m5h7wnNFHWLV0jS
	 iLFhLAbJLCuM7DFJSLZSCT0DDcUhBwIMvnXDVRatvwQvwgVhFHc3OtNXmNeka5ncib
	 9dwme+BXA2WAG8cmNwWiz9q/CNgawdB9a8ksMf0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youssef Samir <quic_yabdulra@quicinc.com>,
	Jeffery Hugo <quic_jhugo@quicinc.com>,
	Carl Vanderlip <quic_carlv@quicinc.com>,
	Chris Lew <quic_clew@quicinc.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 440/634] net: qrtr: Update packets cloning when broadcasting
Date: Wed,  2 Oct 2024 14:59:00 +0200
Message-ID: <20241002125828.470045162@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Youssef Samir <quic_yabdulra@quicinc.com>

[ Upstream commit f011b313e8ebd5b7abd8521b5119aecef403de45 ]

When broadcasting data to multiple nodes via MHI, using skb_clone()
causes all nodes to receive the same header data. This can result in
packets being discarded by endpoints, leading to lost data.

This issue occurs when a socket is closed, and a QRTR_TYPE_DEL_CLIENT
packet is broadcasted. All nodes receive the same destination node ID,
causing the node connected to the client to discard the packet and
remain unaware of the client's deletion.

Replace skb_clone() with pskb_copy(), to create a separate copy of
the header for each sk_buff.

Fixes: bdabad3e363d ("net: Add Qualcomm IPC router")
Signed-off-by: Youssef Samir <quic_yabdulra@quicinc.com>
Reviewed-by: Jeffery Hugo <quic_jhugo@quicinc.com>
Reviewed-by: Carl Vanderlip <quic_carlv@quicinc.com>
Reviewed-by: Chris Lew <quic_clew@quicinc.com>
Link: https://patch.msgid.link/20240916170858.2382247-1-quic_yabdulra@quicinc.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/qrtr/af_qrtr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
index 41ece61eb57ab..00c51cf693f3d 100644
--- a/net/qrtr/af_qrtr.c
+++ b/net/qrtr/af_qrtr.c
@@ -884,7 +884,7 @@ static int qrtr_bcast_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 
 	mutex_lock(&qrtr_node_lock);
 	list_for_each_entry(node, &qrtr_all_nodes, item) {
-		skbn = skb_clone(skb, GFP_KERNEL);
+		skbn = pskb_copy(skb, GFP_KERNEL);
 		if (!skbn)
 			break;
 		skb_set_owner_w(skbn, skb->sk);
-- 
2.43.0



