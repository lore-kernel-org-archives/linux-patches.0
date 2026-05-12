Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1200D3B1EE2;
	Tue, 12 May 2026 17:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607844; cv=none; b=Ctj3GQ8fWeYcpdinV8+dOdMO6fygKN57MT2ygKR6Mcgsvl5IYBkQbboRpj54ErP2m4xVRgLl6S/5APAR7mZ8NH0wZI+MiXc06CPn7JZKbBpkRoJKjiKqoUYmA2SXZelsI4vMyyVQimTzzWWa7d8+7l6oXDgZVithkIPvYaEnpCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607844; c=relaxed/simple;
	bh=F//neRRDO/IcCfBm1QtUW313jVdel2tcnlPLfk2bTPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KWrLH/iBzldnQPisDfrQk5UL8Y+8DZ6CG5NvsU4AwAy4ihT1CESyHV6BcH096FHfOYtGI4Bxo/kCx2exphrnwjWo4C8SvOb6CxEOa7u0Sc3SQVTTHc/3fvzIkGk8Oc1CTh6GMjG2HgJmwwNmEW3yG7GHS5hE/OHbwIbrGSyGQCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GtDdq3TC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GtDdq3TC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CCB9C2BCB0;
	Tue, 12 May 2026 17:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607844;
	bh=F//neRRDO/IcCfBm1QtUW313jVdel2tcnlPLfk2bTPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GtDdq3TCyat2q9sELUBGWGLl+Ts6ynZV4rrHyTBnbHPHrG6o5Xh2dYE/qz+NLSKY/
	 HI1Y7iyJzB03ke1XIYmZiLxJfOtd7Oo0DiK6EeRbilw7lO55LKIx7Hjkl4jUHuMjF2
	 FwE0QZ8LoNy7YPBp+7gdoFhkGrNEM04BZlv8/qnA=
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
Subject: [PATCH 6.12 055/206] ipv6: xfrm6: release dst on error in xfrm6_rcv_encap()
Date: Tue, 12 May 2026 19:38:27 +0200
Message-ID: <20260512173934.004637834@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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
 


