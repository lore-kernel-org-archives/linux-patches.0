Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F881F6667;
	Mon, 23 Jun 2025 22:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717104; cv=none; b=IIWAaJ0DsyE5ogxrBj/lkcH/ybJ08pxdL7l5l5Zh24KloBRiEVDtcxa0CEhmnapvnqwhvD9ZdK0e4SzpVG7J4rLVKnPKpkvZIripocZD3n5bLmtLVbehijNo4DmW7k3V4WICUTwJVVysHFYrDbOLUpUOlGEzx79Jb84pjuPrgwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717104; c=relaxed/simple;
	bh=oIxUzeLJglHW0DKImIM9huXOhAyeNJnhEbGF9HeFHVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LyTzkAaXMOaqs1dFN1J6VFaQNuQGM41ugaGzQRSVz8Ex2sB1EuJ4vCBECJAAmAMxjzGqRFjPpc2yJRLDvFulMnhsSzvfv6zVDiJT7DJBF+cvkpEOFAzFZS7hvqjK9p5twHNATGhpblCkQnlm8X4/bM1/XLkwHFRpXrdklKMk7gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2aALiREe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2aALiREe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27BE2C4CEEA;
	Mon, 23 Jun 2025 22:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717104;
	bh=oIxUzeLJglHW0DKImIM9huXOhAyeNJnhEbGF9HeFHVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2aALiREeSJ070NNJc2Y/x29hO9zXUbVwiNnkaMZrk20SkqgUbZgY8Z6oWW6cxK19a
	 IBhmyHCcF5C6B3GGvhvlcXGEFsg4YV61J9LAocpeuxDXUrL5Cl1/ZHsFPgdl707FXK
	 tuuY1ssBnHp+8v/9k/DHH/2AtWDuCoxVddpcEsaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 402/411] net_sched: sch_sfq: reject invalid perturb period
Date: Mon, 23 Jun 2025 15:09:06 +0200
Message-ID: <20250623130643.799344459@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 7ca52541c05c832d32b112274f81a985101f9ba8 upstream.

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


