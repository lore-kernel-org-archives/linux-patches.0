Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C888189B94;
	Mon, 23 Dec 2024 16:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969809; cv=none; b=G3GNAdiiSTjVU53BXRAQsoXDk4734gn56ybSjpD0kdvJL50tNyomx8fYZz6bJsZcIVPKUPej1j3IjbgGbT0Vc37W76QMAt4bSCNGaFdRPLEriv8bRyHEq99A+4NidPpeSPUrPiz/uK4SqpAg8GMbjdBXgF7ukADmiYYUltp3Iag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969809; c=relaxed/simple;
	bh=lqe2UNhAhlxgF8C2ddUadycqHv9rUeTBLsAvq/2rRYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qWVVAH2cl1SzsfShG+b5c6xPnVmJEqU9WGPS1OZCphzVj3rAOWCglQ7wBKVuUaSu9MUvXtjyxj/4rtG9Nakfe5k+LV41vo2fsuX8gz1neFQtyb5Oao48rQQMtYH3561nQukhA/Xi3RPVqHIXOm8tbruYvxMj/8An+2E+prI4FIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ygsLhhpM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ygsLhhpM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77975C4CED3;
	Mon, 23 Dec 2024 16:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969809;
	bh=lqe2UNhAhlxgF8C2ddUadycqHv9rUeTBLsAvq/2rRYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ygsLhhpMCYR0DyciV88w1QikldzuezT5KT+ufhqGn9la/tg9RoUlZROdu/V9/ClCV
	 Lpi0N4Xf+gCQ4/+LhT/3rKk7PMJzE9wRSxpFM0X3/lKqneZuxS4Unk8vL3bmzx1RU+
	 7KY2n2yAE/ao/ExuVz3MrIjqbq10/p+nVfjetWgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Moreno <amorenoz@redhat.com>,
	Aaron Conole <aconole@redhat.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 061/160] psample: adjust size if rate_as_probability is set
Date: Mon, 23 Dec 2024 16:57:52 +0100
Message-ID: <20241223155411.032324045@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Adrian Moreno <amorenoz@redhat.com>

[ Upstream commit 5eecd85c77a254a43bde3212da8047b001745c9f ]

If PSAMPLE_ATTR_SAMPLE_PROBABILITY flag is to be sent, the available
size for the packet data has to be adjusted accordingly.

Also, check the error code returned by nla_put_flag.

Fixes: 7b1b2b60c63f ("net: psample: allow using rate as probability")
Signed-off-by: Adrian Moreno <amorenoz@redhat.com>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20241217113739.3929300-1-amorenoz@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/psample/psample.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/psample/psample.c b/net/psample/psample.c
index a0ddae8a65f9..25f92ba0840c 100644
--- a/net/psample/psample.c
+++ b/net/psample/psample.c
@@ -393,7 +393,9 @@ void psample_sample_packet(struct psample_group *group,
 		   nla_total_size_64bit(sizeof(u64)) +	/* timestamp */
 		   nla_total_size(sizeof(u16)) +	/* protocol */
 		   (md->user_cookie_len ?
-		    nla_total_size(md->user_cookie_len) : 0); /* user cookie */
+		    nla_total_size(md->user_cookie_len) : 0) + /* user cookie */
+		   (md->rate_as_probability ?
+		    nla_total_size(0) : 0);	/* rate as probability */
 
 #ifdef CONFIG_INET
 	tun_info = skb_tunnel_info(skb);
@@ -498,8 +500,9 @@ void psample_sample_packet(struct psample_group *group,
 		    md->user_cookie))
 		goto error;
 
-	if (md->rate_as_probability)
-		nla_put_flag(nl_skb, PSAMPLE_ATTR_SAMPLE_PROBABILITY);
+	if (md->rate_as_probability &&
+	    nla_put_flag(nl_skb, PSAMPLE_ATTR_SAMPLE_PROBABILITY))
+		goto error;
 
 	genlmsg_end(nl_skb, data);
 	genlmsg_multicast_netns(&psample_nl_family, group->net, nl_skb, 0,
-- 
2.39.5



