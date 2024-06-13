Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09EBE384;
	Thu, 13 Jun 2024 12:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281983; cv=none; b=PbF9PLesBeriBGgV12C+ytmlKM4h9lcmcbiJ67iFh+9MXGPO58SV5JsCvjkvSZ1C9+qjTpaD7FjRINiIfXPhyAiYbhbcxu5g6CzpT9GUjuLfv9b0TxCgz6dsSo4eTzEq1sgavHwgNiT6R0OhX5B4e4yl02xXUt+vSCxO79BiTPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281983; c=relaxed/simple;
	bh=WKuTV4Y0lmpZEaVx+WbsP2M77t/pxJARSXqOij8JDJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EFNBqQIBjoNatUcfCamkkdtnUmSFUjTBOiSuPNLo/cRC1fPV2dG90DMCWDAlrOHLiYw/UBmCu6U6ho/uh591WT67amE8gNhSF8QsQ1Ax8ATEaXIQ5X0IG9XcUcez2f1TrYIU2usIN2NAFslG0aGp0xH/L2xCUId6e44OhX7Tykw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TKCknBUL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TKCknBUL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF6BC2BBFC;
	Thu, 13 Jun 2024 12:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281982;
	bh=WKuTV4Y0lmpZEaVx+WbsP2M77t/pxJARSXqOij8JDJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TKCknBULWJdEEdkKgoJUVL/NX97z5Nw5tjd9dR+futAMMQ4t4Nu+ENCxrXmTozDG+
	 K8vBrw24PPH7MnsIY4PlRnbvqZ5IPxNdNYpuN/zFdBZVazDcsayy7BzEN3Xz2umewi
	 NeIaN6eu4JKoR5tkVbdAmTeGFag/XEaWNEWq8lM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 115/402] ipv6: sr: add missing seg6_local_exit
Date: Thu, 13 Jun 2024 13:31:12 +0200
Message-ID: <20240613113306.618351884@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 3321687e321307629c71b664225b861ebf3e5753 ]

Currently, we only call seg6_local_exit() in seg6_init() if
seg6_local_init() failed. But forgot to call it in seg6_exit().

Fixes: d1df6fd8a1d2 ("ipv6: sr: define core operations for seg6local lightweight tunnel")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20240509131812.1662197-2-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/seg6.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index dc434e4ee6d66..d626e0767a069 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -559,6 +559,7 @@ void seg6_exit(void)
 	seg6_hmac_exit();
 #endif
 #ifdef CONFIG_IPV6_SEG6_LWTUNNEL
+	seg6_local_exit();
 	seg6_iptunnel_exit();
 #endif
 	unregister_pernet_subsys(&ip6_segments_ops);
-- 
2.43.0



