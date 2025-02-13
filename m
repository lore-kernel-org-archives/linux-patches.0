Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C010D281360;
	Thu, 13 Feb 2025 14:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457226; cv=none; b=VDHM9iqoEVx1FnJ9a0UWHE+mCmeGklRN/OC4MXGw7HkhkrsdjK2l1bYyD5KaNS2DMj10aXFgy9tyFzNwhefLde5dD63rMBpTHvO3aOqfotX+cC0OX2lD9RxWzvo3bt+Ff/ONFUt3yNv/FOc0pkJhW+VYvyyrs/3Q/vaDXZ8F/ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457226; c=relaxed/simple;
	bh=gi036BtTHW0QYAq56UucDX70OkZjNXhDb76MWW5SHRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DuGBUKm4d8a+ii169CnUK7r83qH19bBdimXM2I2eB1kdPZZXG2h7jn1RAi1e9Re0nUM03vWCEA3apqt4hEP7xBLe7XlM9U/NFZxDNP2WPt9Wcwl/ghW6/Chzga3CYB//vOGKEmzP8BS+hxiT79orMeEr32uVfdyUUwJu7OTM1dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FuS1BFwS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FuS1BFwS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E0EC4CED1;
	Thu, 13 Feb 2025 14:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457226;
	bh=gi036BtTHW0QYAq56UucDX70OkZjNXhDb76MWW5SHRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FuS1BFwSZPIKKp9aVKc/xV3s3VF9G/INruenHCftmgjB7/G3CdMsr7C57lrySimk+
	 LnaRfplk0ynGqEKd5n6jcrvQ0x4cYw/jhOTTLVEUarRicPbH67G6d2ctwdZb8zMbUX
	 N/s/R4IZKkpnwU+tp0ObCP2reoDjgvvxdmNLqQXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 050/422] mmc: core: Respect quirk_max_rate for non-UHS SDIO card
Date: Thu, 13 Feb 2025 15:23:19 +0100
Message-ID: <20250213142438.493621888@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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
index 9566837c9848e..4b19b8a16b096 100644
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



