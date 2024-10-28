Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215D615B10D;
	Mon, 28 Oct 2024 06:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097860; cv=none; b=mZIuPP06aud2keWj4WHs/uLTiFY+48tcUCaqlEqWXSdGMfEKz+R1OYhOtUchZbEuDD5BfQrJwC2EXCpNeeH0BpHPNWqTHH9tGnt26+nwdvvAS2Uxf2gldx2vySu0riKppu5BgLq7aotX4PMZTV1G+v+BAkC4jADkZZrYF5LYU1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097860; c=relaxed/simple;
	bh=26pFqjS20SOREnwjZ+XOU230K/vZJXRFGd3DtaRRXOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aZyg2x2xsit5r7ko1sxHE+arR3DZ2IYwETPXbwABtMH0O2v1D32pqyRTwu6Iv72X2kx5DeYqNNyaBoCvRb7FOqoJrsMNMCT3yhip/HVchnPnwFonwrDtM7T+fugqVBeZLgBaD/KOHxMmH6oU1k4WN8kxAIVMrw7g5Y4KcGSOdxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qt2Aw2k2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qt2Aw2k2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D73C4CEC3;
	Mon, 28 Oct 2024 06:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097860;
	bh=26pFqjS20SOREnwjZ+XOU230K/vZJXRFGd3DtaRRXOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qt2Aw2k2AhsO3ZCjVG7NCbsyWLPLrqjfp7jHsW7YvG2JsqJIi2s8t1UV4gPebOMJM
	 qpl8j+6PNYMkm7ClT8XVbehTmEg7EtD0BmW1MIv1zfHvnXE3NTyuM66WZS1PyJX+PA
	 56J6HUqslQb0h9hAaI2wNMPeB2hjtvIgg9VduNXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ignat Korchagin <ignat@cloudflare.com>,
	Ilya Katsnelson <me@0upti.me>,
	=?UTF-8?q?Krzysztof=20Ol=C4=99dzki?= <ole@ans.pl>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 144/208] netfilter: xtables: fix typo causing some targets not to load on IPv6
Date: Mon, 28 Oct 2024 07:25:24 +0100
Message-ID: <20241028062310.178366177@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 306ed1728e8438caed30332e1ab46b28c25fe3d8 ]

- There is no NFPROTO_IPV6 family for mark and NFLOG.
- TRACE is also missing module autoload with NFPROTO_IPV6.

This results in ip6tables failing to restore a ruleset. This issue has been
reported by several users providing incomplete patches.

Very similar to Ilya Katsnelson's patch including a missing chunk in the
TRACE extension.

Fixes: 0bfcb7b71e73 ("netfilter: xtables: avoid NFPROTO_UNSPEC where needed")
Reported-by: Ignat Korchagin <ignat@cloudflare.com>
Reported-by: Ilya Katsnelson <me@0upti.me>
Reported-by: Krzysztof Olędzki <ole@ans.pl>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_NFLOG.c | 2 +-
 net/netfilter/xt_TRACE.c | 1 +
 net/netfilter/xt_mark.c  | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_NFLOG.c b/net/netfilter/xt_NFLOG.c
index d80abd6ccaf8f..6dcf4bc7e30b2 100644
--- a/net/netfilter/xt_NFLOG.c
+++ b/net/netfilter/xt_NFLOG.c
@@ -79,7 +79,7 @@ static struct xt_target nflog_tg_reg[] __read_mostly = {
 	{
 		.name       = "NFLOG",
 		.revision   = 0,
-		.family     = NFPROTO_IPV4,
+		.family     = NFPROTO_IPV6,
 		.checkentry = nflog_tg_check,
 		.destroy    = nflog_tg_destroy,
 		.target     = nflog_tg,
diff --git a/net/netfilter/xt_TRACE.c b/net/netfilter/xt_TRACE.c
index f3fa4f11348cd..a642ff09fc8e8 100644
--- a/net/netfilter/xt_TRACE.c
+++ b/net/netfilter/xt_TRACE.c
@@ -49,6 +49,7 @@ static struct xt_target trace_tg_reg[] __read_mostly = {
 		.target		= trace_tg,
 		.checkentry	= trace_tg_check,
 		.destroy	= trace_tg_destroy,
+		.me		= THIS_MODULE,
 	},
 #endif
 };
diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
index f76fe04fc9a4e..65b965ca40ea7 100644
--- a/net/netfilter/xt_mark.c
+++ b/net/netfilter/xt_mark.c
@@ -62,7 +62,7 @@ static struct xt_target mark_tg_reg[] __read_mostly = {
 	{
 		.name           = "MARK",
 		.revision       = 2,
-		.family         = NFPROTO_IPV4,
+		.family         = NFPROTO_IPV6,
 		.target         = mark_tg,
 		.targetsize     = sizeof(struct xt_mark_tginfo2),
 		.me             = THIS_MODULE,
-- 
2.43.0



