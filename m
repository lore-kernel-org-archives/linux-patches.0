Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008F43D6674;
	Wed,  8 Apr 2026 18:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672918; cv=none; b=sBUzzthhp8rJ+N457xKiVj2IiFA2+GIK+JyyW/GAx64oM3zi19uIRNuzjvd/JpfjM7DYpAaq6wAxMQrgKa+rmPEoyedzEYuOVrJ7Wm5U/BtlvrJvqB2ynLORFIvWReYnoYUbbffAHidY3zPqCxbxPTOUY2FvGC556Y3SBm369jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672918; c=relaxed/simple;
	bh=KOygfg7dPMPOD1kvdw8ZkeEuH//TVYl/7ajN3bc5O0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ip+IaG+NszuMPk8X+R9xdLfa7ROGHkqEA6JUFlGTrTmhNQxUcNoOFqErfd5Eai8nKwwwDhstNWZEr2WJC/CZAuQPljfVlv0q3OUl9LUsBj4B5mbm0rbTgMAhzo9ey3Yv0wZz6ZkhEh2v9S2OXi4iDmIFdpCYRY2wtHhgis5pf0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aexqV3IY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aexqV3IY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297ABC19421;
	Wed,  8 Apr 2026 18:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672917;
	bh=KOygfg7dPMPOD1kvdw8ZkeEuH//TVYl/7ajN3bc5O0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aexqV3IYSwtMw6W92CnyaB94RuU4G+lwupdPFszWvJ46gsgtyNEFRPddto0uwYFhN
	 XwMkwdcT40BY8+1djxhWa8Nbv9rNQ1WDXW1SdL9pi+J+edpX4bWHldD8V0773F7JxB
	 g6NGVwvGkwlvua+PEleXGQZtgWEl41JLfZg8HLoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <dqfext@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 030/277] netdevsim: fix build if SKB_EXTENSIONS=n
Date: Wed,  8 Apr 2026 20:00:15 +0200
Message-ID: <20260408175934.976951415@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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
index 50f127451dc65..def9cca948178 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -5018,6 +5018,7 @@ static inline bool skb_has_extensions(struct sk_buff *skb)
 	return unlikely(skb->active_extensions);
 }
 #else
+static inline void __skb_ext_put(struct skb_ext *ext) {}
 static inline void skb_ext_put(struct sk_buff *skb) {}
 static inline void skb_ext_reset(struct sk_buff *skb) {}
 static inline void skb_ext_del(struct sk_buff *skb, int unused) {}
-- 
2.53.0



