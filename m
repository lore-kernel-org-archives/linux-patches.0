Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E6C28DC4;
	Wed, 20 May 2026 17:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296791; cv=none; b=uu39E8J7KJ8/VViXwPKoFZdibmlbPshLloE7ejyu9lt1LgU/VmZHIYRSEcSUG/yVeRcxFGhNq2ROBJoIF3O8lV6TaekLPI8RrjONgZihrqHrWScLcokuGWNv+XoIhqhaAeWBdLUupHp/ltVAUu5ht8glc0RnibL/c1xaL1ApRP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296791; c=relaxed/simple;
	bh=lox6GWvndpyX5rDqYowcsWpEGjOy3x/OA/zFeybwBhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=azASW0OFLMfRkv+FUUZscyc3QbtJa8ZgEJ6nShk100Vv6nd0PNDD6m+pvKjiPKuoP8W/d2mm74JixAHO2le6NKAm8Cpfwq4ldtmrVO+NlleUSqmOAB78q7ZP8xnFgaMbQHKgsv6o+oog+ZYGYUvLPwKs8B7AYndH/wDVP6DDwdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XIntqhG1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XIntqhG1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4533F1F000E9;
	Wed, 20 May 2026 17:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296790;
	bh=a/cWamvj85eI6Oy2fJXerlXve4W/q3J5cRl4kn956Ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XIntqhG1/wMsqz4dfW1nVheB0h/N6Htg89oFP/vFIkLAUiZTMxEIdTT21B/S3yEqI
	 0KHw6Oma8M5k72EZOQQEd6/VhiowOw/88A+98k8YNhMVPOBZDwQc081CYVVoG4k/fq
	 v7gNVkdj6iZ0mHQI98oYEAUaKdu+nySretGlu9eU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Hemminger <stephen@networkplumber.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0933/1146] net/sched: netem: check for negative latency and jitter
Date: Wed, 20 May 2026 18:19:43 +0200
Message-ID: <20260520162209.349797160@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 475c14b3dbdbf..bc18e1976b6e0 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -826,6 +826,16 @@ static int get_dist_table(struct disttable **tbl, const struct nlattr *attr)
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
@@ -1068,6 +1078,18 @@ static int netem_change(struct Qdisc *sch, struct nlattr *opt,
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



