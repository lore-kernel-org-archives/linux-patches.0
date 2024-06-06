Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F0D1AC246;
	Thu,  6 Jun 2024 14:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683308; cv=none; b=o6Jyndcd+cUNWbsPf3liA5+1wkz95uXymvVss69/eJBnf4x+2DE6hpeOkKS2f+c9ZDLfcutf4ReaKWdFOuIM7HcAvk1QsJQFT5IiPcVJfZwTTdsRbcei4taB96VMSABCB3+xOAlKTTfbKnBCh4Pd43bqZAzFJ+x313FGay4vAKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683308; c=relaxed/simple;
	bh=+Wjw8okDf8mPEGPswjBhS0HQ3LdrKEdBjogTMxeMFNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9R56YQ65iIbJtlfya2pv19M5mYDmaPRdYP2lNPquFgyKgDdLU80QfylqaRBn4ZPXrtjghrdtNo4WNeP31Fma3DZxOGKj0MIu23OHGXz7U6WPDC8n96EgL/WynBUsXkGmAKrE79fSAThcd+KEcTm/CEtV10yJq6yQy3N14mRW8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2iBK+YGu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2iBK+YGu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979C7C32781;
	Thu,  6 Jun 2024 14:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683308;
	bh=+Wjw8okDf8mPEGPswjBhS0HQ3LdrKEdBjogTMxeMFNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2iBK+YGuBaBj82XOaZFwvRb4uwK4HyGQWUTeAZycIFgcspvRPIO5+mFAaZcM3fvDw
	 H4HKQ1s0Rj5274FfK++SqBflyZBOV95cR5Iy3uRWHz5E7ZlDBn9h7E3UoECJ3WUZ3V
	 naA8rE7FUHBA1Ursr2Ud45PZjZUx6wJl7nxbLBdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 175/473] ipv6: sr: add missing seg6_local_exit
Date: Thu,  6 Jun 2024 16:01:44 +0200
Message-ID: <20240606131705.718112412@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



