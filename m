Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15ABD1898E3;
	Tue, 30 Jul 2024 16:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356045; cv=none; b=DF1h1Z8pFlF+CMXC5v7AvpWGau3GuIlXrDvemT7ybQ1Nw2LXcAz/k53+yftVqdTrYwecHhsroblaLclC17dNHBqDgE4+C81aOti2S6tpowXXR77pmCo5E2HJBDF8lo4eOxBZtXv6eKAe+WV3ZQfeKZ0Vw6WRG0hYOAS/8MoRzu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356045; c=relaxed/simple;
	bh=fR89XItLoEjqKMj4zOEBkuPDV19QF1IURc0ePdvqT+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nO9ZNKgXTRFimxuNhTj9nExr8OsOsHJohlZ+DvH4WLFMDSbysYoV6tU+dnGObfDvtg1Y/23gQ1wuWMD8GOMUx03jD+16vJf9e9LhYW0XHW8igQaoogPtoxB4y7Oh3eWJB4bhCC7y0MiBok2LkFKCoB1GMdlrQby99Zj5Er8CW3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CHnt7kj8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CHnt7kj8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 790DAC32782;
	Tue, 30 Jul 2024 16:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356045;
	bh=fR89XItLoEjqKMj4zOEBkuPDV19QF1IURc0ePdvqT+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CHnt7kj8XBnnxBgtJINH3ileiCRQrl1kncwkRfNS808q5mCExrTW+ilVrCSDFnvOt
	 vLuE28+0zrO6akludu3Gp35cg2G7ptInw/KjHXCiN4bmYR0nAjnmySGDdAxr1J1290
	 YZXL+6GL6rHRP7xbofkfNlO/v0ik+iOvXfSmtTcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Andy Shevchenko <andy@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 109/568] firmware: turris-mox-rwtm: Initialize completion before mailbox
Date: Tue, 30 Jul 2024 17:43:36 +0200
Message-ID: <20240730151644.136118795@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4b92ac3339872..3d354ebd38c28 100644
--- a/drivers/firmware/turris-mox-rwtm.c
+++ b/drivers/firmware/turris-mox-rwtm.c
@@ -499,6 +499,7 @@ static int turris_mox_rwtm_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, rwtm);
 
 	mutex_init(&rwtm->busy);
+	init_completion(&rwtm->cmd_done);
 
 	rwtm->mbox_client.dev = dev;
 	rwtm->mbox_client.rx_callback = mox_rwtm_rx_callback;
@@ -512,8 +513,6 @@ static int turris_mox_rwtm_probe(struct platform_device *pdev)
 		goto remove_files;
 	}
 
-	init_completion(&rwtm->cmd_done);
-
 	ret = mox_get_board_info(rwtm);
 	if (ret < 0)
 		dev_warn(dev, "Cannot read board information: %i\n", ret);
-- 
2.43.0



