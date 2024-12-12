Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62740223C74;
	Thu, 12 Dec 2024 17:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023189; cv=none; b=WxOueaKOOm2ZsY7r31sNnUs5Vee4HnFAECiWCzUqrCanuLMbtNV3ihMnqcuQkJc+lmcMVk0zGY8X5ikyK6+Hu2PS1poAGclm5qroqhCRTrKklYExnhppaoWAYcFBquNB/4nr35QxXUcyOdVTfpcPlpQAQMnO0HOur+MMKjtdncs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023189; c=relaxed/simple;
	bh=1IHX3kmRqW6MYEyV3tA3HMqZzs4HAs2LZDcsOK8vlQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uRjpLS+DAXfZU3UGLtJkL8f+TSNwl2l6W9ueVemqz2wVqxUIKjOwYyymliQlA4YGPNqldUltpQ8nZHr4GtwZVG447iq/Fw4l8NCsBSaH7UihTL7tSUArJQ/9vDRlN34jXt9z5PIv5rW6GXMzRCY/R8b6KTvBYQ+solSdsp9li0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mJgieU8N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mJgieU8N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1FF5C4CED0;
	Thu, 12 Dec 2024 17:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023189;
	bh=1IHX3kmRqW6MYEyV3tA3HMqZzs4HAs2LZDcsOK8vlQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mJgieU8N73jde+OM2VhtPi7jZ4nO+aLqsWjOMO9GlLCcTRpMynQh1VhG+E/iNgYzE
	 ynJ4ZD4zZJEw2j4lgi7ZTqcCpis2k7feJBt6jA4mvnaS/HKHKDsWwRZho/bds5ayxk
	 nq14ZRyZ0iNTgbY3iJ/xqcra8ZIHKX21uwXAltBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 422/565] netfilter: ipset: Hold module reference while requesting a module
Date: Thu, 12 Dec 2024 16:00:17 +0100
Message-ID: <20241212144328.346501713@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f2f6b7325c706..72e5638206c0e 100644
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



