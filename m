Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B836846D;
	Tue, 11 Mar 2025 15:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706693; cv=none; b=bMd+2yrgVnVtMQkH7lXrcIZbcIwkQQQqzDK2HxC/AjN7ks+YBaIVAfF01yuF1TdrW0eO0QemGHqT2xY1VwDD2aG9XOSrgSXLDLCA5/7oRFx9alY16Mj1Gn9+ejDYw/emPm1V4JVEVRXx/qzJq5se6yX1s4bceK8GzpLEKQfwuA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706693; c=relaxed/simple;
	bh=4NQ35ZIus6ZPkGKy047kmMSKK77xn6LFvtClwif/WaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMw22dXFw0t7SFTKZJD4n6CmK5n4CXJsVFPnDP9OUU9VhZPEkrjvt9CtnHXov+oCkjgdtcGR1LgXfgS06Wnrxs6PMhMWTZMoM/KI5HdeBj7f3Lw9btqHZCTq4e2Jl42xWbh9GkqfNl2oldTn40dB/te/YEPUZIqduC7IXs2uMY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tk4NAfQG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tk4NAfQG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F00C4CEEA;
	Tue, 11 Mar 2025 15:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706692;
	bh=4NQ35ZIus6ZPkGKy047kmMSKK77xn6LFvtClwif/WaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tk4NAfQGU99eLtiApeFVoIEG5XkrhurZRjLgqwWFrNI2kHw9lTdRt69FDsZqpGkn2
	 B7hzpXJKndARm9fZHIe1JltdXzBQJP0xi0MtaluwYLPUHGYx8vyVB9KoNGy4jx6XcF
	 g8RedxfySYg0kyyUQmLr525vvGBtkv4RnfT3bkok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 134/462] mmc: core: Respect quirk_max_rate for non-UHS SDIO card
Date: Tue, 11 Mar 2025 15:56:40 +0100
Message-ID: <20250311145803.652127009@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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
index 85c2947ed45e3..a719f23fa1e95 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -443,6 +443,8 @@ static unsigned mmc_sdio_get_max_clock(struct mmc_card *card)
 	if (card->type == MMC_TYPE_SD_COMBO)
 		max_dtr = min(max_dtr, mmc_sd_get_max_clock(card));
 
+	max_dtr = min_not_zero(max_dtr, card->quirk_max_rate);
+
 	return max_dtr;
 }
 
-- 
2.39.5



