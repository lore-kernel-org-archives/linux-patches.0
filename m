Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1423AD52F;
	Wed, 23 Sep 2026 14:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174981; cv=none; b=UGBaWNIriMaQueBAmrhtf2qrTCA+hzfvnZ0kFkwHgG0pNE3ow3MSFE7MPfPseFFi4ExJY6eXna/wu2o68VuFJUOnQX6uaVET9H2R56/b/amHtVqGq9K8hl7Q9uTvpTA/V8/4c4iCsX53ujvF+4Rl2D4MW6FMXiQEtdTnoHi8DrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174981; c=relaxed/simple;
	bh=ujlEKUreonprsrUEuwBGZrPbWeZPLrto+VwhrLX3Aco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Is2r6oINFwOqeDAfRJ0Prw2yo14+Q3wYPZquR3gF+26sj7UPVGP3F2ZHWTP5L18ag7+AcVMwvBVrNzwCmaIlzo5Tmslh84c/aL+zOxP7Iu+i226gV7Ucshrp9GxAtA++rXWNftGNM4U1LBEJmJKdeZPJD9THHymrWHoaDBdITJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TMZe8K64; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TMZe8K64"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866CF1F000FF;
	Wed, 23 Sep 2026 14:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174980;
	bh=FRX4Mo66LabCBwYwQh7dxcROETHgG0wIFf8Q50FbNq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TMZe8K642AQqK5vQqeGXS/PjGPkEaLl+6jaipLfdZ2DOaHT/Ucsxzo104QVO5rzjA
	 Krs2Xv82IjeAsKTPrDW0bpTO9BB6PdL4V4XE4TXjORcfwlxE4eQ5GmLIelbeCBh3qW
	 dtmKnw/w6Fz2kkidgGwJKHmt40WNoG2EfkMIjtcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 249/398] net/sched: act_api: release tail references on DELACTION failure
Date: Wed, 23 Sep 2026 16:05:23 +0200
Message-ID: <20260923140649.864989422@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


