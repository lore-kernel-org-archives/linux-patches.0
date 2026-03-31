Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28B23A1E8C;
	Tue, 31 Mar 2026 16:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976372; cv=none; b=F1LHXzgYUuNeHmWFRbpou8JzZhhQzic+cBFSKjhVcFdBLB1zRnrR5MFDfw3YtASkQ+lk/rLrQEy32O6NVetqbC5cgW005ZcbW3nBVZMdQZUHZ4XPY6AJ4whUtsYcSV5x9NQG9dtodNoTNby9Puib1HXCOZ6eYW6tRAfR0H93Wg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976372; c=relaxed/simple;
	bh=gKKhuGuZEqSyrMH0E41aH7d8GJzeCesNJfClZsnwdeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fO9sL6vtFBisYekomdFMN8YUujk8da5KtWj3A/eehlbKFMPZBd69eC9n4Sm1R6i4JFWbdp+PvZKps8gYZtLG46mXbGSAUvYstP6LWd6k9XiAXTB4qUV3RNYZuT/3n/YJD9OkwhL+P+LJHWRsvVlTTn6uR/++JwElu9IoBqx5I44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l2tRjeOb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l2tRjeOb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40859C19423;
	Tue, 31 Mar 2026 16:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976372;
	bh=gKKhuGuZEqSyrMH0E41aH7d8GJzeCesNJfClZsnwdeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l2tRjeObs9oRSGFDA9dhCakaNjsCmVOq0u+cVqNVXQHm5icsBx90vDQlcmVShCBzF
	 +j63q7ToBH+azc82kiWIbz/wctAozvvNqVCw1LovJAceOWeoVGVOTqAuPaGvypcDHR
	 TySAeb9QlnhCYQk5Cbu3Af/bWDFT+MXrDhjRmU8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 068/309] xfrm: add missing extack for XFRMA_SA_PCPU in add_acquire and allocspi
Date: Tue, 31 Mar 2026 18:19:31 +0200
Message-ID: <20260331161755.990666532@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit aa8a3f3c67235422a0c3608a8772f69ca3b7b63f ]

We're returning an error caused by invalid user input without setting
an extack. Add one.

Fixes: 1ddf9916ac09 ("xfrm: Add support for per cpu xfrm state handling.")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 403b5ecac2c54..3e6477c6082e7 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1850,6 +1850,7 @@ static int xfrm_alloc_userspi(struct sk_buff *skb, struct nlmsghdr *nlh,
 		pcpu_num = nla_get_u32(attrs[XFRMA_SA_PCPU]);
 		if (pcpu_num >= num_possible_cpus()) {
 			err = -EINVAL;
+			NL_SET_ERR_MSG(extack, "pCPU number too big");
 			goto out_noput;
 		}
 	}
@@ -3001,8 +3002,10 @@ static int xfrm_add_acquire(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (attrs[XFRMA_SA_PCPU]) {
 		x->pcpu_num = nla_get_u32(attrs[XFRMA_SA_PCPU]);
 		err = -EINVAL;
-		if (x->pcpu_num >= num_possible_cpus())
+		if (x->pcpu_num >= num_possible_cpus()) {
+			NL_SET_ERR_MSG(extack, "pCPU number too big");
 			goto free_state;
+		}
 	}
 
 	err = verify_newpolicy_info(&ua->policy, extack);
-- 
2.51.0



