Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1965521CC5A;
	Thu, 15 Jan 2026 17:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497807; cv=none; b=dR7NP48T+4KdECUxXT1l6LXbRSYLSvj158q097qq1xNjL/JK3qSy6VS4gxp6BLuSTAL77xwJENVirCWKrKdw04IrQ/FlCA7scxwU4F+7n0iraSSryH5tzd1k6d31IHVbg8dJ2+LTmoGzYQz0+xJm5k8dsye3r0ooRoY2H7BKnXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497807; c=relaxed/simple;
	bh=d8umWh7rXCOyLALny245fjfgTDEcQPbe/lsmbh87VAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gcx83xqPrfxPNGOoxsWO+w/Zv5yhw9hN21hgOZ/bUJxQw0e+1XEFNbbh4bhAtTbTS5C+teLjdDSRCn1+X8C5yLOAZbodSmALIz77nxPtm61/Ejc0jm4lWOyUw1nPAy9B5UE7D4G6SiPo/4ri2JeRA1Mk1JzSMbXaszeCtc9dEfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A08FRxpg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A08FRxpg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC0CC116D0;
	Thu, 15 Jan 2026 17:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497807;
	bh=d8umWh7rXCOyLALny245fjfgTDEcQPbe/lsmbh87VAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A08FRxpgxyH3phZESZ5s8Os/wW1kAycfaiVGOxqz4MPb83Mvstq/MefNLFBBgZYyG
	 /MOBz22E/IdorB7rZtrcXmavHTNY4KxGxy5EbXuiemAdMBTYZUPSwbhfTSJi1UdOMJ
	 oUXZ+063RctLsPQOmSk64qsz5H78x/e3DoVE85Ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 167/554] pinctrl: single: Fix incorrect type for error return variable
Date: Thu, 15 Jan 2026 17:43:53 +0100
Message-ID: <20260115164252.313260910@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 61d1bb53547d42c6bdaec9da4496beb3a1a05264 ]

pcs_pinconf_get() and pcs_pinconf_set() declare ret as unsigned int,
but assign it the return values of pcs_get_function() that may return
negative error codes. This causes negative error codes to be
converted to large positive values.

Change ret from unsigned int to int in both functions.

Fixes: 9dddb4df90d1 ("pinctrl: single: support generic pinconf")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-single.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index b81297084f097..0659cd3aa3a5a 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -490,7 +490,8 @@ static int pcs_pinconf_get(struct pinctrl_dev *pctldev,
 	struct pcs_device *pcs = pinctrl_dev_get_drvdata(pctldev);
 	struct pcs_function *func;
 	enum pin_config_param param;
-	unsigned offset = 0, data = 0, i, j, ret;
+	unsigned offset = 0, data = 0, i, j;
+	int ret;
 
 	ret = pcs_get_function(pctldev, pin, &func);
 	if (ret)
@@ -554,9 +555,9 @@ static int pcs_pinconf_set(struct pinctrl_dev *pctldev,
 {
 	struct pcs_device *pcs = pinctrl_dev_get_drvdata(pctldev);
 	struct pcs_function *func;
-	unsigned offset = 0, shift = 0, i, data, ret;
+	unsigned offset = 0, shift = 0, i, data;
 	u32 arg;
-	int j;
+	int j, ret;
 	enum pin_config_param param;
 
 	ret = pcs_get_function(pctldev, pin, &func);
-- 
2.51.0



