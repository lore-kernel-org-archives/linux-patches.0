Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E96400E17;
	Tue, 21 Jul 2026 18:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658170; cv=none; b=oCSSBPbYGrX9FR+3yIXtjCWM+N4hUipM6iIB7vodqcaNSEdNGFG2J0uvcF0YeRMRjAr2Furux0rykNoFDzpHYyzqohnh/vZI90f6Mz9xeVl4j1do81mHMspohjB/EX0nJKdB+VobgpZp7on8lmwtucqLooH3g4v6aGKa1PBlfNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658170; c=relaxed/simple;
	bh=Cgur5fitoUZbau2ju1KQnUB5bo+F4WbIbG2SKGKMaCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VlJjku9QJRjVnJpqaalKUdrc+RFSvtQPQm+AGuQ/PboojETWS7sl5LPVO8v24hXqPZFJX2jo8Gxfk9aIyjMZQV/RhExKw/OWj9OgYumv9KR1/EuzLR0wv87iawJABg1liE1uFWe2H8SMBPtc7VqY8805/3AWobSw87lSppCorGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VOIrOcpt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VOIrOcpt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2A91F000E9;
	Tue, 21 Jul 2026 18:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658169;
	bh=8KRLd/qGHzwH6UFi2VNlK2MkQ0N04O3lFBwzTXsnrww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VOIrOcptmHOXyftyAV7LxS+mJJXdsBRbytx5BXpPCfGuq69mK7pYFKth0uJu/oiKP
	 AhxJKgR04XXRl2+kH36oHXiZNNB6pZFkOY6Yi8SCBi/ugRTlU+PFidbyTQm5qP5GT0
	 EVXigvNNFIVtUu7aZEfgs3pyef1I+4E8nAYns2Ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <dstsmallbird@foxmail.com>,
	Wyatt Feng <bronzed_45_vested@icloud.com>,
	Ren Wei <enjou1224z@gmail.com>,
	Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1042/1611] netfilter: xt_connmark: reject invalid shift parameters
Date: Tue, 21 Jul 2026 17:19:18 +0200
Message-ID: <20260721152538.840385537@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Wyatt Feng <bronzed_45_vested@icloud.com>

[ Upstream commit 1b47026fb4b35bac850ad6e8a4ad7fc018e09ebc ]

Revision 2 of the CONNMARK target accepts user-controlled shift
parameters and applies them to 32-bit mark values in
connmark_tg_shift().

A shift_bits value of 32 or more triggers an undefined-shift bug when
the rule is evaluated. Invalid shift_dir values are also accepted and
silently fall back to the left-shift path.

Reject invalid revision-2 shift parameters in connmark_tg_check() so
malformed rules fail at installation time, before they can reach the
packet path.

Fixes: 472a73e00757 ("netfilter: xt_conntrack: Support bit-shifting for CONNMARK & MARK targets.")
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <dstsmallbird@foxmail.com>
Assisted-by: Codex:GPT-5.4
Signed-off-by: Wyatt Feng <bronzed_45_vested@icloud.com>
Reviewed-by: Ren Wei <enjou1224z@gmail.com>
Reviewed-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_connmark.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index 4277084de2e70c..2cf27f7d59b95f 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -112,6 +112,16 @@ static int connmark_tg_check(const struct xt_tgchk_param *par)
 	return ret;
 }
 
+static int connmark_tg_check_v2(const struct xt_tgchk_param *par)
+{
+	const struct xt_connmark_tginfo2 *info = par->targinfo;
+
+	if (info->shift_dir > D_SHIFT_RIGHT || info->shift_bits >= 32)
+		return -EINVAL;
+
+	return connmark_tg_check(par);
+}
+
 static void connmark_tg_destroy(const struct xt_tgdtor_param *par)
 {
 	nf_ct_netns_put(par->net, par->family);
@@ -162,7 +172,7 @@ static struct xt_target connmark_tg_reg[] __read_mostly = {
 		.name           = "CONNMARK",
 		.revision       = 2,
 		.family         = NFPROTO_IPV4,
-		.checkentry     = connmark_tg_check,
+		.checkentry     = connmark_tg_check_v2,
 		.target         = connmark_tg_v2,
 		.targetsize     = sizeof(struct xt_connmark_tginfo2),
 		.destroy        = connmark_tg_destroy,
@@ -183,7 +193,7 @@ static struct xt_target connmark_tg_reg[] __read_mostly = {
 		.name           = "CONNMARK",
 		.revision       = 2,
 		.family         = NFPROTO_IPV6,
-		.checkentry     = connmark_tg_check,
+		.checkentry     = connmark_tg_check_v2,
 		.target         = connmark_tg_v2,
 		.targetsize     = sizeof(struct xt_connmark_tginfo2),
 		.destroy        = connmark_tg_destroy,
-- 
2.53.0



