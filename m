Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92EC9224AE8;
	Mon,  2 Jun 2025 14:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874187; cv=none; b=QuF+EQmK5f5OXGfhRzLUD4rrI7+K5w7mXM/xEw0Jz8EW6uC08A2FGTJaJbUOkETi7QxT2G5u7Yhe7exhQC2FcwDCGmDTr/at3NvvG4A+hAEi8Ov8XCBaFEHRVVmqkAGGdCYuWwkN0XtEzfbzj+iOuze/dplFHlkiGdBwj40ofV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874187; c=relaxed/simple;
	bh=T0YWtduzRksNYlm0vkrrGfonc03TrQBiPlFrQ1BTZjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rZsMcBahQak3ds10e5+olzy2rDuEDVaZq+xdhBr1gw0ccEaOKePj/mjU7LCZRoH45cYyeQBzN3nbArKQIc7XgrXMoZ9ASgpqJhrbyFsRJK6PviuV+pztC9NpT6NAq1JeoPyShbOqHUr5BDbRut2JrHSVtQiAaaL9gPmryXf+Ke0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8Hi2iFU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8Hi2iFU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98235C4CEEB;
	Mon,  2 Jun 2025 14:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874187;
	bh=T0YWtduzRksNYlm0vkrrGfonc03TrQBiPlFrQ1BTZjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u8Hi2iFUp6egjQMN0yDrAEarVri/bMknCe6YHC6X3KB08R7sW02MAlPBzMDQa2HEf
	 3x4Ijv505ORmiPb9DQFE/Tm4z8PfZwt3aYjPhvsB2DRvfYcn4tkoFownZ0YqA9DsrV
	 ofEA0PRM2Y0yZbE7sdi+qH4NCf+RyUeA0BQszPuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>
Subject: [PATCH 6.6 387/444] watchdog: aspeed: fix 64-bit division
Date: Mon,  2 Jun 2025 15:47:31 +0200
Message-ID: <20250602134356.617283794@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 48a136639ec233614a61653e19f559977d5da2b5 upstream.

On 32-bit architectures, the new calculation causes a build failure:

ld.lld-21: error: undefined symbol: __aeabi_uldivmod

Since neither value is ever larger than a register, cast both
sides into a uintptr_t.

Fixes: 5c03f9f4d362 ("watchdog: aspeed: Update bootstatus handling")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20250314160248.502324-1-arnd@kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/aspeed_wdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/watchdog/aspeed_wdt.c
+++ b/drivers/watchdog/aspeed_wdt.c
@@ -252,7 +252,7 @@ static void aspeed_wdt_update_bootstatus
 
 	if (!of_device_is_compatible(pdev->dev.of_node, "aspeed,ast2400-wdt")) {
 		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-		idx = ((intptr_t)wdt->base & 0x00000fff) / resource_size(res);
+		idx = ((intptr_t)wdt->base & 0x00000fff) / (uintptr_t)resource_size(res);
 	}
 
 	scu_base = syscon_regmap_lookup_by_compatible(scu.compatible);


