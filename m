Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27813284B37;
	Wed,  4 Feb 2026 15:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218176; cv=none; b=GbnCfTqaQQrCUDCApg4Y35ohYu30qAXCze2+3+phviTViBo+GJy5Wq506JKJKwTK3evHSulLo6xjPUZdXZcr5Yae9ZwrceucaqZIBgHLIOavFe2qM8Pia99XFi8idlwBCvFVhpiZx2ssHN2WZo4pSmJiaKCOv0FxL7lYKQz9rMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218176; c=relaxed/simple;
	bh=GhTpcLHMS/gQe/x+EMFxqKInbDW074tbQKOOgA7clNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hccIaraDKdgJidBjsKT+E+8uLOGjUdC/0PxfONDCd628UkZYNEi1hQ83lywsugApKrT2Z3BryNL49HgGKSfELU21f5hK/uSmOeP3wQB1ie7lEdGJlnBOifn/mPE/jxbffu01xOjT+GlPhUIlbS9DxobAZ9+RfypxNTt7bCvqMak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZfLx0BYq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZfLx0BYq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C95FC4CEF7;
	Wed,  4 Feb 2026 15:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218176;
	bh=GhTpcLHMS/gQe/x+EMFxqKInbDW074tbQKOOgA7clNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZfLx0BYqauxHoeiDrKabfzS6IHkVxiEpHeQHljWhDvR0YbCEhFK4fM9S2Hb/AQZUc
	 LkTga2BuXxh7YEj8b6s5/LC5QKl3FgvbMui7mhNVNbWn8R4klGWTs6paUN8ioI1a+X
	 11Q1j52vKqJOVAVBscc4Lf/ACNzVzg+iaNe6r7O0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	Florian Westphal <fw@strlen.de>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 201/280] net: bridge: fix static key check
Date: Wed,  4 Feb 2026 15:39:35 +0100
Message-ID: <20260204143916.836463652@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f11345720c275..e33500771b30f 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -243,7 +243,7 @@ static int nf_hook_bridge_pre(struct sk_buff *skb, struct sk_buff **pskb)
 	int ret;
 
 	net = dev_net(skb->dev);
-#ifdef HAVE_JUMP_LABEL
+#ifdef CONFIG_JUMP_LABEL
 	if (!static_key_false(&nf_hooks_needed[NFPROTO_BRIDGE][NF_BR_PRE_ROUTING]))
 		goto frame_finish;
 #endif
-- 
2.51.0



