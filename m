Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8903101CD;
	Mon, 13 Oct 2025 15:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369776; cv=none; b=tYM3NerWx+IPhBchFdFtZNOx2ARaz49y/3daaiEsZVWOzHLbi+gmntjQSgHL1tWXzH+zGha5IqQNIH7Wggu2AFSrs7gps5Pa209qwOCgJ8B11agMXHHnfvsFKIOHwUMcN9NmP8eGFVdXX8UPRFJdeXlizZ4rMfEbic9mx/tBxA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369776; c=relaxed/simple;
	bh=NycFdmMRU5WpcYudxxq7wPCMh7JX/XP+RvLHAKbIFF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ixWaPWyFcfC1vuCgu+clDtN9MOjISZ2RU/1J6FTrQimrsgw/bwhkOaTHMfOx3eOZZL2nlsv9Jvym5iBRWCcsEJW/Q8iKjGdbPq3hddYC6ySdFQo1IlKd0E3+1yoPeVPqX7auAsZY3ZC4KTe2AQYjcrwdnZFhgzuXaccmm9p4TcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N17CGu/a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N17CGu/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B41C4CEE7;
	Mon, 13 Oct 2025 15:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369776;
	bh=NycFdmMRU5WpcYudxxq7wPCMh7JX/XP+RvLHAKbIFF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N17CGu/ak2HOdnnLIQCO6WWtoAGNB8EscO9+bzhu2Y+UKy6JscC25nWy8taKz12vV
	 A5BPKNbywsLprasb3nj5m41R4qaZTPpTCqt7wmhWV0ApRaVLUZNba+QTUTx9VBzAd+
	 OHWgO+jGICMkymfPbo/+A/OS0YILRgEvtC0UCfr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zqiang <qiang.zhang@linux.dev>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 364/563] srcu/tiny: Remove preempt_disable/enable() in srcu_gp_start_if_needed()
Date: Mon, 13 Oct 2025 16:43:45 +0200
Message-ID: <20251013144424.464811624@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zqiang <qiang.zhang@linux.dev>

[ Upstream commit e6a43aeb71852a39432332dcc3a6d11bb464b075 ]

Currently, the srcu_gp_start_if_needed() is always be invoked in
preempt disable's critical section, this commit therefore remove
redundant preempt_disable/enable() in srcu_gp_start_if_needed()
and adds a call to lockdep_assert_preemption_disabled() in order
to enable lockdep to diagnose mistaken invocations of this function
from preempts-enabled code.

Fixes: 65b4a59557f6 ("srcu: Make Tiny SRCU explicitly disable preemption")
Signed-off-by: Zqiang <qiang.zhang@linux.dev>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/srcutiny.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/rcu/srcutiny.c b/kernel/rcu/srcutiny.c
index 6e9fe2ce1075d..e3b64a5e0ec7e 100644
--- a/kernel/rcu/srcutiny.c
+++ b/kernel/rcu/srcutiny.c
@@ -176,10 +176,9 @@ static void srcu_gp_start_if_needed(struct srcu_struct *ssp)
 {
 	unsigned long cookie;
 
-	preempt_disable();  // Needed for PREEMPT_LAZY
+	lockdep_assert_preemption_disabled(); // Needed for PREEMPT_LAZY
 	cookie = get_state_synchronize_srcu(ssp);
 	if (ULONG_CMP_GE(READ_ONCE(ssp->srcu_idx_max), cookie)) {
-		preempt_enable();
 		return;
 	}
 	WRITE_ONCE(ssp->srcu_idx_max, cookie);
@@ -189,7 +188,6 @@ static void srcu_gp_start_if_needed(struct srcu_struct *ssp)
 		else if (list_empty(&ssp->srcu_work.entry))
 			list_add(&ssp->srcu_work.entry, &srcu_boot_list);
 	}
-	preempt_enable();
 }
 
 /*
-- 
2.51.0



