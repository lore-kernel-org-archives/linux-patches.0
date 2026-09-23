Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0578848E0E7;
	Wed, 23 Sep 2026 14:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173763; cv=none; b=RnFs2K2qjA7Sd4rfBMxW+tn6eh2LWo2TzcoCUMabJIONtAAsJ6bB/9xpVpRGUYRYd2ydT+qutEJ1jPEXMMk+2Um6wPxAe1UD0jwuibML2ktRDcuKl7nYZzRd0uXsuWnYuhqVJwClDQUdyYIj/xPr7r8eqt7yMMH3IWlFiLoHj/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173763; c=relaxed/simple;
	bh=Y/chAPsKtVn3UQQ2cpm2P+/fLcPle9ivNtoU79ydjao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3PnpsgJY1KA65ZiXgboT3Rt3oJ6yeT/kK5Fder/CqexYGhYciP828bQBSjdGkR4iyugPtUfbk1sJAmQZx8KtLXqhXhFsLd3xcNhMpI1q1v/RYDBdhfBEQpTpeyFGM0RDV2Kr4Pk7IgNgGgvZj+trt35pPvEQxpjKNQP2AGejgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AJkeXIwh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AJkeXIwh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 486421F000FF;
	Wed, 23 Sep 2026 14:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173761;
	bh=CgrjqP0m7ofjFcOjmT+fjQbTfs7Eg5wdjf75unrO770=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AJkeXIwh0SZurlmupfeIjyKTCF2r2IHzo7jMCJkJsqEIxXbgCvIRru1UqIMI9qOT+
	 UBtFs2M7f3t//RL6VFto54x+9/Ql0W+oA89MKnjg2/MUt5mkZuomJxKn/l6WTGQYNy
	 jmR+uEU1LZ7gIHyLg5Po2rgmPNrhgbgZ2SiLDlxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 301/438] net/sched: act_api: release tail references on DELACTION failure
Date: Wed, 23 Sep 2026 16:05:22 +0200
Message-ID: <20260923140652.580768708@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

commit 6e05e46fa821a5c1b281355f1f622ac76cb6080a upstream.

A batched RTM_DELACTION request takes a temporary reference on each
action before attempting any deletion. tcf_action_delete() clears
each processed slot and drops its temporary reference before attempting
the deletion. If deletion fails, tca_action_gd() calls
tcf_action_put_many() to release the remaining references, but its
tcf_act_for_each_action() iterator stops at the first NULL slot.

When a batch stops at an action bound to a filter, this leaks a
reference on each subsequent action. A later delete of an unbound
action can then return success without removing it from the IDR.

Walk the full array in tcf_action_put_many() and skip NULL slots to
release the references held on the unprocessed actions.

Fixes: a0e947c9ccff ("net/sched: act_api: avoid non-contiguous action array")
Cc: stable@vger.kernel.org
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Link: https://patch.msgid.link/20260910093413.34509-2-xuanqiang.luo@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_api.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1218,11 +1218,16 @@ static int tcf_action_put(struct tc_acti
 
 static void tcf_action_put_many(struct tc_action *actions[])
 {
-	struct tc_action *a;
 	int i;
 
-	tcf_act_for_each_action(i, a, actions) {
-		const struct tc_action_ops *ops = a->ops;
+	/* Deletion may have cleared entries before failing. */
+	for (i = 0; i < TCA_ACT_MAX_PRIO; i++) {
+		struct tc_action *a = actions[i];
+		const struct tc_action_ops *ops;
+
+		if (!a)
+			continue;
+		ops = a->ops;
 		if (tcf_action_put(a))
 			module_put(ops->owner);
 	}


