Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15D950AC30;
	Thu, 17 Sep 2026 15:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658855; cv=none; b=g8HISJIMYWOyKbsVP1h0UXUKOTN5mw5TebnE5fgP7kt6F9KbX9aJFqktslrdwtUbrHJcQIltU1bhC8d2okJY73ZRPyAi/xAGRJlsZzaaZVgnLrxggBjN/erfxSYRn/ITgKSpkPfBtmxPTlURb4hNS30ml8fh9Zk+iIU0DRcQTsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658855; c=relaxed/simple;
	bh=8SgZtuNYt6nf42Nn60WW3XcTxLlNYWZ9/tRp4TTlXuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sywnwgm1icArygJnVKA+wzjIBwq1BbEbo/zWyp/exy56hbbOP8VEAOrv52Jv2+SF3H4z8PlCef2VR3hFzIVvh10xEl/iL342Tsna+wA5SXO/uWizVT9OMtJSNyTqAj+Kcw9sYbGUOylqIJGfJEMbmWPWefdb2tFQmIKNeKvl+0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rgg5f/lW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rgg5f/lW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D61E1F00893;
	Thu, 17 Sep 2026 15:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658847;
	bh=oQ92tKgnr2NCj0J+BEVrqResvHidXxIBW7Mqh0Z8U70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rgg5f/lWq5/vDCegYelfa1m/e+Ne/J7i2jScFGcwFtkNM7f7CLQ3prEU2BOruTgOr
	 Cr6Yzr9Uq6deQOS6Jic/nxaRfqabVzvaFlQ2Pz2Z61O//QyqDeWZyNDGSnzJE8xLjD
	 IiU7rEN817fSTQT+/2HeJ7K6Ku7f11vAmNB1FGGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zero Day Initiative <zdi-disclosures@trendmicro.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 059/733] sctp: fix a TOCTOU race in SCTP_CMD_TIMER_START
Date: Thu, 17 Sep 2026 16:06:07 +0100
Message-ID: <20260917151352.286650902@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 94716406d602c..0d99b7e8c082f 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -1545,17 +1545,8 @@ static int sctp_cmd_interpreter(enum sctp_event_type event_type,
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



