Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ADDA43BDCD;
	Mon, 17 Aug 2026 14:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977276; cv=none; b=seJBeCBQ2jAx+74slplchsqT/iiu0kaoCMy48uub9OYkRiyrwRk+sl0oL8w4whqjPDpRhUiKjAhCIn8aErOCyWkbLY1GG/G/oSQp9bhAvQWArB/ZysgM6SJ15Wb9lLvEDJGfaY/YIblqXEW1pNoNnYl58Jzh6E4ZLkhNGSmVWtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977276; c=relaxed/simple;
	bh=HwTWyE8drbHheIbvo6xAjgExgtfhOkrQKYI79YHhQVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e5MmTipq7FhdTTi9gfVw+a9f8oTdX3lbz/YmUQnlgu/rW4g3OaxpTI1rxfI5Te4X+mnd7kqUTtyiokvAR9Krku2y7xIXNnV3D3i3IZhQnVSEZEkM5TKwsy7M4dlncPYSjs+eFwatrPFv2C6cyj3X9CWAg6cWmH/cxz69KVlpBzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I6iuy4vc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I6iuy4vc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F87C1F000E9;
	Mon, 17 Aug 2026 14:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977274;
	bh=KPGUSt3SePQ7gE9V7vEUHTjNbq0nJQR7XmzQ+zv1iDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I6iuy4vcguhf1aUbqwrdaGKTCVeesTxxTJFTuiiPUG9VzYInMDiF3rO2yyP9q8pFJ
	 yr4NeR0X5CsmwSkpJVPT2nGkcDu8ZPbJgmDoGmHo29xusZfN4EoE+bm3kppO50GYhB
	 zTfnPRD0QBlbwAfXHsBVe/pDpcFkxWEI6w/0wa8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Sperbeck <jsperbeck@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 235/456] raw: fix a typo in raw_icmp_error()
Date: Mon, 17 Aug 2026 15:30:25 +0200
Message-ID: <20260817132549.286738984@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 97a4d46b1516250d640c1ae0c9e7129d160d6a1c upstream.

I accidentally broke IPv4 traceroute, by swapping iph->saddr
and iph->daddr.

Probably because raw_icmp_error() and raw_v4_input()
use different order for iph->saddr and iph->daddr.

Fixes: ba44f8182ec2 ("raw: use more conventional iterators")
Reported-by: John Sperbeck <jsperbeck@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20220623193540.2851799-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/raw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -279,7 +279,7 @@ void raw_icmp_error(struct sk_buff *skb,
 	sk_for_each(sk, head) {
 		iph = (const struct iphdr *)skb->data;
 		if (!raw_v4_match(net, sk, iph->protocol,
-				  iph->saddr, iph->daddr, dif, sdif))
+				  iph->daddr, iph->saddr, dif, sdif))
 			continue;
 		raw_err(sk, skb, info);
 	}


