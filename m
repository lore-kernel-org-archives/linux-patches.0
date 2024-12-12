Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC242153DF;
	Thu, 12 Dec 2024 15:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017571; cv=none; b=Tt21yAlL+y6Wvy68gLLMwKOShKrbHuyITtmhIoR9yRikxbEnw0PlCRrn9Legz69xbUQUI4/b0yeCMkCW89OUTeploiMF/34n6k6ooDauqMz2KLOBeHXpXt4n8v5ucL0/8OJz4aSUot5Rl5WsaEvFiY/MMg0W4LcAlfMJQ6HkYDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017571; c=relaxed/simple;
	bh=jyfMgLgEY2uwqzDWuc80rohnqjHrTfDIAES8x80t958=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y6rPop6ysxXbosOHxOXqZifWwqVCA5yE1GiyDLj+/vADP7/aGqHILZZmbNSx8vKih+DFd6oCz30XEJM5PZanuwOE+pERFvPpms94zl67tLAil9YNsYXoXaDOKRyQxYz258OpgMYHc8a7VbjSBJ64V4EY0kti9pkoZOh3VbT260Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wVUHJBcN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wVUHJBcN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDBFEC4CECE;
	Thu, 12 Dec 2024 15:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017571;
	bh=jyfMgLgEY2uwqzDWuc80rohnqjHrTfDIAES8x80t958=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wVUHJBcNR/opCzb/B+CWRoRrtWkX917dU+sKSEyCFDBVW3Ddpj+0fCJIl6hz+aZ8S
	 /bGkErClrUn0Tyj7ey5OC6yLtlgrYc2TXNij2lARNp7vOgrtreHgzL+YDrHAb41J8w
	 26lGAvkWMwIP19Ee3+1ZQ09q2Ubc+AW0Sp5/XP/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 051/356] netfilter: ipset: Hold module reference while requesting a module
Date: Thu, 12 Dec 2024 15:56:10 +0100
Message-ID: <20241212144246.648598389@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 61431690cbd5f..cc20e6d56807c 100644
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



