Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB501805B;
	Wed, 19 Feb 2025 09:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956843; cv=none; b=gzBExyrhrKZ7vBqpgziq0A2AjZWDgX4IXNvxGa2QEG5XFR3K0h7ULgTmxpCx6IugWAdkBjGwHwaDLkvAf1eRIumWiEyXGqV6hBgI6M6zLfpNJf8XwaTQFeaprEz6JmrQ01cH+t+sR5ZKDq2cmHG14uWSykw9h6oSDt/ig9VUJDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956843; c=relaxed/simple;
	bh=S79+lpsBYBsnC3dPDySf9HUfy2IWrymY2Yh+Ok7jicE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S0oSqBMJ/9z3JfnsYdUhhhCHkprXpThuAbTWso+J0IPrR3TgyjInIy22yAo1oMFWPa8TGQ9d0gcSQYY3K9EOihsC8mKiJFSSPbQzr6tsoP5j13ZpQH7x8+Dx42PdkFj2QjBy0S4UXevYiqzgJKF7UaMZD5Qc+EUye/d69HZgtWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVSvclv0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVSvclv0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC77EC4CEE6;
	Wed, 19 Feb 2025 09:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956843;
	bh=S79+lpsBYBsnC3dPDySf9HUfy2IWrymY2Yh+Ok7jicE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vVSvclv0KdLPZtNHHYCNqLn3SEONWprnDMQuskZeHOSjx6187X1+aitsCQZem8wUY
	 m3K++EfV4ff/Mrfl+zIskT7G+gvI3rVp7e7qo//DFZfrz3KXwDFFCSx0wm/L9trtP4
	 e5v9hwA79dCZKcYQIiUY8OdVwC5v/NJDUkcaQm2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 287/578] mmc: core: Respect quirk_max_rate for non-UHS SDIO card
Date: Wed, 19 Feb 2025 09:24:51 +0100
Message-ID: <20250219082704.302124853@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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



