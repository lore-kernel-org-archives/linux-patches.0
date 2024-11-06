Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F23D1D5AD7;
	Wed,  6 Nov 2024 12:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895095; cv=none; b=LnDtep4gKFByRy9fbL2XQBdADXZhFzXeeFgNvsTATgwiXfb57eM0UyVgSupuBUqCwSuy0tKNEVX2304Xir/wMBYpSSQqSKuVjml+thY+E+4yL4mkySaNEvK8X5tCkvr3VmIv/y/nOnDGHYW1XbgiCxYnAuajefMophYw1LlsWLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895095; c=relaxed/simple;
	bh=/boesxifv2ikMLdW8ANrTha/pucyNhKEoaBOWkWgiOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lMA80xdabvRWxwvhmzZ4aHTu68ylrjty2ABEfE2LKuV3bK9nkTCzv87BKbi67SqLGzRiNhfrSH7ZVjq/VM8KABeR89FsZrjGbksyTm7+5h4fWWy5R0tpvQI/HamghRbrBu3IO/h772KZCknJX4SkxZNCm2sh4vif2ZUhfN9CGSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SlLhingj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SlLhingj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9989C4CECD;
	Wed,  6 Nov 2024 12:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895095;
	bh=/boesxifv2ikMLdW8ANrTha/pucyNhKEoaBOWkWgiOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SlLhingjUvBg5rZxPS4fA1o691zBOlt16265THsu71kcA7DkDX6i0dISaVNefG41q
	 G4+4SvhBRu1AF0UgLmgTPwiK9Sw28+zCneaiqfmM7WCuN1DjiodqhomLdKNc/ACSNb
	 47DoEymbSfEXfCgpS2Hzl8piydnABlQrUnBoCVZY=
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
Subject: [PATCH 4.19 104/350] net: qrtr: Update packets cloning when broadcasting
Date: Wed,  6 Nov 2024 13:00:32 +0100
Message-ID: <20241106120323.471549041@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
 net/qrtr/qrtr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 128d0a48478d1..890a8fe51a9af 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -718,7 +718,7 @@ static int qrtr_bcast_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 
 	mutex_lock(&qrtr_node_lock);
 	list_for_each_entry(node, &qrtr_all_nodes, item) {
-		skbn = skb_clone(skb, GFP_KERNEL);
+		skbn = pskb_copy(skb, GFP_KERNEL);
 		if (!skbn)
 			break;
 		skb_set_owner_w(skbn, skb->sk);
-- 
2.43.0



