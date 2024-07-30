Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F81D1A6169;
	Tue, 30 Jul 2024 16:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357001; cv=none; b=cy5Ka6OEkVaEPNjJyqe/0c8TEFuIbtaZhN0CTdfRH0E1Z7sXr+WT2+Dq1awYhaPXuRwfTe7iecTTOIth5StEABiFQGXiASPNikIm6BkfzeS//hy+YyQORlAp9gs5B5E+q9FzfrET/wmN9Qtc4AH1uUx6B5F+WOYxliymRBhoZUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357001; c=relaxed/simple;
	bh=IUVI1Empc8/zkiI21BhSU16Ff+RvpiH3UC+nkSRQSFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a2RRbQxJ7AMRj3HtfGT3WzXU0qSRLYDY5C/8/dWI1A/lQpP3igppioz5fTOE1iGvxk0KWGqnmIatWLEj5qVO96xEO636/HcUYGvJMeaCs3B44caWtXJqabPIlNAvfzAvzvNDir03HJ7h68uYumUPi4Eqmj3/9PKAWiwT4bMt4OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ISZYnQfE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ISZYnQfE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC6FC4AF0A;
	Tue, 30 Jul 2024 16:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357000;
	bh=IUVI1Empc8/zkiI21BhSU16Ff+RvpiH3UC+nkSRQSFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ISZYnQfEXvv1qRb+yu9Y0//YyootADsLcfmGq3kw5lCHbWdFf38s2XdSHNmML2zaz
	 lqQQTuApQ477usIWkNhnMFYfQYzaDb1dVD8PQfoIxsESJ68Vlj/KyDhGiydIXOdgOC
	 R+8PTBapwWz8qQLO8Cvr5L6luAkvy7CRWMjDNpac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 249/440] pinctrl: freescale: mxs: Fix refcount of child
Date: Tue, 30 Jul 2024 17:48:02 +0200
Message-ID: <20240730151625.575941541@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



