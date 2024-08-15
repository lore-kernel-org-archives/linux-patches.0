Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B601714DD;
	Thu, 15 Aug 2024 14:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731026; cv=none; b=e20goKYqSNHb4X7ixQPdGpFzIfhJekzvRUj0TNVuVjxrBhU6UDaZLEyeSLOaMKXEwfFSoIDPSbCWSCvBQK5XkKu1iA9SeDYKYeT0WkrldGw8NvosbH7lN35ohj3ryoMHDEw6LMpBmjhLPouxiYTQY9lvnx92lQNIklHW0Xz+bAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731026; c=relaxed/simple;
	bh=Xv3iJZpgcewwDmjsZ6lS+RZs5kRp/R2m6WSt0VYvsmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IjSCCPRPoGffKLlRwOrTHiwZ1DGT/PoY2fyEqN8V2YAcgCbStMeG0GSyffEvtDIK2BTOqJ3u10JRBAXoh7Hvwa13GV35AmtGXO4YasEr9CARCIyb4so33v3bukW+OrFVYJZzCFkieg3yTA+/YJQ/DFYjHKs26mVBHkP8ZXxeIGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yuA9bQxq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yuA9bQxq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94CF5C32786;
	Thu, 15 Aug 2024 14:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731026;
	bh=Xv3iJZpgcewwDmjsZ6lS+RZs5kRp/R2m6WSt0VYvsmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yuA9bQxqs6WqQXKb+vh+xO1ASoZnudcTBya7Kj2qUJo+b81iJVbf2uTz44Yp4NZOA
	 IcVvSS1dZAUYZgQmxd4pjqB4zutvQGBe199+PHIZKmvdP/807c+NIoKUej02JtZNLU
	 KR8NZUemJtfkdSC9J6XuVkFERufUCs9aDTOT285I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	yunshui <jiangyunshui@kylinos.cn>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 53/67] bpf, net: Use DEV_STAT_INC()
Date: Thu, 15 Aug 2024 15:26:07 +0200
Message-ID: <20240815131840.345977310@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
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
index 8cb44cd29967b..be313928d272c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2271,12 +2271,12 @@ static int __bpf_redirect_neigh_v6(struct sk_buff *skb, struct net_device *dev,
 
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
@@ -2378,12 +2378,12 @@ static int __bpf_redirect_neigh_v4(struct sk_buff *skb, struct net_device *dev,
 
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



