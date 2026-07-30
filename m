Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7D6358373;
	Thu, 30 Jul 2026 15:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426682; cv=none; b=QvW1bRFPHLn1tkxxUuLfQliC7S1MGLuxkKTjqeNnKedlhFcGtcTcXWMQbXj2XiNw3lVibcuxEY3/+JyfDVBX6f+cQfVRP9+5ZP4xxir/NciVSZN2/ziA1zsEc1m6xPhlfnBh5Ler2FkJSzW3DZ3n6jCCRQknRoqND3yuiKjjymI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426682; c=relaxed/simple;
	bh=BJgfClCRpyg7/KZNnuskODvsmvhn8XcpCNL3Pht0F1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYtNvFAO87Qttra8UX5IcGv4IrB4/kZRiLDziWeWEHJTvDCT6okKcJ5LkTrJxKzEWiJwICcfetoAS8xNDZ7SQu6lR4FGtznLKXMuZjydiv6buJmh8wNGh3KLWrL5CCI2RPQyLs+QXBQ5/0RsghYg2TesB4ee5a+0Xh+MV6dzsXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rN60OTeH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rN60OTeH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64101F000E9;
	Thu, 30 Jul 2026 15:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426681;
	bh=fjcCsN80VVzaMm20n0nVlWpw2sIJ6uiKkFUiW9bRYY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rN60OTeHkjw0gx8ck2HI3Itmd8TqIovRFwTTyzCvaYOYojp7oFp7/F+y+nlfA4ptx
	 TwMcrhMtEpdbJohzaRa9H/Ox8U8WVsp5BcAnnVhoEABfuNiBt5UBf9amtHcQoYXlOU
	 H7ZlX/ePxJ/mbYboLbEOxXCt3yb9WFwBNcwg3k4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 504/602] netfilter: nf_conntrack_sip: remove net variable shadowing
Date: Thu, 30 Jul 2026 16:14:56 +0200
Message-ID: <20260730141446.576233380@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 7970d6aaf710db166de98c5356a260089896fae5 ]

net is already set, derived from nf_conn.
I don't see how the device could be living in a different netns
than the conntrack entry.

Remove the extra variable and re-use existing one.

Signed-off-by: Florian Westphal <fw@strlen.de>
Stable-dep-of: e5e24a365a5e ("netfilter: nf_conntrack_sip: validate skb_dst() before accessing it")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_conntrack_sip.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -948,9 +948,8 @@ static int set_expected_rtp_rtcp(struct
 		saddr = &ct->tuplehash[!dir].tuple.src.u3;
 	} else if (sip_external_media) {
 		struct net_device *dev = skb_dst(skb)->dev;
-		struct net *net = dev_net(dev);
-		struct flowi fl;
 		struct dst_entry *dst = NULL;
+		struct flowi fl;
 
 		memset(&fl, 0, sizeof(fl));
 


