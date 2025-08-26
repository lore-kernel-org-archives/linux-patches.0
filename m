Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5656235CEC0;
	Tue, 26 Aug 2025 14:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218659; cv=none; b=aHMXi19TFBbEtZhUfiENdHPAhFh++YjBOwqX+57RVXbgCMCg2WKAz/VCntVxyFO23fUy6sJMlMjtqpF4VIwIK8vqRV/HzdjGbY9aOzY+7S3Bg4vlZhxYMaBm976w8ORNaw27f9s9qnspEI6B+frPWQ7fjIV4IQuaPGFdH1wCFbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218659; c=relaxed/simple;
	bh=yJ31srxmWc1HwDcA2ZOlf0KSECuWty98tI4IfFPY1G4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nhk47tYnOESzYMfOZvPDomHnyviZmxpxSQHh0T8JXwO5xBJpqVfnuPyj6ucHKmrYpxa3hEpx7ZXrD+bekjlLC3kBG4GByO2uMo2gLK+U8t7zzC9gKoOi4d6ZGA+q3AiQOCT9QxMnIDgafiWbzgmoX0zHvYgrGuiQAOSJHvWk8tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aTmWyj+E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aTmWyj+E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0E2C4CEF1;
	Tue, 26 Aug 2025 14:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218659;
	bh=yJ31srxmWc1HwDcA2ZOlf0KSECuWty98tI4IfFPY1G4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aTmWyj+EhKxexyMgZBHZM4gICD6LMXY19Gjzs7UuGzGohKGIErOJ2vutyJRLm6rzF
	 q3zVQsRQIxJ1FBdeUqlj/byWnFDOtcIrd34eJT/7xpDAzQ247aDYpFqkBC5ibOmRKz
	 oBbJuuiazmnOB8jlsW5cGqJL3dAILQGiIEGoHs3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 5.4 053/403] net_sched: sch_sfq: reject invalid perturb period
Date: Tue, 26 Aug 2025 13:06:19 +0200
Message-ID: <20250826110907.328897857@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 7ca52541c05c832d32b112274f81a985101f9ba8 ]

Gerrard Tai reported that SFQ perturb_period has no range check yet,
and this can be used to trigger a race condition fixed in a separate patch.

We want to make sure ctl->perturb_period * HZ will not overflow
and is positive.

Tested:

tc qd add dev lo root sfq perturb -10   # negative value : error
Error: sch_sfq: invalid perturb period.

tc qd add dev lo root sfq perturb 1000000000 # too big : error
Error: sch_sfq: invalid perturb period.

tc qd add dev lo root sfq perturb 2000000 # acceptable value
tc -s -d qd sh dev lo
qdisc sfq 8005: root refcnt 2 limit 127p quantum 64Kb depth 127 flows 128 divisor 1024 perturb 2000000sec
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250611083501.1810459-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_sfq.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -653,6 +653,14 @@ static int sfq_change(struct Qdisc *sch,
 		NL_SET_ERR_MSG_MOD(extack, "invalid quantum");
 		return -EINVAL;
 	}
+
+	if (ctl->perturb_period < 0 ||
+	    ctl->perturb_period > INT_MAX / HZ) {
+		NL_SET_ERR_MSG_MOD(extack, "invalid perturb period");
+		return -EINVAL;
+	}
+	perturb_period = ctl->perturb_period * HZ;
+
 	if (ctl_v1 && !red_check_params(ctl_v1->qth_min, ctl_v1->qth_max,
 					ctl_v1->Wlog, ctl_v1->Scell_log, NULL))
 		return -EINVAL;
@@ -669,14 +677,12 @@ static int sfq_change(struct Qdisc *sch,
 	headdrop = q->headdrop;
 	maxdepth = q->maxdepth;
 	maxflows = q->maxflows;
-	perturb_period = q->perturb_period;
 	quantum = q->quantum;
 	flags = q->flags;
 
 	/* update and validate configuration */
 	if (ctl->quantum)
 		quantum = ctl->quantum;
-	perturb_period = ctl->perturb_period * HZ;
 	if (ctl->flows)
 		maxflows = min_t(u32, ctl->flows, SFQ_MAX_FLOWS);
 	if (ctl->divisor) {


