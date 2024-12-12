Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA53222D6D;
	Thu, 12 Dec 2024 17:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024575; cv=none; b=vE93FYIpajVTjJusnw3LAU9fRginbs5ZLbbpoNdwr1nqgOs4kyR38kbZyz4ztEJt1ibPO2pyIf7+QYeD4fRVb4mV6pMWwK00kEOG9QmrTiX8a++3NMIcJFjVYrXTLA52edr8//zKsXG98K+ogUeUBWieOb5V1n3lWDC+PvzBz48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024575; c=relaxed/simple;
	bh=Qd1Lep1pqSXxwS5V3qKJQAdKmV1w5eNp9UyKQC8YE80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hSRHU9A7M70oA8im4Gn1gyL7UU4NbwoUGZ1LZ17UCtE6hqpf/xUo16CpU2uzWC13lCA6ESaTdfG/06MvcHIGgNDNAhPaUCx3phY8sLbaSPxDS0f0TyYzt/lIYwZfB4HkFvTncZT7kI8hsY1kGhQdXJFhoqprzVHJILF91zZAjeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=utQxmqUK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="utQxmqUK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70657C4CED0;
	Thu, 12 Dec 2024 17:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024574;
	bh=Qd1Lep1pqSXxwS5V3qKJQAdKmV1w5eNp9UyKQC8YE80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=utQxmqUKzOg5IrJq6NT0d/KvcYO1lrZ2bJRuVH3BbmJ5LRl9cD6AK2RejKITWFZtr
	 iKFEPUCwZIKFjLJMoOo/DcXZXN8x+L2AEAnMA6pHKw/xmScSwL0EuRdmNkWrZofl5w
	 Ir84rI2CT2dw5518PIbGJc216wG2ufvoheTPp+w4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 341/459] netfilter: ipset: Hold module reference while requesting a module
Date: Thu, 12 Dec 2024 16:01:19 +0100
Message-ID: <20241212144307.132975507@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit 456f010bfaefde84d3390c755eedb1b0a5857c3c ]

User space may unload ip_set.ko while it is itself requesting a set type
backend module, leading to a kernel crash. The race condition may be
provoked by inserting an mdelay() right after the nfnl_unlock() call.

Fixes: a7b4f989a629 ("netfilter: ipset: IP set core support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index bac92369a5436..a265efd31ba96 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -104,14 +104,19 @@ find_set_type(const char *name, u8 family, u8 revision)
 static bool
 load_settype(const char *name)
 {
+	if (!try_module_get(THIS_MODULE))
+		return false;
+
 	nfnl_unlock(NFNL_SUBSYS_IPSET);
 	pr_debug("try to load ip_set_%s\n", name);
 	if (request_module("ip_set_%s", name) < 0) {
 		pr_warn("Can't find ip_set type %s\n", name);
 		nfnl_lock(NFNL_SUBSYS_IPSET);
+		module_put(THIS_MODULE);
 		return false;
 	}
 	nfnl_lock(NFNL_SUBSYS_IPSET);
+	module_put(THIS_MODULE);
 	return true;
 }
 
-- 
2.43.0



