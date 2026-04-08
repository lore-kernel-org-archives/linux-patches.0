Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F913D6CAE;
	Wed,  8 Apr 2026 18:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674405; cv=none; b=cPJ9o88RxkDSXbvGec12PXHGnYYsptdF+7p8JPir6UV2a8z+x4fzhT8OKPb7z10EIGDbDejh/Ig0xUIps0+uHnHkB5KCquR60TwEgJKDhRetI2sacyDjHLfHGpfYH2p2ik2Oe3lfBG3eW8quTlm5w5hjls2wrcSRrHRETa3CLpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674405; c=relaxed/simple;
	bh=6W+Kc+l/3euofFD4eTzUDVMm6waX6AOVuF2+VnZSLho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dn9ZX/uiRGY25JyF7c3NOfdLC484LRavOpcYMmGKLSeJp6VmOKmzPP2uvKip4TpauYvtkHHSdwxa6uOTvjaIZnbCljWOUR6W76TjfRIHiMK5FiyPrqfR7EWI1Pf6Qs80hQsd06iDCFjkltgkDVJCUFIfASGmXxd0nEPCB+6p8Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FcGfp4GG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FcGfp4GG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B5EC19421;
	Wed,  8 Apr 2026 18:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674404;
	bh=6W+Kc+l/3euofFD4eTzUDVMm6waX6AOVuF2+VnZSLho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FcGfp4GGVfCzqQ6ggy4cp1wEUOPcvag+vFVBvhlnEfXXb73MZXOOGFv2mOJig0P4O
	 woQXgFOgbpauwzhVDNIooVJgA1g1W2OQS8ERchFJBiokHJWdIPlZy7WMGIs11FMgZJ
	 gdxYnjO/nSiUTLcg+ERalva+y3pJ635NmiHbVYLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 085/311] netfilter: x_tables: ensure names are nul-terminated
Date: Wed,  8 Apr 2026 20:01:25 +0200
Message-ID: <20260408175942.587318437@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit a958a4f90ddd7de0800b33ca9d7b886b7d40f74e ]

Reject names that lack a \0 character before feeding them
to functions that expect c-strings.

Fixes tag is the most recent commit that needs this change.

Fixes: c38c4597e4bf ("netfilter: implement xt_cgroup cgroup2 path match")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_cgroup.c  | 6 ++++++
 net/netfilter/xt_rateest.c | 5 +++++
 2 files changed, 11 insertions(+)

diff --git a/net/netfilter/xt_cgroup.c b/net/netfilter/xt_cgroup.c
index c437fbd59ec13..43d2ae2be628d 100644
--- a/net/netfilter/xt_cgroup.c
+++ b/net/netfilter/xt_cgroup.c
@@ -65,6 +65,9 @@ static int cgroup_mt_check_v1(const struct xt_mtchk_param *par)
 
 	info->priv = NULL;
 	if (info->has_path) {
+		if (strnlen(info->path, sizeof(info->path)) >= sizeof(info->path))
+			return -ENAMETOOLONG;
+
 		cgrp = cgroup_get_from_path(info->path);
 		if (IS_ERR(cgrp)) {
 			pr_info_ratelimited("invalid path, errno=%ld\n",
@@ -102,6 +105,9 @@ static int cgroup_mt_check_v2(const struct xt_mtchk_param *par)
 
 	info->priv = NULL;
 	if (info->has_path) {
+		if (strnlen(info->path, sizeof(info->path)) >= sizeof(info->path))
+			return -ENAMETOOLONG;
+
 		cgrp = cgroup_get_from_path(info->path);
 		if (IS_ERR(cgrp)) {
 			pr_info_ratelimited("invalid path, errno=%ld\n",
diff --git a/net/netfilter/xt_rateest.c b/net/netfilter/xt_rateest.c
index 72324bd976af8..b1d736c15fcbe 100644
--- a/net/netfilter/xt_rateest.c
+++ b/net/netfilter/xt_rateest.c
@@ -91,6 +91,11 @@ static int xt_rateest_mt_checkentry(const struct xt_mtchk_param *par)
 		goto err1;
 	}
 
+	if (strnlen(info->name1, sizeof(info->name1)) >= sizeof(info->name1))
+		return -ENAMETOOLONG;
+	if (strnlen(info->name2, sizeof(info->name2)) >= sizeof(info->name2))
+		return -ENAMETOOLONG;
+
 	ret  = -ENOENT;
 	est1 = xt_rateest_lookup(par->net, info->name1);
 	if (!est1)
-- 
2.53.0



