Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56573449EC3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301147; cv=none; b=O38UfuiaHu3u70jvs3qvU+XDi58KQrGsCoXk2zRz94RDqMNZ+R6mUScm3UM7P98a+USy9IfbK4cPd828WcDK+9aFCSUXQcrsjZFtKsnvfQFzfltvPg6ir+g42PijqSlBwWTqtTyZTDHt+kP3YV/3P/zF5jMdSjRs2QF5KLlqmOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301147; c=relaxed/simple;
	bh=uW56MnovVLGyj+VpJYRd1VPR9qW7GYoiXEzkcRo/UKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHTIvHs13iijLp3y8j+TdohtAd3FQANjCugouN6A+zpqdmWwdDLeoVZA73WXDJoYflXrMrVYeVm2TqjL2h5UQqFLeX55Z+CanF8Jer+ipNLylNTJDXCrMbVf3+/H6Z0NxJpC4qldXqLu0QobV+tSUqdF8BYPixW5Y9yuwiCZuY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A0DbCpS0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A0DbCpS0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DA6C19423;
	Sat, 28 Feb 2026 17:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301147;
	bh=uW56MnovVLGyj+VpJYRd1VPR9qW7GYoiXEzkcRo/UKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A0DbCpS0VzHbK3Df4XYzW1mCA9KKPi41hwoC23lVcfHENR964UR6G15lDxjP4/HJr
	 vcB/GfnFwUXrMMbHBOvR492vidyP5QaBAYMnXt/sd1e0jD4oWrA7bMDH/+sYvUAaoF
	 YTpKR2Mvc53HjRCgOVTDWbxmuAc8mE5nQCbzWppCRgF/V46CB6/1Od1wz+kwNfKMLp
	 NHQQlUHnvdMbGkavmyXfzkhn2RSuib6OS1SzT254E90HOhTjiLFaWnAoZhUP+jo7tR
	 UmTh0L+A6groXDO/HXDjFe/itgxadD3EOiKA+XP8TQTjt9/lzTjVOiRX+6IxukXliV
	 OMkPrAQ2j19Rg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Iuliana Prodan <iuliana.prodan@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 309/752] remoteproc: imx_dsp_rproc: Skip RP_MBOX_SUSPEND_SYSTEM when mailbox TX channel is uninitialized
Date: Sat, 28 Feb 2026 12:40:20 -0500
Message-ID: <20260228174750.1542406-309-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Iuliana Prodan <iuliana.prodan@nxp.com>

[ Upstream commit d62e0e92e589c53c4320ed5914af5fe103f5ce7e ]

Firmwares that do not use mailbox communication (e.g., the hello_world
sample) leave priv->tx_ch as NULL. The current suspend logic
unconditionally sends RP_MBOX_SUSPEND_SYSTEM, which is invalid without
an initialized TX channel.

Detect the no_mailboxes case early and skip sending the suspend
message. Instead, proceed directly to the runtime PM suspend path,
which is the correct behavior for firmwares that cannot respond to
mailbox requests.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Link: https://lore.kernel.org/r/20251204122825.756106-1-iuliana.prodan@oss.nxp.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/imx_dsp_rproc.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/remoteproc/imx_dsp_rproc.c b/drivers/remoteproc/imx_dsp_rproc.c
index e61a08df113e4..c0c2bda4964a7 100644
--- a/drivers/remoteproc/imx_dsp_rproc.c
+++ b/drivers/remoteproc/imx_dsp_rproc.c
@@ -1303,6 +1303,15 @@ static int imx_dsp_suspend(struct device *dev)
 	if (rproc->state != RPROC_RUNNING)
 		goto out;
 
+	/*
+	 * No channel available for sending messages;
+	 * indicates no mailboxes present, so trigger PM runtime suspend
+	 */
+	if (!priv->tx_ch) {
+		dev_dbg(dev, "No initialized mbox tx channel, suspend directly.\n");
+		goto out;
+	}
+
 	reinit_completion(&priv->pm_comp);
 
 	/* Tell DSP that suspend is happening */
-- 
2.51.0

