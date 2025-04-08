Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA830264FA0;
	Tue,  8 Apr 2025 11:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110889; cv=none; b=VbTIkdjpAH6MBKwp8UvPPxrj8dCRD/McmZVpwYri2jf2+ZMFPpJ70PxMbKCr8tWBv0KydPtfdXxJvaAxDNvpSmENC3Lmg1eFLfIZukXwvXLjhxhOv96w8J7hgct3bBOsLed9PBQHlD4EJQs8m5xLpZPcosOFmd4ZxAhNw5y4Qas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110889; c=relaxed/simple;
	bh=ClKNIumN0hP7qfXOad1XsBod1sh9ieGg4tse7Z/OeQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFRAzfFBZv+YGg0h6bNyot/dEghFFEjNPlMg50jTIvZSkeC3LnVkh8QsJ8o2wBakmOhnS67UGt4XbiukcN/YkARwHfCoGPw+tFyaCfGLvg0stjj7KgOyRB+7YV07UhpINzUZHognYzOQbV4fpimIha1cTnBnY8XFrIhDrVYR9EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i9XxSPju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i9XxSPju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7E1C4CEE5;
	Tue,  8 Apr 2025 11:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110889;
	bh=ClKNIumN0hP7qfXOad1XsBod1sh9ieGg4tse7Z/OeQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i9XxSPjuoY1agTPUywLE3H0PSNu55MyH14J5As5epWsHqDdjHm+9wEzOAd/VXo8tO
	 grkAdKbwlDBa06MQ58iifHUZKK4/myDyXX1/M8Q8uEV4heaJRqMk6Jc7tNt0ByWBy2
	 wx8YjVzNYV6k5/Gvi6za1QEwinJeZH3ruCqEgVgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Guan <guanwentao@uniontech.com>,
	WangYuli <wangyuli@uniontech.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 232/731] netfilter: nf_tables: Only use nf_skip_indirect_calls() when MITIGATION_RETPOLINE
Date: Tue,  8 Apr 2025 12:42:09 +0200
Message-ID: <20250408104919.677457030@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WangYuli <wangyuli@uniontech.com>

[ Upstream commit e3a4182edd1ae60e7e3539ff3b3784af9830d223 ]

1. MITIGATION_RETPOLINE is x86-only (defined in arch/x86/Kconfig),
so no need to AND with CONFIG_X86 when checking if enabled.

2. Remove unused declaration of nf_skip_indirect_calls() when
MITIGATION_RETPOLINE is disabled to avoid warnings.

3. Declare nf_skip_indirect_calls() and nf_skip_indirect_calls_enable()
as inline when MITIGATION_RETPOLINE is enabled, as they are called
only once and have simple logic.

Fix follow error with clang-21 when W=1e:
  net/netfilter/nf_tables_core.c:39:20: error: unused function 'nf_skip_indirect_calls' [-Werror,-Wunused-function]
     39 | static inline bool nf_skip_indirect_calls(void) { return false; }
        |                    ^~~~~~~~~~~~~~~~~~~~~~
  1 error generated.
  make[4]: *** [scripts/Makefile.build:207: net/netfilter/nf_tables_core.o] Error 1
  make[3]: *** [scripts/Makefile.build:465: net/netfilter] Error 2
  make[3]: *** Waiting for unfinished jobs....

Fixes: d8d760627855 ("netfilter: nf_tables: add static key to skip retpoline workarounds")
Co-developed-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_core.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 75598520b0fa0..6557a4018c099 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -21,25 +21,22 @@
 #include <net/netfilter/nf_log.h>
 #include <net/netfilter/nft_meta.h>
 
-#if defined(CONFIG_MITIGATION_RETPOLINE) && defined(CONFIG_X86)
-
+#ifdef CONFIG_MITIGATION_RETPOLINE
 static struct static_key_false nf_tables_skip_direct_calls;
 
-static bool nf_skip_indirect_calls(void)
+static inline bool nf_skip_indirect_calls(void)
 {
 	return static_branch_likely(&nf_tables_skip_direct_calls);
 }
 
-static void __init nf_skip_indirect_calls_enable(void)
+static inline void __init nf_skip_indirect_calls_enable(void)
 {
 	if (!cpu_feature_enabled(X86_FEATURE_RETPOLINE))
 		static_branch_enable(&nf_tables_skip_direct_calls);
 }
 #else
-static inline bool nf_skip_indirect_calls(void) { return false; }
-
 static inline void nf_skip_indirect_calls_enable(void) { }
-#endif
+#endif /* CONFIG_MITIGATION_RETPOLINE */
 
 static noinline void __nft_trace_packet(const struct nft_pktinfo *pkt,
 					const struct nft_verdict *verdict,
-- 
2.39.5



