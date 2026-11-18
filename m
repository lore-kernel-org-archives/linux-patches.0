Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039862;
	b=OEtq3E+HoH4GN5SbEjdm6LDH3Di3UFgJ0CFMkCS3M4igCdauH7BVfbM69r6ijp8pGR9M
	 HlNmYtUpHD5vo8KrgEURz4jTeXisKUOvZScxwgwqO16Gd8vhReHOcP3PaUFIQe7UVVZ2E
	 7uk1XYGiDBmV+J00MLOv25Qentg0gAcfpVpO4mLi6BoB4daIg4NPO0xsye/Set0oBo3AD
	 K2c+qeZ+QObR6qPOIIFMEwzKt8FYNdrEJI7getBb2XJUcEAyhG902xqQfq0rqmQSWpM4f
	 TBHPA3sWp1ZPDW7X0tmz2QIp27nMvuBo86g3Az+zjGXARoyKbOK4nUhqv5Vfz+B8QOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039862;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iZJmmB4YLnxhmRg9+thRXRBfJEo4hWukDfCfqCg5QrQ=;
	b=QMYvDupUI5xUUsJTaWshypS0tjJ0TyMNeFA8ApYui+lS+gsqAebNg+fxWAGVeG4zQbFr
	 EKnBz1Egs+egEpjWyT6fBLZ+QWFukCrRpGGTdz75PShJNZdItAbNLK2dYSk9c8tTCG1/b
	 lntx9TP+nbMYMVOU+aIf3Dkj9wkFMRi6JtzeV0IeF/KC0hRkci267JgGGlD+ug70VQXr3
	 1zGqcMLEwQ3nR9M6s2BFzqerJg/+QJn/a/pOoZczrvuhnTsFsd3McOVQdVY6WSxjufXq+
	 6IhE4i58h3OHlhjWw1lgW8D4YN4qSPBIX0WtPN0lDlOoqVZMFH7V/1huHy484TLuJcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="tD/vTDmW";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F033606A325;
	Wed, 18 Nov 2026 22:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tD/vTDmW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41081F000C4;
	Wed, 18 Nov 2026 22:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039862;
	bh=iZJmmB4YLnxhmRg9+thRXRBfJEo4hWukDfCfqCg5QrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tD/vTDmWeBK+wj5RsmY1wpAy9fqUFxy2ohTzWxgflm7aI1thC1pbAYVCcQr+6KU9V
	 bUb4cOKjGE8HGUfVNGNBfsumJPaZOiuDf1ntIPdh68lvn+qV4G5YQaCLbT47Djf5l0
	 xNIB2TLthmM8ot5dSrS9VfGv2lxj6+i+vfKOTfJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Longlong Xia <xialonglong@kylinos.cn>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2252/3318] rcu: fix shrink budget underflow in lazy_rcu_shrink_scan
Date: Wed, 18 Nov 2026 15:47:54 +0100
Message-ID: <20261118150429.392386441@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Longlong Xia <xialonglong@kylinos.cn>

[ Upstream commit 4c714f015d9ecc37d7a330b31822ccbcaff5ddc9 ]

The lazy RCU shrinker decremented sc->nr_to_scan (unsigned long)
and then tested the result with <= 0.  When a single CPU's lazy
callback count exceeds the remaining budget, the subtraction wraps
to a large positive value and the <= 0 comparison, which is
equivalent to == 0 for an unsigned type, never fires again.  The
scan loop then iterates through every nocb CPU instead of honouring
the reclaim budget.

Accumulate into count and stop once count >= nr_to_scan.

Fixes: c945b4da7a448 ("rcu: Shrinker for lazy rcu")
Assisted-by: Zcode:GLM-5.2
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree_nocb.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/rcu/tree_nocb.h b/kernel/rcu/tree_nocb.h
index e29d863e589d0..dd4364827c0e1 100644
--- a/kernel/rcu/tree_nocb.h
+++ b/kernel/rcu/tree_nocb.h
@@ -1351,9 +1351,8 @@ lazy_rcu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 		rcu_nocb_try_flush_bypass(rdp, jiffies);
 		rcu_nocb_unlock_irqrestore(rdp, flags);
 		wake_nocb_gp(rdp);
-		sc->nr_to_scan -= _count;
 		count += _count;
-		if (sc->nr_to_scan <= 0)
+		if (count >= sc->nr_to_scan)
 			break;
 	}
 
-- 
2.53.0



