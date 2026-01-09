Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A085333C52A;
	Fri,  9 Jan 2026 11:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959064; cv=none; b=uLxZ1WrdCMfqHUMM5LAv7ydVc35wrUaiRUrF4YnUZEX+/O5tlNIJV+ucp5pMUC3DSub5CB73m5upV/rpX5e86DiTXWv4u+U/+lCt4jkCyjQQzUt5bHRPzITo3En/O07TclZ3CCrvarDPB/9wOyGf7wvUI2ECWM7D95qoK77YZks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959064; c=relaxed/simple;
	bh=nup5CeBqLMU6bAXTt3iZKYh6st9ZBaveso5cq3eoIY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UATxwj4NRWBIRYKBsptL9ZexLRXfCNfuB/MlfB0Ayd+jWnMhiAaaUMJi6FzYPlQDbDZ90a9MktOxAKMyXzYEmT8zFF3YtZeNiZp594fwg/azByyM1ZvtFYjpaQfYknglAnjVmCajiesd0H53smbZAmF3N1bceHwlm777WXlUPJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IiEggDY9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IiEggDY9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D99C16AAE;
	Fri,  9 Jan 2026 11:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959064;
	bh=nup5CeBqLMU6bAXTt3iZKYh6st9ZBaveso5cq3eoIY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IiEggDY9NLFTUm0mAX8BYQkXGqE8Jdh0ujL6QVbTp900BrsfamkEFXNCfX68L9zGB
	 M7CFobQ4c+EJWDWkUjMUCl4tWoHdnrIg6rGHoCxL+rqZI+PVlGDZD7redJBVs4kcCS
	 oNvkngBGxwh6AqpNnUn/OUOVNfCyRuMKV79kJaVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Chris Mason <clm@meta.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>
Subject: [PATCH 6.12 11/16] sched/fair: Small cleanup to sched_balance_newidle()
Date: Fri,  9 Jan 2026 12:43:52 +0100
Message-ID: <20260109111951.850357777@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109111951.415522519@linuxfoundation.org>
References: <20260109111951.415522519@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit e78e70dbf603c1425f15f32b455ca148c932f6c1 upstream.

Pull out the !sd check to simplify code.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Chris Mason <clm@meta.com>
Link: https://patch.msgid.link/20251107161739.525916173@infradead.org
[ Ajay: Modified to apply on v6.12 ]
Signed-off-by: Ajay Kaher <ajay.kaher@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/fair.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -12864,14 +12864,16 @@ static int sched_balance_newidle(struct
 
 	rcu_read_lock();
 	sd = rcu_dereference_check_sched_domain(this_rq->sd);
+	if (!sd) {
+		rcu_read_unlock();
+		goto out;
+	}
 
 	if (!get_rd_overloaded(this_rq->rd) ||
-	    (sd && this_rq->avg_idle < sd->max_newidle_lb_cost)) {
+	    this_rq->avg_idle < sd->max_newidle_lb_cost) {
 
-		if (sd)
-			update_next_balance(sd, &next_balance);
+		update_next_balance(sd, &next_balance);
 		rcu_read_unlock();
-
 		goto out;
 	}
 	rcu_read_unlock();


