Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF33E43E48C;
	Tue, 16 Jun 2026 15:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623553; cv=none; b=dfPGFOPeTJg5XHXLIw+801N+u1nMvry0L1apQHt6O6hoPp3ehKRWXoEUa+iK1TN8TwoEfm5T/ZXcV95IlF769YhVIDeY/bRwtHB+OC8F+YXGxJV+E+HUv8fc4XmtWdyeAdnwCUZQKXoqbaanlL1tD4fyDSvWRcTdfUCkIEFJ80s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623553; c=relaxed/simple;
	bh=IgIsSzRG35rn5pl/ZjFwBklNNtAhh4mcZpYjnHPbKzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L5eAE9u6P1c4fv7dAjX5ZSYSwD87LhnStkvBK2smYKrmOVtXzVGI0AiCSJbX6weCA+zdCtNWDazHbLlnXHuw4WsoA4UfXTZsc7423SayhwWZwv9xqq4O35tLu7s4tmYAXr39WuX5JyCyzOQJtFwyeE1uBD2n6xe9kCqoTQuAOXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SlCG2rsQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SlCG2rsQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9537A1F000E9;
	Tue, 16 Jun 2026 15:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623552;
	bh=8WF+/nWzUZSaCNi9S5jg8W4d/koVBWTLsi7sLMltB2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SlCG2rsQTIogW4YYFaKkq4J0cVZC7WF3oqYKcqzx8pRee+BnZjrkJWyHEH9oAhRop
	 jzFNueHdqwbUu6GJ26jPCV4FAmJQPMdN+qB0lq8hvCLhowGr7RPjLV6H8z76SxXsmW
	 kbMkv53sxnz2TRKId6nSV5W2WmfoDhy2tyB7KR0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davide Ornaghi <d.ornaghi97@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7.0 170/378] netfilter: nft_meta_bridge: fix stale stack leak via IIFHWADDR register
Date: Tue, 16 Jun 2026 20:26:41 +0530
Message-ID: <20260616145119.278568839@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davide Ornaghi <d.ornaghi97@gmail.com>

commit c7d573551f9286100a055ef696cde6af54549677 upstream.

NFT_META_BRI_IIFHWADDR declares its destination register with
len = ETH_ALEN (6 bytes), which the register-init tracking rounds up to
two 32-bit registers (8 bytes). nft_meta_bridge_get_eval() then does
memcpy(dest, br_dev->dev_addr, ETH_ALEN), writing only 6 bytes and
leaving the upper 2 bytes of the second register as uninitialised
nft_do_chain() stack. A downstream load of that register span leaks
those stale bytes to userspace.

Zero the second register before the memcpy so the full declared span is
written.

Fixes: cbd2257dc96e ("netfilter: nft_meta_bridge: introduce NFT_META_BRI_IIFHWADDR support")
Cc: stable@vger.kernel.org
Signed-off-by: Davide Ornaghi <d.ornaghi97@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/netfilter/nft_meta_bridge.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -64,6 +64,8 @@ static void nft_meta_bridge_get_eval(con
 		if (!br_dev)
 			goto err;
 
+		/* ETH_ALEN (6) is shorter than the destination register span (8) */
+		dest[1] = 0;
 		memcpy(dest, br_dev->dev_addr, ETH_ALEN);
 		return;
 	default:


