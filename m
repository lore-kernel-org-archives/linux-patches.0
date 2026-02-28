Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2279340A47
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301111; cv=none; b=rLV1eDUeh7FN3Zwt6Y2gDajck1c7vYoyhT/PHmDqh/8Qob4Kxq9Hpan/jULJjRS4g3bklkg4UZ8y6w1KqLhb6Kl+ukiqFHUeyGDb8Y8gUZ1Z+HhWw9F+X0ZuLn2LUCwQhuook2/rlIEAqubURQgB4Ua38dRMYT0DXjMz3E+gWrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301111; c=relaxed/simple;
	bh=W2Zu8bffyf0YcmUgY9hYpsOx4Ln8hzrk78JdvpIjSgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BrWA13zAard6gJ8Y0Ri3iuEKZ+cIH8e/OqCbIU8k17jgAVG+RwnvbKLWA0TA4pZRvAHQSGVYhB3243n4Pd+cWeDQYJxTO9FTnz5+OZwu3cLy2B2/lIreFScgvEOWHyXbF2pHojEql4aMbP5HdM4uJiDaL13WP/CTMw3c8ytBkKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gCRwd556; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gCRwd556"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F07C116D0;
	Sat, 28 Feb 2026 17:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301111;
	bh=W2Zu8bffyf0YcmUgY9hYpsOx4Ln8hzrk78JdvpIjSgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gCRwd5567Xc3wBnibrHpdi4OxRwMRr/tQHF4nwU2UwWMsnbn/PrNOfwy/+uGiSl3Z
	 dkQvjeXHi2aeEtF4TGkPtDJUDsI44oSn5QTOUGZFSjZX8dx1CgrbaDQPv3+qaKpz1I
	 4QrqzDJMebPhz++nnp/N6QhuUW2kz72LE0UZAF742XytzR4nKiieYOEmL3A/EVEu4f
	 HBSGSfEHJOjiZwbB+YH9GDWsfgh8Th/dc3BRkcNCzWl76+DjJfAJD6uzNXPegvUOlD
	 d5hJAtloQSDQF9uUSSnNxwoN/wtPJNh5xzVPKkL5VJf16UHh5YT9AL8rRvNqmta2A5
	 MMUPSQAU3lF/w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 266/752] gro: change the BUG_ON() in gro_pull_from_frag0()
Date: Sat, 28 Feb 2026 12:39:37 -0500
Message-ID: <20260228174750.1542406-266-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit cbe41362be2c27e0237a94a404ae413cec9c2ad9 ]

Replace the BUG_ON() which never fired with a DEBUG_NET_WARN_ON_ONCE()

$ scripts/bloat-o-meter -t vmlinux.1 vmlinux.2
add/remove: 2/2 grow/shrink: 1/1 up/down: 370/-254 (116)
Function                                     old     new   delta
gro_try_pull_from_frag0                        -     196    +196
napi_gro_frags                               771     929    +158
__pfx_gro_try_pull_from_frag0                  -      16     +16
__pfx_gro_pull_from_frag0                     16       -     -16
dev_gro_receive                             1514    1464     -50
gro_pull_from_frag0                          188       -    -188
Total: Before=22565899, After=22566015, chg +0.00%

Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260122045720.1221017-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/gro.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/gro.c b/net/core/gro.c
index 482fa7d7f5981..ef61695fbdbb6 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -417,7 +417,7 @@ static void gro_pull_from_frag0(struct sk_buff *skb, int grow)
 {
 	struct skb_shared_info *pinfo = skb_shinfo(skb);
 
-	BUG_ON(skb->end - skb->tail < grow);
+	DEBUG_NET_WARN_ON_ONCE(skb->end - skb->tail < grow);
 
 	memcpy(skb_tail_pointer(skb), NAPI_GRO_CB(skb)->frag0, grow);
 
-- 
2.51.0

