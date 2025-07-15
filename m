Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100BC2E3AE7;
	Tue, 15 Jul 2025 13:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587522; cv=none; b=akd8p5MYtIdSaqm6gjniXITBgPu/5zo4tli/jfwZugZg+vVgD69TwNrmZVChYDC3Dc5KacKN0eFSmN8DDl25ElT42dS1rLMjCPxASX3a9MOzEi2Oj8yuiCdsRWXxiI+HytEKus/xk8wJmjGZWpriEA24MkjMAdaX2IAt0LY42RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587522; c=relaxed/simple;
	bh=AFVQeH7mEGB1S5gYceKzR8K7j7xLfCcmDS80DOaz4WM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PWYCjMMvhoNhN5mOf8R4RHQgyjSvwT/yA5PluhCNK+ME/gZ2V4iTxeFdSdt3NYNL14dNHxFZ5bxRcn0KiHFjCT8HJbNGBAEvHMbVsDRRzwpctrkz9VUgU7GySmDFO8ifnItwCD+cRzgCqET9EZjnxIvn8aB+p4z9hhy+maiDYwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K3//oBQz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K3//oBQz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97CF7C4CEF4;
	Tue, 15 Jul 2025 13:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587521;
	bh=AFVQeH7mEGB1S5gYceKzR8K7j7xLfCcmDS80DOaz4WM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K3//oBQzfmWUNLeR854UPzAvQLWSFeL+x9Q1+oE0Qi8GUpJK7VBfoolyqyYKYO9C3
	 TEy8OulfZGdcVMVuibp/Cg7Wp4FYDh6sqOP9Xx4QDPmI17TwJkJZvIJCw7sJQFPQEq
	 akD/JDaPJEcJYaZ7mg+9I7yPog9Sh6fdhoQpLbFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 044/208] net_sched: sch_sfq: reject invalid perturb period
Date: Tue, 15 Jul 2025 15:12:33 +0200
Message-ID: <20250715130812.720449607@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_sfq.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_sfq.c b/net/sched/sch_sfq.c
index e87560e244861..4a10f794be588 100644
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -653,6 +653,14 @@ static int sfq_change(struct Qdisc *sch, struct nlattr *opt,
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
@@ -669,14 +677,12 @@ static int sfq_change(struct Qdisc *sch, struct nlattr *opt,
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
-- 
2.39.5



