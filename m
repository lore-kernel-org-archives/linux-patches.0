Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9FF371048;
	Wed, 20 May 2026 18:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301371; cv=none; b=B7so2pBFeRTmrSQ0hDRy7pC2wbfscO0e2FxuSt1tmiahZzbhFJHEWTIzCL9NIWYjtig0R77GM3zYBGSkwFsnjQ1OZx4EHbIWkcKHqrBk9RddodAmhHGQBFUYSDsImwUZ9jNA5olngVZSoQJ+JBiViGkmSdWBDijLkt8aSlXyLn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301371; c=relaxed/simple;
	bh=6eJ1d44CI+QjP8zbouJh+Yq6cf7aNN7AL3fwNT98WO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V2DJ48UamRJlM+sAiLHeE1/i9JlaXNyVLgMpvZmmnzGHVbaM0+62Z8qyrWknv+jM+EThxR77i6kWiq5QrnxrS2YGBFWg7oL3+rP06sXfvyNZr6Dw26AuTJL3m+V1PTIMP5SwqWjQ2+gyDerB/+Zp23hrh6lXKP0ZcslWl3Jgkc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GixwXoBZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GixwXoBZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A003B1F000E9;
	Wed, 20 May 2026 18:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301370;
	bh=c7+UDEdgKFIIyW/K4st0n+Tm6+2Esx1ldMJ2MIdcFE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GixwXoBZ2JyzUcsNtC2pkvWl0pORapIIRNJ3qFzDamBVEOrThwQ3GVsJRnaHMAeTt
	 zyvmO45Hypcd7W51Wx8XMEBjsNGWRqb9XD3bITg3KtxNLfAbA+DjyxzYJsoAjf7CIv
	 GEztywZITOXW3o1jVqdzaZqdlAvE+x44H+KzCUPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikola Z. Ivanov" <zlatistiv@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 530/666] netdevsim: zero initialize struct iphdr in dummy sk_buff
Date: Wed, 20 May 2026 18:22:21 +0200
Message-ID: <20260520162122.758847754@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikola Z. Ivanov <zlatistiv@gmail.com>

[ Upstream commit 35eaa6d8d6c2ee65e96f507add856e0eacf24591 ]

Syzbot reports a KMSAN uninit-value originating from
nsim_dev_trap_skb_build, with the allocation also
being performed in the same function.

Fix this by calling skb_put_zero instead of skb_put to
guarantee zero initialization of the whole IP header.

Closes: https://syzkaller.appspot.com/bug?extid=23d7fcd204e3837866ff
Fixes: da58f90f11f5 ("netdevsim: Add devlink-trap support")
Signed-off-by: Nikola Z. Ivanov <zlatistiv@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260426201434.742030-1-zlatistiv@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 2614d6509954c..daec92570c2e3 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -758,7 +758,7 @@ static struct sk_buff *nsim_dev_trap_skb_build(void)
 	skb->protocol = htons(ETH_P_IP);
 
 	skb_set_network_header(skb, skb->len);
-	iph = skb_put(skb, sizeof(struct iphdr));
+	iph = skb_put_zero(skb, sizeof(struct iphdr));
 	iph->protocol = IPPROTO_UDP;
 	iph->saddr = in_aton("192.0.2.1");
 	iph->daddr = in_aton("198.51.100.1");
-- 
2.53.0



