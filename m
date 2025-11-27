Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5603126C0;
	Thu, 27 Nov 2025 14:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255238; cv=none; b=f7HYDqKSbwI76Qk4nVxdSR5gd+2AD1DQKB/RJW/4wPWwnxqwmyojPDWznKps21nXKhGJwJ2kjT2/Nd707lV7fM1vldrZhd7cthsyaVCZYQQ60IBcMPocHWU+FkSKFjGEyyP/z4iWbFs9FKIBzX0iXDaWI3zHeGDmaeZVFNnf69I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255238; c=relaxed/simple;
	bh=b3zVerin3E+gmKgcto8U+7G7rjRcxSXGfpANryebFlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nss7tsSFXhU66U0jG+1F6m+ISmMEHSYpxUac0qS0IYdjR6qmp5co+azTHsqP6jMiXtnbX3rL6mlyQ/OfGaHGiUgMKyEh6KwhrtyHn7abYsZSd0x1qTGzi8TemcuZKah8A/h1HJi9sRI+NVGiqVKGdJNB8MBRRZrF4wxz3kMUXKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m87HKWwV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m87HKWwV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD842C4CEF8;
	Thu, 27 Nov 2025 14:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255238;
	bh=b3zVerin3E+gmKgcto8U+7G7rjRcxSXGfpANryebFlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m87HKWwVetZyQi39PzqbmjEv+4m29pk5eMYcddEU5F6qpkeZkcL5ZmmkgaRm9CZuv
	 8Wsy910wERrerAgn8YvLiZ64v1HwJ+fVuJth4UimwELG5dO1Tj3CPNN9MzwM0Tf8Ba
	 22JBFSIBHC1hwZTtuwhGhUA6UQAfmIl+FlMv+IyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 054/112] xfrm: set err and extack on failure to create pcpu SA
Date: Thu, 27 Nov 2025 15:45:56 +0100
Message-ID: <20251127144034.819527806@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

[ Upstream commit 1dcf617bec5cb85f68ca19969e7537ef6f6931d3 ]

xfrm_state_construct can fail without setting an error if the
requested pcpu_num value is too big. Set err and add an extack message
to avoid confusing userspace.

Fixes: 1ddf9916ac09 ("xfrm: Add support for per cpu xfrm state handling.")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index d41e5642625e3..3d0fdeebaf3c8 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -893,8 +893,11 @@ static struct xfrm_state *xfrm_state_construct(struct net *net,
 
 	if (attrs[XFRMA_SA_PCPU]) {
 		x->pcpu_num = nla_get_u32(attrs[XFRMA_SA_PCPU]);
-		if (x->pcpu_num >= num_possible_cpus())
+		if (x->pcpu_num >= num_possible_cpus()) {
+			err = -ERANGE;
+			NL_SET_ERR_MSG(extack, "pCPU number too big");
 			goto error;
+		}
 	}
 
 	err = __xfrm_init_state(x, false, attrs[XFRMA_OFFLOAD_DEV], extack);
-- 
2.51.0



