Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE1886334;
	Sat, 30 May 2026 18:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166818; cv=none; b=uzekahUCUtx2yUo6PwYJQQE+YyrjTwanIQQ16mK3OuAQ86JW8swQKwDt4oggu5SpTZI9rltbRTlIS9KCvOwVCJyzyKDI00/Bc/xel4oy4IfS5dsK6Sh0JEvhCziRDzB6XyVWNypIy3PFiEcl9pXBNFjaz4I8KhHcTUDR/AzVEcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166818; c=relaxed/simple;
	bh=qX8KVY8FUiCy8CXTeSrQcTMdiDCMsppaCKLuHrtFMRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szpNZWByDX4adRTXgarf6BJ2xnDLgyqG/r4ZgVTejyAA3RiIr3+7zohJejVQuBtfDYoR3/fP7vMDwCoQZ2lyVnPlOI7uOv4PfpzX5ix8RALuCZZ13K+tJ3rvf/tgUhXw+UlySARB9C4qrZULxBpqnLxRHBK+Rwee1Fwf50TqRzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eUkUKzJG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eUkUKzJG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E35F1F00893;
	Sat, 30 May 2026 18:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166817;
	bh=u8Upcj4kqW6ViN5SM6gF4APZyU1Oqd1TG/fi5eO0AQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eUkUKzJGMXlz9dLSKSuLkansDlcdC+EZxA+K6iclpLyl2pC0d57oBy+24Ka4uNvYz
	 8PEhvZJ0LXzJGoGo2Yb00uWf55CsV0e+eFaZ7brahrEXr/YIRzbPVqD4qw/dNSG0hK
	 qEHj1fu2fbeO0Dl4tzEkgORJh2lqJVQquBoV0QaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 433/589] netfilter: nft_osf: restrict it to ipv4
Date: Sat, 30 May 2026 18:05:14 +0200
Message-ID: <20260530160236.097623559@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit b336fdbb7103fb1484e1dcb6741151d4b5a41e35 ]

This expression only supports for ipv4, restrict it.

Fixes: b96af92d6eaf ("netfilter: nf_tables: implement Passive OS fingerprint module in nft_osf")
Acked-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_osf.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index 720dc9fba6d4f..81207c172bbfd 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -28,6 +28,11 @@ static void nft_osf_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	struct nf_osf_data data;
 	struct tcphdr _tcph;
 
+	if (nft_pf(pkt) != NFPROTO_IPV4) {
+		regs->verdict.code = NFT_BREAK;
+		return;
+	}
+
 	if (pkt->tprot != IPPROTO_TCP) {
 		regs->verdict.code = NFT_BREAK;
 		return;
@@ -119,7 +124,6 @@ static int nft_osf_validate(const struct nft_ctx *ctx,
 
 	switch (ctx->family) {
 	case NFPROTO_IPV4:
-	case NFPROTO_IPV6:
 	case NFPROTO_INET:
 		hooks = (1 << NF_INET_LOCAL_IN) |
 			(1 << NF_INET_PRE_ROUTING) |
-- 
2.53.0



