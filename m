Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF7642189E;
	Wed,  4 Feb 2026 15:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218754; cv=none; b=iAo0uVAW61wddxPOzIyduYnfAd70L0kFhtqe8vKl66JE07UBZlgWbpT4xfV5jVsLqD7nR4/hDykqO2AVTa0Ie/LAGa4A6CId8ujc5Xqb/MFiu7CWdotJG138C2lmg45YuOtngq0pHwmlQnZEga97DBGd0GTFjFOKvaKemPpa22I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218754; c=relaxed/simple;
	bh=VWPDSnVguoWVs3Ny9htrsR/cDfrUktr1R9QoFor3An0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdksUkl40n1HgdiFo/td7QmvfelKgcV+cCO2HDJHtVmZ33gIGJUfGFPl2EWNwwuMSMC7ufLp1DpwyKhBFa50Ea31KeL65T19oQoBMDdxsRuKrVNasszzi3lx4er7i7nqI1huhSzgWwDwuO3RMi0zZtZLruDYN0eTdf5BwjKHVbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y2b+cS5u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y2b+cS5u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198D5C116C6;
	Wed,  4 Feb 2026 15:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218754;
	bh=VWPDSnVguoWVs3Ny9htrsR/cDfrUktr1R9QoFor3An0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y2b+cS5u+eqUeUfCbndgTNShFO2h2cBm1qS/dJeis12tBt90HsdlW1NDaEsXjNB6N
	 BprYALIutJYeKh9XjuQG8H77tIPzJ+0PWecXB3Yczz6DpuCwYK08K99YS4oeEG7NB5
	 MpXC/G5d4fboTBtoOHpMi+6M4kiIqo4X7Q0KsV2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	Florian Westphal <fw@strlen.de>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 18/87] net: bridge: fix static key check
Date: Wed,  4 Feb 2026 15:40:16 +0100
Message-ID: <20260204143847.566506051@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

From: Martin Kaiser <martin@kaiser.cx>

[ Upstream commit cc0cf10fdaeadf5542d64a55b5b4120d3df90b7d ]

Fix the check if netfilter's static keys are available. netfilter defines
and exports static keys if CONFIG_JUMP_LABEL is enabled. (HAVE_JUMP_LABEL
is never defined.)

Fixes: 971502d77faa ("bridge: netfilter: unroll NF_HOOK helper in bridge input path")
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Reviewed-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20260127101925.1754425-1-martin@kaiser.cx
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 8c26605c4cc1e..44459c9d2ce77 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -260,7 +260,7 @@ static int nf_hook_bridge_pre(struct sk_buff *skb, struct sk_buff **pskb)
 	int ret;
 
 	net = dev_net(skb->dev);
-#ifdef HAVE_JUMP_LABEL
+#ifdef CONFIG_JUMP_LABEL
 	if (!static_key_false(&nf_hooks_needed[NFPROTO_BRIDGE][NF_BR_PRE_ROUTING]))
 		goto frame_finish;
 #endif
-- 
2.51.0



