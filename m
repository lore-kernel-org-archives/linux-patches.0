Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C731714A8;
	Thu, 15 Aug 2024 13:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729147; cv=none; b=abSA+TO3C+pF6hDXgh6NzPhCxMD1QXnrvQsl1hHO1nvK+qDVHbSNIoZG31kq8M/14etJhFj9BEGSf/kd63xQD90A2nUHLxaHTAMNm2P1W/y4qqzY9WK++IDVlJ2hv/Z5Glfp2u0M/luh6e213t7FVfmI8lusvJ5yffCpBoMw37g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729147; c=relaxed/simple;
	bh=8oHOdSQzNVCefweCzax/IsWsPMQLe3Bsf40GoxqLpQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6u/hBApsJgu+YQG2RbWL5d6oPOn4SSWPtlH8lVl70EYNk0b8zzoGtbZ7KTr3/T3JMbNkagjaUES9hPaSGpDdiElbf4ILXzeTNj1OA79J4ap81MNCoevDMXGFhTqUF1v45KayYVHRgBfKFSG2yYDbiVlQ1/HnBwRfomQW4iA+iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zj2EUhRy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zj2EUhRy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E19C32786;
	Thu, 15 Aug 2024 13:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729147;
	bh=8oHOdSQzNVCefweCzax/IsWsPMQLe3Bsf40GoxqLpQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zj2EUhRylJ3u10/LPXTkyql+M+GkjPtZ8tXd3seUKbo5VYq/UVmCOh9JLLuGZ2+Ah
	 lQJVm1eKBa+Rh/8/Q8NldJd0gqhLyffNH/rh36H4QccesVzDshHVGR/uP8Zd1PhDC/
	 9yYufw4CUWu6N13Nt57j+BhtlWK9i5DbrK45mkE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	yunshui <jiangyunshui@kylinos.cn>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 08/22] bpf, net: Use DEV_STAT_INC()
Date: Thu, 15 Aug 2024 15:25:16 +0200
Message-ID: <20240815131831.583211332@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131831.265729493@linuxfoundation.org>
References: <20240815131831.265729493@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 110692c1dd95a..ab0455c64e49a 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2279,12 +2279,12 @@ static int __bpf_redirect_neigh_v6(struct sk_buff *skb, struct net_device *dev,
 
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
@@ -2385,12 +2385,12 @@ static int __bpf_redirect_neigh_v4(struct sk_buff *skb, struct net_device *dev,
 
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



