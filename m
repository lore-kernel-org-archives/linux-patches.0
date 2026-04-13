Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EAD318ED2;
	Mon, 13 Apr 2026 16:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099434; cv=none; b=VA5TK0XoIB6woKRXat2qCTo6wPV4uLcf6rjAqYKLEDY5HO1miOLBTZdx7dpSnDIWBZWLe9IaNx84NxKRhG2p0y0ztdGQCdty84vbYILPF2DqOz1IyOe5pu3wIKbBaMIkccr/1Ueh5R2CjDeZpxwfecDvb7KZpOUMT3JKZi6fZAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099434; c=relaxed/simple;
	bh=X4tMWpE/x7l4a5WxN8Pj0j36xixdbaGxThj+tyaOHVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z8MHBPAjCmRk/Ly49Og2zyqX1sDyWi9nQrgKx1kkp82KfC9TDzzMoJY7/PJOMs6zzYAtNao739cVsI86c6P5J8nRbESU0EH6bL+OjIhx6ZIbiZc6yNr+Bz6Ax1pR/Ghn3wudIsOG8h9jYJyMOKYGSulc/zsZMRk3QaimMq6eByY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GtbQvNS8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GtbQvNS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AEB5C2BCAF;
	Mon, 13 Apr 2026 16:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099434;
	bh=X4tMWpE/x7l4a5WxN8Pj0j36xixdbaGxThj+tyaOHVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GtbQvNS8MBGFJ3ehjDHAGNmgbpJbubxoAEwoiCj0iIasVwxIKls9yw/N5eiq+ck/f
	 VwDT/cbpCkM669iwNHrR63uY+jWpPFQ/mji8GSxrWoaaajBghplWBpo0zQ9GE+e0+h
	 w4Muqi7Nig7ASUciWlRDLHWB7QGT0WnStvzbu3ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 338/491] netfilter: x_tables: ensure names are nul-terminated
Date: Mon, 13 Apr 2026 17:59:43 +0200
Message-ID: <20260413155831.694623023@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c0f5e9a4f3c65..bfc98719684e2 100644
--- a/net/netfilter/xt_cgroup.c
+++ b/net/netfilter/xt_cgroup.c
@@ -53,6 +53,9 @@ static int cgroup_mt_check_v1(const struct xt_mtchk_param *par)
 
 	info->priv = NULL;
 	if (info->has_path) {
+		if (strnlen(info->path, sizeof(info->path)) >= sizeof(info->path))
+			return -ENAMETOOLONG;
+
 		cgrp = cgroup_get_from_path(info->path);
 		if (IS_ERR(cgrp)) {
 			pr_info_ratelimited("invalid path, errno=%ld\n",
@@ -85,6 +88,9 @@ static int cgroup_mt_check_v2(const struct xt_mtchk_param *par)
 
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



