Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5074E46C4BD;
	Tue, 21 Jul 2026 19:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662994; cv=none; b=q1xqff0wkHkxONm+k4XR0Dwu7DWehs68WKGOeoL2dbUgWlHlzvRc7Jy6+1ol0gQcKwtAJgxuGpm4Qyse35qBVjOsoWHbbNGXNFJYlr0I8Utn2oKR87nE3pzmh5DJBrz2YCPbRRIjGh9Juu5w6z7+8ElU2iRo03gjgWTN73+mON0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662994; c=relaxed/simple;
	bh=xLOS/1lI2P3ofnG0XyX00NoDcY2d6Pk6Wk5vk5bX3i8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=De5akxfaYOVjvSrHHdQ00uXTJSWF7TFxiE2pbJirIY2B0s7awF8jvH/BW96S5euWJBP+ejCpM8bDz0poBqZbnvQyaIV691zml4DCkofiHVDuZ7Ll1ndfvfB7IWLAM3zifSJusH5OwK8c30n2i8nBFB0aV5S+f+G76S64CUCKH8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qU2/dbaL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qU2/dbaL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D641F000E9;
	Tue, 21 Jul 2026 19:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662993;
	bh=F6LQZHZk9YGWmagmZtKZjm5txFhp8agsrSS7cin9vO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qU2/dbaLdzI/HvKYlGw25iNEaZoSrVV/nYHKYKKaHn1s/Z4yfkyBtvWODjn00hzCR
	 I/c7l8UZrdpXfS5pwV3pkGEnXLWWe27L/wid1OqgPkfhcOjoCz2W7oBAQVPgfHh0T5
	 /BWc16+GQwP2LEvFGg6vaS3j1GwoMOVyrfiP9Pb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zero Day Initiative <zdi-disclosures@trendmicro.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0656/1276] net/sched: cls_api: Handle TC_ACT_CONSUMED in tcf_qevent_handle
Date: Tue, 21 Jul 2026 17:18:19 +0200
Message-ID: <20260721152500.789095923@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index 24c1d0480bc544..88f32a06de8712 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -4039,6 +4039,9 @@ struct sk_buff *tcf_qevent_handle(struct tcf_qevent *qe, struct Qdisc *sch, stru
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



