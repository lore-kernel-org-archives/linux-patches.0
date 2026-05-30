Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2ABE3B7B72;
	Sat, 30 May 2026 18:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164638; cv=none; b=klYZIf7JHt1tXiWHWNQ8t8A4/IAxybXxW0dOKxr1SrjNcnN38G5Hg1VZ/HlFYJ7Kl99Rivbb8r4YpQ016U1lmrWgXgt0fpdTnNqg9ZdM2sfHSMTaSqMoouW0xk9RcRuY+UCvMQXFyLd05Ix6prVhPJJ97DLZL0/ibFBtoZNWhNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164638; c=relaxed/simple;
	bh=aTsFHTLEHUdgqCt0qrqn6hqFrFg3Wo0vXkCtjH4Jcn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N1LsXHNXWRp3V/80cVv9TPErm8sFk4miOl7d1DWNioZedruVJnuDm235a0Zdg01WG2dpIR8KN6yleV7IhAsktoyyfUj3ogQ/pZxEOzHX1Pd+Kmg/44yzaCEB62oEzEd6Edh1H/Ws/F9YIHdZMk+eUff2seyuntn11+Gjtroc68E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pzltiSCo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pzltiSCo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D201F00893;
	Sat, 30 May 2026 18:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164637;
	bh=yodlt6V3RtMlPMeODGVsgDCgUpD7Z5eWoWM9NGBwY7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pzltiSComFyO+koUa+zJKsnkG36saSQtcJmj5zLrIesbUJaHVurtYTZmPoIa8i2u4
	 47RzBvQnDLJyRkMlNKm+dFcVgYJuAXhA5E6R3AubeF/uKjGFUOAUaG67L3/lKLNpkS
	 SZvCpF2gMdIbnMx5eYMlU60UFSd0Npom1DJTCYso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Stephen Hemminger <stephen@networkplumber.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 614/776] net: sched: sch_netem: Refactor code in 4-state loss generator
Date: Sat, 30 May 2026 18:05:28 +0200
Message-ID: <20260530160255.872926725@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit cb3ef7b00042479277cda7871d899378ad91f081 ]

Fixed comments to match description with variable names and
refactored code to match the convention as per [1].

To match the convention mapping is done as follows:
State 3 - LOST_IN_BURST_PERIOD
State 4 - LOST_IN_GAP_PERIOD

[1] S. Salsano, F. Ludovici, A. Ordine, "Definition of a general
and intuitive loss model for packet networks and its implementation
in the Netem module in the Linux kernel"

Fixes: a6e2fe17eba4 ("sch_netem: replace magic numbers with enumerate")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Acked-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 732b463449fd ("net/sched: netem: fix probability gaps in 4-state loss model")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_netem.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 951156d7e5485..cbd7f3032fccf 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -210,17 +210,17 @@ static bool loss_4state(struct netem_sched_data *q)
 	 * next state and if the next packet has to be transmitted or lost.
 	 * The four states correspond to:
 	 *   TX_IN_GAP_PERIOD => successfully transmitted packets within a gap period
-	 *   LOST_IN_BURST_PERIOD => isolated losses within a gap period
-	 *   LOST_IN_GAP_PERIOD => lost packets within a burst period
-	 *   TX_IN_GAP_PERIOD => successfully transmitted packets within a burst period
+	 *   LOST_IN_GAP_PERIOD => isolated losses within a gap period
+	 *   LOST_IN_BURST_PERIOD => lost packets within a burst period
+	 *   TX_IN_BURST_PERIOD => successfully transmitted packets within a burst period
 	 */
 	switch (clg->state) {
 	case TX_IN_GAP_PERIOD:
 		if (rnd < clg->a4) {
-			clg->state = LOST_IN_BURST_PERIOD;
+			clg->state = LOST_IN_GAP_PERIOD;
 			return true;
 		} else if (clg->a4 < rnd && rnd < clg->a1 + clg->a4) {
-			clg->state = LOST_IN_GAP_PERIOD;
+			clg->state = LOST_IN_BURST_PERIOD;
 			return true;
 		} else if (clg->a1 + clg->a4 < rnd) {
 			clg->state = TX_IN_GAP_PERIOD;
@@ -229,24 +229,24 @@ static bool loss_4state(struct netem_sched_data *q)
 		break;
 	case TX_IN_BURST_PERIOD:
 		if (rnd < clg->a5) {
-			clg->state = LOST_IN_GAP_PERIOD;
+			clg->state = LOST_IN_BURST_PERIOD;
 			return true;
 		} else {
 			clg->state = TX_IN_BURST_PERIOD;
 		}
 
 		break;
-	case LOST_IN_GAP_PERIOD:
+	case LOST_IN_BURST_PERIOD:
 		if (rnd < clg->a3)
 			clg->state = TX_IN_BURST_PERIOD;
 		else if (clg->a3 < rnd && rnd < clg->a2 + clg->a3) {
 			clg->state = TX_IN_GAP_PERIOD;
 		} else if (clg->a2 + clg->a3 < rnd) {
-			clg->state = LOST_IN_GAP_PERIOD;
+			clg->state = LOST_IN_BURST_PERIOD;
 			return true;
 		}
 		break;
-	case LOST_IN_BURST_PERIOD:
+	case LOST_IN_GAP_PERIOD:
 		clg->state = TX_IN_GAP_PERIOD;
 		break;
 	}
-- 
2.53.0



