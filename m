Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629E42512C7;
	Wed,  5 Mar 2025 17:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197347; cv=none; b=H6kTAWS9qa5uUT+907Wy+RGNufztPA+4zDm0hHoV5E9D4iTGmQ2jTKoC9YML8BHz+KVR9mQmuADcu+ZebAAIEa8sXcWVyI0q64PXybW82XK856Kad63bT0cRmI8NuOytcXRXJpQc99hznmoLucizG3bMa3E8y1kVAocsfxPn5+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197347; c=relaxed/simple;
	bh=emvvPD5y2kUFU/ux8cNLylVKglKnrZzkuR4Yasxinms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPtyYbtkkUYqVfMzN/9oB7zWs/Q8kytupk4prDftGRLsvzVFNYxBurkf7tQAMCGsmzB80hcdcZsYSEMRvf/NHnt8kcMnnQ2D4vkVMD8Fq/O1F7C31m51q6kK07YKNWYMzWIXIxJC9vYW3Ie/BPExeLjfRBEr1NCcZWtdbCCv7+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X4+/BQfe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X4+/BQfe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AEAEC4CED1;
	Wed,  5 Mar 2025 17:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197346;
	bh=emvvPD5y2kUFU/ux8cNLylVKglKnrZzkuR4Yasxinms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X4+/BQfevTPWSzuhV6dh2FytRUEyousSD4IbxZ1m4iVaLO0n3LG0cIh/GdBFRAIgd
	 DWUHTIZ/2hj5WlBYktik/kN1dKO8BWZHbM/v7wJ5fOZSD0o0ID470R13VayGWm/mTB
	 n+yOY4eQ0gOk00EB0LOFxC1bB/o6Ybp3N7CNWzTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Guillaume Nault <gnault@redhat.com>,
	Florian Westphal <fw@strlen.de>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 124/176] ipv4: icmp: Pass full DS field to ip_route_input()
Date: Wed,  5 Mar 2025 18:48:13 +0100
Message-ID: <20250305174510.431141912@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 1c6f50b37f711b831d78973dad0df1da99ad0014 ]

Align the ICMP code to other callers of ip_route_input() and pass the
full DS field. In the future this will allow us to perform a route
lookup according to the full DSCP value.

No functional changes intended since the upper DSCP bits are masked when
comparing against the TOS selectors in FIB rules and routes.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Acked-by: Florian Westphal <fw@strlen.de>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20240821125251.1571445-11-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 27843ce6ba3d ("ipvlan: ensure network headers are in skb linear part")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/icmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index b05fa424ad5ce..3807a269e0755 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -550,7 +550,7 @@ static struct rtable *icmp_route_lookup(struct net *net,
 		orefdst = skb_in->_skb_refdst; /* save old refdst */
 		skb_dst_set(skb_in, NULL);
 		err = ip_route_input(skb_in, fl4_dec.daddr, fl4_dec.saddr,
-				     RT_TOS(tos), rt2->dst.dev);
+				     tos, rt2->dst.dev);
 
 		dst_release(&rt2->dst);
 		rt2 = skb_rtable(skb_in);
-- 
2.39.5



