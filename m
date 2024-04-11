Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150A813E897;
	Thu, 11 Apr 2024 10:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830653; cv=none; b=HgDxliL38Nf43+wocobT7NM0lIltv1Lm4C+aq5+9FjAYZnQq2pYcpsLYQc29vBsU+ripvgpH7LN6WPQsrhTqqgb1YORTUEGwahZI1mi3VsOwYrHpALRUVYZBz16TRWtkxzFpemC+Br6MNuWKnfWAIQTmENT5/YlpOUJC/bpfCMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830653; c=relaxed/simple;
	bh=itagJ48jM26u6sdaKymkIdmUMll1s4uBBumzZxcEc/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=olIVc7qn2AMFk7BvSSm1SdMT7kt4lz5UWXB/vNUvWUS4HKKxFkSKiESfd0cYEWWhSpBaqK4kS+TAkDZ6vXL0Zxlx8Hpt1W7BsX/xoDjsIxVr3uYDluTBkou6OP0K5HHZfHEIOBl7Sr6HSaFJEsRe1iTOdKEKpRECEjiICcnDq7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZBbItpV0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZBbItpV0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84CD3C433F1;
	Thu, 11 Apr 2024 10:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830652;
	bh=itagJ48jM26u6sdaKymkIdmUMll1s4uBBumzZxcEc/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZBbItpV0oqM8r74mitlT4OAevZcNm/wvDzh9poc2XlQ0SBMFTF7Qn1hDG+ezqfpaK
	 LDwmqzZU7F6TOO2XbYnGeLm0PwdPNMZwa39RqtVyNelUY557zu6M8cjbAAFK/CR004
	 /fMojjvxZKy3bhq4WUugrSf1px3kLCgPwl5rbruw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@seco.com>,
	Camelia Groza <camelia.groza@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 065/215] soc: fsl: qbman: Add helper for sanity checking cgr ops
Date: Thu, 11 Apr 2024 11:54:34 +0200
Message-ID: <20240411095426.851569781@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Anderson <sean.anderson@seco.com>

[ Upstream commit d0e17a4653cebc2c8a20251c837dd1fcec5014d9 ]

This breaks out/combines get_affine_portal and the cgr sanity check in
preparation for the next commit. No functional change intended.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: fbec4e7fed89 ("soc: fsl: qbman: Use raw spinlock for cgr_lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/fsl/qbman/qman.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/soc/fsl/qbman/qman.c b/drivers/soc/fsl/qbman/qman.c
index 53b4cd0fb662d..e31d33d000526 100644
--- a/drivers/soc/fsl/qbman/qman.c
+++ b/drivers/soc/fsl/qbman/qman.c
@@ -2481,13 +2481,8 @@ int qman_create_cgr(struct qman_cgr *cgr, u32 flags,
 }
 EXPORT_SYMBOL(qman_create_cgr);
 
-int qman_delete_cgr(struct qman_cgr *cgr)
+static struct qman_portal *qman_cgr_get_affine_portal(struct qman_cgr *cgr)
 {
-	unsigned long irqflags;
-	struct qm_mcr_querycgr cgr_state;
-	struct qm_mcc_initcgr local_opts;
-	int ret = 0;
-	struct qman_cgr *i;
 	struct qman_portal *p = get_affine_portal();
 
 	if (cgr->chan != p->config->channel) {
@@ -2495,10 +2490,25 @@ int qman_delete_cgr(struct qman_cgr *cgr)
 		dev_err(p->config->dev, "CGR not owned by current portal");
 		dev_dbg(p->config->dev, " create 0x%x, delete 0x%x\n",
 			cgr->chan, p->config->channel);
-
-		ret = -EINVAL;
-		goto put_portal;
+		put_affine_portal();
+		return NULL;
 	}
+
+	return p;
+}
+
+int qman_delete_cgr(struct qman_cgr *cgr)
+{
+	unsigned long irqflags;
+	struct qm_mcr_querycgr cgr_state;
+	struct qm_mcc_initcgr local_opts;
+	int ret = 0;
+	struct qman_cgr *i;
+	struct qman_portal *p = qman_cgr_get_affine_portal(cgr);
+
+	if (!p)
+		return -EINVAL;
+
 	memset(&local_opts, 0, sizeof(struct qm_mcc_initcgr));
 	spin_lock_irqsave(&p->cgr_lock, irqflags);
 	list_del(&cgr->node);
@@ -2526,7 +2536,6 @@ int qman_delete_cgr(struct qman_cgr *cgr)
 		list_add(&cgr->node, &p->cgr_cbs);
 release_lock:
 	spin_unlock_irqrestore(&p->cgr_lock, irqflags);
-put_portal:
 	put_affine_portal();
 	return ret;
 }
-- 
2.43.0



