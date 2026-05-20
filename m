Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1467B34A3BF;
	Wed, 20 May 2026 17:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296776; cv=none; b=BxuMbfD9u2pvY2HJNOwhVgu3LoEJrZ9uiqBqnMQ+fmCiEEFEhuwgD2/aqrwaKwG8CYrPIgH5KWnEi0Epx4TsP1kUVjhHyHtXxokGVFqDA6t+pTZwWL9AFlDja/GgoY+AX3ZMDxP3wkf8M7DZGb7bbaXpl03Ys6O6ViDhp87RJC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296776; c=relaxed/simple;
	bh=4Af15NsI/T9PUPFSqXOC61iT8kotuBWD5Xuqdz+2jNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u7feKElDq8VYgqkYrtu8v4K5AbqfoN7mWCG1EjDzsbJA4SZBR/b/g+/dwMKzPEwIYvXZTGK1KgSosb3QbiSbwTMDzI4cVOPqdTXBtMKpV3SQ9Gov8nn7X5qfpfEsNTY+w7OPl5CGY1LqrGPx9H9J6FF2+OrS6Svu5FAcPKf1QZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kMG6LuFl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kMG6LuFl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768FA1F00896;
	Wed, 20 May 2026 17:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296775;
	bh=l12dWRZ7n/hYZfkuTC4x7MWxrJhpDQt7UeyO4SD0fjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kMG6LuFlGhTRB35sv5eCkkrZKS+hszQNKQReUGnzDiBGJw+Ld3wKm4L6XGvtsbEkP
	 F24aCY/bcFTl214RuxdPJMtidzNneY72x62Ol29IUPRBLLZBCmMULF2OqbfMt9kli+
	 l8k9LjWhBML1S7XLop/biiHyDq7tIAWCotLVBmsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Hemminger <stephen@networkplumber.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0928/1146] net/sched: netem: fix probability gaps in 4-state loss model
Date: Wed, 20 May 2026 18:19:38 +0200
Message-ID: <20260520162209.238194348@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 20df1c08b1e9d..8ee72cac1faf0 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -227,10 +227,10 @@ static bool loss_4state(struct netem_sched_data *q)
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
 
@@ -247,9 +247,9 @@ static bool loss_4state(struct netem_sched_data *q)
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



