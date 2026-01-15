Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0ADD26CE04;
	Thu, 15 Jan 2026 17:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499018; cv=none; b=MNCTxvffeErAvQfTfzRuGXSlVnokxqBuzx0yhJUfzs/yldoljGQmrlnQBLeLMCeuukMQttfXCXYPM67dhI4Bv6bgDL5GMtBKUD1Z59l2foawEgYizdyE2hlngvEX809tD3lxN932TqJ+ylqZTpdVObUsRv9A0VE7quSZ3c9q6JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499018; c=relaxed/simple;
	bh=osDfMmbwdiolGriAgkoXF/2uYILwpza58WV/mPfGxmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NEB3SzLnN//DtLS8M2h0glQcR8VkCcxNLoBjpSVjB+FyL19GIUgr0aZnmou+4fz52ywpK9JCDxDh+zxej3v7dkSUX+XaCfEX39RNku0NVA+Dbcz7gY5Mfj36gwgyKjmfQCxU/ubaOuNlrOhZi+/rF/vSUTrsT6gW68GH3UGe0kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aXuvbv/Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aXuvbv/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531CAC116D0;
	Thu, 15 Jan 2026 17:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499018;
	bh=osDfMmbwdiolGriAgkoXF/2uYILwpza58WV/mPfGxmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aXuvbv/YNYngA0IaytMi9fuFP+dJOmd+UIvvWUnLcheFWaWZ84EmzlA5efR6i49jr
	 tw8NBNE4S63MaqCQdEGLVLIgt+lJiqSNsa7qPfk/MKL15wLgy1KaOutrjD7b3jH9TJ
	 EMkodUTvtvSW2CfNqawdUsCKt1+JQFL4os6Hn1ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Xinpeng <liuxp11@chinatelecom.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 079/451] watchdog: wdat_wdt: Stop watchdog when uninstalling module
Date: Thu, 15 Jan 2026 17:44:40 +0100
Message-ID: <20260115164233.772483050@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c60723f5ed99d..ec308836aad9c 100644
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



