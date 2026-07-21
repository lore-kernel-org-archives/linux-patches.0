Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F7B46EF64;
	Tue, 21 Jul 2026 18:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658897; cv=none; b=u8nmdo/rla64VcnQ4hqMX6JpIbmJAvDlGH51tpfvVs68G4boP3I9/XikvbVemkyrSTxFZ/LEseToZlBF4FMOhxXmSxwWuPnR/I5U5ls7+1qTc5qbwVDV/6skCsUYAPWweTpXARxWkoUXspjpZdaWYVNXrgohyXho44iPHdHjwb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658897; c=relaxed/simple;
	bh=mRGoy2RqiupL9x50/BmEM91Qu2BXPF+4dJxqYHsm60g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tTKRpIzmoyBLOxZBWexAK93KE4tIF2fFV9cV55d+o7hL9O3zzqr2NSRVKWzu1mGisMIC1NQ3P+0w5YUqtiuDyOzSuUN8rCYPkAUFEmoiuYRJSs919VpQRilQK2FFjAlv2jGif6X0xEbTOYu/cvCF6AxC9fkpbX11ahekN04jHE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gsr/0Pn+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gsr/0Pn+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0FBF1F000E9;
	Tue, 21 Jul 2026 18:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658896;
	bh=L5qALKmnPydlxX67yXV2vkPlFfkaaGJkvVIwhFPI7Vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gsr/0Pn+wb31dd+fyRfKz5L6h+GgD5+YIm6neJ3mzCbpcHSYkkK5Y6ZKkZryBAukd
	 fTDMAnV2EgYI6AokSMbmGTkOgJfcpCwOA5JZ+ZK86toaKJ9w9AX4IrUnv/cEG7wjDw
	 Yx0BgB5N3tQ35tfdrRFrOKt+4JRYpj29BxFC/hg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Qianyu Luo <qianyuluo3@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Eyal Birger <eyal.birger@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.18 1317/1611] xfrm: nat_keepalive: avoid double free on send error
Date: Tue, 21 Jul 2026 17:23:53 +0200
Message-ID: <20260721152545.079878236@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qianyu Luo <qianyuluo3@gmail.com>

commit 226f4a490d1a938fc838d8f8c46a4eca864c0d78 upstream.

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


