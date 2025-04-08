Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE99726B2C1;
	Tue,  8 Apr 2025 12:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114387; cv=none; b=A+w+VggAiEJzyNsdzgIEeiN0LgI6LXxQNOxUNwfn16MaY78G5+fYbIw9Kh4LAuiD1zNR2/+jAD5HL4qLPQR7RPcf5lGG11Y04Rx4FbjiS8jR9A+JdgRa/KbRQy8SCaTaMnwNMGKbHQUC1f3trHibWoaZe/W3luU+zYzB2VXXpWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114387; c=relaxed/simple;
	bh=DJ83m2dWLd9EVmL5iDmIMSwiwLLJsNHhLo+g4iRtC+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9iwuc9Vv2maWFWe/amlpdjXiwbnXd7EUICfhIUx84G3ji5ejw+183/p6Fgan/KhQrprNy9PAEZcIy/hPWAm3oEth5LgjhamFI+SFExyLDkMmzpadCzJ71XavsbuelZYSXuyeS9HODBnRVsCmcIA1VVH7hXOy6WsW++VilfvUwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ISijec59; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ISijec59"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2B1C4CEE5;
	Tue,  8 Apr 2025 12:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114386;
	bh=DJ83m2dWLd9EVmL5iDmIMSwiwLLJsNHhLo+g4iRtC+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ISijec59gl80HUqKKTte6O9CwnSkuR4Go6Yl3omw7zGIuHbWd4ojg4kSvebXeXNN5
	 4I5yZtwGxYX/Xy+2FTVWuwIJIApooaiZhfMxShRpQnv0mnePah1ILyWhTyoYWgVmOm
	 2J3x5keRw07HcNRs+OLYqWPLozzNtcewDKVi1/Ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 047/499] auxdisplay: panel: Fix an API misuse in panel.c
Date: Tue,  8 Apr 2025 12:44:19 +0200
Message-ID: <20250408104852.415494405@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 72e1c440c848624ad4cfac93d69d8a999a20355b ]

Variable allocated by charlcd_alloc() should be released
by charlcd_free(). The following patch changed kfree() to
charlcd_free() to fix an API misuse.

Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Fixes: 718e05ed92ec ("auxdisplay: Introduce hd44780_common.[ch]")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/auxdisplay/panel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/auxdisplay/panel.c b/drivers/auxdisplay/panel.c
index a731f28455b45..6dc8798d01f98 100644
--- a/drivers/auxdisplay/panel.c
+++ b/drivers/auxdisplay/panel.c
@@ -1664,7 +1664,7 @@ static void panel_attach(struct parport *port)
 	if (lcd.enabled)
 		charlcd_unregister(lcd.charlcd);
 err_unreg_device:
-	kfree(lcd.charlcd);
+	charlcd_free(lcd.charlcd);
 	lcd.charlcd = NULL;
 	parport_unregister_device(pprt);
 	pprt = NULL;
@@ -1692,7 +1692,7 @@ static void panel_detach(struct parport *port)
 		charlcd_unregister(lcd.charlcd);
 		lcd.initialized = false;
 		kfree(lcd.charlcd->drvdata);
-		kfree(lcd.charlcd);
+		charlcd_free(lcd.charlcd);
 		lcd.charlcd = NULL;
 	}
 
-- 
2.39.5



