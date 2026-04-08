Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1758D3DB658;
	Wed,  8 Apr 2026 18:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672559; cv=none; b=FWHKAc2m0lhatwvk7bjynMXBa/MFvtsh3WwsprZNSSzdXAfQsgdXT4xhjoOco+rdXBZi53FhrlUqklRv9i0BCAt3C5BDQgLQqBRsjXT4cxanR1VqWgVrMk7cKuSUUG1q1Y1EWOWfUYwbj0rpUmn4dyVt7zJcvcRUenckZTbeVoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672559; c=relaxed/simple;
	bh=TTMJJ+07iGLrJzRnVlaxgAOcw4brE/fH7alZwhEuMeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZoWjoceeQYetGUQjOvcaLQpVpDk1ZSPoUyT7z9AkKip5yHmsY6rjTdeIw8rwgQ72z0FF81DzGx58OazsQy0BlF+NBtOyJtHuPwWe8BYfRNRHQZp+6yzxg6rQWRSziBq5aH0ZzwwL8q/rBobaEb57FIOVr59vK3dlFGse9n3iFTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tuNTim6f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tuNTim6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5567EC2BC87;
	Wed,  8 Apr 2026 18:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672558;
	bh=TTMJJ+07iGLrJzRnVlaxgAOcw4brE/fH7alZwhEuMeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tuNTim6fQeOCqZN9Cstft15RWi+grUvYjUAhyHcan+j3rQKHIJe877xbcv8uGASS4
	 OXR4nuAlu0HxhKAYlnRZ1qAXOCEfKz8VLPyjimD6FxlkLV6rVRH8pYwWdt/HUpMjs1
	 eD0Z63WLQuA32fTp+gPJhwrhOczD94YOUT3Q4kNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <tanyuan98@outlook.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Yuhang Zheng <z1652074432@gmail.com>,
	Yucheng Lu <kanolyc@gmail.com>,
	Stephen Hemminger <stephen@networkplumber.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/160] net/sched: sch_netem: fix out-of-bounds access in packet corruption
Date: Wed,  8 Apr 2026 20:02:20 +0200
Message-ID: <20260408175915.185202705@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yucheng Lu <kanolyc@gmail.com>

[ Upstream commit d64cb81dcbd54927515a7f65e5e24affdc73c14b ]

In netem_enqueue(), the packet corruption logic uses
get_random_u32_below(skb_headlen(skb)) to select an index for
modifying skb->data. When an AF_PACKET TX_RING sends fully non-linear
packets over an IPIP tunnel, skb_headlen(skb) evaluates to 0.

Passing 0 to get_random_u32_below() takes the variable-ceil slow path
which returns an unconstrained 32-bit random integer. Using this
unconstrained value as an offset into skb->data results in an
out-of-bounds memory access.

Fix this by verifying skb_headlen(skb) is non-zero before attempting
to corrupt the linear data area. Fully non-linear packets will silently
bypass the corruption logic.

Fixes: c865e5d99e25 ("[PKT_SCHED] netem: packet corruption option")
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Signed-off-by: Yuan Tan <tanyuan98@outlook.com>
Signed-off-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Yuhang Zheng <z1652074432@gmail.com>
Signed-off-by: Yucheng Lu <kanolyc@gmail.com>
Reviewed-by: Stephen Hemminger <stephen@networkplumber.org>
Link: https://patch.msgid.link/45435c0935df877853a81e6d06205ac738ec65fa.1774941614.git.kanolyc@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_netem.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 0ad231e94e14d..7361f90c8c1a1 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -517,8 +517,9 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			goto finish_segs;
 		}
 
-		skb->data[get_random_u32_below(skb_headlen(skb))] ^=
-			1<<get_random_u32_below(8);
+		if (skb_headlen(skb))
+			skb->data[get_random_u32_below(skb_headlen(skb))] ^=
+				1 << get_random_u32_below(8);
 	}
 
 	if (unlikely(q->t_len >= sch->limit)) {
-- 
2.53.0



