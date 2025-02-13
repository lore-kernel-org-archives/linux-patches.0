Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E5826B09D;
	Thu, 13 Feb 2025 14:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458715; cv=none; b=QIOh1tj9kWl4soH+TCAXbA2ZEP0uqMjKkIlkvovrCkajGUIsGTzs5yPWRy3uT2jnNizQiE64eRKXaiijIp6DwxMryN/oMAx+maM+L7t2Kh/HYt6RjMcbalFxzBTKxUqlvSurPbpWM/AiWafJxV/+2LrbUQ/0/Q84MlXA7YJO+Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458715; c=relaxed/simple;
	bh=WT0hsga8EuK6KL9uth2Wm8xoQ7ZTzI6ZHsxVcfoK+J8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tP+H5KnEGSUPsT+UJKKGlJ6eBVHCoQrnZxbBvT/JNKARG5aeqGQX5HKvYgNE6lsIeB7XmR4aknD9EBVFqcQWR94LDM9Q+gFOmMg2qRwihaREMqYkxZMmwzBh4qhpKsfrlIxd7+gYX0DtqXYMkeF/4BajOyin2i0vNJ4pFF5WwZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s1m0FVKX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s1m0FVKX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC016C4CED1;
	Thu, 13 Feb 2025 14:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458715;
	bh=WT0hsga8EuK6KL9uth2Wm8xoQ7ZTzI6ZHsxVcfoK+J8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s1m0FVKXgH4j04xSQ7vSI9pecYxL7ShEXy7iFOIsmAIW322kvuKIvguN6gv/1SATF
	 oP97rNq+u19vzAkpB1nkqKun51CdPmtX72x/X2iDXNubVT5wg8j2TroHKJD7IEUCyH
	 uZBzer1q2XqF5CLpr7BZL0OVhw1o/NvshpV4D1hA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 057/443] mmc: core: Respect quirk_max_rate for non-UHS SDIO card
Date: Thu, 13 Feb 2025 15:23:42 +0100
Message-ID: <20250213142442.824818801@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



