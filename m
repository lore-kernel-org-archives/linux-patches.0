Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB2F1D12F5;
	Wed,  2 Oct 2024 14:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879294; cv=none; b=uWpoaBpiQkMfGprjtyMBBtnBCvYn6350KOqqyvSD7zFtoGqh5Nq3NUugyTmloVJdFtkyX+ABfvTkNsQjeiF4ylCQakWIE5wAJq9WnvJRLWaDAvkSJDyQ6hALPBTBVa0Lc1NLFk+NDDI6AjD2ysUBnu2Rcwpx9gCZwSHLMHFxyfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879294; c=relaxed/simple;
	bh=FSC/7kx71DN8eBELyHK3yATj+s4WD0AIG24baxpyh5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZkeYfrYqRSojPMYX2vxjSk3ckNXmYCayku5t4R2gjBd0s2pwylcrys34pF2rvh+K2OVsYgKS6QW+nZE/TGVy0d7/ZlbRZfrjV1VQVHkpBbOpmkdiwFs1eXeo1ZIrkmAwYTiNapL585v0rjtt0OMcJsy4Cispgqry11YG1I6cVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ySbzCvWn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ySbzCvWn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C68F5C4CEC2;
	Wed,  2 Oct 2024 14:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879294;
	bh=FSC/7kx71DN8eBELyHK3yATj+s4WD0AIG24baxpyh5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ySbzCvWnof4MWE3bLypS6aADwEzQvqRO8w4qeQQKpqGqi64VaDZMgB2+UDSZE+aUC
	 BOjvmqfogYsWSDHq0UQmB2CNZ3O4YN/EgydncRQ9R2gYsCFeFb9gw5gFgvl4yaDihh
	 2gmcdVJ5hes8bIRSL33uIgzI8WRt3fDuHHOyCS9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 070/538] bareudp: Pull inner IP header on xmit.
Date: Wed,  2 Oct 2024 14:55:09 +0200
Message-ID: <20241002125754.977277460@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit c471236b2359e6b27388475dd04fff0a5e2bf922 ]

Both bareudp_xmit_skb() and bareudp6_xmit_skb() read their skb's inner
IP header to get its ECN value (with ip_tunnel_ecn_encap()). Therefore
we need to ensure that the inner IP header is part of the skb's linear
data.

Fixes: 571912c69f0e ("net: UDP tunnel encapsulation module for tunnelling different protocols like MPLS, IP, NSH etc.")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/267328222f0a11519c6de04c640a4f87a38ea9ed.1726046181.git.gnault@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bareudp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index d0759d8bf7305..54767154de265 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -319,6 +319,9 @@ static int bareudp_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	__be32 saddr;
 	int err;
 
+	if (!skb_vlan_inet_prepare(skb, skb->protocol != htons(ETH_P_TEB)))
+		return -EINVAL;
+
 	if (!sock)
 		return -ESHUTDOWN;
 
@@ -382,6 +385,9 @@ static int bareudp6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	__be16 sport;
 	int err;
 
+	if (!skb_vlan_inet_prepare(skb, skb->protocol != htons(ETH_P_TEB)))
+		return -EINVAL;
+
 	if (!sock)
 		return -ESHUTDOWN;
 
-- 
2.43.0



