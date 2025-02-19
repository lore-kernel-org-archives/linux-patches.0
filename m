Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDD31DF73E;
	Wed, 19 Feb 2025 08:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954490; cv=none; b=JuGm0+4XtHfZvJPNO9yf6stkQ6+P/yUa2sKqkpBobXwuyKWHZzuV9EbNIfiCGPPFX5owKKLHsiQNJ2fnq/OdXTOD/PD6/XztVkS794EQL4/KLjbt+K/NVaVtH2/0u30FdVvjG//YIMEGyn+xWdGWteiahljKC4tZxUAauUfwPEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954490; c=relaxed/simple;
	bh=lUk6QwKeZSJt6jptvUZ/2H4/IxplmztVvY2zkMNAuWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJIyPDBKbWoZs7ftAKBfXrl/EtLXpebwMnbd3aghAfxz98xY7DeGhsuADT5W2ze/2xcux+rdTjGWgTKDwx3A4p/4jzYKEnMInvf8SJplpeg89o2cwsqwTtTU4WxhUYjMDmC8gxaHTzQI/QqEOwLmkAFpUAl8+012JEenDyufKhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mk8r77IM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mk8r77IM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1DFC4CEE6;
	Wed, 19 Feb 2025 08:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954490;
	bh=lUk6QwKeZSJt6jptvUZ/2H4/IxplmztVvY2zkMNAuWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mk8r77IMEG9e5R0xBEi5DwwBula4Nk+FNqitAYbEXTA7qGzq7GhBJ3IM3tS/Q9StU
	 5QF/vBuLl45Ts9SZLuy3t43JUISYTOCPNuNdmrNShTj4AJ6qV3hzQnCow4EHjt7G9X
	 2EHwF5iImz/zQm18flO4/o8E5SFbdJ+wWwN57kbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 219/274] ipv4: use RCU protection in inet_select_addr()
Date: Wed, 19 Feb 2025 09:27:53 +0100
Message-ID: <20250219082618.147539473@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 719817cd293e4fa389e1f69c396f3f816ed5aa41 ]

inet_select_addr() must use RCU protection to make
sure the net structure it reads does not disappear.

Fixes: c4544c724322 ("[NETNS]: Process inet_select_addr inside a namespace.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250205155120.1676781-7-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/devinet.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index c8b3cf5fba4c0..55b8151759bc9 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1371,10 +1371,11 @@ __be32 inet_select_addr(const struct net_device *dev, __be32 dst, int scope)
 	__be32 addr = 0;
 	unsigned char localnet_scope = RT_SCOPE_HOST;
 	struct in_device *in_dev;
-	struct net *net = dev_net(dev);
+	struct net *net;
 	int master_idx;
 
 	rcu_read_lock();
+	net = dev_net_rcu(dev);
 	in_dev = __in_dev_get_rcu(dev);
 	if (!in_dev)
 		goto no_in_dev;
-- 
2.39.5



