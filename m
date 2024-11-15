Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459CF1885AA;
	Fri, 15 Nov 2024 06:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653608; cv=none; b=J0YAOHiLq8/fYqREHFhMYoXYpNczA1qiifgiHefXojdJXHCXtsl/b0sxo7WJsNwRNSJRmFx4eb2+GSB/3l6MO3+TeEC/DNbU54RAPmDpNjylDuxph0Plui7V/5j6s/YqOntrHYav8spyHZ736gyJl1njowkHnf9UzZWby8YYoS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653608; c=relaxed/simple;
	bh=GII/UOhyQ2UJQDpEAcEO7r0/ahHbzCydUjCGdp4qnP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hRltgYRMKw+LNtj+SITRoUROT5yzk/7xsURyFIo4FVBRsiN/8fsaRc13tlGBpK3jKOsYU/urDT45+Rwp8alRWgvmbX9fNBkTihcozdW0xWY3pYbE0MGNeUAqYIcPMDxJp7PUvXRf5s4QqVyl4ca3HsSB+DHaeKeY5eS9DPz2Xwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yCR3JlT1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yCR3JlT1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4973AC4CECF;
	Fri, 15 Nov 2024 06:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653606;
	bh=GII/UOhyQ2UJQDpEAcEO7r0/ahHbzCydUjCGdp4qnP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yCR3JlT1ux8Zjn82Kj3Qowes4c9zZkiGRGkQrPvnhSN1rGBLMYZIgHXfxj6lQ5Nqv
	 vFAoV55XgWTcxBFZxVikx2U5FAxF/mOc4nOqTHYti1qmHhgK1J2j1oGAKS2IByB2QW
	 OJUrfHmaeI3OWLOwkJAyC3kcEAPxLsE6gA7eSyYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawei Ye <jiawei.ye@foxmail.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 23/39] bpf: Fix mismatched RCU unlock flavour in bpf_out_neigh_v6
Date: Fri, 15 Nov 2024 07:38:33 +0100
Message-ID: <20241115063723.447182706@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.599985562@linuxfoundation.org>
References: <20241115063722.599985562@linuxfoundation.org>
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

From: Jiawei Ye <jiawei.ye@foxmail.com>

[ Upstream commit fb86c42a2a5d44e849ddfbc98b8d2f4f40d36ee3 ]

In the bpf_out_neigh_v6 function, rcu_read_lock() is used to begin an RCU
read-side critical section. However, when unlocking, one branch
incorrectly uses a different RCU unlock flavour rcu_read_unlock_bh()
instead of rcu_read_unlock(). This mismatch in RCU locking flavours can
lead to unexpected behavior and potential concurrency issues.

This possible bug was identified using a static analysis tool developed
by myself, specifically designed to detect RCU-related issues.

This patch corrects the mismatched unlock flavour by replacing the
incorrect rcu_read_unlock_bh() with the appropriate rcu_read_unlock(),
ensuring that the RCU critical section is properly exited. This change
prevents potential synchronization issues and aligns with proper RCU
usage patterns.

Fixes: 09eed1192cec ("neighbour: switch to standard rcu, instead of rcu_bh")
Signed-off-by: Jiawei Ye <jiawei.ye@foxmail.com>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/tencent_CFD3D1C3D68B45EA9F52D8EC76D2C4134306@qq.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 3f3286cf438e7..2f6fef5f5864f 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2226,7 +2226,7 @@ static int bpf_out_neigh_v6(struct net *net, struct sk_buff *skb,
 		rcu_read_unlock();
 		return ret;
 	}
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 	if (dst)
 		IP6_INC_STATS(net, ip6_dst_idev(dst), IPSTATS_MIB_OUTNOROUTES);
 out_drop:
-- 
2.43.0



