Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A583854B1BA;
	Mon, 31 Aug 2026 13:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184001; cv=none; b=JKvvWdf6n0PctWGnyUqcNcux4EgQw3fH1vdjTVMB1qXc5tjB+AEyTyrDAWz1iwKQy+0rORhCBKfKsKZ0jfzAxu39x89jA/j4PNa/2krMrmUSo+YzspfSEA76QmfIpf8yMmDFytEyOsWPxTWhI0bWcP0tDouYOwbMo/YfcuQTlzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184001; c=relaxed/simple;
	bh=vAFPF4RBJuAmgl5+GNm+lH/H/g5c+GTRp9uuBF+y6tI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oAFRsA1zJdrElhiX3yQbJG5vLvyCS/fylW4W6LH1cMA3BMcxogcnQZAbARJj/uSUwF0TP55CvFKiVXXTrihlt69W+RvDxuLfpE3yA84Jk+XNofuAPepgIUl+y28fx/aU2zWKUD4pQIklzbgblCnxWFGQ0F6Nqy0dD9vi/CnuRJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lGmTErtp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lGmTErtp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5885D1F00ACF;
	Mon, 31 Aug 2026 13:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183996;
	bh=DzqnDHpy5EDQ4ZskrnbD5c5j0txZMhrATyfjSFeySh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lGmTErtpwhATIlZMsW/Ic2I3yVJj12Pdag0Vw7tqPaaGqsJ+Lf3fBHj3zvfbmF2Ae
	 BIbWusewvFNKCnkbrfOWW2LYyqTi17MMyTPWnj69W5RxEyEMH7lG5xzQTcE3dDf3+0
	 QU1rfPQPiLr192Q+gIX9XuKXUmu/O2A2sxjv8+6miNthMworCM+CdLgRY6n5tqPp6C
	 LS0k6tspvTS28FGb1InZMMDGsxJAGD5zpUBjKXsrqrR9tV80x26t2XOPx6nYVr7fgk
	 GUFxH7pTYaUYM7ZYYjbHCyaClqNQIC2ZNq7ZoPxbXUxCsTtmhUu+yPgytI2ib9P3ph
	 oRy8dmfguph/g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Antony Antony <antony.antony@secunet.com>,
	Yan Yan <evitayan@google.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] xfrm: allow migration from UDP encapsulated to non-encapsulated ESP
Date: Mon, 31 Aug 2026 09:27:36 -0400
Message-ID: <20260831133314.4125787-428-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Antony Antony <antony.antony@secunet.com>

[ Upstream commit b8addb8884f2dc1b13cf3e4fa0265ecd0bc58b69 ]

The current code prevents migrating an SA from UDP encapsulation to
plain ESP. This is needed when moving from a NATed path to a non-NATed
one, for example when switching from IPv4+NAT to IPv6.

Only copy the existing encapsulation during migration if the encap
attribute is explicitly provided.

Note: PF_KEY's SADB_X_MIGRATE always passes encap=NULL and never
supported encapsulation in migration. PF_KEY is deprecated and was
in feature freeze when UDP encapsulation was added to xfrm.

Tested-by: Yan Yan <evitayan@google.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Antony Antony <antony.antony@secunet.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The branch check finished. Commit `b8addb8884f2d` is in mainline and
several `-next` trees (via the `ipsec-next-2026-06-12` merge), but not
in `stable/linux-6.18.y` — which matches the earlier analysis.

**Summary:** Backport to 6.18.y is warranted. The buggy encap-
inheritance code is still present, the adapted patch applies cleanly on
top of the already-backported `b64120d`, and this completes the MOBIKE
NAT→non-NAT migration fix that partial stable work started.

**YES**

 net/xfrm/xfrm_state.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index b9049c2297bd5..0a629fce0a00f 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2017,14 +2017,8 @@ static struct xfrm_state *xfrm_state_clone_and_setup(struct xfrm_state *orig,
 	}
 	x->props.calgo = orig->props.calgo;
 
-	if (encap || orig->encap) {
-		if (encap)
-			x->encap = kmemdup(encap, sizeof(*x->encap),
-					GFP_KERNEL);
-		else
-			x->encap = kmemdup(orig->encap, sizeof(*x->encap),
-					GFP_KERNEL);
-
+	if (encap) {
+		x->encap = kmemdup(encap, sizeof(*x->encap), GFP_KERNEL);
 		if (!x->encap)
 			goto error;
 		x->mapping_maxage = orig->mapping_maxage;
-- 
2.53.0

