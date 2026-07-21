Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8048417D67;
	Tue, 21 Jul 2026 19:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661167; cv=none; b=kJWVPKJbQ/wE6vX6HzJdJHI2Y/QlgK2gSiUIc1kM4Cg1AC7qQZP2mPihVq4WAIBrUzdeyACpharQmY/Amr8IRgzoVlgLw3chwGxgF9Wb42Ne+XqFNv8Dl+YVkcf3FSO6D5UYgGhCcV0UpQhHY6QqyZJC85fiOBXNFSMyoztD3Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661167; c=relaxed/simple;
	bh=LhDPTKhHDErBCKLMr+p0ZYJFwUSoX/CnIIMMkT0XWLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GISfM2TZYI/TX8QjTJvgx6qjOBh++JF07+i5+4maWUmCgiWpHzHge5bNZMk/SLhG4bxwFbZiqjWSC+ihSuk5DdKhy8W1D90AQ+N+vfAYfGXKb3+FrqUMfGfs7O37/SMGGaVGfpTGk8WoOJrnu3nyjVTEfOMLjuDyo3VnaUTET9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mJiFeMle; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mJiFeMle"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2021F000E9;
	Tue, 21 Jul 2026 19:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661166;
	bh=WqFi0UpnXJk6UhSMvusm+pg17n5hwPPbV0h2rtOPOww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mJiFeMledQyKyYDJQAbuNM12D1qNNS7Y9g6DFzJFPgm+OZBLvpbMxTnFIHStsH5CW
	 qdgbzfe9csd3Gaoyy2r7cD3WivAszqVqOacnDbWlSPxUp4D9hxrEFFJSGQsSfiL++r
	 6BBvhbnG5iqtCf85WK7hXj3E/lZ7zCv2EF2W76rM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zero Day Initiative <zdi-disclosures@trendmicro.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1257/2077] net/sched: cls_api: Handle TC_ACT_CONSUMED in tcf_qevent_handle
Date: Tue, 21 Jul 2026 17:15:30 +0200
Message-ID: <20260721152622.462213525@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit a8a02897f2b479127db261de05cbf0c28b98d159 ]

tcf_classify() can return TC_ACT_CONSUMED while the skb is held by the
defragmentation engine (e.g. act_ct on out-of-order fragments). When
that happens the skb is no longer owned by the caller and must not be
touched again.

tcf_qevent_handle() did not handle TC_ACT_CONSUMED: it fell through the
switch and returned the skb to the caller as if classification had
passed. The only qdisc that wires up qevents today is RED, via three call sites
(qe_mark on RED_PROB_MARK/HARD_MARK, qe_early_drop on congestion_drop)
red_enqueue() was continuing to operate on an skb it no longer owns  in this
case -- enqueueing it, dropping it, or updating statistics. Resulting in a UAF.

  tc qdisc add dev eth0 root handle 1: red ... qevent early_drop block 10
  tc filter add block 10 ... action ct

  (with ct defrag enabled and traffic that produces out-of-order
  fragments, e.g. a fragmented UDP stream)

Handle TC_ACT_CONSUMED in tcf_qevent_handle() the same way the ingress
and egress fast paths do: treat it as stolen and return NULL without
touching the skb. Unlike the TC_ACT_STOLEN case, the skb must not be
dropped/freed here, as it is no longer owned by us.

Fixes: 3f14b377d01d ("net/sched: act_ct: fix skb leak and crash on ooo frags")
Reported-by: Zero Day Initiative <zdi-disclosures@trendmicro.com>
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260620130749.226642-1-jhs@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 20f7f9ee0b353a..3e67600a4a1a10 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -4049,6 +4049,9 @@ struct sk_buff *tcf_qevent_handle(struct tcf_qevent *qe, struct Qdisc *sch, stru
 		skb_do_redirect(skb);
 		*ret = __NET_XMIT_STOLEN;
 		return NULL;
+	case TC_ACT_CONSUMED:
+		*ret = __NET_XMIT_STOLEN;
+		return NULL;
 	}
 
 	return skb;
-- 
2.53.0



