Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9113803CD;
	Tue, 10 Mar 2026 11:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142127; cv=none; b=j4ZOj9ulj4knW1c9fwrvp4Zsmwm6gBwV+tdVW4WK1kqoG5JcgQ803DJshdvkKCJfQeOCOrHkIqGPbKsFEqQB8gqatFN/kD8YZkeXR8KcPjqQbYOl/pFxd9qTzlqQMRSrtfuFW/efjiJqt6ytvQ8+NazQ0W7P1tLdFq/PAQejR48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142127; c=relaxed/simple;
	bh=GEjIdMjyMqRi5Xs3Pc2FDXjQvtTA4FrDF2qYjuy3hbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNbwJIbaqtQdM49dlyLnhFJSos3jQa4+9k6n9FVEyK2FzHCYEwv1AP1y5vNJCQRpx21RLVSXThTWZiqU2CuGLONt4Ad4zn4+U/gvu6CTi5dxuY5hLKGM2jdm+efsFh2yqnYlluD+Blv+sNBOoBOZIjuawa7wCZzOstCxK3omMtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pP6iqbxq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pP6iqbxq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9689C19423;
	Tue, 10 Mar 2026 11:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142126;
	bh=GEjIdMjyMqRi5Xs3Pc2FDXjQvtTA4FrDF2qYjuy3hbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pP6iqbxq5tGQG4nn9qnbdd89b7+1VRJvmWb2ItGOkpVQEcnnZtj6ypEQl0m8ss3vg
	 z5UpwIgge9rR6hX53M/iJFNexPKoO42Y8NAWVKPGq2cG4w2lxUBmUQl3/69n6b4NRU
	 LDJjCrfEZDmakw1lyCVr/DDVcKqeHNVkMnlkM8j8MCWPFD9Yfwu8Aj7DpbykKk21vg
	 Vv9yl2JlW1C7FeFMCyj5TYHIa/PRCLBlj6zE80TthpViCHgF19rNtY/n/jlQi/fr2A
	 btrT1jc+3W6CItmAwca3GpL16SsbrfIpY3E9H099G5I9YA465s5Byl/SixMY2dwhel
	 9Hof2k6dwV9fQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Felix Gu <ustc.gu@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 215/314] pinctrl: meson: amlogic-a4: Fix device node reference leak in aml_dt_node_to_map_pinmux()
Date: Tue, 10 Mar 2026 07:17:54 -0400
Message-ID: <d6e8eba4c78b494750a7550001b20e2448e8d970.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
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

