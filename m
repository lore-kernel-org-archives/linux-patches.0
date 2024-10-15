Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBD81C07C2;
	Tue, 15 Oct 2024 12:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997147; cv=none; b=cqtSPhPYgsgDn+ib2tsy0aBjU4pxT7V1JXZm1lHGbcuLvPJ8oX5JWiAujBoy0z4edZAkqbmq9S0TOO7T25FxLzEPiBb9mfLUYDmdfyAS1uRW/rfK6vQ/r0eRXVR2X+n2+ybvGNmLunQFw2GscrW+3xpRXNGZ24InUKPDgJs1eMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997147; c=relaxed/simple;
	bh=y/2VGZhdFGlicpvj1uUsY0kLFHx7kdVjOSEnuzAts0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eHgpcflCGDX4hGJGru2geY76DN+nGN09ACBiFad9DfiDSAIwBuNIZvxnj6JO+4nDxxZjG4rTD5qD9FoFcpBDeklwTSym5HaMvARviW8AE5oDF8Nd0r/uKAlRoq+6dj65S/cliI0DMR+dYcDlNdSiyy59UEritXfgss7rZq+WCOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xPv5GWyR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xPv5GWyR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55CBAC4CEC6;
	Tue, 15 Oct 2024 12:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997146;
	bh=y/2VGZhdFGlicpvj1uUsY0kLFHx7kdVjOSEnuzAts0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xPv5GWyRb7shArtFKG4CId2EsOv4Us4UYUQFNQLojKtyOs6l1hrxtEtXCCmV5hmvE
	 VirD11WRyNo2/ubbIlDP2DdpAEOtd2ELAdL4reu+l032VfeAWPjfNvLQ0pYSG7/dLk
	 ZmV8QCxvynGo3/FeQzoa1dwyAjGi5XKqxgXrNp9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/518] netfilter: nf_tables: reject element expiration with no timeout
Date: Tue, 15 Oct 2024 14:39:32 +0200
Message-ID: <20241015123919.629748718@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit d2dc429ecb4e79ad164028d965c00f689e6f6d06 ]

If element timeout is unset and set provides no default timeout, the
element expiration is silently ignored, reject this instead to let user
know this is unsupported.

Also prepare for supporting timeout that never expire, where zero
timeout and expiration must be also rejected.

Fixes: 8e1102d5a159 ("netfilter: nf_tables: support timeouts larger than 23 days")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5c937c5564b3f..a788f3e8fe2bb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5628,6 +5628,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	if (nla[NFTA_SET_ELEM_EXPIRATION] != NULL) {
 		if (!(set->flags & NFT_SET_TIMEOUT))
 			return -EINVAL;
+		if (timeout == 0)
+			return -EOPNOTSUPP;
+
 		err = nf_msecs_to_jiffies64(nla[NFTA_SET_ELEM_EXPIRATION],
 					    &expiration);
 		if (err)
-- 
2.43.0



