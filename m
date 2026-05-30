Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC93233952;
	Sat, 30 May 2026 18:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166794; cv=none; b=b4IYvEPr7vgg2/z3nyyDMn8roXmkX7wuLnQ7YVUzCWXuXWua9K1L/L1yYVUTfQplJsNk+iPbNbNE3LppvTF4SMRTPtMN6U9kpRU8hk6x1vonPefesFR7r/NqD10frSfssoMC5aN1vrwGoCqS4+oG/8/DUj4LPjB/JTuJQfifRcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166794; c=relaxed/simple;
	bh=8waXrjd0f1+tcQp57ozV/cRjS/+hk+nzmkiB5XzhEjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fuXdhgsTfBErF2IG+Zxv/KLhJE3S12zK/+RYXlc9Vvu5utHc3zcUnXvooR5Z3qGWsnU3lpIuCh8NQ2rUoZUspk4O7MzAz2XIFxLJ5l+xHTmbYDYs6BQIdiPOsQNSFikk4uSyYf+gotddCzbazD6UFsYXwZ1NI+BlX1L0+NESROI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gZLWgiPg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gZLWgiPg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A73A1F00893;
	Sat, 30 May 2026 18:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166792;
	bh=EdJHzDO97tAMUpFEqNsrIp9n4ucyRpRV6B+LwX6muss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gZLWgiPg5kYiYDCDPOhRnQHBAvpKIc4sdb58KeCoA97e/OoKgiSGPNU/DIZck3C+/
	 cDd1RvqW0fU+KWEIXB0d6llWqWy7kyaDHmtt9mZY1vUaT0ZiijlhAogud25gEN8+49
	 C/JKSSa6pwQqh/7A3XwVWQhLOuTZ8u5dXKJaJMr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikola Z. Ivanov" <zlatistiv@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 472/589] netdevsim: zero initialize struct iphdr in dummy sk_buff
Date: Sat, 30 May 2026 18:05:53 +0200
Message-ID: <20260530160237.057573733@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index bcf354719745c..c8834ea84732b 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -514,7 +514,7 @@ static struct sk_buff *nsim_dev_trap_skb_build(void)
 	skb->protocol = htons(ETH_P_IP);
 
 	skb_set_network_header(skb, skb->len);
-	iph = skb_put(skb, sizeof(struct iphdr));
+	iph = skb_put_zero(skb, sizeof(struct iphdr));
 	iph->protocol = IPPROTO_UDP;
 	iph->saddr = in_aton("192.0.2.1");
 	iph->daddr = in_aton("198.51.100.1");
-- 
2.53.0



