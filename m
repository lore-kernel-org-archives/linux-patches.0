Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9519E239E8B;
	Tue, 26 Aug 2025 14:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218951; cv=none; b=ripykCfL5CL9L4TVjn4IZvBwBoVqei41NX9QQAwW4jV2LKvLp99oHZd+FulAK8D3DxbyL4ocff3PpH9KlCBfPwFkyOopH/iQw9dGDKmcYXQ7taDh8kqHzelvJasQOAsauKL0e/3bnurKofbhqNCvXQJS6pR0O1fv3JMswVo4+LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218951; c=relaxed/simple;
	bh=AgQ0C0vnPcWnvuJgmYEZ9jw5t5eNFGjr1WxQ2JI2P/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rXWv9m24u4XTyStqK5zx9/7LSvwX3M/KY/nDpfFt4mkz0fWoThOBRrjarccLawBD643dD0OGHCKy8/iFDxcqIhi6QUgbzaWVNszMNNVEykq3sTuPFngvr4RgQQQ5V60ol2C49SPeuYBZx6YximihwBEV9hylCN4BJ3NFo/DGTN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SVp8CSC8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SVp8CSC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23679C4CEF1;
	Tue, 26 Aug 2025 14:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218951;
	bh=AgQ0C0vnPcWnvuJgmYEZ9jw5t5eNFGjr1WxQ2JI2P/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SVp8CSC8iT7ajOTarab5v1pZrCXH1GQpjgkhuWowPM7gfbyh92FAQJgu1eUHXbC3I
	 h4XL6n8DZtoUrwDmX4SglXyo2kk47aDfz8j4lJCaK9r7R75Vq5S71h4s4UdWW42lLn
	 sZfELVjV4TE07MPlMXBJqRoPR5qOcZ7W1c30m4LA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avri Altman <avri.altman@sandisk.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Ricky Wu <ricky_wu@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 197/403] mmc: rtsx_usb_sdmmc: Fix error-path in sd_set_power_mode()
Date: Tue, 26 Aug 2025 13:08:43 +0200
Message-ID: <20250826110912.309063387@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 3261560bede4..581bec5c4caf 100644
--- a/drivers/mmc/host/rtsx_usb_sdmmc.c
+++ b/drivers/mmc/host/rtsx_usb_sdmmc.c
@@ -1038,9 +1038,7 @@ static int sd_set_power_mode(struct rtsx_usb_sdmmc *host,
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



