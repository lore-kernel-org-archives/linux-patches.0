Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1D31C08
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 14:56:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA52C4339E;
	Mon, 20 Mar 2023 14:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324196;
	bh=a1KPJkflHWD0JIEyXxwWbSMNHI7iIWc1mdqqOdskrG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CgnYKMwcXU2Rc4t04KFZh6j2m5qkVk22rsNCcC3EyQKauM0g2e6u/qdExKL+KHun6
	 TUZylXQilLYHTvT3UdNaiyQ56U+rCTXdC3g6RfVxHNluogTEuiGIXs1I0scMNnr74J
	 DCGRlQhrZkNxGa+/hfXl2bjW0O+3lK8upp3qhlxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David George <David.George@sophos.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 001/211] xfrm: Allow transport-mode states with AF_UNSPEC selector
Date: Mon, 20 Mar 2023 15:52:16 +0100
Message-Id: <20230320145513.365055571@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit c276a706ea1f51cf9723ed8484feceaf961b8f89 ]

xfrm state selectors are matched against the inner-most flow
which can be of any address family.  Therefore middle states
in nested configurations need to carry a wildcard selector in
order to work at all.

However, this is currently forbidden for transport-mode states.

Fix this by removing the unnecessary check.

Fixes: 13996378e658 ("[IPSEC]: Rename mode to outer_mode and add inner_mode")
Reported-by: David George <David.George@sophos.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_state.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 00afe831c71c4..f238048bf786e 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2815,11 +2815,6 @@ int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload,
 			goto error;
 		}
 
-		if (!(inner_mode->flags & XFRM_MODE_FLAG_TUNNEL)) {
-			NL_SET_ERR_MSG(extack, "Only tunnel modes can accommodate an AF_UNSPEC selector");
-			goto error;
-		}
-
 		x->inner_mode = *inner_mode;
 
 		if (x->props.family == AF_INET)
-- 
2.39.2



