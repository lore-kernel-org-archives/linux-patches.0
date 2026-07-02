Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDB033A033;
	Thu,  2 Jul 2026 16:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009437; cv=none; b=I1Fjrx89+hI3UcIQZylhGo4p1wPHMRpYGlswPq3lZp+hxAGokEZYXlmEzJQMBuZ6McRDZkSXw74ZNsUD86O7qwprEtibUEMg1HuqdEWde0zuP1LXKat9EjcXlDVPsWgBSKUTF+czWbN5yz6Uxxum9TS7iUgB7L9/bBoFzFXZ3mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009437; c=relaxed/simple;
	bh=rXbETS3T1I6j4oSrWe62MpCAqfUYvovr6ZuJsbHnJWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WkcxDN9P5sUipgpErraWgPZ1kzk73ummr+gUz4BZXpecOo+yf8vgBdEZT/FwT4BEb+MZZ6JbiRv1xleBsQ9zu7VdOGLcS0EMT36X8c+iqgqw9oKsTs7NJVDWQYYhQa0Ihx9jo8MBvml5qhZ/YXN3xQTKZ/y082abzdEwMG+aIbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UAWmJ+N+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UAWmJ+N+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620351F00A3A;
	Thu,  2 Jul 2026 16:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009431;
	bh=7KU8i9NQhqb+PC9WTMO+klWsLigVV9uyv6z15IYWDio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UAWmJ+N+mzL6gYM0koDrzDBXKGzbyyKgARqhCvsqTq5TfY8/QlY5xEESf4LfZC0pV
	 kWNaPLC4ISwqzmnuNrfBfNfB+zrye6yHqNVppzmnt/DQ5buQpRhw7Pp+DkKIaVxBUV
	 wWfTwNouq8LY/YfcYg5Uy/gN9p5SP0TGGG30U+18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Simon Horman <simon.horman@corigine.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	"David S. Miller" <davem@davemloft.net>,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 06/96] net/sched: act_pedit: rate limit datapath messages
Date: Thu,  2 Jul 2026 18:18:58 +0200
Message-ID: <20260702155109.101296679@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
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

From: Pedro Tammela <pctammela@mojatatu.com>

[ Upstream commit e3c9673e2f6e1b3aa4bb87c570336e10f364c28a ]

Unbounded info messages in the pedit datapath can flood the printk
ring buffer quite easily depending on the action created.
As these messages are informational, usually printing some, not all,
is enough to bring attention to the real issue.

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_pedit.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 95ae885ecba168..ecad6fc39dc3d7 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -383,8 +383,8 @@ static int tcf_pedit_act(struct sk_buff *skb, const struct tc_action *a,
 			u8 *d, _d;
 
 			if (!offset_valid(skb, hoffset + tkey->at)) {
-				pr_info("tc action pedit 'at' offset %d out of bounds\n",
-					hoffset + tkey->at);
+				pr_info_ratelimited("tc action pedit 'at' offset %d out of bounds\n",
+						    hoffset + tkey->at);
 				goto bad;
 			}
 			d = skb_header_pointer(skb, hoffset + tkey->at,
@@ -394,14 +394,13 @@ static int tcf_pedit_act(struct sk_buff *skb, const struct tc_action *a,
 
 			offset += (*d & tkey->offmask) >> tkey->shift;
 			if (offset % 4) {
-				pr_info("tc action pedit offset must be on 32 bit boundaries\n");
+				pr_info_ratelimited("tc action pedit offset must be on 32 bit boundaries\n");
 				goto bad;
 			}
 		}
 
 		if (!offset_valid(skb, hoffset + offset)) {
-			pr_info("tc action pedit offset %d out of bounds\n",
-				hoffset + offset);
+			pr_info_ratelimited("tc action pedit offset %d out of bounds\n", hoffset + offset);
 			goto bad;
 		}
 
@@ -418,8 +417,7 @@ static int tcf_pedit_act(struct sk_buff *skb, const struct tc_action *a,
 			val = (*ptr + tkey->val) & ~tkey->mask;
 			break;
 		default:
-			pr_info("tc action pedit bad command (%d)\n",
-				cmd);
+			pr_info_ratelimited("tc action pedit bad command (%d)\n", cmd);
 			goto bad;
 		}
 
-- 
2.53.0



