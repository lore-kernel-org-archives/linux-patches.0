Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F28B40EB9B;
	Thu, 30 Jul 2026 15:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426768; cv=none; b=hHJHdb+/nmFZYctJyMnu9GUZ7vlUzJS0mulgB5Mihx1RtV3F5uS3EHxnFlYCiHkpnw05zqLA7IVPXFieX7g445l10ujNAlALYzTeS4RFhzxoTza5b9YhuNV35lEjgS64SatWu8gTD6el45YS7R63Xb+Z8SZgYsQsONx3wzf6bcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426768; c=relaxed/simple;
	bh=Hszp5Ihd0uJ5Ai3i6qglhVHrMe1IjuVkVxQNtWRUzS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YXKLt2TZV6hK4bplLB+fMaYQMx/ZHB0To4o8jduatOzb5t6aS9+6jIS8JRgdnseFF24hG+pwGsntzUPr7tXGqGkuNY7xrhRPkQ0ZbnDbRO9VI/yk2lswqK+ayJSh16hNHihsxcyscDf4bbu3Z/ZiRV8gqC6k/hR1G07C8gFuGn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=leicmBOM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="leicmBOM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D29D1F000E9;
	Thu, 30 Jul 2026 15:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426767;
	bh=zduzq953dsxf6387/qdF0dG5VXs2ugVcGFyzFh6jfOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=leicmBOM4EpxSOfnZpyoLAz/si0S07oXuIce15kjdt1MaisuXn/Ert1i0wL7cO7/x
	 MI47a3OEciJN0N3M3VWhNcZSJM1sSKR/CClE1DmHKfFaU+yPDup+Ok+N2o9emEZiLP
	 aLAaUGEoY0uEdXrzG0ojgui4CGac6ATxDXd/Ss/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Qianyu Luo <qianyuluo3@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Eyal Birger <eyal.birger@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 535/602] xfrm: nat_keepalive: avoid double free on send error
Date: Thu, 30 Jul 2026 16:15:27 +0200
Message-ID: <20260730141447.261741745@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Qianyu Luo <qianyuluo3@gmail.com>

[ Upstream commit 226f4a490d1a938fc838d8f8c46a4eca864c0d78 ]

nat_keepalive_send() frees the keepalive skb whenever the IPv4 or IPv6
send helper reports an error.

That cleanup is only correct before the skb is handed to the output
path. Once ip_build_and_send_pkt() or ip6_xmit() takes ownership, the
networking stack may already have consumed the skb before returning an
error, so freeing it again is unsafe.

Handle the pre-handoff failure cases inside nat_keepalive_send_ipv4()
and nat_keepalive_send_ipv6(), where the caller still owns the skb, and
keep nat_keepalive_send() responsible only for family dispatch and the
unsupported-family cleanup path.

Fixes: f531d13bdfe3 ("xfrm: support sending NAT keepalives in ESP in UDP states")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Qianyu Luo <qianyuluo3@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reviewed-by: Eyal Birger <eyal.birger@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_nat_keepalive.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/net/xfrm/xfrm_nat_keepalive.c
+++ b/net/xfrm/xfrm_nat_keepalive.c
@@ -55,8 +55,10 @@ static int nat_keepalive_send_ipv4(struc
 			   ka->encap_sport, sock_net_uid(net, NULL));
 
 	rt = ip_route_output_key(net, &fl4);
-	if (IS_ERR(rt))
+	if (IS_ERR(rt)) {
+		kfree_skb(skb);
 		return PTR_ERR(rt);
+	}
 
 	skb_dst_set(skb, &rt->dst);
 
@@ -101,6 +103,7 @@ static int nat_keepalive_send_ipv6(struc
 	dst = ipv6_stub->ipv6_dst_lookup_flow(net, sk, &fl6, NULL);
 	if (IS_ERR(dst)) {
 		local_unlock_nested_bh(&nat_keepalive_sk_ipv6.bh_lock);
+		kfree_skb(skb);
 		return PTR_ERR(dst);
 	}
 
@@ -118,7 +121,6 @@ static void nat_keepalive_send(struct na
 					sizeof(struct ipv6hdr)) +
 				    sizeof(struct udphdr);
 	const u8 nat_ka_payload = 0xFF;
-	int err = -EAFNOSUPPORT;
 	struct sk_buff *skb;
 	struct udphdr *uh;
 
@@ -140,16 +142,17 @@ static void nat_keepalive_send(struct na
 
 	switch (ka->family) {
 	case AF_INET:
-		err = nat_keepalive_send_ipv4(skb, ka);
+		nat_keepalive_send_ipv4(skb, ka);
 		break;
 #if IS_ENABLED(CONFIG_IPV6)
 	case AF_INET6:
-		err = nat_keepalive_send_ipv6(skb, ka, uh);
+		nat_keepalive_send_ipv6(skb, ka, uh);
 		break;
 #endif
-	}
-	if (err)
+	default:
 		kfree_skb(skb);
+		break;
+	}
 }
 
 struct nat_keepalive_work_ctx {


