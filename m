Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A792013C8E8;
	Mon, 18 Aug 2025 13:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523689; cv=none; b=ZpwCGl9vxWzBn0L/xWKKnYICWLfvyiGMdq45D8sG/TQD4VYfh2riUhjFUa5Wes1b8rx97uNlLltOrmmYHLxpUsfARoJhfGqiMkXTo7IJw201S4mltIYn+tx6Ssb+G4wFhExzgEgQB4h5HXwoKU/910MgSOUjXsyqEKbMSOsDwOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523689; c=relaxed/simple;
	bh=URtdvqASFaXzRckEMvP3XjUNZTMnp67MoajcI1jIoco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFVqTF8TrLLya1r0E87eJHi0moHrYckfGMJrfk16QU6sQaWFNhheIacAwAUoLBEUSXWuABVgTOf55iSiHTBCY3dTYkBrpzbZ9C/bO+XCzAn9nlilGbCj2vYyL/XjWRLBeGV6n3rtiApd5AcF0KZODks/EWf4MRnbF7czGv2o6mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bMouQyQy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bMouQyQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F96C4CEEB;
	Mon, 18 Aug 2025 13:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523689;
	bh=URtdvqASFaXzRckEMvP3XjUNZTMnp67MoajcI1jIoco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bMouQyQyly8eCViOUjCWU+Xiw35zFfvKIfvYMMIib3JNfbT0U5KE8umXHGxAAZVWI
	 o0MoMXXamd8yLF+h62dBtvhM/c464I/Cpyn+ZIrOrSsKC43NyIAzmSSwt+gKThvQui
	 e1lB2u+0MXfycbl4EhlR1xvF038EorMNo4rQItCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zqiang <qiang.zhang1211@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	"Neeraj Upadhyay (AMD)" <neeraj.upadhyay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 248/515] rcu/nocb: Fix possible invalid rdps->nocb_cb_kthread pointer access
Date: Mon, 18 Aug 2025 14:43:54 +0200
Message-ID: <20250818124507.942087362@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zqiang <qiang.zhang1211@gmail.com>

[ Upstream commit 1bba3900ca18bdae28d1b9fa10f16a8f8cb2ada1 ]

In the preparation stage of CPU online, if the corresponding
the rdp's->nocb_cb_kthread does not exist, will be created,
there is a situation where the rdp's rcuop kthreads creation fails,
and then de-offload this CPU's rdp, does not assign this CPU's
rdp->nocb_cb_kthread pointer, but this rdp's->nocb_gp_rdp and
rdp's->rdp_gp->nocb_gp_kthread is still valid.

This will cause the subsequent re-offload operation of this offline
CPU, which will pass the conditional check and the kthread_unpark()
will access invalid rdp's->nocb_cb_kthread pointer.

This commit therefore use rdp's->nocb_gp_kthread instead of
rdp_gp's->nocb_gp_kthread for safety check.

Signed-off-by: Zqiang <qiang.zhang1211@gmail.com>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Neeraj Upadhyay (AMD) <neeraj.upadhyay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree_nocb.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/rcu/tree_nocb.h b/kernel/rcu/tree_nocb.h
index 6b3118a4dde3..2083d2343bd4 100644
--- a/kernel/rcu/tree_nocb.h
+++ b/kernel/rcu/tree_nocb.h
@@ -1152,7 +1152,6 @@ static bool rcu_nocb_rdp_offload_wait_cond(struct rcu_data *rdp)
 static int rcu_nocb_rdp_offload(struct rcu_data *rdp)
 {
 	int wake_gp;
-	struct rcu_data *rdp_gp = rdp->nocb_gp_rdp;
 
 	WARN_ON_ONCE(cpu_online(rdp->cpu));
 	/*
@@ -1162,7 +1161,7 @@ static int rcu_nocb_rdp_offload(struct rcu_data *rdp)
 	if (!rdp->nocb_gp_rdp)
 		return -EINVAL;
 
-	if (WARN_ON_ONCE(!rdp_gp->nocb_gp_kthread))
+	if (WARN_ON_ONCE(!rdp->nocb_gp_kthread))
 		return -EINVAL;
 
 	pr_info("Offloading %d\n", rdp->cpu);
@@ -1172,7 +1171,7 @@ static int rcu_nocb_rdp_offload(struct rcu_data *rdp)
 
 	wake_gp = rcu_nocb_queue_toggle_rdp(rdp);
 	if (wake_gp)
-		wake_up_process(rdp_gp->nocb_gp_kthread);
+		wake_up_process(rdp->nocb_gp_kthread);
 
 	swait_event_exclusive(rdp->nocb_state_wq,
 			      rcu_nocb_rdp_offload_wait_cond(rdp));
-- 
2.39.5



