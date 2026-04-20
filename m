Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE124CA285;
	Mon, 20 Apr 2026 13:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776692005; cv=none; b=i46sw2b3Apf9VnrH4CoGnCIAZtfZ5lrVO+69jz7svAgHqE9fvsMnEYQstkm5ucGwBp7XxTPS0S0RkMop5jIHCLAFRNgzBqdgcpgShSecvUw6wK/hG4+9+w8WnCVYEPJXMCHS1I8bCp2vE1wP3n5yI7MnF43uubdW0qbuUTlkMss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776692005; c=relaxed/simple;
	bh=jWw+kjULLOINHtTCs/awCVSQNwIoMnd53DJYth8+OwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jnLqRLxA0CYkoQeOFTnJcN1g1Cj0w6NL11aO5jssdXRmaJvdb8MdoZQhCbQnFEAzWUJO1z44TUjghmcixIQI5v170pFrPImhk1C5QF4YhwrHgY92/T4Db1gvXUCjYI1BJ5K9R+1ihdAYXvGUMapGaQTt4RXCkbOqKqK1qZx9fKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pCJmUMXQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pCJmUMXQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A89C19425;
	Mon, 20 Apr 2026 13:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776692005;
	bh=jWw+kjULLOINHtTCs/awCVSQNwIoMnd53DJYth8+OwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pCJmUMXQOENZT3exzQGpkk0F7MJP203NaxPQcmEv2LIb4hWFoa/b9HJoHqRNkEMtK
	 S3baUfzwgdI9zTktULULbDw4NwmDootOXbAIG9IETPvi6/oL2twypufBa8p8JemXM5
	 cILGM2/ACNgUMtMGEohZp8xTEaVG+FQHpfUtK/tUt66DpSDnxH/5TurjA3ZTXIDxk8
	 rHEErtB1b2jpvZpUDj8aSi8vHnMija86Q1BnkpLgP0WoSRt7n2I1g0idvJYSvVqKmY
	 YZpTHR2XL0rEOaC14dZkR8gWv3uL1KH1BIm5F80IUdsDwpa3UNjWaGL+GpOTsesPkN
	 /fZgbM08Aijig==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	martin@strongswan.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] xfrm_user: fix info leak in build_mapping()
Date: Mon, 20 Apr 2026 09:21:51 -0400
Message-ID: <20260420132314.1023554-317-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 net/xfrm/xfrm_user.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 1ddcf2a1eff7a..b3f69c0760d4c 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -4164,6 +4164,7 @@ static int build_mapping(struct sk_buff *skb, struct xfrm_state *x,
 
 	um = nlmsg_data(nlh);
 
+	memset(&um->id, 0, sizeof(um->id));
 	memcpy(&um->id.daddr, &x->id.daddr, sizeof(um->id.daddr));
 	um->id.spi = x->id.spi;
 	um->id.family = x->props.family;
-- 
2.53.0

