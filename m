Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F25233D65;
	Mon, 10 Mar 2025 17:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627657; cv=none; b=THETCXPOVyxF3JcQQJcQ0LpHaHTDiUKtyeIeycMoFoViiOxlR9GH6O97nbTIg5bd4P42YjZJ8l6Cuy+CcglF4ifGWAVPU/wHOqbM+8EDe06W1qVQO8b0uQY1O6BbqlnyZCE9Gd2e7bC15cz0EbMmone9UzkhVSwtp/guOA4MDgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627657; c=relaxed/simple;
	bh=sosTkotJJ5064k4WfrTDHsWunOYs9J0W0rdlfpKH7as=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+kGZWAKSPKNIYcWS6MfBAAELCiLrjG8lernyYovG47KMYn9on42d/XwIQGulI2GXczkD+O04AaQ3uwv1Pb5MJnpZXMauaX0GoorRqrGL9lyHVkPxJi2hSMBBk6kEsUbKR0TOBBLC1hXROOQlimPzDhB8545oH0TPfwBzp59aT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qSfvHjmH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qSfvHjmH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B00CC4CEEE;
	Mon, 10 Mar 2025 17:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627656;
	bh=sosTkotJJ5064k4WfrTDHsWunOYs9J0W0rdlfpKH7as=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qSfvHjmH5+855FfrM3ftJcKNbPSl83yTBELvTkPHBfUXug/AkJEzWDAxbRGGmTEq6
	 GyYSlr8QikQVI3Q2EoGzY4P2kmFc1uk6ZUc1oT2k8c0xhl30V5vM5G0GeX4WPo61Qz
	 B5UqLJFPG8Opu8RZlNMXMHotXPN/kFQ0y4oTspgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Herbert <tom@herbertland.com>,
	Justin Iurman <justin.iurman@uliege.be>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 204/269] net: ipv6: fix missing dst ref drop in ila lwtunnel
Date: Mon, 10 Mar 2025 18:05:57 +0100
Message-ID: <20250310170505.828382668@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

From: Justin Iurman <justin.iurman@uliege.be>

[ Upstream commit 5da15a9c11c1c47ef573e6805b60a7d8a1687a2a ]

Add missing skb_dst_drop() to drop reference to the old dst before
adding the new dst to the skb.

Fixes: 79ff2fc31e0f ("ila: Cache a route to translated address")
Cc: Tom Herbert <tom@herbertland.com>
Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
Link: https://patch.msgid.link/20250305081655.19032-1-justin.iurman@uliege.be
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ila/ila_lwt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/ila/ila_lwt.c b/net/ipv6/ila/ila_lwt.c
index ac4bcc623603a..7d574f5132e2f 100644
--- a/net/ipv6/ila/ila_lwt.c
+++ b/net/ipv6/ila/ila_lwt.c
@@ -96,6 +96,7 @@ static int ila_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 		}
 	}
 
+	skb_dst_drop(skb);
 	skb_dst_set(skb, dst);
 	return dst_output(net, sk, skb);
 
-- 
2.39.5



