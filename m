Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653EA3CEB9E;
	Thu, 17 Sep 2026 18:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671103; cv=none; b=b3RR0fzb4aX4GkYtD4Rs3HUZT8kw6zeTKHaw9lX0W6/Fm+l/zozEriKxojBGOZQ3D296xmA8WRcEakF0j67thXGPO247Vti+7FFW675eKzakglYAouRCx8+WX9wO76mQ6VHVQadyaP3T7kxkEXuoTSX4JpomfUZEx9IgReK7Qkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671103; c=relaxed/simple;
	bh=VM3UjkkGT7pcnVu7/cBdfyxUyjVB2sZ9XTuQfviciYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V1pFFN2h/RNWzWtx/hdosOYnCpQy/GukHVgr28Rr8+Wc3t9f6r4KiZ4g9msmGPKlejmhgqkQKkO/r7JqcF33WbIYll+jkoDfwe5n01EV0J6jMoupFYddE+7QiUqcNF45vID23T2vvRBgHUGpB6DY5BYRDkZQ35zB0JF1FDd/Vn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aWVd+BiQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aWVd+BiQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2731F00898;
	Thu, 17 Sep 2026 18:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671102;
	bh=0cMcxMWMgvLjuE+nDPtjrEndn89tWmdbbNf1nmHwgd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aWVd+BiQtwadAngm3mQwT2BS+HXxAHvavVgreCR0RORobRDdPlTwPS09v6cfu5mY3
	 QptYSFpCtVe/viROYA1eaQ0lDotQvU/tI5k0hK6skEFLf3uZmcZgLm6HtBwL1wFBFL
	 QUAiwtHxfHgTA0RX8eFALcPSZMWQKkfHPItM/RxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 0841/1102] net/sched: act_api: release all action references on NEWACTION failure
Date: Thu, 17 Sep 2026 16:13:04 +0100
Message-ID: <20260917151601.634891320@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

commit 478eb5abb51931a152abab068f8a717b7ff480fd upstream.

When a batched RTM_NEWACTION request replaces an existing action,
tcf_idr_check_alloc() takes a temporary reference on it. If a later
action fails to initialize, tcf_action_destroy() uses strict release
semantics to clean up the actions initialized so far. For an action
bound to a filter, the strict check returns -EPERM without dropping
the temporary reference.

This error also makes tcf_action_destroy() return before releasing
subsequent entries. Any new action initialized between the bound
action and the failing entry is leaked together with its reserved
IDR slot, preventing reuse of its index.

Use tcf_idr_release() to drop each reference held by the batch without
rejecting bound actions. This allows cleanup to continue through all
initialized entries and preserves the module reference release when
an action is destroyed. Explicit action deletion and flushing retain
their separate bind-count checks.

Fixes: 55334a5db5cd ("net_sched: act: refuse to remove bound action outside")
Cc: stable@vger.kernel.org
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260909070336.32979-2-xuanqiang.luo@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_api.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1147,18 +1147,13 @@ EXPORT_SYMBOL(tcf_action_exec);
 
 int tcf_action_destroy(struct tc_action *actions[], int bind)
 {
-	const struct tc_action_ops *ops;
 	struct tc_action *a;
 	int ret = 0, i;
 
 	tcf_act_for_each_action(i, a, actions) {
 		actions[i] = NULL;
-		ops = a->ops;
-		ret = __tcf_idr_release(a, bind, true);
-		if (ret == ACT_P_DELETED)
-			module_put(ops->owner);
-		else if (ret < 0)
-			return ret;
+		/* Drop our reference even if the action is still bound to a filter. */
+		ret = tcf_idr_release(a, bind);
 	}
 	return ret;
 }


