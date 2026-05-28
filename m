Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54F3DDC5;
	Thu, 28 May 2026 20:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000116; cv=none; b=gn+5CZk3utjq55i48aP1Xxby/Pjcny1VbLNPJwlx6i0lSW1/lzORFF7vVrMUC44JAMg8LFqM1Su5rJ3Qpah0H8nnye5PSis6yPj4r5g+FMDM0uMFTSU+zg0hB7yofMks4RQUhJN/MQp25GELJmfwgRHjZDXHUj/ryu5MIBBV/MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000116; c=relaxed/simple;
	bh=J1XQnfUtMnmiG3n3opYvTji5eQV2BV+Okr1BDELDd/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FE8UE2XSDT3C25yXJckmwtStVY2TkZCXSyq/a1bzmItKZydGI83Ewb/iBrNdUNuwwKutF14aHN34clxs+90NDRwQfu+k/IWQKY8qE9VMbKlBAougXyQ/OQrMeK2nO/tCfI2REUO2SNPjjRVQypoj3AtCFHl7Z72Zx3JlTFU+QyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x0rd9AiL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x0rd9AiL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD151F000E9;
	Thu, 28 May 2026 20:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000115;
	bh=SORGKgDyiNqONqVZOUOHm24uAEW6tlXox2vmF7wjPEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x0rd9AiLYoe9sMgHlSJ1oiwMdqHQ+1oMOlz+YsHqmpmI7FsZjJWeUKVobNE4mDszu
	 IW7NfhP1ijWT3d5/H9Pyi7VCBrvMR1XbL6hfgwBpFMyXc5YqMadC6mswlsSGJKuM2e
	 cR7Xg0JQcSsABQuAoSeX3ouzeP+a76KAEqKkUNnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 307/377] netfilter: nft_inner: release local_lock before re-enabling softirqs
Date: Thu, 28 May 2026 21:49:05 +0200
Message-ID: <20260528194647.258234089@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit a6cb3ff979855f7f0ee9450a947fe8f96c2ba37a ]

Quoting sashiko:
 In the error path, local_bh_enable() is called before
 local_unlock_nested_bh().

Fixes: ba36fada9ab4 ("netfilter: nft_inner: Use nested-BH locking for nft_pcpu_tun_ctx")
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_inner.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_inner.c b/net/netfilter/nft_inner.c
index 1b3e7a976f560..ad08a43535b55 100644
--- a/net/netfilter/nft_inner.c
+++ b/net/netfilter/nft_inner.c
@@ -246,8 +246,8 @@ static bool nft_inner_restore_tun_ctx(const struct nft_pktinfo *pkt,
 	local_lock_nested_bh(&nft_pcpu_tun_ctx.bh_lock);
 	this_cpu_tun_ctx = this_cpu_ptr(&nft_pcpu_tun_ctx.ctx);
 	if (this_cpu_tun_ctx->cookie != (unsigned long)pkt->skb) {
-		local_bh_enable();
 		local_unlock_nested_bh(&nft_pcpu_tun_ctx.bh_lock);
+		local_bh_enable();
 		return false;
 	}
 	*tun_ctx = *this_cpu_tun_ctx;
-- 
2.53.0



