Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BAE2149C57;
	Mon, 16 Sep 2024 12:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488670; cv=none; b=p+7m7e6nGv4AcMdh+IzJVK+TXQVS6PDUyrv4Rz9Zz4HYZk4T5u17cWKzatjNY5E3XTkn4h08MEjQ7BhBZJ+E/GM3LmrAB5ezeMfxXUH+MICqkmFF/DBBgMhpZ4GazxF99cTgfatMZupdYkB1YzaFXtuT/WcNffe4KIXC263/Wqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488670; c=relaxed/simple;
	bh=bNAzY/3imvP5IElGAgLlLEKQkMBJxHPA1jDHowjRBDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rup+Jcc7S3XUGTd6z4AaqBRCFsUI6thy+6EdH8cFxxkuoLlgiNMBYlm/zra66ecfmEAxkB8YxnvPDO+Tm+Ah7UhOp3Gm8Jc/eA81kbIt5QD/30o7ePc3rcn23Y8gBwyXWrvi95xf3FEJVB7jvhdKr01RM4RwRtjEWOMgV3O6kCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J131iAwH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J131iAwH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A33BEC4CEC4;
	Mon, 16 Sep 2024 12:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488670;
	bh=bNAzY/3imvP5IElGAgLlLEKQkMBJxHPA1jDHowjRBDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J131iAwHsHuBq4GJ9dTB5GrQjRTZoZ3zrfXKTrhLURq4Pma6YT9ivIuC6DhZyiCWn
	 Gk46J0zI1zqcRBBK9OUMtLAwl0uOizzx14T+qDVQV2fBdeZf4TWO2zdKIozglB6+LK
	 +7du9YXCKD1n2Hqe0UkG/Zc9N75cuOgpYSpIsnA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 72/91] netfilter: nft_socket: fix sk refcount leaks
Date: Mon, 16 Sep 2024 13:44:48 +0200
Message-ID: <20240916114226.850044503@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 8b26ff7af8c32cb4148b3e147c52f9e4c695209c ]

We must put 'sk' reference before returning.

Fixes: 039b1f4f24ec ("netfilter: nft_socket: fix erroneous socket assignment")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_socket.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index f30163e2ca62..765ffd6e06bc 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -110,13 +110,13 @@ static void nft_socket_eval(const struct nft_expr *expr,
 			*dest = READ_ONCE(sk->sk_mark);
 		} else {
 			regs->verdict.code = NFT_BREAK;
-			return;
+			goto out_put_sk;
 		}
 		break;
 	case NFT_SOCKET_WILDCARD:
 		if (!sk_fullsock(sk)) {
 			regs->verdict.code = NFT_BREAK;
-			return;
+			goto out_put_sk;
 		}
 		nft_socket_wildcard(pkt, regs, sk, dest);
 		break;
@@ -124,7 +124,7 @@ static void nft_socket_eval(const struct nft_expr *expr,
 	case NFT_SOCKET_CGROUPV2:
 		if (!nft_sock_get_eval_cgroupv2(dest, sk, pkt, priv->level)) {
 			regs->verdict.code = NFT_BREAK;
-			return;
+			goto out_put_sk;
 		}
 		break;
 #endif
@@ -133,6 +133,7 @@ static void nft_socket_eval(const struct nft_expr *expr,
 		regs->verdict.code = NFT_BREAK;
 	}
 
+out_put_sk:
 	if (sk != skb->sk)
 		sock_gen_put(sk);
 }
-- 
2.43.0



