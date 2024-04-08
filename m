Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A4B7C0BE;
	Mon,  8 Apr 2024 13:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581911; cv=none; b=bvRuNWpyA1AeZ9NQhZInGaxXaoygXd4PkdcXDEKQz+OR7Ai9xOxFdFdClhaIEtIVvBz/33mlRX2gTg/mUcIcksZFGP2tnaFoFqiipzcWaeOHOWlbVY/jjlQuBldl9TZ0CVB5GquQMTBy0/7Ouw8sEaOI8+Yd61azvf56TzwjICU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581911; c=relaxed/simple;
	bh=tuOR5SQ9g449ztumhmWG6pSOmpRhj6ITDBabF0m+x3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TO9ZSdNYC9FPi42rLD+koVEgR7wYGZqMcaAkP+xUoFqdcq87A74x8pL2AAF5h2QbP0mmacnsRCtSvdiT9i+6ktKlpbX4vCqYlnqMQnx3KNodXukxZenPTEEu7v+WCVVFpL5mNZZUomaYSB2lfyS/GNhjjnDizgUtJxBQvkB72cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BsCp8oSZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BsCp8oSZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 970ADC433F1;
	Mon,  8 Apr 2024 13:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581911;
	bh=tuOR5SQ9g449ztumhmWG6pSOmpRhj6ITDBabF0m+x3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BsCp8oSZ8o5qSdDZw+ln3dEmdjBzqafquU4GWxfxcgdKnd/rZ2J8ATRwcwLXMH5Ce
	 66QMs2dyHVcvEd/XgkmWhOJ00jRVChitAdnqUEo7Xkjd/P2/0fXC6ipVGNySIiZIow
	 8GS1SPwdhzqRWX00gi6tWI/9aFusf+lIPLN52xnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@seco.com>,
	Camelia Groza <camelia.groza@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 092/690] soc: fsl: qbman: Add helper for sanity checking cgr ops
Date: Mon,  8 Apr 2024 14:49:18 +0200
Message-ID: <20240408125402.818185715@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d04a1a39dc286..30c6c09d9d00c 100644
--- a/drivers/soc/fsl/qbman/qman.c
+++ b/drivers/soc/fsl/qbman/qman.c
@@ -2483,13 +2483,8 @@ int qman_create_cgr(struct qman_cgr *cgr, u32 flags,
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
@@ -2497,10 +2492,25 @@ int qman_delete_cgr(struct qman_cgr *cgr)
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
@@ -2528,7 +2538,6 @@ int qman_delete_cgr(struct qman_cgr *cgr)
 		list_add(&cgr->node, &p->cgr_cbs);
 release_lock:
 	spin_unlock_irqrestore(&p->cgr_lock, irqflags);
-put_portal:
 	put_affine_portal();
 	return ret;
 }
-- 
2.43.0



