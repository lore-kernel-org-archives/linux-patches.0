Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B237413225;
	Tue, 31 Mar 2026 16:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975689; cv=none; b=cCGG/Yni2+2nsFq61v4H4z3+wiOHWFSeIOQtiToferanxORC97gI6CgOWncrnQwEPYzQjC9jdW4zTwkQQ3z8wT1cJC2mjlodKpStLiKBse8QZpRloOfecOjyAhLtFiAskZna7PN97rvqX0fVFiJM/9vWUCoMJ2QUeNMVRKcAbGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975689; c=relaxed/simple;
	bh=mycfoH4VzeBL/TviqnpTDO1Lve0DiS0+w57ZGcCBDl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RP6mJRc/s+/F7LykSjmkH21z+tfAbrqEW6MWWQUmQ3ON1aBWW0Mhg3t6KOymVwylrYv8DG7osBJ/K/eb2t0hcPBfdsZYWCxtZSTuY06R+hIsni9LGkAiR8rX/0CT/i9W9/UL40sCcY9L0zgCvWna27PPnZR9qt88kv11E7WdYQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CRS7bISj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CRS7bISj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C5EC19423;
	Tue, 31 Mar 2026 16:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975689;
	bh=mycfoH4VzeBL/TviqnpTDO1Lve0DiS0+w57ZGcCBDl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CRS7bISjZrKNuwxqN8k1wCOwp2ipQOykRhmyhEyi5CwUDQTjMZoRDIwYIk1FC85Qf
	 WJhicUnGIx8jN1O2P1kH01xFyyR2VsMNcfegQqfV5X08vfj+nQ6Zcvb/99HUlxNdfJ
	 8rpwExP0k+Wut4zv843whpLQZwVs7MpgmeQSTdrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 049/244] xfrm: call xdo_dev_state_delete during state update
Date: Tue, 31 Mar 2026 18:19:59 +0200
Message-ID: <20260331161743.505669740@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c927560a77316..a55c88b43c339 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2180,6 +2180,7 @@ int xfrm_state_update(struct xfrm_state *x)
 
 		err = 0;
 		x->km.state = XFRM_STATE_DEAD;
+		xfrm_dev_state_delete(x);
 		__xfrm_state_put(x);
 	}
 
-- 
2.51.0



