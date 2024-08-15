Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9822A19FA90;
	Thu, 15 Aug 2024 14:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731972; cv=none; b=A/K61R4dsBj5blUP6fR9FeNqS+69TUyHUhZ3VVA3aNvX1yOZtP2IFpxUVEAc7zPTk+o3HP6mAKRsVoB9viN44+4SHz3Fw4BESwItH7YtuZubgx0rt+lNfrhriivqkiDYV4Gbwosjn/0r8h1pZNR1n5eeb/hwOSehnbXXEuwuHFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731972; c=relaxed/simple;
	bh=fzWn/Owi2pfOr9FCAWBuKZkKF92XQzmb5Y515exmJYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hbd4IqT7Jn3U85RIzmggBZhlwzIchHmJeza4M5dvosj/nFnPxgnM/olXytDvO6ZRgEiBrB1LSmUn2dAu5/iABya4PG56RazLYN+SD4HjURpMngSVSrdyBzu4MerFXIt1ipj0ckZ5E049t+4NmF/0VzvvAqOVgWycMwXlIXxr3fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HVqYpzME; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HVqYpzME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17756C32786;
	Thu, 15 Aug 2024 14:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731972;
	bh=fzWn/Owi2pfOr9FCAWBuKZkKF92XQzmb5Y515exmJYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HVqYpzMEPwzpXpBXQmKnd++12FB/zyehO/vudJwrNRhAJJtddPTvZrTonDKicsUmP
	 cfJTbtZFNcbM/0YSReUR2u0TQPgl3xDhSJC2GSNqOGe4xF+uvrDKlJMWGhwqhQ01mP
	 N7m9bm7mk37cuczJeKupxUppv70Ujnf69unEC3CI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Andy Shevchenko <andy@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 034/352] firmware: turris-mox-rwtm: Initialize completion before mailbox
Date: Thu, 15 Aug 2024 15:21:40 +0200
Message-ID: <20240815131920.547165880@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Behún <kabel@kernel.org>

[ Upstream commit 49e24c80d3c81c43e2a56101449e1eea32fcf292 ]

Initialize the completion before the mailbox channel is requested.

Fixes: 389711b37493 ("firmware: Add Turris Mox rWTM firmware driver")
Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/turris-mox-rwtm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/firmware/turris-mox-rwtm.c b/drivers/firmware/turris-mox-rwtm.c
index 32c94c306b23e..dcb717254c79e 100644
--- a/drivers/firmware/turris-mox-rwtm.c
+++ b/drivers/firmware/turris-mox-rwtm.c
@@ -496,6 +496,7 @@ static int turris_mox_rwtm_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, rwtm);
 
 	mutex_init(&rwtm->busy);
+	init_completion(&rwtm->cmd_done);
 
 	rwtm->mbox_client.dev = dev;
 	rwtm->mbox_client.rx_callback = mox_rwtm_rx_callback;
@@ -509,8 +510,6 @@ static int turris_mox_rwtm_probe(struct platform_device *pdev)
 		goto remove_files;
 	}
 
-	init_completion(&rwtm->cmd_done);
-
 	ret = mox_get_board_info(rwtm);
 	if (ret < 0)
 		dev_warn(dev, "Cannot read board information: %i\n", ret);
-- 
2.43.0



