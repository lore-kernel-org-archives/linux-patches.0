Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B015130EF7D;
	Sat, 30 May 2026 17:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163582; cv=none; b=pQyVyrVAdZhQqBL6hmvth2E8Yaei9PFjdwIhwnImv1bT/ukL6DIzkQbPuSzDpIDuDle3KJP+I+V5tLUavSOS/MTu9fzhNLeWnyxtWRz/LeNa0Xso6ln/y80dyEhSCyHVO/+d2gchY3JIvfJHSDlHGNXSTf1Gw7Mbq01j0v+mVkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163582; c=relaxed/simple;
	bh=R6WwY8n+qNtKbwDblf4+E7w5nNl6ILxeoiCDEokJJI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V4OD9ztohHtm8Esvi16YwlWpAIuTrz3uudFzLCs2qhZJHbKtGrpIru8Dc+z6KVOn/WHeTOtsAojQuGWWYle+B/MWkTytAJoceYJUTPVR9a+o17Cg2bDwytylclVCi+fpF9eCiATlDpXxWEFk7kFxtLDRtjU//xTP/b/JVWy1J5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VN6FS4DH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VN6FS4DH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F127F1F00893;
	Sat, 30 May 2026 17:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163581;
	bh=mkNt0u6virv9pcKv776FW0RYRCNO9jph9xTdlkwQzyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VN6FS4DHBrBgGayNBB0exQcocH+2Ske/cR3DjHOUBaPNDKmcIOFChqMbEYQ43VaR5
	 1MQASv8BkuBAZUxpSVl2XzC/oUlsdNs+u9wG7tOuRi/ZpPFTbwk1Be19C1qvpmquEg
	 i4ELzqyjPzW+kYKvBh+pYp0dsol1MVIqLoSu//TA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Ruide Cao <caoruide123@gmail.com>,
	Yilin Zhu <zylzyl2333@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.15 302/776] ipv6: xfrm6: release dst on error in xfrm6_rcv_encap()
Date: Sat, 30 May 2026 18:00:16 +0200
Message-ID: <20260530160248.371539347@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Yilin Zhu <zylzyl2333@gmail.com>

commit bc0fcb9823cd0894934cf968b525c575833d7078 upstream.

xfrm6_rcv_encap() performs an IPv6 route lookup when the skb does not
already have a dst attached. ip6_route_input_lookup() returns a
referenced dst entry even when the lookup resolves to an error route.

If dst->error is set, xfrm6_rcv_encap() drops the skb without attaching
the dst to the skb and without releasing the reference returned by the
lookup. Repeated packets hitting this path therefore leak dst entries.

Release the dst before jumping to the drop path.

Fixes: 0146dca70b87 ("xfrm: add support for UDPv6 encapsulation of ESP")
Cc: stable@kernel.org
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Tested-by: Ruide Cao <caoruide123@gmail.com>
Signed-off-by: Yilin Zhu <zylzyl2333@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/xfrm6_protocol.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ipv6/xfrm6_protocol.c
+++ b/net/ipv6/xfrm6_protocol.c
@@ -88,8 +88,10 @@ int xfrm6_rcv_encap(struct sk_buff *skb,
 
 		dst = ip6_route_input_lookup(dev_net(skb->dev), skb->dev, &fl6,
 					     skb, flags);
-		if (dst->error)
+		if (dst->error) {
+			dst_release(dst);
 			goto drop;
+		}
 		skb_dst_set(skb, dst);
 	}
 


