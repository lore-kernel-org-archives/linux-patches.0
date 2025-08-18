Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75CB1E51FE;
	Mon, 18 Aug 2025 12:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521841; cv=none; b=PWfFla1JsI141IXbeUqp40UCuOBivSFNAJJDTENNSCuViVfD2WZi6WrkMhCLLL7S5sHYGba1N03MGnCBtHWgaZG94CYIAgg9IZI9ZpK0+b0E93jDPqYfsbRhaTQearDhP9B+rzZMglmOQkF5jRS7/fr79t5kAfcLkEczSeQhJwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521841; c=relaxed/simple;
	bh=NUpl1UyN++ohICrLKuKIdiss7HNZhVRDrTCWLH31fzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gz4t+XNPQAk3oYGI+PrqM5b4KeCk5IiRVGZfFjEhkykceQto63CF5y2tmOOWMRjIJKnIVc94ptaMfW1fNut2zbkhHj+Sa3oGf3KWx2BHrIavrZDLbQzPlkZWxezAwEvoVWIZvn0A5IrRc/TEppcp6P8bS3Uogd4mQEBRPGgusSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xK29BKlh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xK29BKlh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4098BC4CEEB;
	Mon, 18 Aug 2025 12:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521841;
	bh=NUpl1UyN++ohICrLKuKIdiss7HNZhVRDrTCWLH31fzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xK29BKlh0rTIO40Xjj70p+f1rExO7qxX1SqoWuTjArKpBuiV+qruqqT/9T1NY/72t
	 G77kCdTPRJTEBPDLimkNWydB6t6b33UvzQPD2B/Xpdf+75tfm6VKFEzKytHNuIyfrF
	 /JnUbsPBwojAUmZNVwS+QsMyqD86tAEo++lMqCZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avri Altman <avri.altman@sandisk.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Ricky Wu <ricky_wu@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 138/444] mmc: rtsx_usb_sdmmc: Fix error-path in sd_set_power_mode()
Date: Mon, 18 Aug 2025 14:42:44 +0200
Message-ID: <20250818124454.080695962@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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
index 4e86f0a705b6..2bf51fe11a09 100644
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



