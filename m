Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0571326296;
	Mon, 14 Oct 2024 15:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918247; cv=none; b=kQ/LyQOeVztvc8murZvAtZXHOnqGbn5GZ/hI6YV5lH1/5Z5T7fsFWlsNeBYPyc50Xj7V6fPNlkvs5YteyknrgzgTaSAs12K7kVzuv1TBBFhVS/qPJhsxv6eRWnx0zK6XwaaGpZidP6ziee2xZJ1aUE7UtkBoLVQ8Hfmp6etQ9q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918247; c=relaxed/simple;
	bh=UwP3ktJBoDfSvi2Dt/grabYw8YzH5I19pGYXFPhF274=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBTd/aSGSPstka3IKQVzjxvvmS+6GSpPF7dXcNDsKcaXuC4kcB1UT6AHTSSK6bjDFxaYkU53ZC5snN2c9bSw/Qh5ZFPQ8lBWbttQpioe09G3rAu3oH6cspe7nj+frR47fQr+biB0mAf8zCjfS0ecMGqdzg78jGijQaZPoNXe3pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vtfcsdc0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vtfcsdc0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65929C4CEC3;
	Mon, 14 Oct 2024 15:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918246;
	bh=UwP3ktJBoDfSvi2Dt/grabYw8YzH5I19pGYXFPhF274=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vtfcsdc0hTOzh0JciXxRA117sNv5gPhX9hFtdz6Emkao8O+sGi75nUyfqgXD1dpGu
	 afH5qqZJFBlAMdSAq53pjBbSlYWiV6VIiR9pHznYdKAwxoI5bMDMnj+98ZGo8WRdc3
	 3UI9tTr7+20hm3a9vReOvV2dltyhayItLjCalp8s=
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
Subject: [PATCH 6.1 267/798] net: qrtr: Update packets cloning when broadcasting
Date: Mon, 14 Oct 2024 16:13:41 +0200
Message-ID: <20241014141228.423714800@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 76f0434d3d06a..a59e1b2fea1c5 100644
--- a/net/qrtr/af_qrtr.c
+++ b/net/qrtr/af_qrtr.c
@@ -879,7 +879,7 @@ static int qrtr_bcast_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 
 	mutex_lock(&qrtr_node_lock);
 	list_for_each_entry(node, &qrtr_all_nodes, item) {
-		skbn = skb_clone(skb, GFP_KERNEL);
+		skbn = pskb_copy(skb, GFP_KERNEL);
 		if (!skbn)
 			break;
 		skb_set_owner_w(skbn, skb->sk);
-- 
2.43.0



