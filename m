Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173481474B9;
	Thu, 11 Apr 2024 10:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831692; cv=none; b=Ogf0PEDTrPl8/4m8MlVG+bzdOqRnMVVGOuilFTILFf8Zj2Wb7Yx4iECEfSotxkshDab5AZJTXb/w41C27kfRfkvpOmWopbPIYa22rXdvFB0vDAupHvI0zbBOAY8k9nxhq5IIjPKC9XB0PkUds5+OcIbOEHMxvXlxNqi1/Vs76Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831692; c=relaxed/simple;
	bh=J+iJg8JtfirQYsQqqRGX5njokJyBdCflLhWXRDDJ1f4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fj+GU/i0FOa6Jlbtt2o6wEtmN+xGIJbiarL4zuA57omtqZiIxIdSjELb8d8a9T8bImLDaZ0/zrwvv244WmU8CJKKiAmUM39FGi4ZHlwjtVMKsKMBNeT0ML9mAgNMWV7OGCkzMk2qc++dY+qH39aylFRv0kDTk3Se9DNm2leCojM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xYQo4UHR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xYQo4UHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89017C433C7;
	Thu, 11 Apr 2024 10:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831691;
	bh=J+iJg8JtfirQYsQqqRGX5njokJyBdCflLhWXRDDJ1f4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xYQo4UHRK1uii0nQaoGiGT8qk+cQiOXoxP8rNE/gXmuRyS/d4is+MaKjE/SBABlTc
	 mbZazkqP8WvsrNf6xNHPWI3MlTtqrCdg1n/T4rq6l3MxoLacvHciQZ51KjlS/L+rry
	 2YwWz8xntAuLKgLZK9RyP4IAYQQwSw+1pGW8yHa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@seco.com>,
	Camelia Groza <camelia.groza@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 093/294] soc: fsl: qbman: Add CGR update function
Date: Thu, 11 Apr 2024 11:54:16 +0200
Message-ID: <20240411095438.477421659@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Sean Anderson <sean.anderson@seco.com>

[ Upstream commit 914f8b228ede709274b8c80514b352248ec9da00 ]

This adds a function to update a CGR with new parameters. qman_create_cgr
can almost be used for this (with flags=0), but it's not suitable because
it also registers the callback function. The _safe variant was modeled off
of qman_cgr_delete_safe. However, we handle multiple arguments and a return
value.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: fbec4e7fed89 ("soc: fsl: qbman: Use raw spinlock for cgr_lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/fsl/qbman/qman.c | 48 ++++++++++++++++++++++++++++++++++++
 include/soc/fsl/qman.h       |  9 +++++++
 2 files changed, 57 insertions(+)

diff --git a/drivers/soc/fsl/qbman/qman.c b/drivers/soc/fsl/qbman/qman.c
index d581576c9a861..3346593e0bc62 100644
--- a/drivers/soc/fsl/qbman/qman.c
+++ b/drivers/soc/fsl/qbman/qman.c
@@ -2568,6 +2568,54 @@ void qman_delete_cgr_safe(struct qman_cgr *cgr)
 }
 EXPORT_SYMBOL(qman_delete_cgr_safe);
 
+static int qman_update_cgr(struct qman_cgr *cgr, struct qm_mcc_initcgr *opts)
+{
+	int ret;
+	unsigned long irqflags;
+	struct qman_portal *p = qman_cgr_get_affine_portal(cgr);
+
+	if (!p)
+		return -EINVAL;
+
+	spin_lock_irqsave(&p->cgr_lock, irqflags);
+	ret = qm_modify_cgr(cgr, 0, opts);
+	spin_unlock_irqrestore(&p->cgr_lock, irqflags);
+	put_affine_portal();
+	return ret;
+}
+
+struct update_cgr_params {
+	struct qman_cgr *cgr;
+	struct qm_mcc_initcgr *opts;
+	int ret;
+};
+
+static void qman_update_cgr_smp_call(void *p)
+{
+	struct update_cgr_params *params = p;
+
+	params->ret = qman_update_cgr(params->cgr, params->opts);
+}
+
+int qman_update_cgr_safe(struct qman_cgr *cgr, struct qm_mcc_initcgr *opts)
+{
+	struct update_cgr_params params = {
+		.cgr = cgr,
+		.opts = opts,
+	};
+
+	preempt_disable();
+	if (qman_cgr_cpus[cgr->cgrid] != smp_processor_id())
+		smp_call_function_single(qman_cgr_cpus[cgr->cgrid],
+					 qman_update_cgr_smp_call, &params,
+					 true);
+	else
+		params.ret = qman_update_cgr(cgr, opts);
+	preempt_enable();
+	return params.ret;
+}
+EXPORT_SYMBOL(qman_update_cgr_safe);
+
 /* Cleanup FQs */
 
 static int _qm_mr_consume_and_match_verb(struct qm_portal *p, int v)
diff --git a/include/soc/fsl/qman.h b/include/soc/fsl/qman.h
index 9f484113cfda7..3cecbfdb0f8c2 100644
--- a/include/soc/fsl/qman.h
+++ b/include/soc/fsl/qman.h
@@ -1170,6 +1170,15 @@ int qman_delete_cgr(struct qman_cgr *cgr);
  */
 void qman_delete_cgr_safe(struct qman_cgr *cgr);
 
+/**
+ * qman_update_cgr_safe - Modifies a congestion group object from any CPU
+ * @cgr: the 'cgr' object to modify
+ * @opts: state of the CGR settings
+ *
+ * This will select the proper CPU and modify the CGR settings.
+ */
+int qman_update_cgr_safe(struct qman_cgr *cgr, struct qm_mcc_initcgr *opts);
+
 /**
  * qman_query_cgr_congested - Queries CGR's congestion status
  * @cgr: the 'cgr' object to query
-- 
2.43.0



