Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FE514B946;
	Mon, 16 Sep 2024 12:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488077; cv=none; b=sn42jzQDgSDLG6WK9z+0GqP+ahS+Hs/f8MAvOdCgMyW3uFyVze+/0yF4JW/Toyl5Nd8AxToBTX6yWxnSIfwshYvUqcPcxSXnnrGcDjJMbZo/8p7kFXTAg85AA4HpK5QZL9YhlVNGebCCxAoshqvYjW0D59VYM4fPMjyIGwDTymQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488077; c=relaxed/simple;
	bh=KqYQm5bQIpZ3VYzI6lVD9OKA7HiYU45E44x3KN49Uhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lHlZnshF31/e4iy4lFnYUweSUQQHYzwydDAF2KdPvhWU3eDOJUL6Hdy50rlJTLAAE9n1w8lT2S8YDqIMVFn8Nik5YnXU62SgH37RNzgIz2ehnW84HIbd00E7eSoCo+HD5bSfkDGPNdIP9Y1ZqpGLCynZz8mPkc6YGWXVrKeNoxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CuLjF6o/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CuLjF6o/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14A9C4CEC4;
	Mon, 16 Sep 2024 12:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488077;
	bh=KqYQm5bQIpZ3VYzI6lVD9OKA7HiYU45E44x3KN49Uhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CuLjF6o/FJYaDzaOTSylzlVt71q91bp2MBNGwx5TpML5in2K07k1Zxlh+nSUJ3cSi
	 nbUqCFxtXn2VLiIhGnyUH8E09mMUXqQbKbpfx/AC7L11CZeQFQlgDLm3EixbU4xuzc
	 E2vvmV+i8KKKx/X+cp/5QGST9YdFLNKp6lRHDKEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 51/63] netfilter: nft_socket: fix sk refcount leaks
Date: Mon, 16 Sep 2024 13:44:30 +0200
Message-ID: <20240916114222.863406933@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
References: <20240916114221.021192667@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f28324fd8d71..0f37738e4b26 100644
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



