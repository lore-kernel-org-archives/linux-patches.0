Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA831C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 14:56:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F1EC433EF;
	Mon, 20 Mar 2023 14:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324167;
	bh=Iul98cO9WwjBptxcwtg6AU5aSf3fxAnW8jfb4vk5Oc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tQC4iZi1Ht/63yjywFo3wSQg4VU5qhleiZXZjKW/Hhzc+0rmwTtsjnpCaGBAr0b6T
	 6szcKyKcSGDdiQEKguw4sjn5ZwNpSvxFzQxyxu67omRMUs8Vs9SIV91tHHxE14PIdZ
	 RJvZGMAuL1n8noPgm9k5q6yaBPNwo9//BUygjopI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David George <David.George@sophos.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 02/60] xfrm: Allow transport-mode states with AF_UNSPEC selector
Date: Mon, 20 Mar 2023 15:54:11 +0100
Message-Id: <20230320145430.969514300@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145430.861072439@linuxfoundation.org>
References: <20230320145430.861072439@linuxfoundation.org>
User-Agent: quilt/0.67
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
index bee1a8143d75f..e8be18bff0960 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2511,9 +2511,6 @@ int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload)
 		if (inner_mode == NULL)
 			goto error;
 
-		if (!(inner_mode->flags & XFRM_MODE_FLAG_TUNNEL))
-			goto error;
-
 		x->inner_mode = *inner_mode;
 
 		if (x->props.family == AF_INET)
-- 
2.39.2



