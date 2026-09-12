Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D88A38F92F;
	Sat, 12 Sep 2026 19:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243056; cv=none; b=VLO5warNlC7F6/bdCmkfENRAsl9unTO3ylsDsdXgCJbi0pAYLSmHEps2biulwk1VY5C8c5av4m8IFlOgO5RWxQpsh8fo17ys3XRJcPA34I4Tny2gy9xbsvRpelvQ2zl3e8+FrIE5FNXmb4ZFuWfel2eMpOsh4ahY/6SsHJ3f2Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243056; c=relaxed/simple;
	bh=P7p8HG10l519GE73My9KJsVgd7xoddN5bimpnRi4FJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emKliJWAFzqIkgcb/1+Oag/vFelpV7wS6svpM5ZugmSWwmAtb2OeUv3l2/sJ12CWl+nRO3KN8dcpMB3QLVpOfQXUpVZzrS4KaS72fA9wiWBKcNlcWp8rdWFRTw25RSHp8qgbsRpzdxg6rStCZy45Za8iWr6YB4tON7NluO/Uf48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dB+NMMP5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dB+NMMP5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC801F000FF;
	Sat, 12 Sep 2026 19:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243055;
	bh=vX3tFi/ek5finaFqfU54IzZn8zqORKP0RnOLL3nTwGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dB+NMMP5u+f8xSW0dtkoLQbnyMIyLB5ArIf58E9R7hwEjFV5FTrLEplCsfdlYyip0
	 8NzA+Sm861sF6BrE7RM+lj1QzJVDLKxb/nEZNLUpWl2PNZRK2+9e3Hj0D8ybgbBNzP
	 VN0QgilZXPA28noJcr7ZIP5G2tQzVqei61MUEA+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Peng Fan <peng.fan@nxp.com>,
	Arnaud Pouliquen <arnaud.pouliquen@st.com>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 604/798] remoteproc: Introduce function __rproc_detach()
Date: Sat, 12 Sep 2026 09:03:52 +0200
Message-ID: <20260912065530.969644384@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

From: Mathieu Poirier <mathieu.poirier@linaro.org>

[ Upstream commit 6070203fe43335a02b7fd103bae582095411adc5 ]

Introduce function __rproc_detach() to perform the same kind of
operation as rproc_stop(), but instead of switching off the
remote processor using rproc->ops->stop(), it uses
rproc->ops->detach().  That way it is possible for the core
to release the resources associated with a remote processor while
the latter is kept operating.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Arnaud Pouliquen <arnaud.pouliquen@st.com>
Link: https://lore.kernel.org/r/20210312162453.1234145-10-mathieu.poirier@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Stable-dep-of: bb840ea69347 ("remoteproc: fix OOB read via signed offset in rsc_table_for_each_entry()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/remoteproc_core.c | 30 ++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 3b12d438ae514..e73f6eb3279d3 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1710,6 +1710,36 @@ static int rproc_stop(struct rproc *rproc, bool crashed)
 	return 0;
 }
 
+/*
+ * __rproc_detach(): Does the opposite of __rproc_attach()
+ */
+static int __maybe_unused __rproc_detach(struct rproc *rproc)
+{
+	struct device *dev = &rproc->dev;
+	int ret;
+
+	/* No need to continue if a detach() operation has not been provided */
+	if (!rproc->ops->detach)
+		return -EINVAL;
+
+	/* Stop any subdevices for the remote processor */
+	rproc_stop_subdevices(rproc, false);
+
+	/* Tell the remote processor the core isn't available anymore */
+	ret = rproc->ops->detach(rproc);
+	if (ret) {
+		dev_err(dev, "can't detach from rproc: %d\n", ret);
+		return ret;
+	}
+
+	rproc_unprepare_subdevices(rproc);
+
+	rproc->state = RPROC_DETACHED;
+
+	dev_info(dev, "detached remote processor %s\n", rproc->name);
+
+	return 0;
+}
 
 /**
  * rproc_trigger_recovery() - recover a remoteproc
-- 
2.53.0



