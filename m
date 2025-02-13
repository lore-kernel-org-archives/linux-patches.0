Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55EB156653;
	Thu, 13 Feb 2025 15:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460178; cv=none; b=AZsRFl3wWrn58iY3PHvDOuvOBQ3hShtSH39eTruvOwyiidEqJqK/h3F8EobOIsY+JZwYy3tZun7GPnyIMS9uwMF9A0HzLsz71XaHQpZT3AARZ4zodp1EcPA59xoKatUxgXsO/+pWJmWH8L7aMMu1/V72H9e0EAgmlh1aUOJiae8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460178; c=relaxed/simple;
	bh=gp7XctmyxTndjxiauppn6NXgjwqc+ej7PwHpSCOLfIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQK99CO63TCgODMgHhleDGHcQjhKRUYWUNVghbu/+lIH0Vdwlzt8kb5nUfPvY0IXLGoRaVkEvDzya7EbRDwwNSGdi9hax11nBDurS+xP4bp9PKX6IgmbJf13bMIeZupeRXQW7H/6E8Wg+McyeKGmRCH73+NhvCK4K65aYpiDhOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fu9Cpkf4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fu9Cpkf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5922BC4CED1;
	Thu, 13 Feb 2025 15:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460177;
	bh=gp7XctmyxTndjxiauppn6NXgjwqc+ej7PwHpSCOLfIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fu9Cpkf4XM6+xJQwUP8RB7QaNalYIlpOTzQo3ZwQTlVFbAJRGz5Dbn+wsA7IcsPOv
	 h5Mpz+JbVqnC6WBoUm7DfYMbBKmteolZqSE8CyO2B1VkCLm47vIYIkEHabzwPA7+WY
	 8/O2Xj3wHvyv9dBhuVz/sA3Xxx7YHM6SNOZSxZ70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/273] mmc: core: Respect quirk_max_rate for non-UHS SDIO card
Date: Thu, 13 Feb 2025 15:26:42 +0100
Message-ID: <20250213142408.546512712@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

From: Shawn Lin <shawn.lin@rock-chips.com>

[ Upstream commit a2a44f8da29352f76c99c6904ee652911b8dc7dd ]

The card-quirk was added to limit the clock-rate for a card with UHS-mode
support, although let's respect the quirk for non-UHS mode too, to make the
behaviour consistent.

Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Message-ID: <1732268242-72799-1-git-send-email-shawn.lin@rock-chips.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/sdio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 5914516df2f7f..cb87e82737793 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -458,6 +458,8 @@ static unsigned mmc_sdio_get_max_clock(struct mmc_card *card)
 	if (mmc_card_sd_combo(card))
 		max_dtr = min(max_dtr, mmc_sd_get_max_clock(card));
 
+	max_dtr = min_not_zero(max_dtr, card->quirk_max_rate);
+
 	return max_dtr;
 }
 
-- 
2.39.5



