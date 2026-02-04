Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8786E41B359;
	Wed,  4 Feb 2026 15:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218390; cv=none; b=Q7CjTuU9DgbLCzRZnkwqVLd3zzguETl9w9k3lpd4h/QjwmoVecrLFtRAa34A33a3MxGRmd0+7zY5qtCaNQgqQX5qMS65VV8MYVIJOFTUvxJvE9mzzB7udwR0Ppw4vpVVw0+RDRGeIF25qTMNjI0fqj/hL+6klpvSCdKgWHbje4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218390; c=relaxed/simple;
	bh=tL7RuOzMQLx08XwTNjQyWMMBFrRTCoU4/lj+05bzjUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ffopo5DB6hxvNSVC1590x0i5NGf9PH7BqH4vrqyALNMrT7+J+58cuHPWmAJwZe51FTZVxBOY3SfxqYBIq8ag/fN8ijtIBBXVVtRncIPyf/fQNsFE7EIrYBTGXpr64nYMfRJ3S1TTRdvLAOBYEVbaXS4DQ7oEJMLPzDVMpky5qbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p2IiyQ9Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p2IiyQ9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09664C19423;
	Wed,  4 Feb 2026 15:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218390;
	bh=tL7RuOzMQLx08XwTNjQyWMMBFrRTCoU4/lj+05bzjUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p2IiyQ9YOWUqIjZo1642SfVfWVw8ycnp9TWozwZrhga3v83gB/kQCKJLK15IsvlIZ
	 EE33jiniJu6YLNP+mmWB+rq0SQChu+mDWvo+78OaSRPQt6E8rF4utxrem7PsqNc/5f
	 4kyEpHBBEDuKrC+RsW9m91JN6KTNwz98iW5D8r2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	Florian Westphal <fw@strlen.de>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 17/72] net: bridge: fix static key check
Date: Wed,  4 Feb 2026 15:40:20 +0100
Message-ID: <20260204143846.245776625@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>
References: <20260204143845.603454952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2d5b81ebbaa6d..847fe03a08ee8 100644
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



