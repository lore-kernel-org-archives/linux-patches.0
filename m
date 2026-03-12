Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC987384253;
	Thu, 12 Mar 2026 20:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347316; cv=none; b=qH63ePb9aJHWSoW6AbuLqxigxYCEs1J2XqiHUvGMjc+6BN/XQ5yv1c5lF2DiUshIoOmodJmIKS1bwBFmlmTQG3tXS55nuWlvc3+Ygok8x4Rt4HZX1pEAXK1DezGa9f/Lt1Dttj78oHV9QFR81WTWjesxVt4xkFimYYUOMLotTXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347316; c=relaxed/simple;
	bh=TjrmxY3ryKrra2I/Ax24gvuL1lmQwca18fcFy4ICdK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JuMlFQwhEz2WuF44aEefCmCTORSYnFrA7GAaFrUeW1bP6xgzTsqxm2zmsnXroNT+8y379uM+qHtNW+YW1pnaRVC/Tw33TUxWXRG7AWfjX0pQkTzPCbQ0uZjXFGICX6fDbAQONwKIRZxqhK/eHAXt7f0nkAQerPN57WM8wOlg3dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xyqFgHXh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xyqFgHXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58478C19425;
	Thu, 12 Mar 2026 20:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347316;
	bh=TjrmxY3ryKrra2I/Ax24gvuL1lmQwca18fcFy4ICdK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xyqFgHXhwb0HeM+F7hu4GOf7XF+9ghFV/aWaC8gLJpA9sPXeh0AqO6jCph8pPeu0k
	 BjPE9aTQhWV7aMXP9secocUwpAjP2mhOtpg2mmicqXK4ETEi4UtPmcWhYCYxRFw5H2
	 Qk4p2vO8Q8/cu/RXBfTn1ZkXiUaijJ8WSl2hN1gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Praveen Kaligineedi <pkaligineedi@google.com>
Subject: [PATCH 6.12 229/265] net_sched: sch_fq: clear q->band_pkt_count[] in fq_reset()
Date: Thu, 12 Mar 2026 21:10:16 +0100
Message-ID: <20260312201026.600321821@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a4c2b8be2e5329e7fac6e8f64ddcb8958155cfcb ]

When/if a NIC resets, queues are deactivated by dev_deactivate_many(),
then reactivated when the reset operation completes.

fq_reset() removes all the skbs from various queues.

If we do not clear q->band_pkt_count[], these counters keep growing
and can eventually reach sch->limit, preventing new packets to be queued.

Many thanks to Praveen for discovering the root cause.

Fixes: 29f834aa326e ("net_sched: sch_fq: add 3 bands and WRR scheduling")
Diagnosed-by: Praveen Kaligineedi <pkaligineedi@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260304015640.961780-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_fq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index 1af9768cd8ff6..682daf79af373 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -815,6 +815,7 @@ static void fq_reset(struct Qdisc *sch)
 	for (idx = 0; idx < FQ_BANDS; idx++) {
 		q->band_flows[idx].new_flows.first = NULL;
 		q->band_flows[idx].old_flows.first = NULL;
+		q->band_pkt_count[idx] = 0;
 	}
 	q->delayed		= RB_ROOT;
 	q->flows		= 0;
-- 
2.51.0



