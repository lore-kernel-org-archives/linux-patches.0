Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C080B1C57B2;
	Mon, 10 Mar 2025 18:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630708; cv=none; b=OTovD3dlICewoG79ixy89XaMbdlIzD9aiG1neIa2S55FkDGKFkK3shQTGEHOHcmEcjUpI60mYIx1+811s+Hg3BzSFmriuJiLMO/B0S+8Ivq99ykKfbbra8FdNZeSI9EUo/W14ksURAgAJXM3F9A1ZiN0vB0ebnClvzYa20n7oZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630708; c=relaxed/simple;
	bh=hFtAuxAX/I/FJ463G6SnkHKWGrW/dBPO5xImGJEGrS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vj3h9jOYKdFgREzr7uzRdo0EsP3JDLI/v7jy0wRTn8Fcy7Wd20yj68eSw5VjDlxnjBjMgc8qJActfIGZg5r6ZLV9SUWfPC15R+b3uHWcAMVa/+vDhGrdzurhYeBsiOKbxHGYCVEzog6u+4NzHQxTGdcVaJXaRCu/RrWqnkSqgFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BMMDdbuO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BMMDdbuO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE31EC4CEE5;
	Mon, 10 Mar 2025 18:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630708;
	bh=hFtAuxAX/I/FJ463G6SnkHKWGrW/dBPO5xImGJEGrS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BMMDdbuO6RbUoMQ6LRcqbGk6jsmu3qAVPHUeQaTATh/aoYiUlem4JNV+uumsXn2Yz
	 uDbYBnqr06Ozwb6rjCQPSI3GHM6WB1NuHn2E8lgmbkbHEv6VsdS3k/AfaKcWMpkdY4
	 wVaHGciYqf9aqWrQ0KPbzk7a1EzOY3InadPjXZOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	Anton Makarov <anton.makarov11235@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 507/620] seg6: add support for SRv6 H.L2Encaps.Red behavior
Date: Mon, 10 Mar 2025 18:05:53 +0100
Message-ID: <20250310170605.572220715@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Mayer <andrea.mayer@uniroma2.it>

[ Upstream commit 13f0296be8ece1189cbc4383a45ba97cafaecc09 ]

The SRv6 H.L2Encaps.Red behavior described in [1] is an optimization of
the SRv6 H.L2Encaps behavior [2].

H.L2Encaps.Red reduces the length of the SRH by excluding the first
segment (SID) in the SRH of the pushed IPv6 header. The first SID is
only placed in the IPv6 Destination Address field of the pushed IPv6
header.
When the SRv6 Policy only contains one SID the SRH is omitted, unless
there is an HMAC TLV to be carried.

[1] - https://datatracker.ietf.org/doc/html/rfc8986#section-5.4
[2] - https://datatracker.ietf.org/doc/html/rfc8986#section-5.3

Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Signed-off-by: Anton Makarov <anton.makarov11235@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: c64a0727f9b1 ("net: ipv6: fix dst ref loop on input in seg6 lwt")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/seg6_iptunnel.h |  1 +
 net/ipv6/seg6_iptunnel.c           | 12 +++++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/seg6_iptunnel.h b/include/uapi/linux/seg6_iptunnel.h
index 538152a7b2c3f..a9fa777f16de4 100644
--- a/include/uapi/linux/seg6_iptunnel.h
+++ b/include/uapi/linux/seg6_iptunnel.h
@@ -36,6 +36,7 @@ enum {
 	SEG6_IPTUN_MODE_ENCAP,
 	SEG6_IPTUN_MODE_L2ENCAP,
 	SEG6_IPTUN_MODE_ENCAP_RED,
+	SEG6_IPTUN_MODE_L2ENCAP_RED,
 };
 
 #endif
diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index 0e4b11d190be3..ae5299c277bcf 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -40,6 +40,7 @@ static size_t seg6_lwt_headroom(struct seg6_iptunnel_encap *tuninfo)
 		head = sizeof(struct ipv6hdr);
 		break;
 	case SEG6_IPTUN_MODE_L2ENCAP:
+	case SEG6_IPTUN_MODE_L2ENCAP_RED:
 		return 0;
 	}
 
@@ -413,6 +414,7 @@ static int seg6_do_srh(struct sk_buff *skb)
 		skb->protocol = htons(ETH_P_IPV6);
 		break;
 	case SEG6_IPTUN_MODE_L2ENCAP:
+	case SEG6_IPTUN_MODE_L2ENCAP_RED:
 		if (!skb_mac_header_was_set(skb))
 			return -EINVAL;
 
@@ -422,7 +424,13 @@ static int seg6_do_srh(struct sk_buff *skb)
 		skb_mac_header_rebuild(skb);
 		skb_push(skb, skb->mac_len);
 
-		err = seg6_do_srh_encap(skb, tinfo->srh, IPPROTO_ETHERNET);
+		if (tinfo->mode == SEG6_IPTUN_MODE_L2ENCAP)
+			err = seg6_do_srh_encap(skb, tinfo->srh,
+						IPPROTO_ETHERNET);
+		else
+			err = seg6_do_srh_encap_red(skb, tinfo->srh,
+						    IPPROTO_ETHERNET);
+
 		if (err)
 			return err;
 
@@ -642,6 +650,8 @@ static int seg6_build_state(struct net *net, struct nlattr *nla,
 		break;
 	case SEG6_IPTUN_MODE_ENCAP_RED:
 		break;
+	case SEG6_IPTUN_MODE_L2ENCAP_RED:
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
2.39.5



