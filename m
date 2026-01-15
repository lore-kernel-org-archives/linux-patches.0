Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C0A280327;
	Thu, 15 Jan 2026 17:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497515; cv=none; b=P8QXK0LNVlz7ziGVIj76+Nr4/5dELf6uSv3Fpl15E4hKX66yLS4Kg1/X9kZ3I1IgHF6KQwnesa8O2hll3+UlIthgTcxvLgNYS3H+Ill+1iWTEjyBZqaAajfvTG92I6SK1yOsiqVl0y4z6FEmeTvA14KF9rL78b6y6brVJ4QyOZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497515; c=relaxed/simple;
	bh=SRN5h3y1pOUSzzzKaNiNYPThfzZNHXskty4qut55pJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sctSCnVMa0amuARseeP8uNXe1v39a2vNRZpehaHtcbrhl61NW/pMCEFr2GjcDRLPJucgVzUuwx0+quynOWFHO5AUNm5FPbgkVzQoo1/u/MMFrVIOTDvhq66LeOBWs1SjsX5zpoewCrV5bdamlBMTbq6gRA769U07ytrvijWpS2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TEUZ/L29; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TEUZ/L29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267F3C116D0;
	Thu, 15 Jan 2026 17:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497515;
	bh=SRN5h3y1pOUSzzzKaNiNYPThfzZNHXskty4qut55pJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TEUZ/L295UyF9nrJ0C8qQZZ5YvxjcCz4YVTQnfHXlgRozi8hSbzkOEwrL+Jb06rNy
	 lNAj8DeZXr5kiebgT7AWkFt8j5sxRda+pXTE7klPRLc2T+eZgXVoLp04azazpdCIsy
	 lFVN218zTGfkNyTmLTs/LJMD2livR5NmEiLxHEVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Xinpeng <liuxp11@chinatelecom.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 109/554] watchdog: wdat_wdt: Stop watchdog when uninstalling module
Date: Thu, 15 Jan 2026 17:42:55 +0100
Message-ID: <20260115164250.199687235@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Xinpeng <liuxp11@chinatelecom.cn>

[ Upstream commit 330415ebea81b65842e4cc6d2fd985c1b369e650 ]

Test shows that wachdog still reboots machine after the module
is removed. Use watchdog_stop_on_unregister to stop the watchdog
on removing.

Signed-off-by: Liu Xinpeng <liuxp11@chinatelecom.cn>
eviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/1650984810-6247-4-git-send-email-liuxp11@chinatelecom.cn
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Stable-dep-of: 25c0b472eab8 ("watchdog: wdat_wdt: Fix ACPI table leak in probe function")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/wdat_wdt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/wdat_wdt.c b/drivers/watchdog/wdat_wdt.c
index 4fac8148a8e62..51cd99428940a 100644
--- a/drivers/watchdog/wdat_wdt.c
+++ b/drivers/watchdog/wdat_wdt.c
@@ -463,6 +463,7 @@ static int wdat_wdt_probe(struct platform_device *pdev)
 
 	watchdog_set_nowayout(&wdat->wdd, nowayout);
 	watchdog_stop_on_reboot(&wdat->wdd);
+	watchdog_stop_on_unregister(&wdat->wdd);
 	return devm_watchdog_register_device(dev, &wdat->wdd);
 }
 
-- 
2.51.0



