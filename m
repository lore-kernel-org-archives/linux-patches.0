Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473B432D42B;
	Sat, 30 May 2026 16:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160351; cv=none; b=OQj947QPOIDwqs49CVPCXD1ADCe2vbiy1f45lCSjE5L6D8FzLcK+yY53pG743PVuaXW37bq40K2sj0FPn3hI47UUZ6Vceam8DCAH61gAJSZ6cVXZAm8Fabay1iPjteg4HW6XgVEKRLb3pqv+btuAxJPc4Zh0vDKFm7gEZY/eo9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160351; c=relaxed/simple;
	bh=BOrmvhGWIvYszLyJ5z+LIyMs/0hdQlBG1ZKPCxdC9Zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qruChhKIgUydE+7nhF8gmmH1q0y4OycG26LRL+gwUMUaLMx6mpj0hF7fAFY2b99epOBLJZ/qqvgfY5OhApAeojCLMlmKF6AiSIAtU3VnfaYRyvqrocuUXJSGJleBQlWs2GXwPHxA9qW4Ect1yWnz82vqopZLOW9Mf4rDiVNQtW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lj07MsHo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lj07MsHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D2C1F00893;
	Sat, 30 May 2026 16:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160350;
	bh=LATBZ1gKDKZpWKFDaAN1cYuRQJQqbRQgfV3QPn9Rp3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lj07MsHoe8frvCM4O8U3D1OqsLLYzbgFHf1HD3rPF5vH1MDlpdhp7gj9coUxSUssA
	 r2MhpCIgzH1deRpOdoNelC4AwieF3po9ryNrEuXpxQeheNCwhwllKtYE1mpwxm1m+N
	 wa5gE+XeYFU7dkg4bgrfc6czlW0B8BqnAzozPStU=
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
Subject: [PATCH 6.1 315/969] ipv6: xfrm6: release dst on error in xfrm6_rcv_encap()
Date: Sat, 30 May 2026 17:57:19 +0200
Message-ID: <20260530160309.108925080@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


