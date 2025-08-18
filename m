Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D3E2192F1;
	Mon, 18 Aug 2025 13:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523412; cv=none; b=GQcbrVzeKV2ATJCpLNE+YGLybXmtoPn3d12QckGQmK/x9zgURZ5oDfN4iQ3zDnFEy0Wgvz1YymR8TfhVJbmLv/uI58AprT8KyNfhKlCcXW4UWqkd7Fij3omb31MbOP64owpVahvqdbZySytQUelfSIRQW7dlNJ7QMB4I6ckDkEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523412; c=relaxed/simple;
	bh=wwdcVZYHzEWvyEXVOxxTee6+uW059Nu6y3pfEnjs340=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S3d0WZqCngv85cgAchSbvNr9ddpLJ4AEa0Gx/pRJlWuETg1grz62dIyIVztI1MjxT7BcGkZG7KoR92796I0Vl3JDGM8e13HV9KYg7HCim8CXIuyHapj5luDP99wCNiGPKsX+QFwoXmYggBar+MLVcGve+m8YdQjxYweExE3hIPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EvIniKyT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EvIniKyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A77C4CEEB;
	Mon, 18 Aug 2025 13:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523412;
	bh=wwdcVZYHzEWvyEXVOxxTee6+uW059Nu6y3pfEnjs340=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EvIniKyT9CWMkHAkLdB83fbnCUZOr/R3/nJSUbBUXfuo6/UdeIRmwChr1UtGsqau6
	 TBuG8JHrstGETxw0qsZDfQ9Atdk3oFZVzvW2JrSycs8NGYEO4mGaMc2xk0Kwc7EBcz
	 2c03q2PiPq+YHaFEk0aMpUenYDldK1XsD7S3S32U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avri Altman <avri.altman@sandisk.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Ricky Wu <ricky_wu@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 164/515] mmc: rtsx_usb_sdmmc: Fix error-path in sd_set_power_mode()
Date: Mon, 18 Aug 2025 14:42:30 +0200
Message-ID: <20250818124504.693220686@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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
index d229c2b83ea9..8c35cb85a9c0 100644
--- a/drivers/mmc/host/rtsx_usb_sdmmc.c
+++ b/drivers/mmc/host/rtsx_usb_sdmmc.c
@@ -1029,9 +1029,7 @@ static int sd_set_power_mode(struct rtsx_usb_sdmmc *host,
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



