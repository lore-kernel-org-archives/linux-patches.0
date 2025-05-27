Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B355C278750;
	Tue, 27 May 2025 17:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366208; cv=none; b=eKP0DGtlOkJQheuL25fcCe7/y6pr3PmTF3FCtjQi/YARetRqc7uigsjQmzDP3w6+wNS9k17TVCDT4njY44JeSIh6R214EJ+do51y99GAlmTw9xmj3RUPpYp3ZW/QDaCRlSc1HYXSbsHjgK8zZlnQOPfZPY8Kx5OADnmtUI1Ezms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366208; c=relaxed/simple;
	bh=Yluf82iJinIws4NZ5ty0/fy5DSFfgHLD9h6PUnxBxRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q4yOUlZkmuEvjM98scmMdctIo0h3ucszH3JewQQCBkMpxzX88+iM2QgL7seUSpwMgt/jiwW2++hpTvhnSExJHDNUbokJ2K9uAx8+tcGG/vmCBfPmtEwYSETy6o8UnSIJ0brgr1rw+pRoCJJc50xNuEboacAzDu7ByZyvU0nfByk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aIGgJq6N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aIGgJq6N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02D8C4CEE9;
	Tue, 27 May 2025 17:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366208;
	bh=Yluf82iJinIws4NZ5ty0/fy5DSFfgHLD9h6PUnxBxRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aIGgJq6N6Zcyo8NVD3B1N2uj2VDhdUUX0GS3G6j+gn3l8cbRF0XpUHncFF4shU3H5
	 v79k/Re/1JMh/wA3UE4EbaJ3POi8bGIIoNciRhEBWeiFC8ESVkOMeOlH3fKmpWOo/X
	 g1+XWKSoMXjmEagkV0Jh2S5VEXDO+nnX/exvYEBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>
Subject: [PATCH 6.12 622/626] watchdog: aspeed: fix 64-bit division
Date: Tue, 27 May 2025 18:28:35 +0200
Message-ID: <20250527162510.271624108@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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
@@ -254,7 +254,7 @@ static void aspeed_wdt_update_bootstatus
 
 	if (!of_device_is_compatible(pdev->dev.of_node, "aspeed,ast2400-wdt")) {
 		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-		idx = ((intptr_t)wdt->base & 0x00000fff) / resource_size(res);
+		idx = ((intptr_t)wdt->base & 0x00000fff) / (uintptr_t)resource_size(res);
 	}
 
 	scu_base = syscon_regmap_lookup_by_compatible(scu.compatible);


