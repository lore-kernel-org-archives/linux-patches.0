Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96776219301;
	Wed,  4 Feb 2026 14:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216581; cv=none; b=nUHMWtgjeMPB8YW0brVWhgLFfYd+kNjUGNe1CKN4Fs5zR7sN8+0SxmY79f7B8K+7RwYSYAzI9tu7TlmKe3IYhqOvnphSGyEX2trfs8GVLldwF0zMagZYBYHqBMsk4Qp4D2IHmhr9wu1w7NuelnVsmNN5i9giKZeqp1UjX3W6dLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216581; c=relaxed/simple;
	bh=D35PslkfhK3I4L7Oym6vN0QXXd6JB8Eh57AcaJPXZUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qr2fl1dJW/puHwz40UB+Yv5gzfMB5ttP4JYoBgXUp7zqvCImDBYJSV36C/Sjv175UWy2PPOmcCygKpKiE/I5YsebHG7Jl5sIAZTlaeAUw2RfF6RKRxgDK1KWxUP8dVK+xsOuXxox9gvKoGKZvjon+nvhqPG/F3ARZAHenQi7OkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k0r7wAT6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k0r7wAT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB528C4CEF7;
	Wed,  4 Feb 2026 14:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216581;
	bh=D35PslkfhK3I4L7Oym6vN0QXXd6JB8Eh57AcaJPXZUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k0r7wAT6BYnoszrO7I+mvw7iZAafrU3BMhnqcT1eSfwswHiGJXbZKwLDSctYFgq1C
	 FPnaMzRPeKMp6EHZQv9wAxayFhTyG20OIWeqB5ntJ+SvuN7IsrVjfri6E6YLzaeLan
	 GgE5iHvWt/5Cw3DDwo08xld6XFLeL0KFGTTfmbEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	Florian Westphal <fw@strlen.de>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 129/161] net: bridge: fix static key check
Date: Wed,  4 Feb 2026 15:39:52 +0100
Message-ID: <20260204143856.383957828@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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
index 52dd0708fd143..f9d4b86e3186d 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -218,7 +218,7 @@ static int nf_hook_bridge_pre(struct sk_buff *skb, struct sk_buff **pskb)
 	int ret;
 
 	net = dev_net(skb->dev);
-#ifdef HAVE_JUMP_LABEL
+#ifdef CONFIG_JUMP_LABEL
 	if (!static_key_false(&nf_hooks_needed[NFPROTO_BRIDGE][NF_BR_PRE_ROUTING]))
 		goto frame_finish;
 #endif
-- 
2.51.0



