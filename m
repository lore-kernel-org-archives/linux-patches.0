Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7D9352C4F;
	Tue, 10 Mar 2026 11:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141187; cv=none; b=YbjrB0sXGRIvzIEE/cPGNp6agmRt3KkuA527aqU/ukg4N3maWc4BGjFocRZmB1ieiL/J7JN7i3tRTDfLfDosCyF6aBwZyPhQ9bD2Q+78NZCmsfHimFPgiUMwdllP9BQyS/CdWA06WSXHnxwug0TNHinfybCSIS2TlglSeapedJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141187; c=relaxed/simple;
	bh=GEjIdMjyMqRi5Xs3Pc2FDXjQvtTA4FrDF2qYjuy3hbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R5ayTTJLfMjt5YGCZY09dkMOe5ZJf8phRcNq8uKyVahOd912PseIL68CyiuUUnQ1XUCc/z0Y23+3JhsDgDZxGMgIHZS/XzobYuuly398mMBvQ5xS3S/hGMsI/3+RjIEwdA2oJfsqouRE+z78KB4bYJ1P0/8fNlglhOffntxmU1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UGQmR8Wc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UGQmR8Wc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13CBCC2BCAF;
	Tue, 10 Mar 2026 11:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141187;
	bh=GEjIdMjyMqRi5Xs3Pc2FDXjQvtTA4FrDF2qYjuy3hbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UGQmR8Wcg5EJ6mf11+j6FxS0A+TaHx0fRr64btHRGTYxelI2HEPAs721Qimy6JaQ1
	 fiF06Ox6kHk71aZnP9RNVU15SBZ9Oihkb9njg00+FE9Uilq+OIxjGTQ/yylEgZ8HG4
	 u/qchAXRfLu8170S8ezYFKPAHqdOVizCA479X4ka0fKFFlRSZSE65yrZdvkTYsxtOY
	 m07WT01uuDRaUtGtfRYT2Z0pOWLmRwyfL0KLVJ018JQodu+Wta16Y08r4IXBVU204m
	 teTVNCl56PgBk1w/N3LCP5MO7PvM7FIhPHeGDVFanvGjEDcwXVOcky3csaVk2Quilt
	 Rsisi3jtZnYUQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Felix Gu <ustc.gu@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 189/311] pinctrl: meson: amlogic-a4: Fix device node reference leak in aml_dt_node_to_map_pinmux()
Date: Tue, 10 Mar 2026 07:03:56 -0400
Message-ID: <037307032190d89c8c6ae6a83710780e8c0ce8fe.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit a2539b92e4b791c1ba482930b5e51b1591975461 ]

The of_get_parent() function returns a device_node with an incremented
reference count.

Use the __free(device_node) cleanup attribute to ensure of_node_put()
is automatically called when pnode goes out of scope, fixing a
reference leak.

Fixes: 6e9be3abb78c ("pinctrl: Add driver support for Amlogic SoCs")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/meson/pinctrl-amlogic-a4.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/pinctrl/meson/pinctrl-amlogic-a4.c b/drivers/pinctrl/meson/pinctrl-amlogic-a4.c
index dfa32b11555cd..e2293a872dcb7 100644
--- a/drivers/pinctrl/meson/pinctrl-amlogic-a4.c
+++ b/drivers/pinctrl/meson/pinctrl-amlogic-a4.c
@@ -679,7 +679,6 @@ static int aml_dt_node_to_map_pinmux(struct pinctrl_dev *pctldev,
 				     unsigned int *num_maps)
 {
 	struct device *dev = pctldev->dev;
-	struct device_node *pnode;
 	unsigned long *configs = NULL;
 	unsigned int num_configs = 0;
 	struct property *prop;
@@ -693,7 +692,7 @@ static int aml_dt_node_to_map_pinmux(struct pinctrl_dev *pctldev,
 		return -ENOENT;
 	}
 
-	pnode = of_get_parent(np);
+	struct device_node *pnode __free(device_node) = of_get_parent(np);
 	if (!pnode) {
 		dev_info(dev, "Missing function node\n");
 		return -EINVAL;
-- 
2.51.0

