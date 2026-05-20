Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6583FF891;
	Wed, 20 May 2026 18:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302758; cv=none; b=Mh8LzKLSHKwlLEClZhSjjMGTGOefsfuimvsW5aaTWazYu4IsTtr9dYPmlsD4kziqiib2IuMj3u6ag64ek5f+whjl9k/NeFGZSPy+7D5NjOndFsOIApqjs7NX4JW49KFLLuwqu8hAGU46sgfYLmMZYQsE3GCqeQAHSQn4IB+S1Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302758; c=relaxed/simple;
	bh=cJd5xLO2wJzzae71NzmZFwQq0JZONLiAb9dyBXeg95Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EJfQIs0hiSMMPeE6c1lpIZ+tfDQtKjcpLVeUpINuwlbLiZ4bWyBYBNupgj93FXgVkSlXT17Ef+iuBkwQ9Y0be4Dk2mVZgD4OyLRnlLo7Aupr1JCWSTirEjCbdQRpULtgYgylNlNnH2SZUepcq3hLExthO4/94FnHQ1Qxn/BuDQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q8EYiFK9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q8EYiFK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300951F000E9;
	Wed, 20 May 2026 18:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302756;
	bh=HbgulPpWh70ybfRSWAYWTjlmMWLNlKXSAByE4tbeHWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q8EYiFK9BpqlWT102XEZFpdhu642WnI//5UeFxexD5erxKKBuUDarEs30f2/D0zqD
	 DA3cX4RaMy0dMVExYVNf1QNIevyKaz1Jr/XYC2EdooZeiBqrWpQoNZCiIEBwpMs+Dr
	 0i9OXk11ptlhJL6tJBs5SAEcwZEk1cb3r9DUNMh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Hemminger <stephen@networkplumber.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 386/508] net/sched: netem: check for negative latency and jitter
Date: Wed, 20 May 2026 18:23:29 +0200
Message-ID: <20260520162106.982298136@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Hemminger <stephen@networkplumber.org>

[ Upstream commit 90be9fedb218ee95a1cf59050d1306fbfb0e8b87 ]

Reject requests with negative latency or jitter.
A negative value added to current timestamp (u64) wraps
to an enormous time_to_send, disabling dequeue.
The original UAPI used u32 for these values; the conversion to 64-bit
time values via TCA_NETEM_LATENCY64 and TCA_NETEM_JITTER64
allowed signed values to reach the kernel without validation.

Jitter is already silently clamped by an abs() in netem_change();
that abs() can be removed in a follow-up once this rejection is in
place.

Fixes: 99803171ef04 ("netem: add uapi to express delay and jitter in nanoseconds")
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260418032027.900913-7-stephen@networkplumber.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_netem.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index b632e6678881a..f8c5c50618085 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -824,6 +824,16 @@ static int get_dist_table(struct disttable **tbl, const struct nlattr *attr)
 	return 0;
 }
 
+static int validate_time(const struct nlattr *attr, const char *name,
+			 struct netlink_ext_ack *extack)
+{
+	if (nla_get_s64(attr) < 0) {
+		NL_SET_ERR_MSG_ATTR_FMT(extack, attr, "negative %s", name);
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int validate_slot(const struct nlattr *attr, struct netlink_ext_ack *extack)
 {
 	const struct tc_netem_slot *c = nla_data(attr);
@@ -1066,6 +1076,18 @@ static int netem_change(struct Qdisc *sch, struct nlattr *opt,
 			goto table_free;
 	}
 
+	if (tb[TCA_NETEM_LATENCY64]) {
+		ret = validate_time(tb[TCA_NETEM_LATENCY64], "latency", extack);
+		if (ret)
+			goto table_free;
+	}
+
+	if (tb[TCA_NETEM_JITTER64]) {
+		ret = validate_time(tb[TCA_NETEM_JITTER64], "jitter", extack);
+		if (ret)
+			goto table_free;
+	}
+
 	sch_tree_lock(sch);
 	/* backup q->clg and q->loss_model */
 	old_clg = q->clg;
-- 
2.53.0



