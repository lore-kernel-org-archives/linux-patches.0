Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7A7449B2A;
	Tue, 21 Jul 2026 17:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655072; cv=none; b=BFm2B0drnhEPhX/e8TXeu0xriQZdo1ZY3Av5smGGk5xlCmgpX5XPoeATjOVL7VnDXg6aazFbAF7bkLvyhuqNHajCjOT043Bq3sScr6ke7Qbo0ANYVN+kQXlKJ/VLiGi2uTDufQAiQ5pfoJ4CV+kgERaPJuwr3qUH/N4RpCoeEYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655072; c=relaxed/simple;
	bh=Yq3MF6PyFnXvQN3CKXqqXo6lUp0hqChsTZoiY1J7pmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5cv5dI9ST2UyKeTGNWP47dZxiTqoRBW89I0mqB4V3R6L8eG+v2+hJ3yH9ye4biILuFnYxPTJtEEpHzHyBS33nA+sW9kicOMqx03bIbBaqETrsSO8fuKUPm9iM3vbGoNE8jB110tCglPeZkkQWUXRFJZSmBqyH6/Oeahs9V1VaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OttNcrQP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OttNcrQP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB12E1F000E9;
	Tue, 21 Jul 2026 17:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655071;
	bh=0xnSgvZYOGG7t4MTWZZbXkJn/S5wr4rqg88LTTuehsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OttNcrQPlHp3CaUT7WwTN4GjoqU0QuMR5zwKB8Gp32cJtLxMRlqLA00C9wA/7xZKP
	 m2MR3sEICSbNy2YW4GSOQwiZKuDbgA2kYHXRi/G+jDurwMduZ9lGSED+HIOysiSWnQ
	 RkYbKx380d66SypJo99EoKptvo3TVPxRiYzwSW90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Valentina Fernandez <valentina.fernandezalanis@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 7.1 1946/2077] rtc: mpfs: fix counter upload completion condition
Date: Tue, 21 Jul 2026 17:26:59 +0200
Message-ID: <20260721152638.610487815@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Conor Dooley <conor.dooley@microchip.com>

commit 9792ff8afa9017fe14f436f3ef3cd75f41f9f145 upstream.

The condition that needs to be checked for upload completion is the
UPLOAD bit in the completion register going low. The original iterations
of this driver used a do-while and this was converted to a
read_poll_timeout() during upstreaming without the condition being
inverted as it should have been.

I suspect that this went unnoticed until now because a) the first read
was done when the bit was still set, immediately completing the
read_poll_timeout() and b) because the RTC doesn't hold time when power
is removed from the SoC reducing its utility (I for one keep it
disabled). If my first suspicion was true when the driver was
upstreamed, it's not true any longer though, hence the detection of the
problem.

Fixes: 0b31d703598dc ("rtc: Add driver for Microchip PolarFire SoC")
CC: stable@vger.kernel.org
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Tested-by: Valentina Fernandez <valentina.fernandezalanis@microchip.com>
Link: https://patch.msgid.link/20260513-panhandle-ashy-70c6abf84d59@spud
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-mpfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rtc/rtc-mpfs.c
+++ b/drivers/rtc/rtc-mpfs.c
@@ -112,7 +112,7 @@ static int mpfs_rtc_settime(struct devic
 	ctrl |= CONTROL_UPLOAD_BIT;
 	writel(ctrl, rtcdev->base + CONTROL_REG);
 
-	ret = read_poll_timeout(readl, prog, prog & CONTROL_UPLOAD_BIT, 0, UPLOAD_TIMEOUT_US,
+	ret = read_poll_timeout(readl, prog, !(prog & CONTROL_UPLOAD_BIT), 0, UPLOAD_TIMEOUT_US,
 				false, rtcdev->base + CONTROL_REG);
 	if (ret) {
 		dev_err(dev, "timed out uploading time to rtc");


