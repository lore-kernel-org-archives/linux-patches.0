Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E092236E3;
	Mon, 20 Apr 2026 16:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700877; cv=none; b=txxDdTT//aRnekyvHTzdYIAQnXP5Eqztc8Yjnke/AD0zethjSI0s5JMBKDnqtflcII3FdpXsCAESnSv3o+ULcMllaBjpPX1ccZE3041rO0vc8EBnOFVs9n0OcmZB6bh0+pLInwUm0g4gIJ6woYdjqUZg9FCnPmZtk6bNVQVZVtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700877; c=relaxed/simple;
	bh=ErwAew/0u+qTX1s1ptKKPdSIRvd3+dhL9e6I2uBZ5vM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jToHFltzCrqizNygaJfGRPbDyrteOSZwlrTAq0oIkERKyHU+0VVBjjig1Fn6mhd0f8EdPeY5W9p/4WuWlpO7IlByFXbNU/LtQnQFcv4X2FyERptQBtMYCU5g0G30GYmj8RWIzU8Xk9xSMHHi1Ugrso0TonF1oMGz6UsFpj4XmrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oWADlweq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oWADlweq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB60C19425;
	Mon, 20 Apr 2026 16:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700877;
	bh=ErwAew/0u+qTX1s1ptKKPdSIRvd3+dhL9e6I2uBZ5vM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oWADlweqf5343tMGN6liirjktYZcXdRy6vrwy7p8Z1GQ2Ocxhk54ctWSzfcrKSzWa
	 ktpGsVx6yzB9W4phXolUgFJ8w5Vg4ZCjS3uMw3MuVbZpjhDNeL30HMX6J2VePnwp20
	 r+l/IWORjvLg4kNnSy0PSety9LIr433I4bLtKoGc=
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
Subject: [PATCH 6.18 094/198] xfrm_user: fix info leak in build_mapping()
Date: Mon, 20 Apr 2026 17:41:13 +0200
Message-ID: <20260420153938.989895778@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



