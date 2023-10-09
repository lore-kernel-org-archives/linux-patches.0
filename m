Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28DA28DD9
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yXlspOJy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD6FC433C7;
	Mon,  9 Oct 2023 13:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858905;
	bh=bGY6YxVN2w/PHeoRq1+mfugigxI9xVVhQRlGJQrzJBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yXlspOJyFIkwuL4Pdc5dvi2yQS71amjbLyeK08KmnRHz6Y/W7t10svdYhe6L6vKfh
	 ABTbtSH3ySZn1nohZlFPR8S8owZPiwtSzVjqMr3J/d8RlZ/w8J0j+kUVCsOKYohbuk
	 L4uFx8rcBdAP7ddSm25Eb4CMzgT10TUB2gYydESc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Malin Jonsson <malin.jonsson@ericsson.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 137/226] watchdog: iTCO_wdt: No need to stop the timer in probe
Date: Mon,  9 Oct 2023 15:01:38 +0200
Message-ID: <20231009130130.326492115@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 1ae3e78c08209ac657c59f6f7ea21bbbd7f6a1d4 upstream.

The watchdog core can handle pinging of the watchdog before userspace
opens the device. For this reason instead of stopping the timer, just
mark it as running and let the watchdog core take care of it.

Cc: Malin Jonsson <malin.jonsson@ericsson.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20210921102900.61586-1-mika.westerberg@linux.intel.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/iTCO_wdt.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index a370a185a41c4..9048fa44897fc 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -426,6 +426,16 @@ static unsigned int iTCO_wdt_get_timeleft(struct watchdog_device *wd_dev)
 	return time_left;
 }
 
+static void iTCO_wdt_set_running(struct iTCO_wdt_private *p)
+{
+	u16 val;
+
+	/* Bit 11: TCO Timer Halt -> 0 = The TCO timer is * enabled */
+	val = inw(TCO1_CNT(p));
+	if (!(val & BIT(11)))
+		set_bit(WDOG_HW_RUNNING, &p->wddev.status);
+}
+
 /*
  *	Kernel Interfaces
  */
@@ -568,8 +578,7 @@ static int iTCO_wdt_probe(struct platform_device *pdev)
 	watchdog_set_drvdata(&p->wddev, p);
 	platform_set_drvdata(pdev, p);
 
-	/* Make sure the watchdog is not running */
-	iTCO_wdt_stop(&p->wddev);
+	iTCO_wdt_set_running(p);
 
 	/* Check that the heartbeat value is within it's range;
 	   if not reset to the default */
-- 
2.40.1



