Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C584217704;
	Sat, 30 May 2026 18:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165269; cv=none; b=KDB3b+gOwDM4CrI6tNYril2o3Ml4cHxEbfzYDaW86pMVQ+UtsuHwKtYxbU2ZwtDBZReHpIizE+JRrN/iNP0jztVsfoDTI2wPf+o3xQZOHpAXRI5btvwAVIQuPMghaELZRqBv1IU7Sng0BqgFNoyr1lUHDoKlxIGAbAWpJeLo0IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165269; c=relaxed/simple;
	bh=w0McELRg1S5hKSlO92G526FUE34vJa9MXv8q0G1TV4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rnrazWaOoSYSLevsB/o2nHomiq68zg5sUm9Yxg06IG2VYFNhHYZW90w//qxMjwZoGcP/dysmYPtNKs63TYEfYCVSQZnOM2l4y3XLxBrrLuUSE2i8vwxc429SOQzaqFiEfjqH96QN++pIr+Kdst1x7KNRL5WAInBBT0fmjdmYR0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XlsBYwFb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XlsBYwFb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99CE1F00893;
	Sat, 30 May 2026 18:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165268;
	bh=dEAUYBguE3RKG4B+OGnqukhhgmef9Qg0/kANRwxN2T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XlsBYwFbiBHxEMmmMJ+iRA3nOVyzmFCpr1T67DNbfXYKGViTjKLDOTkNO1iRGUybT
	 GL9jumEF5dqNqIC2RgR/zWEgvebm8wlNGY8XIYxkReyn8GciuSKxRS06yTGnarxEIM
	 AS1bspnJr5uzUNMcIQyMyZyZr6fSzObQimsPfv9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/589] xfrm_user: fix info leak in build_mapping()
Date: Sat, 30 May 2026 17:58:29 +0200
Message-ID: <20260530160225.322332048@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 1beb76b2053b68c491b78370794b8ff63c8f8c02 ]

struct xfrm_usersa_id has a one-byte padding hole after the proto
field, which ends up never getting set to zero before copying out to
userspace.  Fix that up by zeroing out the whole structure before
setting individual variables.

Fixes: 3a2dfbe8acb1 ("xfrm: Notify changes in UDP encapsulation via netlink")
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index a55f8fe3e052f..ab79a739b3638 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -3493,6 +3493,7 @@ static int build_mapping(struct sk_buff *skb, struct xfrm_state *x,
 
 	um = nlmsg_data(nlh);
 
+	memset(&um->id, 0, sizeof(um->id));
 	memcpy(&um->id.daddr, &x->id.daddr, sizeof(um->id.daddr));
 	um->id.spi = x->id.spi;
 	um->id.family = x->props.family;
-- 
2.53.0



