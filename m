Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A9736E467;
	Wed, 30 Sep 2026 19:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795377; cv=none; b=mg3js6H3UjN6slG50lCvxhVYx+PeYofLprTZ40IhWdy4jf3JU/pEQrG1RSXctAIUPtZV5vuO83xcbxnyr2+mAgHzdNCuVGCo/HWHA3YaokaArTpstygljmiDMa+YOP1xsMljfw/grYUDZGlTplptMNbVp6bRjKg5wpS2jlTLM6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795377; c=relaxed/simple;
	bh=6NgzBSVNvBBY/eLALV3Wrvr9EH5VHSEc8tfePWGPAmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZKb3Af9iOdV7DMxfe+sJDrcTL6Z1Twlr/YrSJGUsOrBPeJvXpsFDbrS0TRBiqKpe08nKzra77/yZ0d/mNOFvm/hxUcv/BkrLFWAJID0IHFZ13CZjohDT3+oWhly8YWED0X2RFyHUY+KZeYd79r+Z56SWU/MDnytb1VNQRsv56V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c/IWPZsA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c/IWPZsA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A082E1F000FF;
	Wed, 30 Sep 2026 19:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795376;
	bh=K9mpYl+K3trBIYOs+P+DmqCLSI4+YRH1tRtlrwrwY4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c/IWPZsAC83DWpwBIDA+Y/wTnv49lzf2QmCGWZ1bUoRCv94FKyXHJZXFKo/mrgqLQ
	 kzbTDNjDTVARJ11ivSp0YbGSZ08H+TjGx/alswOk3UiJTjNADzneBQsus8lnG5fNER
	 64GVnPhD52fpwDFAFhKWiEZgfAq9Ho4bPKpZLqVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0540/1193] ipv6: lockless IPV6_MTU implementation
Date: Wed, 30 Sep 2026 17:20:24 +0200
Message-ID: <20260930152446.222907671@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 15f926c4457aa65b1ac83bda1bbdcaad3f48e4e7 ]

np->frag_size can be read/written without holding socket lock.

Add missing annotations and make IPV6_MTU setsockopt() lockless.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 0ae10b6be49b ("net: ipv6: Fix UDP length overflow with PMTU discover and big MTU")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_output.c    |   19 +++++++++++--------
 net/ipv6/ipv6_sockglue.c |   15 +++++++--------
 2 files changed, 18 insertions(+), 16 deletions(-)

--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -906,9 +906,11 @@ int ip6_fragment(struct net *net, struct
 			mtu = IPV6_MIN_MTU;
 	}
 
-	if (np && np->frag_size < mtu) {
-		if (np->frag_size)
-			mtu = np->frag_size;
+	if (np) {
+		u32 frag_size = READ_ONCE(np->frag_size);
+
+		if (frag_size && frag_size < mtu)
+			mtu = frag_size;
 	}
 	if (mtu < hlen + sizeof(struct frag_hdr) + 8)
 		goto fail_toobig;
@@ -1350,7 +1352,7 @@ static int ip6_setup_cork(struct sock *s
 			  struct rt6_info *rt)
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
-	unsigned int mtu;
+	unsigned int mtu, frag_size;
 	struct ipv6_txoptions *nopt, *opt = ipc6->opt;
 
 	/* callers pass dst together with a reference, set it first so
@@ -1399,10 +1401,11 @@ static int ip6_setup_cork(struct sock *s
 	else
 		mtu = np->pmtudisc >= IPV6_PMTUDISC_PROBE ?
 			READ_ONCE(rt->dst.dev->mtu) : dst_mtu(xfrm_dst_path(&rt->dst));
-	if (np->frag_size < mtu) {
-		if (np->frag_size)
-			mtu = np->frag_size;
-	}
+
+	frag_size = READ_ONCE(np->frag_size);
+	if (frag_size && frag_size < mtu)
+		mtu = frag_size;
+
 	cork->base.fragsize = mtu;
 	cork->base.gso_size = ipc6->gso_size;
 	cork->base.tx_flags = 0;
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -440,6 +440,13 @@ int do_ipv6_setsockopt(struct sock *sk,
 		WRITE_ONCE(np->mcast_hops,
 			   val == -1 ? IPV6_DEFAULT_MCASTHOPS : val);
 		return 0;
+	case IPV6_MTU:
+		if (optlen < sizeof(int))
+			return -EINVAL;
+		if (val && val < IPV6_MIN_MTU)
+			return -EINVAL;
+		WRITE_ONCE(np->frag_size, val);
+		return 0;
 	}
 	if (needs_rtnl)
 		rtnl_lock();
@@ -909,14 +916,6 @@ done:
 		np->pmtudisc = val;
 		retv = 0;
 		break;
-	case IPV6_MTU:
-		if (optlen < sizeof(int))
-			goto e_inval;
-		if (val && val < IPV6_MIN_MTU)
-			goto e_inval;
-		np->frag_size = val;
-		retv = 0;
-		break;
 	case IPV6_RECVERR:
 		if (optlen < sizeof(int))
 			goto e_inval;


