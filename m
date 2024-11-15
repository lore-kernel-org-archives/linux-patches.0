Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70E7185B5B;
	Fri, 15 Nov 2024 06:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653460; cv=none; b=A7PbWJhI3amPRcf7bmplCCYgwrsF8pZ73kIYzJHGXPCZDjrJilPJWXl2pcppkKFIo1qYHY9x/FR8SeqsmVet/CtdbnVs9UeKDj1xYe0vLU0XaBTqfQgbwBqdN0GiiD+Ez+uopQ1lJUobRLkDDSkxMOcB/MwH3oukaw7hoMn0K7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653460; c=relaxed/simple;
	bh=1fr3EtsOkHDI9IQaT/448iiex5sU9ypI9iHJvov0HEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E20C+3o+lSf0rv2zA6n67fkNUzRMNm+cotuPDHjCrYTSYDjy65yGj8xINTSLUxWJQTptvNL5lsVTFJ//HakPNf4HuWsNvPOt+yw4HxOdcRiacWaXlj6ctf/dOY/31aeoOLSbq2QHA4codjAPXKU5oBBdxSPldnG7AI3OjLYrR/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zKk3HaFp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zKk3HaFp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B4FC4CED0;
	Fri, 15 Nov 2024 06:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653459;
	bh=1fr3EtsOkHDI9IQaT/448iiex5sU9ypI9iHJvov0HEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zKk3HaFpAa5K/1hSW7VGgTFu+s/0Pyd3mddym8El3cJsg/3+MX7vra6B3eM3RpKwn
	 XACeeelLXPBUGR6RQXunTaRvG7krfdOE7LW5sK85VLcbkfyVPndZp0CoTKP9q7KdbQ
	 CW64YHoMgAG2qete1ZAGR45P8hOgP4RiHMavPtls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawei Ye <jiawei.ye@foxmail.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 28/48] bpf: Fix mismatched RCU unlock flavour in bpf_out_neigh_v6
Date: Fri, 15 Nov 2024 07:38:17 +0100
Message-ID: <20241115063723.980603900@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.962047137@linuxfoundation.org>
References: <20241115063722.962047137@linuxfoundation.org>
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
index a2467a7c01f9e..f9d05eff80b17 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2233,7 +2233,7 @@ static int bpf_out_neigh_v6(struct net *net, struct sk_buff *skb,
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



