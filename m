Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35EF18DF89;
	Sun,  7 Sep 2025 20:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277035; cv=none; b=CdQ3vuql+FeBS9UGQwi5YSnCHS0+8hkGYEYH//a4aPddK/wJwcySJD6ZYoJDbiWEWGoHt1lXhbKSCzKBK6MRbWqeO/Xc+yWMbfUD4+SLzVbsSv4ayaAkgdTrQVS4Ge6fopCl1igCAKRYkS+x+62Xjvy8x/KTdwP5yl/1BVGKito=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277035; c=relaxed/simple;
	bh=rfThUlZLibanzRcr32pMkI9/DrMv7pRuEM818p1WCps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u4ePQoIXDqTaIKwF8aHd95/+Ikfk+bBUfMLCMPhSUe9IfzWzOIabNLfAh1YprSIyuyMbM2IWyKbX28GlV70EMZ4C4iWOnpLFFs/Z7abx9Dbl2AKo4w417OhzwE4bXIXsn+sMCJJLW/sB26IWqWQEcOcj/c866lPrlACUcyB8YAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cChsM0bQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cChsM0bQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E31AC4CEF0;
	Sun,  7 Sep 2025 20:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277035;
	bh=rfThUlZLibanzRcr32pMkI9/DrMv7pRuEM818p1WCps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cChsM0bQmAvNj2ZdiOLzi9L37ObGxsF70+FTMou3T3+WZ9QJJIoV+XDTZYG4HgAdv
	 PIRyIGgl4hRYEQDQJJxK2+1gV9MpKSaFyjOG5E1XfnzfhlFR+Q6qMGCNv3lyYljUxn
	 7Ra0+zK17Ng2q+3YZPmPuXQY9oBDLO8795ZRRjrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Menglong Dong <dongml2@chinatelecom.cn>,
	Simon Horman <horms@kernel.org>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 064/175] net: tunnel: add pskb_inet_may_pull_reason() helper
Date: Sun,  7 Sep 2025 21:57:39 +0200
Message-ID: <20250907195616.353724182@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Menglong Dong <menglong8.dong@gmail.com>

[ Upstream commit 7f20dbd7de7b9b2804e6bf54b0c22f2bc447cd64 ]

Introduce the function pskb_inet_may_pull_reason() and make
pskb_inet_may_pull a simple inline call to it. The drop reasons of it just
come from pskb_may_pull_reason().

Signed-off-by: Menglong Dong <dongml2@chinatelecom.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 6ead38147ebb ("vxlan: Fix NPD when refreshing an FDB entry with a nexthop object")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip_tunnels.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index 6a070478254d8..ae83a969ae64b 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -439,7 +439,8 @@ int ip_tunnel_encap_del_ops(const struct ip_tunnel_encap_ops *op,
 int ip_tunnel_encap_setup(struct ip_tunnel *t,
 			  struct ip_tunnel_encap *ipencap);
 
-static inline bool pskb_inet_may_pull(struct sk_buff *skb)
+static inline enum skb_drop_reason
+pskb_inet_may_pull_reason(struct sk_buff *skb)
 {
 	int nhlen;
 
@@ -456,7 +457,12 @@ static inline bool pskb_inet_may_pull(struct sk_buff *skb)
 		nhlen = 0;
 	}
 
-	return pskb_network_may_pull(skb, nhlen);
+	return pskb_network_may_pull_reason(skb, nhlen);
+}
+
+static inline bool pskb_inet_may_pull(struct sk_buff *skb)
+{
+	return pskb_inet_may_pull_reason(skb) == SKB_NOT_DROPPED_YET;
 }
 
 /* Variant of pskb_inet_may_pull().
-- 
2.50.1



