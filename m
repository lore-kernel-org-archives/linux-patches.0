Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC7C37B40C;
	Tue, 21 Jul 2026 17:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653548; cv=none; b=LITXNXlHlLk9kfUDd5rQyBjcaHfGG4uqcKCQNTJg6bKWN2DoK/uNQelo2XJXP9949/bbFQyqy2q6VjHYvpC7qkVqFYrXCmW9X/TMP0hRTDsRvd13cIHbVJP2ucGC+RKxP6v494ibCJAlDnSm5XNtM1KWdEUrJciNlLNoZCVh9fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653548; c=relaxed/simple;
	bh=QO9/+kph0zucdANqjLSTq3XC142Z3jiG3dakOQxhTfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mUig1z4nOTsqWCnNk/RycjWI91K1PAziXq5pZorI12eEPGYY9pbHgMwT3863Tu58HYsYWfDjhboPkWTXIIrK/lThx7H6jkdtVR72ttY+rNYRgcT8yLzRMb8Z1R50Z7gaOGC8lvKDKaOnVtPCAodneM57dngFFxhL3kruGGT+yt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O2m8laP0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O2m8laP0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FFF1F00A3A;
	Tue, 21 Jul 2026 17:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653547;
	bh=OkqL7oTAuymuZDbzJGZBZehpjzwqjYBdoRjnoz7xWxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O2m8laP0gjsqcMDwwf8V/pE0RgdCBvcxy+7u//Tdj+oYUXmlxbaoWj44b9A13uxq3
	 0wppcDE66As/lq1ky1VLMwiRsn6L/m5j4q0PMeCsKvUcexDaTwo/QbRXV/s5dcH0uo
	 9Yt+l2KkhGXkk9GBj8CbLxF83O5xk7TbGtN5U578=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1367/2077] net/sched: dualpi2: clear stale classification on filter miss
Date: Tue, 21 Jul 2026 17:17:20 +0200
Message-ID: <20260721152625.060995162@linuxfoundation.org>
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

From: Samuel Moelius <sam.moelius@trailofbits.com>

[ Upstream commit bf83ee45874e9f071478bed39f9cf40cc741629f ]

DualPI2 leaves previous classification state attached to an skb when
filter classification returns no match.  The enqueue path can then act
on stale state from an earlier classification attempt.

A filter miss should fall back to the default class without reusing old
per-packet classification data.

Initialize the classification result to CLASSIC before running the
classifier.  Explicit L4S, priority, and successful filter
classification can still override that default.

Fixes: 8f9516daedd6 ("sched: Add enqueue/dequeue of dualpi2 qdisc")
Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_dualpi2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_dualpi2.c b/net/sched/sch_dualpi2.c
index 5434df6ca8efe6..27088760eff443 100644
--- a/net/sched/sch_dualpi2.c
+++ b/net/sched/sch_dualpi2.c
@@ -346,6 +346,8 @@ static int dualpi2_skb_classify(struct dualpi2_sched_data *q,
 	struct tcf_proto *fl;
 	int result;
 
+	cb->classified = DUALPI2_C_CLASSIC;
+
 	dualpi2_read_ect(skb);
 	if (cb->ect & q->ecn_mask) {
 		cb->classified = DUALPI2_C_L4S;
@@ -359,10 +361,8 @@ static int dualpi2_skb_classify(struct dualpi2_sched_data *q,
 	}
 
 	fl = rcu_dereference_bh(q->tcf_filters);
-	if (!fl) {
-		cb->classified = DUALPI2_C_CLASSIC;
+	if (!fl)
 		return NET_XMIT_SUCCESS;
-	}
 
 	result = tcf_classify(skb, NULL, fl, &res, false);
 	if (result >= 0) {
-- 
2.53.0



