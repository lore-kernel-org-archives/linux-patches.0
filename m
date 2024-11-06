Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D571E0B84;
	Wed,  6 Nov 2024 13:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898136; cv=none; b=j1gnb8yu/BK2s9U+etbMpnwblPWBOT1HS2Xl8m+DmHqYF6I6M2Oeb59NPd9f0+I3PLqH0gLOYSb4Av/mbtfe9YJO6TLmmrU5O29ZjJDanjjVTJE0/3N8hUfXupiPuxOagLKkz4HqV9VtYKgPK4V5aqbw8UQQPfYf9Yz/GkGFcb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898136; c=relaxed/simple;
	bh=7x9TDUltnHT2PdpFBK/60ADcz2/z2bv/I7lX+cDHI1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hKy+FA5Dcp5P295PDNhAQxh0qWDesU7kimmkY1Nj/pO5gGVmOe1WrtSXgOGFwUBZgpEqK7hWr2z2cHAJL3JGLbp5MuDao1fX7T2qZCrQTs2cwdiRAHyMyqylotia74YrtkIJlkRoShW3N7IWfHQIZMb/G3I19hSGc1Ryct5htms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VkJP6Jnw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VkJP6Jnw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F13C4CECD;
	Wed,  6 Nov 2024 13:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898136;
	bh=7x9TDUltnHT2PdpFBK/60ADcz2/z2bv/I7lX+cDHI1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VkJP6Jnw7fsccMgyJmJo8/wsIUHeD2UrmwmJKpInQDgJ735nL+v3mAo7bMEIAyyE4
	 nYxM3jcCpB4q5LT5c7rCCCWX/XjMrD7EHE1XtW1gXgzaThWhhq2lUGeqgojkjIFPia
	 beU1ghWlFbDFMN0236s+9Qibf5CyYmrcWgOhg5jw=
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
Subject: [PATCH 5.4 136/462] net: qrtr: Update packets cloning when broadcasting
Date: Wed,  6 Nov 2024 13:00:29 +0100
Message-ID: <20241106120334.866848395@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index b97a786d048cc..2fb510a4124ba 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -711,7 +711,7 @@ static int qrtr_bcast_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 
 	mutex_lock(&qrtr_node_lock);
 	list_for_each_entry(node, &qrtr_all_nodes, item) {
-		skbn = skb_clone(skb, GFP_KERNEL);
+		skbn = pskb_copy(skb, GFP_KERNEL);
 		if (!skbn)
 			break;
 		skb_set_owner_w(skbn, skb->sk);
-- 
2.43.0



