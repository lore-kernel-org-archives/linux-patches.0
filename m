Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269442FF17B;
	Tue, 12 Aug 2025 18:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022473; cv=none; b=ILZI7vp3ofmoWTn0kV0BGpoKhbBm8mkzBxyZnNW5TAAwjnn1CWgwodoXfDwL8UMKXUdRFB8a68dRduXqduRd5KUQ2Mf6P/PCKKe9HaozbF84y7E0ao4Sjdas4UfVvJ9qDNKzeeqv0vatgL9w6s+QK+AC9JyCxZlhe8khXEV/GOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022473; c=relaxed/simple;
	bh=Q6qV85uo+04zpwjM7s4tCk8jhGnd6io7ZW4QrotE+FU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HpcYi9e7N3PYxP1WWIIAIEibXW+AUdbahtK5KcfT6YQLe7DucSJQChPe4l7cTz3Gxt732wU3Ot8Mcv/HTJcrM/3fkLDXgY9yrBK7dm2hN3pyRwugXgXq9uPRc9ZhHf8R9m3gYwKqZ7UoHVhLXoCuGQTTB+oCgSP6WHl9BrnHx3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sYaUaLrf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sYaUaLrf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7E1C4CEF6;
	Tue, 12 Aug 2025 18:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022473;
	bh=Q6qV85uo+04zpwjM7s4tCk8jhGnd6io7ZW4QrotE+FU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sYaUaLrfrGEiJBEnFDqjlLIwaQEwoPdVd+CiLuV0mLWi9sNh4V6mQYtCEYxeaXcGj
	 k9pMEQQ7UDQpw8zxvMlE5O43e/k8DhtOvVN4WEisR2UxMpP9Lx715UKDuykFWJBN5o
	 ZGT6oM7iCpAvrZisYiO/+BNx7o0n7mFzpGssCcB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 165/369] power: supply: max14577: Handle NULL pdata when CONFIG_OF is not set
Date: Tue, 12 Aug 2025 19:27:42 +0200
Message-ID: <20250812173020.981352478@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Han <hanchunchao@inspur.com>

[ Upstream commit 2937f5d2e24eefef8cb126244caec7fe3307f724 ]

When the kernel is not configured  CONFIG_OF, the max14577_charger_dt_init
function returns NULL. Fix the max14577_charger_probe functionby returning
-ENODATA instead of potentially passing a NULL pointer to PTR_ERR.

This fixes the below smatch warning:
max14577_charger_probe() warn: passing zero to 'PTR_ERR'

Fixes: e30110e9c96f ("charger: max14577: Configure battery-dependent settings from DTS and sysfs")
Signed-off-by: Charles Han <hanchunchao@inspur.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250519061601.8755-1-hanchunchao@inspur.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/max14577_charger.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/max14577_charger.c b/drivers/power/supply/max14577_charger.c
index b28c04157709..90d40b35256f 100644
--- a/drivers/power/supply/max14577_charger.c
+++ b/drivers/power/supply/max14577_charger.c
@@ -501,7 +501,7 @@ static struct max14577_charger_platform_data *max14577_charger_dt_init(
 static struct max14577_charger_platform_data *max14577_charger_dt_init(
 		struct platform_device *pdev)
 {
-	return NULL;
+	return ERR_PTR(-ENODATA);
 }
 #endif /* CONFIG_OF */
 
@@ -572,7 +572,7 @@ static int max14577_charger_probe(struct platform_device *pdev)
 	chg->max14577 = max14577;
 
 	chg->pdata = max14577_charger_dt_init(pdev);
-	if (IS_ERR_OR_NULL(chg->pdata))
+	if (IS_ERR(chg->pdata))
 		return PTR_ERR(chg->pdata);
 
 	ret = max14577_charger_reg_init(chg);
-- 
2.39.5



