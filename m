Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3067349AFF;
	Wed, 20 May 2026 17:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299417; cv=none; b=SCiXC6QGVLEL6QDohRshdZEbKlsVvaoWucaNsMCFFuVlag2jxYvJob0M3lXC/YJT3Qvp+rNRDsooZbejFd0LyBqftX6McTPerINytns0KXZM+axWKAyJ2vNkAsmpFAP/9SjqOXdObnAKJe+0PUS7qdgv65tjqUUXMjJup52IG3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299417; c=relaxed/simple;
	bh=M4lOwg/xZ13mqxH8CYLxgDiuC1WgrGZC/Xx5cokHzbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ks1ikLGFrpc4i7j82Tjn1crVBWAdgEPu/2JZoo90vPqnF0Fumqbx4xkTpXSdEr6QtLuPWS9WKpNufrh8W5inqEOvxJg5wlImcKZwNy5y4Y1aTLzanDnGYn8NWySDPofFioGP2E4w5Wh5JSoya6zf7IIBlx7/olB+P1CwNG+XFqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=10TjWN18; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="10TjWN18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9221F000E9;
	Wed, 20 May 2026 17:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299416;
	bh=JKqKawmZJpbx7Y1dIX/jVcwWbPRclydU8H4XbIMqzKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=10TjWN18nQyoBbpiS9i94pOgNsMDDXmOAjCmhDSFADnCT+aYIdTC/XPoaRR/9i+10
	 eKirHuk+DOn9MgYIxpPx+xCO6m4EQKkK/S5uTLBeUzlzgtKhj6qHg7ARoTc3qVkBV8
	 hjp4hxI7QcJEAjodN+bQpYxm7ujrmF/z9KTIzdlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Hemminger <stephen@networkplumber.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 765/957] net/sched: netem: fix probability gaps in 4-state loss model
Date: Wed, 20 May 2026 18:20:48 +0200
Message-ID: <20260520162151.154003996@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index 6f8fcc4b504ce..4eb6ed60ee9b6 100644
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



