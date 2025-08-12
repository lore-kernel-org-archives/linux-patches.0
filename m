Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF3F2AE90;
	Tue, 12 Aug 2025 19:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026108; cv=none; b=XRclB8STHVaaOXECJPBw8lvkUXhB2dAX9fY4lZ4ymVvK1/VE9KzVQighbWhZQcAfqrPZq+cWkUA+Nz8jIxChK5GFvOIeVLv44bEkJL8m+IqqFvry4bCZtBZMnv3WRrYg8e2WT1hWFFP3BZLes3LM2KKzX0j+x0CDJm2trz8yEjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026108; c=relaxed/simple;
	bh=bLCXgTksg++npbVkObDU7dM+3fgUaI0HGonIbo8ZtkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DO8WsMDwZd6MbC7gNmFA1Qa456QY0TYWSzQ7D6VSIY+ZyOX1CdTM9AjqC2/pZyAqnjiYzDW201wKlfV0Cjp9FVBl0hW09IGKBMghO93kCKA84J7/LDU93ztzqii6y+yjwF1juIsw1Sewfv032rm4T61I18WcRJXIsBQZvOzCmxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LXdmWMtm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LXdmWMtm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D21CC4CEF0;
	Tue, 12 Aug 2025 19:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026108;
	bh=bLCXgTksg++npbVkObDU7dM+3fgUaI0HGonIbo8ZtkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LXdmWMtmHZw73MYispLtZ4lVjPSP6czo2VWMPMV3SLaFlNjwGoZJOe3oJbsUutRno
	 ni/2JWMWU8h1/4+d2NvvSwG3hg4Ley4e4WeDf5eoDhzBXBgUn8pFY91g1ocNuV0Bxq
	 sHL+aCpz0R7ye/RJynke2uQ1HzatFYo6aAIIjjwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Casey Connolly <casey.connolly@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 239/480] power: supply: qcom_pmi8998_charger: fix wakeirq
Date: Tue, 12 Aug 2025 19:47:27 +0200
Message-ID: <20250812174407.313017435@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Casey Connolly <casey.connolly@linaro.org>

[ Upstream commit 6c5393771c50fac30f08dfb6d2f65f4f2cfeb8c7 ]

Unloading and reloading the driver (e.g. when built as a module)
currently leads to errors trying to enable wake IRQ since it's already
enabled.

Use devm to manage this for us so it correctly gets disabled when
removing the driver.

Additionally, call device_init_wakeup() so that charger attach/remove
will trigger a wakeup by default.

Fixes: 8648aeb5d7b7 ("power: supply: add Qualcomm PMI8998 SMB2 Charger driver")
Signed-off-by: Casey Connolly <casey.connolly@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250619-smb2-smb5-support-v1-3-ac5dec51b6e1@linaro.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/qcom_pmi8998_charger.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/qcom_pmi8998_charger.c b/drivers/power/supply/qcom_pmi8998_charger.c
index 74a8d8ed8d9f..8b641b822f52 100644
--- a/drivers/power/supply/qcom_pmi8998_charger.c
+++ b/drivers/power/supply/qcom_pmi8998_charger.c
@@ -1016,7 +1016,9 @@ static int smb2_probe(struct platform_device *pdev)
 	if (rc < 0)
 		return rc;
 
-	rc = dev_pm_set_wake_irq(chip->dev, chip->cable_irq);
+	devm_device_init_wakeup(chip->dev);
+
+	rc = devm_pm_set_wake_irq(chip->dev, chip->cable_irq);
 	if (rc < 0)
 		return dev_err_probe(chip->dev, rc, "Couldn't set wake irq\n");
 
-- 
2.39.5



