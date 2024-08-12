Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1008C1EA8D;
	Mon, 12 Aug 2024 16:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478716; cv=none; b=CCM/tox0hT6eslm5XTTugYc/+7+xcg6EZW22CbWRCw6rB7JvBr0X0yS74CZvlhBCuIpLH4sZGvwuXV0LpQu1vzAGDV83BXtYB6HR/sVs1FaotJ3GOffAiKD+nSaM+0xYAz/EBDZnzHGf7vs9Xotl/WvMC+7H9ZoPhIg6BhplyxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478716; c=relaxed/simple;
	bh=LoIhXv3y+3Pi0dz+1owLDzeMAh3/Pew8Gs7q3eiYxxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=exKuwjbWwjbI1xYTiuBSWr6NFaY9ijRAQTzVS2HsON5ZuHnioqrkFfkNhPKkcJSD49erRuiqJN4U5ArVlZDGJm5UNvjbzQqJfLTbyaKyezuuuhOTRUP8Q/LEsO7em9t/pLkNrSFAhMDUJq6oPyDtRBZ5himi3mLzcaKVM3op+0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xKXEoQ3N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xKXEoQ3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA479C32782;
	Mon, 12 Aug 2024 16:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478715;
	bh=LoIhXv3y+3Pi0dz+1owLDzeMAh3/Pew8Gs7q3eiYxxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xKXEoQ3NvTlLkIPLGLvHsQaCCzjD3kCTPDzAmBcauavCo/0jNhV4qKIY5a0xflBlD
	 7M2EvMP0paoJnT3ZwhyNcvj/NRYCepl+HKFUPVtapC0tAK6FbuQ7/BoaHXfUbiJtfH
	 j1iumbPjjdSN/DcvH2AnjzHSd28bhFqubot/2Qic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Marco Elver <elver@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	kasan-dev@googlegroups.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/150] rcutorture: Fix rcu_torture_fwd_cb_cr() data race
Date: Mon, 12 Aug 2024 18:01:37 +0200
Message-ID: <20240812160125.786769750@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit 6040072f4774a575fa67b912efe7722874be337b ]

On powerpc systems, spinlock acquisition does not order prior stores
against later loads.  This means that this statement:

	rfcp->rfc_next = NULL;

Can be reordered to follow this statement:

	WRITE_ONCE(*rfcpp, rfcp);

Which is then a data race with rcu_torture_fwd_prog_cr(), specifically,
this statement:

	rfcpn = READ_ONCE(rfcp->rfc_next)

KCSAN located this data race, which represents a real failure on powerpc.

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Acked-by: Marco Elver <elver@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: <kasan-dev@googlegroups.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/rcutorture.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 8c45df910763a..c14517912cfaa 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -2547,7 +2547,7 @@ static void rcu_torture_fwd_cb_cr(struct rcu_head *rhp)
 	spin_lock_irqsave(&rfp->rcu_fwd_lock, flags);
 	rfcpp = rfp->rcu_fwd_cb_tail;
 	rfp->rcu_fwd_cb_tail = &rfcp->rfc_next;
-	WRITE_ONCE(*rfcpp, rfcp);
+	smp_store_release(rfcpp, rfcp);
 	WRITE_ONCE(rfp->n_launders_cb, rfp->n_launders_cb + 1);
 	i = ((jiffies - rfp->rcu_fwd_startat) / (HZ / FWD_CBS_HIST_DIV));
 	if (i >= ARRAY_SIZE(rfp->n_launders_hist))
-- 
2.43.0



