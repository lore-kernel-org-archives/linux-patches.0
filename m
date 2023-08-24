Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F0B100C0
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 14:55:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9FEC433C8;
	Thu, 24 Aug 2023 14:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692888909;
	bh=rZDjO6TKvVbowXQemjNdG5klWQiAJ8AmWU+9sJMsmf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yw6OoXhr/rr1glfq1xtTVye6tSCpQEeYCX9DlpzR2hw3E2M8IhcyfTTlQRwZ5u948
	 JtMOnhm8ZIOSiHmfEXUFUD8MDg0tTmdcEtgSGKFZuuNsnJoHt40s9Qu40hc7KK+y0O
	 a4nULZ1vhPNSGnobn3HnnQqoIC5fQOGovOCnwTA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	Simon Horman <simon.horman@corigine.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 086/139] xfrm: add forgotten nla_policy for XFRMA_MTIMER_THRESH
Date: Thu, 24 Aug 2023 16:50:09 +0200
Message-ID: <20230824145027.386828298@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145023.559380953@linuxfoundation.org>
References: <20230824145023.559380953@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit 5e2424708da7207087934c5c75211e8584d553a0 ]

The previous commit 4e484b3e969b ("xfrm: rate limit SA mapping change
message to user space") added one additional attribute named
XFRMA_MTIMER_THRESH and described its type at compat_policy
(net/xfrm/xfrm_compat.c).

However, the author forgot to also describe the nla_policy at
xfrma_policy (net/xfrm/xfrm_user.c). Hence, this suppose NLA_U32 (4
bytes) value can be faked as empty (0 bytes) by a malicious user, which
leads to 4 bytes overflow read and heap information leak when parsing
nlattrs.

To exploit this, one malicious user can spray the SLUB objects and then
leverage this 4 bytes OOB read to leak the heap data into
x->mapping_maxage (see xfrm_update_ae_params(...)), and leak it to
userspace via copy_to_user_state_extra(...).

The above bug is assigned CVE-2023-3773. To fix it, this commit just
completes the nla_policy description for XFRMA_MTIMER_THRESH, which
enforces the length check and avoids such OOB read.

Fixes: 4e484b3e969b ("xfrm: rate limit SA mapping change message to user space")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 6ff405c2cd2c1..ff56b6a0162ea 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -2854,6 +2854,7 @@ const struct nla_policy xfrma_policy[XFRMA_MAX+1] = {
 	[XFRMA_SET_MARK]	= { .type = NLA_U32 },
 	[XFRMA_SET_MARK_MASK]	= { .type = NLA_U32 },
 	[XFRMA_IF_ID]		= { .type = NLA_U32 },
+	[XFRMA_MTIMER_THRESH]   = { .type = NLA_U32 },
 };
 EXPORT_SYMBOL_GPL(xfrma_policy);
 
-- 
2.40.1



