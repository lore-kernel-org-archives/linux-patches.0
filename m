Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFAB1C08
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 14:56:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07D1DC4339C;
	Mon, 20 Mar 2023 14:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324173;
	bh=FsiStpV3+bybq+rSmNCRkZtA8Qyuyc9RYS5R47+YxxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IS2laMqnMNBKmLS3Sb+i/srPakl5NfxaO3+Gzj4kfh3yjUz2CYzL9N2LKQ+0mvkGQ
	 C23RMDBggqlU4kGk+eCfhcsICM9JsMWRZRm5QTR3Ns1WJlrNFaYVLwpJfOi/4m1uhp
	 pTHdZkszg4VhiXp0UWypVKCPGOq2/ibm5DhN/qKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David George <David.George@sophos.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 01/99] xfrm: Allow transport-mode states with AF_UNSPEC selector
Date: Mon, 20 Mar 2023 15:53:39 +0100
Message-Id: <20230320145443.402233211@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
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
 net/xfrm/xfrm_state.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index fdbd56ed4bd52..ba73014805a4f 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2611,9 +2611,6 @@ int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload)
 		if (inner_mode == NULL)
 			goto error;
 
-		if (!(inner_mode->flags & XFRM_MODE_FLAG_TUNNEL))
-			goto error;
-
 		x->inner_mode = *inner_mode;
 
 		if (x->props.family == AF_INET)
-- 
2.39.2



