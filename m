Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0CF17E90E;
	Mon, 27 May 2024 19:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836941; cv=none; b=masLrqyCJCIkrszk1LJmRKIziWyt6romRFlxVZmW0V4zYp72+5828kpCMzFLNnCWTsty1O5iWvf1vSMu+hzcqwEQJlsJWYJ646JL8X4QrgtIAYJmmTIGvE1teb5WrxJczhr+jbNep0Xe0+Tr8xrX3CgAin9g3YL20ypdduQJVTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836941; c=relaxed/simple;
	bh=/jw8BuDvZ0MEuOwQyUpQ9K6gfj5ViRvGUuuwIFh99ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WVus19qNM0S6po49u1WIs95hmkI9CfRaSKRlYyZPhRrQKwOuxzIt9cyck6RLjS0RvRLn0Am9h62U/OaRfNm+LFTtEuhK9rzIk8gdiyRequjI1OrkvlD+6cThBPhYyBW1IJnsruxtDNPIu9LCmhfZHgaAS5ctNsFE+Kgzpo2Ghb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uaXlUT2o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uaXlUT2o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBCA8C2BBFC;
	Mon, 27 May 2024 19:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836941;
	bh=/jw8BuDvZ0MEuOwQyUpQ9K6gfj5ViRvGUuuwIFh99ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uaXlUT2o8dG1/nxpyHXfby0CxwQ6WlguHgXcqVx7M650MJSFdZVT+nKCgWOzWuiz5
	 Ch+r8RionE4WHQ2s9N2Ud0KQ2K3rRGHnyEWTIO2SVQpApr2pYA3uoLfYaoZm94Q0qJ
	 I3TiPgl6xlJZdA3JZ0rY4ibTa+6l7lA9imR2tY8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 248/427] ipv6: sr: add missing seg6_local_exit
Date: Mon, 27 May 2024 20:54:55 +0200
Message-ID: <20240527185625.718528142@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 35508abd76f43..5423f1f2aa626 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -564,6 +564,7 @@ void seg6_exit(void)
 	seg6_hmac_exit();
 #endif
 #ifdef CONFIG_IPV6_SEG6_LWTUNNEL
+	seg6_local_exit();
 	seg6_iptunnel_exit();
 #endif
 	unregister_pernet_subsys(&ip6_segments_ops);
-- 
2.43.0



