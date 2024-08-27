Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFC41C688E;
	Tue, 27 Aug 2024 15:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771976; cv=none; b=jypI009WsipDbHZ/znEEgbGxwcPmd3bjaOOPqbnzjk1uTOK/zy9EAbQizEkr/1vYahyd/jyo7UpEmMUeAIbq1X20lWZiOKGYP/Z00OXJUjAb+P5hQQ4m7Xmr42F+j1WqUhegtwkhUcQX2TdUu5K2HJXWmqvvhqkwpMKeB4aGXwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771976; c=relaxed/simple;
	bh=KFbcS86Aajsonht6nVvMdPgevxR4dI1JEc3H2aFHWs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UwwCwCS2WoTbaBD9lWvMYR/EYz2kVG+OXgsL/flaSDfivhjWOsrSChVOBHfA0SpXfykZzZDVHJECenZeDPoUOSwaENUwnRE/ddpAtaAhMyE9bqOWEMT3RlIaizs8qkm5DZdxbgjwR4zQF1AjX+NNDmXmbhDiyzv2mtE2mTP708s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YRDZZ8/i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YRDZZ8/i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA63C61067;
	Tue, 27 Aug 2024 15:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771975;
	bh=KFbcS86Aajsonht6nVvMdPgevxR4dI1JEc3H2aFHWs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YRDZZ8/iXCzEa74lO4sdK1AXqspMUiImB+KEDVMsmdsHV2B2fBg52SQkWeWsj9tTi
	 SA4Ckw1WXSAfcNkuSyC9kN3WDGAtSjWkmXSMqoVfHFZiwlyPxbYoySou2HbSgAbxwW
	 JKa6Eg9S9dOstpDsLeSQNU3gCDilgyRrhc2XLcBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	yunshui <jiangyunshui@kylinos.cn>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 077/321] bpf, net: Use DEV_STAT_INC()
Date: Tue, 27 Aug 2024 16:36:25 +0200
Message-ID: <20240827143841.172587986@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: yunshui <jiangyunshui@kylinos.cn>

[ Upstream commit d9cbd8343b010016fcaabc361c37720dcafddcbe ]

syzbot/KCSAN reported that races happen when multiple CPUs updating
dev->stats.tx_error concurrently. Adopt SMP safe DEV_STATS_INC() to
update the dev->stats fields.

Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: yunshui <jiangyunshui@kylinos.cn>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20240523033520.4029314-1-jiangyunshui@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 210b881cb50b8..1cd5f146cafe4 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2264,12 +2264,12 @@ static int __bpf_redirect_neigh_v6(struct sk_buff *skb, struct net_device *dev,
 
 	err = bpf_out_neigh_v6(net, skb, dev, nh);
 	if (unlikely(net_xmit_eval(err)))
-		dev->stats.tx_errors++;
+		DEV_STATS_INC(dev, tx_errors);
 	else
 		ret = NET_XMIT_SUCCESS;
 	goto out_xmit;
 out_drop:
-	dev->stats.tx_errors++;
+	DEV_STATS_INC(dev, tx_errors);
 	kfree_skb(skb);
 out_xmit:
 	return ret;
@@ -2371,12 +2371,12 @@ static int __bpf_redirect_neigh_v4(struct sk_buff *skb, struct net_device *dev,
 
 	err = bpf_out_neigh_v4(net, skb, dev, nh);
 	if (unlikely(net_xmit_eval(err)))
-		dev->stats.tx_errors++;
+		DEV_STATS_INC(dev, tx_errors);
 	else
 		ret = NET_XMIT_SUCCESS;
 	goto out_xmit;
 out_drop:
-	dev->stats.tx_errors++;
+	DEV_STATS_INC(dev, tx_errors);
 	kfree_skb(skb);
 out_xmit:
 	return ret;
-- 
2.43.0



