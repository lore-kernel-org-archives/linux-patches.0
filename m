Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD4134250D
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301942; cv=none; b=ckYC6tCp8hBjLKsViBLsL3TrjAo2EoCi+/9qJ08KJwjHprMpZU0mjfir6xIByXlWqO2aTDNgfYL35iHZ2V0p6qd5imwj62s7NckMF+RTTGpwU6jz0jQ+iS2S1nutmUpV2r/83c1JyY/VGrhXPTNatp4mcLE4Hx74x7GgNF/xAIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301942; c=relaxed/simple;
	bh=Q2FF34X8jhhMEbaoOW/mJFnbO/nF1vkKeoqJq/yvFg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B+oAc5DBOhxM4hVwQw5puqa5PBw54Pmrawkv1ZYXjqHJ2A1J0ur0tgIfRDXlWMV7rYMDvyKKvwkJnPSMckMuB4T/FO2FTHdP8xxhh3eUKhh9uv/zulutpe85Xr1V1M/sG0jnvqb+8xi4QAk25gIl/gn5Az8cRwzkB5pF3Q4YsZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GtmXDAjM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GtmXDAjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35ECEC19423;
	Sat, 28 Feb 2026 18:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301942;
	bh=Q2FF34X8jhhMEbaoOW/mJFnbO/nF1vkKeoqJq/yvFg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GtmXDAjMm1ddHIEw1A96oeJUmTMKISmrK1r2lGLN5eQS9CAaJ18mSB4WfrhiDN3Nm
	 veQ66GVneJRnxf9TemiHeKzpUelaRZR169SkKMZg2aK0ef3Qo25zK/OarosNOqr4dI
	 kFf7I5uN/EtuNdcA2aYpN2BTrmBfu+VEtcdCqKTCYCxAwGDlSj57FgKO/4yrRQnWq7
	 W3u/66uhLeH+EAl8rFTz8OZMnSROiw+C2gaVwGlFS45wOzOQClVilSDHjZNJZPJkyF
	 x8/a0coUjXCF2ciYkpo6QvtfD+MSRg/v1yMoot0ltC6naABquzAFchQZqmsE2WAwz1
	 Wev3SuY4AVZ5A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 380/385] net: remove WARN_ON_ONCE when accessing forward path array
Date: Sat, 28 Feb 2026 13:00:02 -0500
Message-ID: <20260228180011.1568201-380-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 008e7a7c293b30bc43e4368dac6ea3808b75a572 ]

Although unlikely, recent support for IPIP tunnels increases chances of
reaching this WARN_ON_ONCE if userspace manages to build a sufficiently
long forward path.

Remove it.

Fixes: ddb94eafab8b ("net: resolve forwarding path from virtual netdevice and HW destination address")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 1d276a26a360d..553317ad6f1b4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -720,7 +720,7 @@ static struct net_device_path *dev_fwd_path(struct net_device_path_stack *stack)
 {
 	int k = stack->num_paths++;
 
-	if (WARN_ON_ONCE(k >= NET_DEVICE_PATH_STACK_MAX))
+	if (k >= NET_DEVICE_PATH_STACK_MAX)
 		return NULL;
 
 	return &stack->path[k];
-- 
2.51.0

