Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0E47080E;
	Mon, 23 Jun 2025 22:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716498; cv=none; b=FTnWACIW5GDFcGjOPUf2lJpBY28fAl2inVrUcfTv5tYF3a8PKtaaewEKLGfVAnhd/F1PTGg8hLluefHTTwyuz7bN20IkhH7Qt0GweMz2OSgvLqqOXPjEN3dCEmWfsQ9ISQZCnQzD0pfeH4YT0CoodWuis3Z7YejQC5oa0WYmUpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716498; c=relaxed/simple;
	bh=ECVv7DVIggYBdWn80IZ9PXx/FTjapqCAGjVNGxEXn/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tnGkeT+UcingdWZAavZTdt+ufdm33128FX8cossnrmY8NCeUYehtrbexTFuW2hvWLnWjvybykDB9B347inr9RW2F+b0IP3Fmz8RtHF/tJbS4LaoSyg5abdHZSKhtXvLIQQ1xIaWYOXLUvYzVAfNg6YzJPaZNBTVFS5lSHj7oS94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i012crPj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i012crPj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95DDDC4CEED;
	Mon, 23 Jun 2025 22:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716497;
	bh=ECVv7DVIggYBdWn80IZ9PXx/FTjapqCAGjVNGxEXn/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i012crPjUWFFdLgVNhtN13UWxhi+jTJrkAUWxXAwvsb06KhCQ+2k6YYps3dXGmMdV
	 pJahFb1HlGc1sUHXpPVOdA4hnOPU+LwNKDsjAowkGhYkA7ufqC7X8ApBL0cmDG1sq7
	 FciHzZJybcniGkL7ssW307qo7E+KSKm+XFEzlEx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcus Folkesson <marcus.folkesson@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 283/414] watchdog: da9052_wdt: respect TWDMIN
Date: Mon, 23 Jun 2025 15:07:00 +0200
Message-ID: <20250623130649.093085642@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcus Folkesson <marcus.folkesson@gmail.com>

[ Upstream commit 325f510fcd9cda5a44bcb662b74ba4e3dabaca10 ]

We have to wait at least the minimium time for the watchdog window
(TWDMIN) before writings to the wdt register after the
watchdog is activated.
Otherwise the chip will assert TWD_ERROR and power down to reset mode.

Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20250326-da9052-fixes-v3-4-a38a560fef0e@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/da9052_wdt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/da9052_wdt.c b/drivers/watchdog/da9052_wdt.c
index d708c091bf1b1..180526220d8c4 100644
--- a/drivers/watchdog/da9052_wdt.c
+++ b/drivers/watchdog/da9052_wdt.c
@@ -164,6 +164,7 @@ static int da9052_wdt_probe(struct platform_device *pdev)
 	da9052_wdt = &driver_data->wdt;
 
 	da9052_wdt->timeout = DA9052_DEF_TIMEOUT;
+	da9052_wdt->min_hw_heartbeat_ms = DA9052_TWDMIN;
 	da9052_wdt->info = &da9052_wdt_info;
 	da9052_wdt->ops = &da9052_wdt_ops;
 	da9052_wdt->parent = dev;
-- 
2.39.5



