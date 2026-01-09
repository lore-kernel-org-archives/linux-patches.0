Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A996359704;
	Fri,  9 Jan 2026 11:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959112; cv=none; b=s8i3DYlExJPg3TrJllPNgxpgToMGB43wKRcfmXAdJi1FkqA2oZ8IvcY++XAspphcL2qEvv/K42IMxFt4qr4WMTuvcBTpqLbJTU/pYy/TpylvUwc9C4n3M/OgdC08a5mly4AaKbMA7WmqzcdwpU2L802HIOKZXSfDGfV/eY4bplw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959112; c=relaxed/simple;
	bh=3tGW3qoN4Ume7ufXenhsUEVS2MJwRtEK/2TGszajCiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rl17/hqiNHrhLNE4imIEkSHUsyQ8gEr7vlIjvYqyHXLq4wYImDrsvY3qgw0cjJjoErMjcU3L8xts6h0gBhPOWgdTr0AUC6DTDMP84MJ+FzkK7+2OAWT8mGT5TnvUwFS9eZPXviJSSrEI14BjAcQvyUkL9Q6jye07t0PN6n5FviM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rXObHB7A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rXObHB7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8451BC4CEF1;
	Fri,  9 Jan 2026 11:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959110;
	bh=3tGW3qoN4Ume7ufXenhsUEVS2MJwRtEK/2TGszajCiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rXObHB7A1FIkCv0OZ6aXVdBI2TOGDY+PtuSDyirJUPuXfIwI/PT4badsZZafsDoX0
	 udLd3oRxpX7iPgkBKGa1QIGdAPPfVMam0jDlTg+zuceCvLlNtD558pvT0x2DkTeYa+
	 5jptXvN2HxOzkHu7eiOXqVGIVuCHkhJx9xE8EonU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Chris Mason <clm@meta.com>
Subject: [PATCH 6.18 2/5] sched/fair: Small cleanup to sched_balance_newidle()
Date: Fri,  9 Jan 2026 12:44:04 +0100
Message-ID: <20260109111950.440046196@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109111950.344681501@linuxfoundation.org>
References: <20260109111950.344681501@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

commit e78e70dbf603c1425f15f32b455ca148c932f6c1 upstream.

Pull out the !sd check to simplify code.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Chris Mason <clm@meta.com>
Link: https://patch.msgid.link/20251107161739.525916173@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/fair.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -12787,14 +12787,16 @@ static int sched_balance_newidle(struct
 
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


