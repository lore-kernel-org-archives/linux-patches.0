Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7E644BC93;
	Tue, 16 Jun 2026 15:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623413; cv=none; b=ZBCyHRDaFwupbBovuzRQwlQIDa98CGu3CiTABw5ByaUHhGxJZFLtcEudAqD+R7igJukvRfTJKK4Giae6T4CMvmJxpHPYQeGQ8X6GqyQRD1amX/8omRAaQlbEYo1vIjuQjtc/NhwOM6tSp25PG1EFZXz8yeA+T57yjgpOhQa5d04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623413; c=relaxed/simple;
	bh=w9Ri3Fvr1SpHeSfX5m1j/EUGxq6cKi1cmnUeLrPX+nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FX6KNOgjoeV+zGfj7hu7mlgir8x+fVN/js7e6WQflHipdynlc85pJwaPsvGq2Epeph/9ikPpPAYPlvncmx/QDkauWJmenNSUgP98cAu3+b4t3oTPQ8k9YgduqAWEUcCwmMNtfUeG9K6sJuIYbuCli/zCCJtS1NzMH50X2WHEGa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fdsAPxnh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fdsAPxnh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A671F000E9;
	Tue, 16 Jun 2026 15:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623412;
	bh=rn4+izzixdQOXvEdP/ie2RGNG8PzSV8Bf28m/mAtMCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fdsAPxnhfOtfUkPYVSGrWD8xz5X1dPCUTWqU+jz3UVMQgWBGaVoMpPWvAMUMu15eu
	 OF/8wmNFIXW3pSXvYzcy7JPvvLa3+XR19Ell6Vq5veEvUTfVnPZ/Nf0sKXpo1YkvCi
	 t2d5WOrQUekWThrkflGiqF19oXLGnQJNpFgS0eEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HanQuan <eilaimemedsnaimel@gmail.com>,
	MingXuan <bwnie0730@outlook.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 110/378] net: add pskb_may_pull() to skb_gro_receive_list()
Date: Tue, 16 Jun 2026 20:25:41 +0530
Message-ID: <20260616145116.163339600@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HanQuan <eilaimemedsnaimel@gmail.com>

[ Upstream commit f2bb3434544454099a5b6dec213567267b05d79d ]

skb_gro_receive_list() calls skb_pull(skb, skb_gro_offset(skb)) without
first ensuring the data is in the linear area via pskb_may_pull(). When
the skb arrives via napi_gro_frags(), skb_headlen can be 0 (all data in
page fragments) while skb_gro_offset is non-zero (after IP+TCP header
parsing). The skb_pull() then decrements skb->len by skb_gro_offset
but skb->data_len stays unchanged, hitting BUG_ON(skb->len < skb->data_len)
in __skb_pull().

The UDP fraglist GRO path already contains this guard at
udp_offload.c:749. Adding it to skb_gro_receive_list() itself provides
centralized protection for all callers (TCP, UDP, and any future
protocols), and ensures the precondition of skb_pull() is satisfied
before it is called.

On pskb_may_pull() failure, set NAPI_GRO_CB(skb)->flush = 1 so the
skb is not held as a new GRO head and is instead delivered through the
normal receive path, matching the UDP handling.

Fixes: 8d95dc474f85 ("net: add code for TCP fraglist GRO")
Reported-by: HanQuan <eilaimemedsnaimel@gmail.com>
Reported-by: MingXuan <bwnie0730@outlook.com>
Signed-off-by: HanQuan <eilaimemedsnaimel@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/gro.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/core/gro.c b/net/core/gro.c
index a847539834679c..35f2f708f01052 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -232,6 +232,11 @@ int skb_gro_receive_list(struct sk_buff *p, struct sk_buff *skb)
 	if (unlikely(p->len + skb->len >= 65536))
 		return -E2BIG;
 
+	if (!pskb_may_pull(skb, skb_gro_offset(skb))) {
+		NAPI_GRO_CB(skb)->flush = 1;
+		return -ENOMEM;
+	}
+
 	if (NAPI_GRO_CB(p)->last == p)
 		skb_shinfo(p)->frag_list = skb;
 	else
-- 
2.53.0



