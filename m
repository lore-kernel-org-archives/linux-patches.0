Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71521DAC95;
	Tue, 26 Aug 2025 13:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214323; cv=none; b=ePWiPR0+Pi7chaE/nF3CGfCHJq+pIDsfNsnWO6nnr3ivhCJNlvX9p7TPo/SuIBmaqJ4+dmrh2XgKBhTOLm5bbG4hsnydncKH0w3qwN2oIZZRyfDAyYu3G9B7w1+DCkdYwzUR1Hnsi7/bEqPb6xEx+7amz7N2k11ZF0AI1yA1glw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214323; c=relaxed/simple;
	bh=yIOsG67Lol29vaG7yZrRJREIuDeO5QHa/zlusKJFjvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K2t1KA/r+C44oUvK/5wJprmWB4tMzysHnPHpP2T72yXxhNw9B91CjXpPuM5fr+B0AycBUuzkiU2cIt28yok676ezM8vjerB3ye0YGDoz3d0j+/8LyoyWWdR+vPsRm/P6HsJ7+hgh+NtqXqu13sK3/PM7h8NweFdxRqQYk6Y6kzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nKYzUcwM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nKYzUcwM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 398FBC4CEF1;
	Tue, 26 Aug 2025 13:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214323;
	bh=yIOsG67Lol29vaG7yZrRJREIuDeO5QHa/zlusKJFjvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nKYzUcwMbHhKTErnTqWavEepKEr5kPh9bTk9bX6pjEAto5il8cDXELrIgLmT7rocM
	 2laVmvRbqc6zXEe/aZqiFbx9rDtt4mwk/rm+pL16dNoIcc5FiFFVyfF8PH043QeSo5
	 mjMCNgZX7ijGJmUcKhPBaAEQ1w6jSbhcLF34h14Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avri Altman <avri.altman@sandisk.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Ricky Wu <ricky_wu@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 096/482] mmc: rtsx_usb_sdmmc: Fix error-path in sd_set_power_mode()
Date: Tue, 26 Aug 2025 13:05:49 +0200
Message-ID: <20250826110933.200543259@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2c650cd58693..c5a6bbc06953 100644
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



