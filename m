Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AF329B799;
	Sat, 30 May 2026 18:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164642; cv=none; b=PSG9oxqIBzXXziBGu3Pae2LxGf6YZgdRz097toLt3foKFHuMBH8nAfUtCoa+A+2sD+XV66yTjtziPL2J7BP7zYzj4Wpk8QoLdAX1lUlzev+Dj51URsdUrYHfgBiXqT26VPnsH/+t1SebNm9h8QQfuGpXcKFTEx4/OEntPbSqty4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164642; c=relaxed/simple;
	bh=yNOHklpWFjhfZhBJrMHgNMDwJWUv11yGY1QmCpA/GdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RRi8AMQwvTz2DFSZv2DJEC1eqsD6Jr1qOsuz3XOnE/TGsvAQJSkuWJgaeiJ3063oqfvmxzQTpV+RpzSO0UZIxgWu30SCfFzhINdetmduBpo53NRaO7KjIZZaTNp6YA+2ibFZs/pfFA0+QaA4qq1ItAReBxYxvWNXOOVKvCXWUgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h7LovUXI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h7LovUXI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7A71F00893;
	Sat, 30 May 2026 18:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164641;
	bh=XjmV2rKQv277RKO+v/pjiX7NwpjgVaXves92XLbUKv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h7LovUXIOpASwZNx//ckqX+3qT/wUxwSe8qbVr5PpXW1MMEv5D6jukWz8gXzYclDd
	 sATfx2Bafh0lyOUIyiTSucTZI0R3qFMMFXkWbGttr1VA+gRqM0Fv4YgZyKP6kmCTwS
	 XVTlZ6r9Qs3pHedcPrTh6HWYFfz0/6lF38RUKltg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Hemminger <stephen@networkplumber.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 615/776] net/sched: netem: fix probability gaps in 4-state loss model
Date: Sat, 30 May 2026 18:05:29 +0200
Message-ID: <20260530160255.894736273@linuxfoundation.org>
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

From: Stephen Hemminger <stephen@networkplumber.org>

[ Upstream commit 732b463449fd0ef90acd13cda68eab1c91adb00c ]

The 4-state Markov chain in loss_4state() has gaps at the boundaries
between transition probability ranges. The comparisons use:

  if (rnd < a4)
  else if (a4 < rnd && rnd < a1 + a4)

When rnd equals a boundary value exactly, neither branch matches and
no state transition occurs. The redundant lower-bound check (a4 < rnd)
is already implied by being in the else branch.

Remove the unnecessary lower-bound comparisons so the ranges are
contiguous and every random value produces a transition, matching
the GI (General and Intuitive) loss model specification.

This bug goes back to original implementation of this model.

Fixes: 661b79725fea ("netem: revised correlated loss generator")
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260418032027.900913-2-stephen@networkplumber.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_netem.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index cbd7f3032fccf..1f47711cb1667 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -219,10 +219,10 @@ static bool loss_4state(struct netem_sched_data *q)
 		if (rnd < clg->a4) {
 			clg->state = LOST_IN_GAP_PERIOD;
 			return true;
-		} else if (clg->a4 < rnd && rnd < clg->a1 + clg->a4) {
+		} else if (rnd < clg->a1 + clg->a4) {
 			clg->state = LOST_IN_BURST_PERIOD;
 			return true;
-		} else if (clg->a1 + clg->a4 < rnd) {
+		} else {
 			clg->state = TX_IN_GAP_PERIOD;
 		}
 
@@ -239,9 +239,9 @@ static bool loss_4state(struct netem_sched_data *q)
 	case LOST_IN_BURST_PERIOD:
 		if (rnd < clg->a3)
 			clg->state = TX_IN_BURST_PERIOD;
-		else if (clg->a3 < rnd && rnd < clg->a2 + clg->a3) {
+		else if (rnd < clg->a2 + clg->a3) {
 			clg->state = TX_IN_GAP_PERIOD;
-		} else if (clg->a2 + clg->a3 < rnd) {
+		} else {
 			clg->state = LOST_IN_BURST_PERIOD;
 			return true;
 		}
-- 
2.53.0



