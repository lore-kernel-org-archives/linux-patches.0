Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C96217739;
	Thu, 12 Dec 2024 15:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016155; cv=none; b=GbIG2jY6N+kmMZkvjEdjcHmNgibXrlfwxB5ysBtrfNWrWe+GPvw6EOEzs5O27G+fqE259i3s21SnQiC5d5H/+8yGGvxwgiA/HUq6Czg8ZkNeE/CfWsWXoa3ELdQo1WCcCH+jdkHwKQa+ceBlW1dLf8F3mjQo7NW0lwu76ZpCCks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016155; c=relaxed/simple;
	bh=g1v+FZ9E/+BFHMcVQJxIA38+9rTr4EaiTYCBV7INom8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OIAYNpwjpD8BpPDsLE2KUysnSsUmhAJOQMssQH9YkvgZIPZUvWkBxBMt/AlCompFw+M6jPe3h25luaOIkS26nxDhjEbaVrUU/uc9RiC8Sq6mPosT30p1fMhy+0ZBN7L235quSWHGmOK2I2YHefrUNOCaDnbrU8PzqBjYNGcSVUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XBdkg81W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XBdkg81W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A9BFC4CED4;
	Thu, 12 Dec 2024 15:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016155;
	bh=g1v+FZ9E/+BFHMcVQJxIA38+9rTr4EaiTYCBV7INom8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XBdkg81WnTaJkj18odzm6oKiDmb3NAHAmmbysCLpvE0Vkorw+r/kTUtHogsDKt0/a
	 h3XhBGO4U8qcjSD2sd/5M7v2Jw0mI3+0WmQgJUTEyXYmY7fhopQ1oaPibg1R/YhU0W
	 04kxJ2LhKtnFLtDzl0ESc/1s4pXTAtB9q+JOy6j4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>
Subject: [PATCH 6.12 128/466] watchdog: rti: of: honor timeout-sec property
Date: Thu, 12 Dec 2024 15:54:57 +0100
Message-ID: <20241212144311.863726908@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Sverdlin <alexander.sverdlin@siemens.com>

commit 4962ee045d8f06638714d801ab0fb72f89c16690 upstream.

Currently "timeout-sec" Device Tree property is being silently ignored:
even though watchdog_init_timeout() is being used, the driver always passes
"heartbeat" == DEFAULT_HEARTBEAT == 60 as argument.

Fix this by setting struct watchdog_device::timeout to DEFAULT_HEARTBEAT
and passing real module parameter value to watchdog_init_timeout() (which
may now be 0 if not specified).

Cc: stable@vger.kernel.org
Fixes: 2d63908bdbfb ("watchdog: Add K3 RTI watchdog support")
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Reviewed-by: Vignesh Raghavendra <vigneshr@ti.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20241107203830.1068456-1-alexander.sverdlin@siemens.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/rti_wdt.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/watchdog/rti_wdt.c
+++ b/drivers/watchdog/rti_wdt.c
@@ -61,7 +61,7 @@
 
 #define MAX_HW_ERROR		250
 
-static int heartbeat = DEFAULT_HEARTBEAT;
+static int heartbeat;
 
 /*
  * struct to hold data for each WDT device
@@ -252,6 +252,7 @@ static int rti_wdt_probe(struct platform
 	wdd->min_timeout = 1;
 	wdd->max_hw_heartbeat_ms = (WDT_PRELOAD_MAX << WDT_PRELOAD_SHIFT) /
 		wdt->freq * 1000;
+	wdd->timeout = DEFAULT_HEARTBEAT;
 	wdd->parent = dev;
 
 	watchdog_set_drvdata(wdd, wdt);


