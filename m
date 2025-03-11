Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D855B25D908;
	Tue, 11 Mar 2025 15:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705593; cv=none; b=snDOx6Wgi7asqkxodxtDqle1gM7WW4ipV5xhqzDulMWtYHErijU6bU7Ynuoc3GyTe6n0L4ONC6/+aYs3Pwc4rOZrwTRuQjD4jhSrZbNm9Miiw0ae4Z0dY6bGtzBkoqnk5Shrr9ejwhg1fDeVsTZE8xlHkscn3eRtj//fhq/25EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705593; c=relaxed/simple;
	bh=8PRAP0E6f4mfSrQjF9qhvuF7DCJoHoPwFM9mWibEn8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LMOYRt8Hs3l30sWaElmpcoZ5lzGCzCDFhq47yoaRN2Ie4Q+ysqSoMFdYUmajHXcCD7UXIE0zYLwySZaYtTB1mdHkA+gAaIqum8A1/Pn3wzJAfwAPGQCfa5tukdG7xanHT5plSuqO3P7dWkH+nxf19NIBiYjfbA67NOb6jbqAzJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rdH0kLpQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rdH0kLpQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7C8C4CEE9;
	Tue, 11 Mar 2025 15:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705593;
	bh=8PRAP0E6f4mfSrQjF9qhvuF7DCJoHoPwFM9mWibEn8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rdH0kLpQxnWyi3d11BSueNiznHNrD9H6jDhGknX6J8AfrXFgWLR6XlQfmIUZIJ5Qi
	 HJ3AlVGi0sGb+DfqCBDTjSiXH/YLyxgGjjZRx0hfxVUK3Qupo4Ogp2Fwjebtxn3oc9
	 kK/4z11cX/XoV/LHrTwEwoM8x8j8N9Bj3rMjIzUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 089/328] mmc: core: Respect quirk_max_rate for non-UHS SDIO card
Date: Tue, 11 Mar 2025 15:57:39 +0100
Message-ID: <20250311145718.424202008@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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
index e614fd82a32a4..2362a70460f1c 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -379,6 +379,8 @@ static unsigned mmc_sdio_get_max_clock(struct mmc_card *card)
 	if (card->type == MMC_TYPE_SD_COMBO)
 		max_dtr = min(max_dtr, mmc_sd_get_max_clock(card));
 
+	max_dtr = min_not_zero(max_dtr, card->quirk_max_rate);
+
 	return max_dtr;
 }
 
-- 
2.39.5



