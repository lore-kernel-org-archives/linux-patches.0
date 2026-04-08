Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27403D902B;
	Wed,  8 Apr 2026 18:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671755; cv=none; b=RWYQuqiOHRsJLtpt9c4FCxOvcJkIjqr8bPtbVVUNcbAeztmICPDrhas24xdT9/JUn6YddlhhsFIA3JUDvqw2BqbHli8GKZjl6moa0kNcSBIG1yUPXjEFow2MXR9qkLsOr7L+qdyQGx/URysjfW6i13Yqsd8E9ukUXNMpi9NXdKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671755; c=relaxed/simple;
	bh=nVuI85FVnnu07j7H5DfrZ0M5N1TnI1Y7MCQ8ciPKxqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JyVbSzfCsBmFITwFdtGNfC/kYxtGdIBoP5cyqFRjwlI336X62VRCLJLmNU7laMG+SnuJCVqgfXOGJky1iye8Lo8JyR+c1AHUGwLA/xU5qcf84T6RiTbtaHAr/jyYyVgLr01I5RuTcv+KLWEnYTbmpLaSlDQJkAYURzAFlxffHVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zpjctglz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zpjctglz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4911DC19421;
	Wed,  8 Apr 2026 18:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671755;
	bh=nVuI85FVnnu07j7H5DfrZ0M5N1TnI1Y7MCQ8ciPKxqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZpjctglzXHC2rHywnqwnwuqxijg6jwgtxZVUFEsFTQ7hRMTF7aYjVi2yDN9X7nTzP
	 mzcJEHtHC6M4Y/o1DzcryZ1olqk/PWZgFuo81XVZOpP2TwhvzOY5uNuPgHBZFFrg43
	 lppcXa1rUo6DDGmKwbnuobRRATADvhgX3f0azwNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 023/312] xfrm: call xdo_dev_state_delete during state update
Date: Wed,  8 Apr 2026 19:59:00 +0200
Message-ID: <20260408175934.594610782@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 7d2fc41f91bc69acb6e01b0fa23cd7d0109a6a23 ]

When we update an SA, we construct a new state and call
xdo_dev_state_add, but never insert it. The existing state is updated,
then we immediately destroy the new state. Since we haven't added it,
we don't go through the standard state delete code, and we're skipping
removing it from the device (but xdo_dev_state_free will get called
when we destroy the temporary state).

This is similar to commit c5d4d7d83165 ("xfrm: Fix deletion of
offloaded SAs on failure.").

Fixes: d77e38e612a0 ("xfrm: Add an IPsec hardware offloading API")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_state.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 38d9b0b5cc5db..7dd536d5f43f3 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1768,6 +1768,7 @@ int xfrm_state_update(struct xfrm_state *x)
 
 		err = 0;
 		x->km.state = XFRM_STATE_DEAD;
+		xfrm_dev_state_delete(x);
 		__xfrm_state_put(x);
 	}
 
-- 
2.51.0



