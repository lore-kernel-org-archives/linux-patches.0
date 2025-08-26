Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1A629D26A;
	Tue, 26 Aug 2025 11:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208780; cv=none; b=IUnKtmIV9L9PucKR9AuCVUFCyWeLx8cguQuUEC5aYHmaQ28lun64lDjov3LzBoqiZ97eoo7KuTZbwCLVUbJwqVPdTd1OkVrtrQo+QrEZC9OJoQvkag0SATReos67j7y8WJRCAqGqxFlFJwqegLZAgqDYMfbBCZEkExKoT/wjooU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208780; c=relaxed/simple;
	bh=1X7gXNOV/wETFpSsc4ZrsKLAuP6ZkbGbwfVgEco9PMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZT1b3HajZJzQuyyYodmDISSoq9ue6HEU+i3SHIdGfbxqrGz+Cv7zrinswIzWDIUflgEG0Mwvuk+3T7/dUTY4MJmYL0BnB3xUytWDATYvo7TuyK2uLWDbwwSpdQgv5M9s2V7TM5jIGyhwIJod3Qku7JL1sL8Xp+LnDRaAK8QqiZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mYq7vm5R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mYq7vm5R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6D5C113CF;
	Tue, 26 Aug 2025 11:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208780;
	bh=1X7gXNOV/wETFpSsc4ZrsKLAuP6ZkbGbwfVgEco9PMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mYq7vm5REkI5uMfqCDu4FKmio2a9FTGCL2X1iAddZ5c3rkrQvEZmyKqL/37ZqxA2V
	 K60KiKMCwU0+Dirm9YoVPpf6PXxTJ43ICug6OBt1HjOSlbF56dEPpyS+Z/0CClmTVl
	 YCp4gEVj2KcN9/29K0rTjQBU7qkjrqWMYqqvUhBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Christian Loehle <christian.loehle@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 211/322] cpuidle: governors: menu: Avoid selecting states with too much latency
Date: Tue, 26 Aug 2025 13:10:26 +0200
Message-ID: <20250826110921.079800680@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 779b1a1cb13ae17028aeddb2fbbdba97357a1e15 ]

Occasionally, the exit latency of the idle state selected by the menu
governor may exceed the PM QoS CPU wakeup latency limit.  Namely, if the
scheduler tick has been stopped already and predicted_ns is greater than
the tick period length, the governor may return an idle state whose exit
latency exceeds latency_req because that decision is made before
checking the current idle state's exit latency.

For instance, say that there are 3 idle states, 0, 1, and 2.  For idle
states 0 and 1, the exit latency is equal to the target residency and
the values are 0 and 5 us, respectively.  State 2 is deeper and has the
exit latency and target residency of 200 us and 2 ms (which is greater
than the tick period length), respectively.

Say that predicted_ns is equal to TICK_NSEC and the PM QoS latency
limit is 20 us.  After the first two iterations of the main loop in
menu_select(), idx becomes 1 and in the third iteration of it the target
residency of the current state (state 2) is greater than predicted_ns.
State 2 is not a polling one and predicted_ns is not less than TICK_NSEC,
so the check on whether or not the tick has been stopped is done.  Say
that the tick has been stopped already and there are no imminent timers
(that is, delta_tick is greater than the target residency of state 2).
In that case, idx becomes 2 and it is returned immediately, but the exit
latency of state 2 exceeds the latency limit.

Address this issue by modifying the code to compare the exit latency of
the current idle state (idle state i) with the latency limit before
comparing its target residency with predicted_ns, which allows one
more exit_latency_ns check that becomes redundant to be dropped.

However, after the above change, latency_req cannot take the predicted_ns
value any more, which takes place after commit 38f83090f515 ("cpuidle:
menu: Remove iowait influence"), because it may cause a polling state
to be returned prematurely.

In the context of the previous example say that predicted_ns is 3000 and
the PM QoS latency limit is still 20 us.  Additionally, say that idle
state 0 is a polling one.  Moving the exit_latency_ns check before the
target_residency_ns one causes the loop to terminate in the second
iteration, before the target_residency_ns check, so idle state 0 will be
returned even though previously state 1 would be returned if there were
no imminent timers.

For this reason, remove the assignment of the predicted_ns value to
latency_req from the code.

Fixes: 5ef499cd571c ("cpuidle: menu: Handle stopped tick more aggressively")
Cc: 4.17+ <stable@vger.kernel.org> # 4.17+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/5043159.31r3eYUQgx@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpuidle/governors/menu.c |   29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -293,20 +293,15 @@ static int menu_select(struct cpuidle_dr
 		return 0;
 	}
 
-	if (tick_nohz_tick_stopped()) {
-		/*
-		 * If the tick is already stopped, the cost of possible short
-		 * idle duration misprediction is much higher, because the CPU
-		 * may be stuck in a shallow idle state for a long time as a
-		 * result of it.  In that case say we might mispredict and use
-		 * the known time till the closest timer event for the idle
-		 * state selection.
-		 */
-		if (predicted_ns < TICK_NSEC)
-			predicted_ns = data->next_timer_ns;
-	} else if (latency_req > predicted_ns) {
-		latency_req = predicted_ns;
-	}
+	/*
+	 * If the tick is already stopped, the cost of possible short idle
+	 * duration misprediction is much higher, because the CPU may be stuck
+	 * in a shallow idle state for a long time as a result of it.  In that
+	 * case, say we might mispredict and use the known time till the closest
+	 * timer event for the idle state selection.
+	 */
+	if (tick_nohz_tick_stopped() && predicted_ns < TICK_NSEC)
+		predicted_ns = data->next_timer_ns;
 
 	/*
 	 * Find the idle state with the lowest power while satisfying
@@ -322,13 +317,15 @@ static int menu_select(struct cpuidle_dr
 		if (idx == -1)
 			idx = i; /* first enabled state */
 
+		if (s->exit_latency_ns > latency_req)
+			break;
+
 		if (s->target_residency_ns > predicted_ns) {
 			/*
 			 * Use a physical idle state, not busy polling, unless
 			 * a timer is going to trigger soon enough.
 			 */
 			if ((drv->states[idx].flags & CPUIDLE_FLAG_POLLING) &&
-			    s->exit_latency_ns <= latency_req &&
 			    s->target_residency_ns <= data->next_timer_ns) {
 				predicted_ns = s->target_residency_ns;
 				idx = i;
@@ -360,8 +357,6 @@ static int menu_select(struct cpuidle_dr
 
 			return idx;
 		}
-		if (s->exit_latency_ns > latency_req)
-			break;
 
 		idx = i;
 	}


