Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8433E183CD9;
	Mon, 12 Aug 2024 16:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479937; cv=none; b=CI11rIU5FtrmqLDl52ipBKAYfk34oqTJ/awobzTUPev7I9E7OpoS78vL7oe6TGe1hIqxT9cU8YdS9NX2Y3eS9XK5RT+IYHrvAAZIpeRdwGKTa+KdGRdDeuHL072Q10SAv0UHjQi73XBccMwWPPzLDYAfeXfQK+7fOiy8EfhRPmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479937; c=relaxed/simple;
	bh=8HS6s612pH0L3Rx0ImdQT7AZO92xRZy6BJ0FNpm+ILY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOL1509TB7xyma8xW5chI5Dd7bvGOgQtCH0sJY7EjH2KUYY+miUf+2OWTSOvl5ZwDHWSzdZPdn5oNXzPr5+jYvLrQFsoFxfeQmadKRhw5MB+oeQG6OvLKiuSf5UBVOumRilh+jmzKKZyFiX3jQ/YxqrFrCCso/fVwWGdPIJX3vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CPqrfZLU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CPqrfZLU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88901C32782;
	Mon, 12 Aug 2024 16:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479937;
	bh=8HS6s612pH0L3Rx0ImdQT7AZO92xRZy6BJ0FNpm+ILY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CPqrfZLUooCxQCvucK3zKFirNd0vDjhd+/WOPfH5pjbtP9WCIzixEqavkA13Jbf8V
	 tw7t4Hv11Z9bURW3Lf+dciIpiT/OSSd742Ek99fYPctBa+DK+/0BTB2lJrM6aYNLAX
	 DZgG7Fd0dCONUfoK/vubz50C0uqZDYqU5EkA412M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Marco Elver <elver@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	kasan-dev@googlegroups.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 045/263] rcutorture: Fix rcu_torture_fwd_cb_cr() data race
Date: Mon, 12 Aug 2024 18:00:46 +0200
Message-ID: <20240812160148.270053242@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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
index 807fbf6123a77..251cead744603 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -2626,7 +2626,7 @@ static void rcu_torture_fwd_cb_cr(struct rcu_head *rhp)
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



