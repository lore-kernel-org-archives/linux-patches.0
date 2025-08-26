Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFF81E521E;
	Tue, 26 Aug 2025 12:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212835; cv=none; b=acGeaV+CNY2WlzT3smC53ROClL4F14Q7uobHGal1jlo0NTDY4ON+y4kxw6xm+RaHmo5ZoPFNR7axdMPhMZFzd0Y9LngkVQUj2XYPQY9YWOGb9bXk/4NamK+ijwDEG8IPEWdzgAFjmLMB/wwMoqTHGDkel/xAYt1VsYuMIErqtRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212835; c=relaxed/simple;
	bh=rfmjw3Cvn3Ojq1mjp6u3jQAgqiBh/YbVpAubO8SfD4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KPyfsLAHLYlNr6vv2sYBlcemGBfnIiF1JzE1Kc00qMCEv3pIFSgTdtzBY74eE6R25OtAtwd3V2OhOIs3rY0nNpblN5ExHojFJr0gKdzpvv//PHxIK8um3JvUOtZtuk/EQRCPM3fnQse6Ufct16xf45psypgJLMEhcJUkBMDsovg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DZqZCmBA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DZqZCmBA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D36C4CEF1;
	Tue, 26 Aug 2025 12:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212834;
	bh=rfmjw3Cvn3Ojq1mjp6u3jQAgqiBh/YbVpAubO8SfD4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DZqZCmBA1UuVP5JXyX3O6sjRIRF1HkVypRfIgq4uhq3VLSqsQaabI3+USAZN+IzaV
	 NGb8001gDZOSc8hf84hqG6r8UJteM+9rSSKZOdtQMrzQi7tkqSOsWIJm1tnA4faHQp
	 E7t6hSfm1hUMQ6+44QepvP2JwUn+cuZJMUFmpGsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avri Altman <avri.altman@sandisk.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Ricky Wu <ricky_wu@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 119/587] mmc: rtsx_usb_sdmmc: Fix error-path in sd_set_power_mode()
Date: Tue, 26 Aug 2025 13:04:28 +0200
Message-ID: <20250826110955.990330862@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit 47a255f7d2eabee06cfbf5b1c2379749442fd01d ]

In the error path of sd_set_power_mode() we don't update host->power_mode,
which could lead to an imbalance of the runtime PM usage count. Fix this by
always updating host->power_mode.

Reviewed-by: Avri Altman <avri.altman@sandisk.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Acked-by: Ricky Wu <ricky_wu@realtek.com>
Link: https://lore.kernel.org/r/20250610111633.504366-2-ulf.hansson@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/rtsx_usb_sdmmc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/mmc/host/rtsx_usb_sdmmc.c b/drivers/mmc/host/rtsx_usb_sdmmc.c
index ded9b6849e35..90ea92bbdb2c 100644
--- a/drivers/mmc/host/rtsx_usb_sdmmc.c
+++ b/drivers/mmc/host/rtsx_usb_sdmmc.c
@@ -1032,9 +1032,7 @@ static int sd_set_power_mode(struct rtsx_usb_sdmmc *host,
 		err = sd_power_on(host);
 	}
 
-	if (!err)
-		host->power_mode = power_mode;
-
+	host->power_mode = power_mode;
 	return err;
 }
 
-- 
2.39.5



