Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7D318FDD2;
	Mon, 28 Oct 2024 06:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097357; cv=none; b=Ko08fhEKq8ds1ifk2NF7S3t7+iRfWGIWiUnK5/F53Yc2T7nRD77zX1yXsj9SkfGQXC9ayC8yvXGudEp8uuUa1qNLQ1LBU8+PjmBItmVZYpIv4iqCj0eZCseJQ5anJfEac64dnz7svVENAzBai2K6DASyJF3jAtjiAOvOBK+r8z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097357; c=relaxed/simple;
	bh=zKM1BipH0DXY4+T8/fl260zaKE97dpPXjyfMLlXRb6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ld19Ch2dEh9N4xqH6Tx2OSgjkqeQ17r3pWcZzwweVQEJAP0ytUOTTJ/WnqUmjEwPhpONzXGGAt8KJyGW3cXhSNCCTx8KmX5300r+LWLJyHhYRtCng6ue6iYws+c9qLoJ8N3WG7FRuEQ6tMV9BDVTvLNQQ0wor8EVCP5GavMAFGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ETsWgJ2w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ETsWgJ2w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1A5C4CEC3;
	Mon, 28 Oct 2024 06:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097357;
	bh=zKM1BipH0DXY4+T8/fl260zaKE97dpPXjyfMLlXRb6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ETsWgJ2wSVNcGdWtWMtvishcEB/II/wZ8MJ5g1Gru3rad/VmLr3mlvJXyrzK8z9Lo
	 15TMr0wZrD/292d0pwIPF+Vv8aR2NrEU8KwS7ncSaEaX/HsX/Wf5+45OZe1viNSwqI
	 0MRapzxmKHsKqrT6OwtiAHZJjGpxa3ZRgXwqMZ9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ignat Korchagin <ignat@cloudflare.com>,
	Ilya Katsnelson <me@0upti.me>,
	=?UTF-8?q?Krzysztof=20Ol=C4=99dzki?= <ole@ans.pl>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 094/137] netfilter: xtables: fix typo causing some targets not to load on IPv6
Date: Mon, 28 Oct 2024 07:25:31 +0100
Message-ID: <20241028062301.355239940@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



