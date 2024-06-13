Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBFBDDB1;
	Thu, 13 Jun 2024 11:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278763; cv=none; b=MxRU2lj8bewmAJx+kTkgSvnpmf6xIBjZpQ20E3kSzLRd/2glj0oXw49XFHostG5PP65L526JcYnRMS6LN/QdouktJhFgDvy2x9jxaO3TiG6YQ4s6ox+JYobVaDhDfAajw/1PcXDKEoiVVK4axh3TO6yKhdpqTmoGqYoSm6yECAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278763; c=relaxed/simple;
	bh=izJtpBk7IXnGxLUfEfodBVVreDmjuh12MUcDsIdX2UY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0s5kto+Aj68lPZ/eIt629STf6SsgwnKBJHXchqlchQHYk5kwbA/Du3Dr8L1Pve2HDsOJsCp+ZJs4JQEBDjluO+pXIqJydVNwx4VxfPpZUMO4uijron1ijPHfckZKWYQB4cwKGo53YBO+W33k8lnBUol1KY488kyVvyRnOq4r/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LaRQLfz4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LaRQLfz4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25CF1C2BBFC;
	Thu, 13 Jun 2024 11:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278763;
	bh=izJtpBk7IXnGxLUfEfodBVVreDmjuh12MUcDsIdX2UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LaRQLfz492CY6RyUS4eSom6ZOkP6WTw5hGZeBe+Hz8e9hq5kkP9elrSLy7ag4Am1A
	 AeKSwqTim1fII/vKahs/R+LqyOHW6QLFCCZX16YPfokZUpr5BDfB982F+mL+dLFtc1
	 oqkLLq4ojOCkcm8lHV2llS08LlPNu2A+cICP1U6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 062/213] ipv6: sr: add missing seg6_local_exit
Date: Thu, 13 Jun 2024 13:31:50 +0200
Message-ID: <20240613113230.402497377@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 4bd601c964343..42ff4f421d42a 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -497,6 +497,7 @@ void seg6_exit(void)
 	seg6_hmac_exit();
 #endif
 #ifdef CONFIG_IPV6_SEG6_LWTUNNEL
+	seg6_local_exit();
 	seg6_iptunnel_exit();
 #endif
 	unregister_pernet_subsys(&ip6_segments_ops);
-- 
2.43.0



