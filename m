Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE22233F5A4;
	Wed,  8 Apr 2026 18:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673063; cv=none; b=FXM/cJAns3s3H+WKh7MtQyUa/1Ji6S7mqZqLqeVfPpVbkV+YBadoOr7HvNC0Y67zljuWkJANNM18Rn3I8sfZ8QOQQ0CTKee9r6N9oBmZJpPu7kmpkSjTDor9SIx/QiYXvRIGg0oJbGUk5Qo/a5rW3EUR1KBoICNs0i6thnp1/Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673063; c=relaxed/simple;
	bh=3Tbi0Fv3W6/x3vA5DiFN0vds7LdlZcQ1Snm9n6A7eqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VhFB19QqJSdC/xBfP+X7lScPOJDmK0eouLSp7n1OIXdZA9IbQg/SIHwSKGJeXX5Le8STVJfgBKjCKVKoHBCWgogLmEZ737ry1vXJ7xKh6dEb2usm/0nEjZ8OCsEDJdDef+0rAgt2n6n/JjrJBBp/5teGN6hSBKG/ntyVtU6pWok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z6yUWRXI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z6yUWRXI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A34C19421;
	Wed,  8 Apr 2026 18:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673062;
	bh=3Tbi0Fv3W6/x3vA5DiFN0vds7LdlZcQ1Snm9n6A7eqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z6yUWRXIPg6QNVIjCJN/DKomj5Ii5Y9cPZI5d1xSmu+Gj1FpT3PpcOhtgkQt0+qCC
	 niGM0yQr/RBq2uFqsWCRGvS91fBZdyrgyuyWKJ0CWl6M6ZsDSCd9NSiNjUBRlwsK4T
	 tMVB7CTfgdsMYUKyRq9GQXrVkm2neNBP7rp4o0K8=
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
Subject: [PATCH 6.18 087/277] net/sched: sch_netem: fix out-of-bounds access in packet corruption
Date: Wed,  8 Apr 2026 20:01:12 +0200
Message-ID: <20260408175937.112956790@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index eafc316ae319e..6f8fcc4b504ce 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -518,8 +518,9 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
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



