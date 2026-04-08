Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42E725A321;
	Wed,  8 Apr 2026 18:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674294; cv=none; b=mpKmiBhNwGYxp9AUPxRt3Nd6IeSz+Lz3mozNoyX7Vm7aG1WlPcmwmNYyyETJxyMn43YmJhEROWDQIiy0yejabmHI0ZwBDu9lRKgPvHF2PhRzp02EfF5qB0coXr8IN0TOved72cJOXs7BEcdzQUHdNKotGa/65Iadw/GbXwoCcYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674294; c=relaxed/simple;
	bh=r7jNuEOrDmlOxJ77sMUC7nJR9KzVNiZz5eOWKi/lX/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJ3svNE5HflYzEQsIAV8pxL1vxQzLLAB07MuTRDn32xNQctcb2WzvKTJylnSmXg/26AmEhmSzP8+jhHG9KHw2ffCpsM5Ma7PaPG24ycvngRdvtDT2sIYF4Sk/HVf/OK0+uWckuytF+O/k6PHyEna/MA5ETG4SaHhwCNeBl+MhiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sENC9HXI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sENC9HXI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA48C19425;
	Wed,  8 Apr 2026 18:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674293;
	bh=r7jNuEOrDmlOxJ77sMUC7nJR9KzVNiZz5eOWKi/lX/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sENC9HXIZQdINp1aHI+e+LXd4FGraxFYxNRgd+5EG5fcZv070XV0EjgcbGHM5esGK
	 /RJWk3aE+5NM5V7pt6t+oMgJZAcqdoIfeWTOz59+gGy7j+86fitFrJEDLZbp22UCG7
	 GSq72/TGaduHuYWe1QH9Aq1Nn/xMnDF1xEVQamYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <dqfext@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 042/311] netdevsim: fix build if SKB_EXTENSIONS=n
Date: Wed,  8 Apr 2026 20:00:42 +0200
Message-ID: <20260408175940.985657407@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

From: Qingfang Deng <dqfext@gmail.com>

[ Upstream commit 57a04a13aac1f247d171c3f3aef93efc69e6979e ]

__skb_ext_put() is not declared if SKB_EXTENSIONS is not enabled, which
causes a build error:

drivers/net/netdevsim/netdev.c: In function 'nsim_forward_skb':
drivers/net/netdevsim/netdev.c:114:25: error: implicit declaration of function '__skb_ext_put'; did you mean 'skb_ext_put'? [-Werror=implicit-function-declaration]
  114 |                         __skb_ext_put(psp_ext);
      |                         ^~~~~~~~~~~~~
      |                         skb_ext_put
cc1: some warnings being treated as errors

Add a stub to fix the build.

Fixes: 7d9351435ebb ("netdevsim: drop PSP ext ref on forward failure")
Signed-off-by: Qingfang Deng <dqfext@gmail.com>
Link: https://patch.msgid.link/20260324140857.783-1-dqfext@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 112e48970338f..13c6eca3bbc69 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -5093,6 +5093,7 @@ static inline bool skb_has_extensions(struct sk_buff *skb)
 	return unlikely(skb->active_extensions);
 }
 #else
+static inline void __skb_ext_put(struct skb_ext *ext) {}
 static inline void skb_ext_put(struct sk_buff *skb) {}
 static inline void skb_ext_reset(struct sk_buff *skb) {}
 static inline void skb_ext_del(struct sk_buff *skb, int unused) {}
-- 
2.53.0



