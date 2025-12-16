Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A99032C936;
	Tue, 16 Dec 2025 12:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888536; cv=none; b=grTxnyrKDbaITVZ0EWH3caFSsBgVhmcvQ0Hn7184W+wnxexTjHHeebEkW/gz/xfEMtnYjnh5eaz3IJC9zLtmdHiMnES2ENebdwvK61gWQzc+xG+eRmP1VxFdhpYnBNqmidU229xgZ6wx46yvnTtNk5JqLb3FWiAvvRbGY0AwVFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888536; c=relaxed/simple;
	bh=o6d8raLnGjOW/uskW2hvnmQ+5Jobg2wMO35nW0YFK2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nAo7YaQMCRfr7nZMUnzpUPr5jwzB9ElG4beCuALDEAhRsuXoXh07yCMkPqqOjN3MQ2YB7w79k7Rr7tiePzrTJktHBu5N2jwuJMwzzHMk/0JYzLwmMbBMpJGplm+dYYlY1LUpZzmQ542FdI9YjV/Skm1RpX9vRcyicy+oBLsZDiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CVpDL5pD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CVpDL5pD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D69C4CEF1;
	Tue, 16 Dec 2025 12:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888535;
	bh=o6d8raLnGjOW/uskW2hvnmQ+5Jobg2wMO35nW0YFK2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CVpDL5pDJS09U9jAmNB5eM5nfxtuFOeSdjEoHaoTVMXxk4nNdKgx+QyRa0n5wjaTH
	 +0K4pLydytmE5ii9ciUsFhweo0YTpGlYWAemaQMRjv2JI67MWtB1GS6Mv/MPlocZhT
	 UBrR/u/RXmJaSt6eKFlqAh47e1WXk47lDUpT/j9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 530/614] pinctrl: single: Fix incorrect type for error return variable
Date: Tue, 16 Dec 2025 12:14:57 +0100
Message-ID: <20251216111420.580998589@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6d580aa282ec9..998f23d6c3179 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -485,7 +485,8 @@ static int pcs_pinconf_get(struct pinctrl_dev *pctldev,
 	struct pcs_device *pcs = pinctrl_dev_get_drvdata(pctldev);
 	struct pcs_function *func;
 	enum pin_config_param param;
-	unsigned offset = 0, data = 0, i, j, ret;
+	unsigned offset = 0, data = 0, i, j;
+	int ret;
 
 	ret = pcs_get_function(pctldev, pin, &func);
 	if (ret)
@@ -549,9 +550,9 @@ static int pcs_pinconf_set(struct pinctrl_dev *pctldev,
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



