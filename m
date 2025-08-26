Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC1C3568F8;
	Tue, 26 Aug 2025 14:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217701; cv=none; b=rN/Bokh2lbZzWmJfoPtPZw32xbZ41xxBo8BotUemTlUIHhvcmmz1whpy6XdRxzdXBDw79eEdlVz9P0MFetneADJePN8WvmJbjmGUCqX1cFR4vXRttZkmAwjIVYv/vH/ORVG/xifoQMGRhBGuCyFfwtyqPYm8tymnZ6H68tbU5GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217701; c=relaxed/simple;
	bh=DOexs8crp6RQmpdjitHE1l6IqmAVlxYnGS38QHxMHtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uty7L4jF8jpW+f0+p5JjCKxLF+yYE4t/ux7ehGZVpO8iWLZbmQhLEPoEhpGwfS8eV8M69jL+CrVhnUX7zI/1vCnLqsOp9wSkwIkDrhBYca76jX8r6M8yl/sy7ieVKyP8i5EVbziKRxsGeKZaZoRJl/Rfsqt4TaJBP+zAVrdhwa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QC9VFj1x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QC9VFj1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D573FC113D0;
	Tue, 26 Aug 2025 14:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217701;
	bh=DOexs8crp6RQmpdjitHE1l6IqmAVlxYnGS38QHxMHtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QC9VFj1xv/2OJnq4VzYWFfiqQc1B3zFI2C7anGcZvYcgrEBspWXtC5ZXkkl964CE9
	 3hnmYoH7JEOPyHDB1LWzWk0KH5q+StkyMA2YrjFUPwH4h5X25NMHpPhfk+MwTASDKS
	 ubegaPoEX25IR6XHZ4JrmUMDkr+SlE7Kuu0sU3XY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avri Altman <avri.altman@sandisk.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Ricky Wu <ricky_wu@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 243/523] mmc: rtsx_usb_sdmmc: Fix error-path in sd_set_power_mode()
Date: Tue, 26 Aug 2025 13:07:33 +0200
Message-ID: <20250826110930.434083536@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1be3a355f10d..ab7023d956eb 100644
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



