Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5BB268C60;
	Tue,  8 Apr 2025 10:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109918; cv=none; b=DV64UWs0LRP5pDCVvVy0Y0smCJU1bFAalh4mnj4/eKEPVQHliFnP1WCqO4PHHCSSd2LYYF1EbxrrEnxWXP/SAZN2TsZIfqimu51sS5p3rkOYibXc/AhulEoDxC30dgXm3pAngV8VFNmAVETyIx7Ah69ydOZxL7FjKhhN/aCMt+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109918; c=relaxed/simple;
	bh=tq5KdWgvX8XhpSnvIxGFVyxIghqWNv110NosiXvs75I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+9gP5AF8SVehBdq6PYze7FK3f+8HalWGe8N3yBg62ZG7Kvx4CLuhhCK4iZEaPx3E8Cn+jtHSI1I0qR1uQQ8T8l1uY5ode/eNfefGICUL72+9EInDjzCM0+xmCf9Q7bbrYsVh4cBverUvCAtg4I4Vu6YpMUubA5FgZPoYV6/ZO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rSefLeN/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rSefLeN/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1AFC4CEE5;
	Tue,  8 Apr 2025 10:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109918;
	bh=tq5KdWgvX8XhpSnvIxGFVyxIghqWNv110NosiXvs75I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rSefLeN/npbKGqnFeLVOB7GzGELkcW/t+1EM4Qo2Lcqgy7RbEq6E0gSuDn54r3HND
	 lVpPNUD0w+qgHdwUl1/E7bSpKq0rUfWcypnusYdzv2QMNDwE/xxzMVTxB3a4Rb4CZw
	 VRWn/VP10iRet4lOFXphjpurN9VCAZGT8TXzG6jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gu Bowen <gubowen5@huawei.com>,
	Aubin Constans <aubin.constans@microchip.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 084/227] mmc: atmel-mci: Add missing clk_disable_unprepare()
Date: Tue,  8 Apr 2025 12:47:42 +0200
Message-ID: <20250408104822.904315051@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

From: Gu Bowen <gubowen5@huawei.com>

commit e51a349d2dcf1df8422dabb90b2f691dc7df6f92 upstream.

The error path when atmci_configure_dma() set dma fails in atmci driver
does not correctly disable the clock.
Add the missing clk_disable_unprepare() to the error path for pair with
clk_prepare_enable().

Fixes: 467e081d23e6 ("mmc: atmel-mci: use probe deferring if dma controller is not ready yet")
Signed-off-by: Gu Bowen <gubowen5@huawei.com>
Acked-by: Aubin Constans <aubin.constans@microchip.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250225022856.3452240-1-gubowen5@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/atmel-mci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -2507,8 +2507,10 @@ static int atmci_probe(struct platform_d
 	/* Get MCI capabilities and set operations according to it */
 	atmci_get_cap(host);
 	ret = atmci_configure_dma(host);
-	if (ret == -EPROBE_DEFER)
+	if (ret == -EPROBE_DEFER) {
+		clk_disable_unprepare(host->mck);
 		goto err_dma_probe_defer;
+	}
 	if (ret == 0) {
 		host->prepare_data = &atmci_prepare_data_dma;
 		host->submit_data = &atmci_submit_data_dma;


