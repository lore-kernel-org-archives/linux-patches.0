Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F986503BD3;
	Wed, 30 Sep 2026 15:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782866; cv=none; b=N5PtYJI70YtVPJkuqQSSilds53xQFwxLXd3ycat/B7we6R7UT2EZYIQ4NmU3DvMB+0ueJBq+cEncLh5yp43xaninBLMKo0q+o8S9gTfMETAzZrB4HinjELZH9g8MwgqFPwGkIaTm5WJSuGbTR4p6f1Ij6yZbjFAst4J7QE0AUF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782866; c=relaxed/simple;
	bh=gk1kKHRBwZwtVTdqKX/Y83lfxBrzwiv7/guz+g/GEms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=faxTUEmQocNUzaVnpjX8hEn2zt3pOAUycyVe+xnREu5ZmzA7+XOL8QU+iLmQJ5lLSEn0bjQamzGKLs/svLLceXkh+Yhx+DIKI7MC2MMUiYMcilgnrLWk1cdexnFGM64sW6t4c1JLeq+Iwd4CvWN3ln9IgP0YYrv/zZoQP1KCNb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h7dLT0xp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h7dLT0xp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744651F00898;
	Wed, 30 Sep 2026 15:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782862;
	bh=/CpoEdWslpmh2EewrwhZ2yTINeIW1K4miHdp/RfsRVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h7dLT0xpQMR9zaJHu4XVJsAEsGvhCftDKDzTxsJLKCCZer3OjrwW3V0joeJL7zotS
	 mLawSfqJrXMu4VZ0st8Zhq4LmwfydXkcPxdfxDU9I9eeTVuWptc3dQktUTf1EH5bqU
	 ngHcAINul+RIGqgcV3Jsmz1sMeFsmKg3XslacdGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zero Day Initiative <zdi-disclosures@trendmicro.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 195/595] sctp: fix a TOCTOU race in SCTP_CMD_TIMER_START
Date: Wed, 30 Sep 2026 17:21:28 +0200
Message-ID: <20260930152351.933421907@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 2188569e7e1b0bc3f3b557dc97ab7a02befc11c8 ]

The SCTP_CMD_TIMER_START handler checks timer_pending() before calling
timer_reduce(). The timer can expire and detach between these operations,
causing timer_reduce() to rearm the timer without taking the association
reference required for the newly armed timer.

The timer callback later unconditionally drops its association reference,
which can leave the association reference count unbalanced and result in
use-after-free during association teardown.

Use the return value of timer_reduce() to determine whether the timer was
actually armed. Take the association reference only when timer_reduce()
successfully starts a new timer, closing the race between checking the
timer state and rearming it.

This issue was reported by Nico Yip (@_cyeaa_) working with TrendAI Zero
Day Initiative.

Fixes: 20a785aa52c8 ("sctp: Don't add the shutdown timer if its already been added")
Reported-by: Zero Day Initiative <zdi-disclosures@trendmicro.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/9d8f1b5c50329d5ea7c642128d35681abaa9ed20.1787773744.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sm_sideeffect.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index a9fb38de8b12d..9ad5dd28329f7 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -1534,17 +1534,8 @@ static int sctp_cmd_interpreter(enum sctp_event_type event_type,
 			timeout = asoc->timeouts[cmd->obj.to];
 			BUG_ON(!timeout);
 
-			/*
-			 * SCTP has a hard time with timer starts.  Because we process
-			 * timer starts as side effects, it can be hard to tell if we
-			 * have already started a timer or not, which leads to BUG
-			 * halts when we call add_timer. So here, instead of just starting
-			 * a timer, if the timer is already started, and just mod
-			 * the timer with the shorter of the two expiration times
-			 */
-			if (!timer_pending(timer))
+			if (!timer_reduce(timer, jiffies + timeout))
 				sctp_association_hold(asoc);
-			timer_reduce(timer, jiffies + timeout);
 			break;
 
 		case SCTP_CMD_TIMER_RESTART:
-- 
2.53.0



