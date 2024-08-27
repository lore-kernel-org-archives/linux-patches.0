Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762CF1BC9E3;
	Tue, 27 Aug 2024 15:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772106; cv=none; b=JKCUfT/V0GU0/06ZBIp66SjLmvxfpDkkzxQhQB7je72EKp5mGjuspQY/G3QiAVeVnJyJqEfLt/VsSmwgALO0oFhSHWLar0YERNLw2GfDbedL+oy9R2EW1SIJrwmJeB1Db6vPDCMWGZn+pmg0gK6kh7ZTNhjpA9ANIjxRF7WhJjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772106; c=relaxed/simple;
	bh=qPINfyVZEUwRtnkix2Pcb7gkRW04INERPxAKcTMIrAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gllNUl+5kYcQTEmNPuF4lAReE2qmzD0ISr7zCZ765YRbXMPT2L6NDrjxX5yqwoKhGfbKspLWCae6IgPfBtvi4ugzxREgWYJ6xl2x/prpyamz01MpSf8j0sGR6L1G5zXZ114H5A7MMayrm1WwXQdd/lxeT1hYISyFIsHDzD3qS+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kntlbvOK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kntlbvOK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63ADC4FE09;
	Tue, 27 Aug 2024 15:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772106;
	bh=qPINfyVZEUwRtnkix2Pcb7gkRW04INERPxAKcTMIrAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kntlbvOKlQx7FhHD08bea5si658aoSLzZQKrgIiZK/vpY+Mwtzy1g6ToicQGSAndB
	 xyIq9zNv5yo6GAanUlTLG/ca+5SlJ3uaoxABjoNdjQFa5dXaNJ+q7zgWcRvPbMMMK5
	 Aj2Nnebh0cFYZbK1pULYOyJmDegP/jghUAp4czzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 116/321] rcu: Eliminate rcu_gp_slow_unregister() false positive
Date: Tue, 27 Aug 2024 16:37:04 +0200
Message-ID: <20240827143842.659936477@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

[ Upstream commit 0ae9942f03d0d034fdb0a4f44fc99f62a3107987 ]

When using rcutorture as a module, there are a number of conditions that
can abort the modprobe operation, for example, when attempting to run
both RCU CPU stall warning tests and forward-progress tests.  This can
cause rcu_torture_cleanup() to be invoked on the unwind path out of
rcu_rcu_torture_init(), which will mean that rcu_gp_slow_unregister()
is invoked without a matching rcu_gp_slow_register().  This will cause
a splat because rcu_gp_slow_unregister() is passed rcu_fwd_cb_nodelay,
which does not match a NULL pointer.

This commit therefore forgives a mismatch involving a NULL pointer, thus
avoiding this false-positive splat.

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 86923a8914007..dd6e15ca63b0c 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1336,7 +1336,7 @@ EXPORT_SYMBOL_GPL(rcu_gp_slow_register);
 /* Unregister a counter, with NULL for not caring which. */
 void rcu_gp_slow_unregister(atomic_t *rgssp)
 {
-	WARN_ON_ONCE(rgssp && rgssp != rcu_gp_slow_suppress);
+	WARN_ON_ONCE(rgssp && rgssp != rcu_gp_slow_suppress && rcu_gp_slow_suppress != NULL);
 
 	WRITE_ONCE(rcu_gp_slow_suppress, NULL);
 }
-- 
2.43.0



