Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD176253B47;
	Mon, 23 Jun 2025 13:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684904; cv=none; b=R7/drT+GMcoL90nb0+6asnGDhW0qyh+5vIZDEqrBReHNCEiV7/2L46cxs4WUacY4HrJHaIHq56HbPGlgJXqhFoLKvZ1S+z/ju/9V8XzbqrnhRdOMqBFSXeaUW2NOKXu9xDOVBtmkHA0g6M9nlvlvUYKtpxyAiC5byVpqmmv20Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684904; c=relaxed/simple;
	bh=IU7q8dpsZPB7qORpFlWsBWtPMqrPMBlKxHwJM0DzIj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XcmUrG4CytigaDoerzUX11SKbXWk3wjfbsSQ/r2EqH025/MkYGt3WX8kQgV4SsgIXY4QmYa/7gY+JsclmcDfsWCUaOfCHDIFFb9md2pS4du/svxEddpiBy1lv4c51ZE5a6tC5js6+l37OjQJ8P/l6HBFNWs56VMp1CCNsOUG+fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0x8Cs5w5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0x8Cs5w5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA435C4CEF2;
	Mon, 23 Jun 2025 13:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684904;
	bh=IU7q8dpsZPB7qORpFlWsBWtPMqrPMBlKxHwJM0DzIj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0x8Cs5w5WJTmP27iJd3hpK1cRPL55PieQkBJDkk5BOKoVI614r9Eur6dBJOrV6rz5
	 RCrFLVb0FpuYAFeZQvbSoSymwg4wGg5rI4bK+1Y7jYOFD6cMOjvVO5ZZFQvKTJbe6/
	 TCmCAoC2m++fKitvJ7MboyF9gPmxV6Qxw+yXNNSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 009/355] netfilter: nft_socket: fix sk refcount leaks
Date: Mon, 23 Jun 2025 15:03:30 +0200
Message-ID: <20250623130627.024060716@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit 8b26ff7af8c32cb4148b3e147c52f9e4c695209c upstream.

We must put 'sk' reference before returning.

Fixes: 039b1f4f24ec ("netfilter: nft_socket: fix erroneous socket assignment")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_socket.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -88,13 +88,13 @@ static void nft_socket_eval(const struct
 			*dest = sk->sk_mark;
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
@@ -103,6 +103,7 @@ static void nft_socket_eval(const struct
 		regs->verdict.code = NFT_BREAK;
 	}
 
+out_put_sk:
 	if (sk != skb->sk)
 		sock_gen_put(sk);
 }


