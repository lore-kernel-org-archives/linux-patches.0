Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1579248895;
	Mon, 23 Jun 2025 13:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684682; cv=none; b=o81ik2Vbjxorojfn1f2mXrAwtHGxQU9M9EUE3BcawS0RStzpa00k4fGATLcYTyR1E5WTDwW1BLx1Vy4Fd6W6ywv42lBiOqdLiA3MjthUZGx0AZdkfAAFeexIsn/taAtYCB5JBaDGHWBHxWW/kMNKuT6F5gGPhuPee9HRGet114k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684682; c=relaxed/simple;
	bh=n9+PdzRWSJx7wBJ/wPTkv7a5o6NOHK/mdlS3IZgP0pE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTYSD05hI3tlg/cJYDtOwlxJT6O1jTFEyfLABgP/PUadjIHMKMbIsLtTUaTv1I3FGfW4aT8kEhtMXToY2c13XNcbhxI1/VJThuK1WFjEUTn1s6LL8X8DZaq/NsBSlJFDXmu/Q5dfdLzpmmvBrE+mAc+ANGRx7xz+/vTEtG+5cQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sr8p3IeN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sr8p3IeN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780EDC4CEEA;
	Mon, 23 Jun 2025 13:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684681;
	bh=n9+PdzRWSJx7wBJ/wPTkv7a5o6NOHK/mdlS3IZgP0pE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sr8p3IeN/BAneYlKRAWttMf4YAoB2IlZZ5yyO1JCw8EdinuA7jAyTKtU8DfSss41P
	 Lug83QohHWKgXi3Z0AGJ6IaykTcGUWyI4iVfT63aNsWcIt1NYfOq9SyCimuHTMdSDB
	 0bhNHhstoKE2W7IoqhsHDMeY547h1lni4vPpWDAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 008/222] netfilter: nft_socket: fix sk refcount leaks
Date: Mon, 23 Jun 2025 15:05:43 +0200
Message-ID: <20250623130612.150097773@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit 8b26ff7af8c32cb4148b3e147c52f9e4c695209c upstream.

We must put 'sk' reference before returning.

Fixes: 039b1f4f24ec ("netfilter: nft_socket: fix erroneous socket assignment")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_socket.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -69,7 +69,7 @@ static void nft_socket_eval(const struct
 			*dest = sk->sk_mark;
 		} else {
 			regs->verdict.code = NFT_BREAK;
-			return;
+			goto out_put_sk;
 		}
 		break;
 	default:
@@ -77,6 +77,7 @@ static void nft_socket_eval(const struct
 		regs->verdict.code = NFT_BREAK;
 	}
 
+out_put_sk:
 	if (sk != skb->sk)
 		sock_gen_put(sk);
 }


