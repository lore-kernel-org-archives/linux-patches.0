Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC88E3FA5E6;
	Tue, 31 Mar 2026 16:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974876; cv=none; b=VnldeMiwkMg16vhjUCo7xmNldZqUfDZ/euRgzRYsM8LEBK7N8GnB8aQdrO/BIzeEqrUaEKhjRAJHU9ECIPRp9VLWbET0fHkplPrq+sIaaQ9KSp+y51hQvHkph6y6ooX303aKt2nodvk7H1mWIcN//ChjLdbOtVZWmC+dII9dBMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974876; c=relaxed/simple;
	bh=LzfIUSTcCSUI1vyz1x0ft/ll7b1eay8Zm5JMSo2FCDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hAvBl/UjKuPKNDihLw3spJkvJITzH/J7PpCoDasgL0+VHJDjoWjUIt3Ynu5sSii7xaqsuOGpdwdvjfPOBtzAxnr+mzx6WCfkad7dgJAMtevxxrxyVdPuRAeUCsV2HYJuO/2E175Qw1Fb6NO9H6zXq3ZJ8MOOq9ph1tuM/uXewfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JYKKh687; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JYKKh687"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5350FC19423;
	Tue, 31 Mar 2026 16:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974876;
	bh=LzfIUSTcCSUI1vyz1x0ft/ll7b1eay8Zm5JMSo2FCDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JYKKh687znHsGDffQs6Qar4uMcaiu38Zxgu68+Q1LtyJr9oCrFd2agxERkBl8oSpw
	 YFPgbUApnrAIaWLsqSO+YUcrvV4vE/d5lqb5PatyvPrBf2xDPLp2CVk7HCElf6uEyb
	 AF/3JfUTcHeJ94+UrB2VX3ycU6HYCZ9exDTVxmeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 078/342] xfrm: add missing extack for XFRMA_SA_PCPU in add_acquire and allocspi
Date: Tue, 31 Mar 2026 18:18:31 +0200
Message-ID: <20260331161801.761192849@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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



