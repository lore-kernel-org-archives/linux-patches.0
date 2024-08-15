Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFC8189BB5;
	Thu, 15 Aug 2024 13:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729636; cv=none; b=U4UhxH5Yft1j+1s2CzOh5C8c887DTJ0L5Lb9KUoufXZRwl/rV8H9+ii16p7A+L9VzNz37lwVvoEaej54fGxgLR6DkYVs4+KWpPkdLAYpytjoeKzhPREoXUNUOmEVUaiu++iMczNCwiNO3JL6fRwzgPklUvaYc1hWY8S7mwzld2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729636; c=relaxed/simple;
	bh=ko8Jk6FVEmmYkztUQn1hUKz+D8KNKvyNqt03NWDbYXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yh7xXSYr6afCzKEU3gSRe3bilv60vPiugesf3KrwrddxSSQNNBPOvdfcZ6ec3fVWgd465J8Wo0m/lWvnaUGJSxe0jbKuLyTIjSo9SVLCRaAPoTpaUkoJj7GcddDjsygDKxGyMwgcBTTrSSTXRXs97UUHVeJGqb1JqsJD25fHqNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sLCiWK/u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sLCiWK/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6191FC32786;
	Thu, 15 Aug 2024 13:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729635;
	bh=ko8Jk6FVEmmYkztUQn1hUKz+D8KNKvyNqt03NWDbYXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sLCiWK/ubJEcx5AWbSVYeJegGRPTs9hm+0bziHqvOrOGiuIQVtmtAY12pBa80SyXB
	 QXThDbrz4ymPNdmQNQMrpN8uefjB7ZSjMV5K9hIPxiyGMC+LYlweIVMIzCI9ppub1t
	 5dMsjmc9oHnO2Z8q7twvMl+Vz1VYnW/JmtxzqtBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 159/484] pinctrl: freescale: mxs: Fix refcount of child
Date: Thu, 15 Aug 2024 15:20:17 +0200
Message-ID: <20240815131947.554874840@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 7f500f2011c0bbb6e1cacab74b4c99222e60248e ]

of_get_next_child() will increase refcount of the returned node, need
use of_node_put() on it when done.

Per current implementation, 'child' will be override by
for_each_child_of_node(np, child), so use of_get_child_count to avoid
refcount leakage.

Fixes: 17723111e64f ("pinctrl: add pinctrl-mxs support")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/20240504-pinctrl-cleanup-v2-18-26c5f2dc1181@nxp.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/freescale/pinctrl-mxs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/freescale/pinctrl-mxs.c b/drivers/pinctrl/freescale/pinctrl-mxs.c
index 735cedd0958a2..5b0fcf15f2804 100644
--- a/drivers/pinctrl/freescale/pinctrl-mxs.c
+++ b/drivers/pinctrl/freescale/pinctrl-mxs.c
@@ -405,8 +405,8 @@ static int mxs_pinctrl_probe_dt(struct platform_device *pdev,
 	int ret;
 	u32 val;
 
-	child = of_get_next_child(np, NULL);
-	if (!child) {
+	val = of_get_child_count(np);
+	if (val == 0) {
 		dev_err(&pdev->dev, "no group is defined\n");
 		return -ENOENT;
 	}
-- 
2.43.0



