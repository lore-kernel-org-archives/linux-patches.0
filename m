Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A86C267B65;
	Tue,  8 Apr 2025 11:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110431; cv=none; b=NMTuACe0hpMGjbhyk2nO3Df1OesVJ19rVdd7LcYeOz6YFLebPkdDiXzKZVhrQOuXUI3P+oKYIC9+Um+7I3OsB00QXddiBbKzU+K2U5kR+7LE2siBg6HZ36cAPtNQTePn2YbUuiK7u7YOoWu0j052jb5B51pnR9kQu//XsoBQM8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110431; c=relaxed/simple;
	bh=q0Ak0xvbPZIi8oh7SyCMsTpR8S1k3St6tgZQmCQOl44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+oHoLp0/brpDsAbqKBLe6O3q/fzELyJkpwna/7+DDT9TUMCSNJW8Mqop6ijz5kHNBNM7Zv9wd3EYJC189uOITnHa8ly7hUoHv91/bRfk2+qVrgcKy37+stiYonuS+xUKTDSgA5/1oOYutlbaQtE33YFmVSSY72hEaDrbJAYAeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0YxaRoSU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0YxaRoSU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DCFFC4CEE5;
	Tue,  8 Apr 2025 11:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110431;
	bh=q0Ak0xvbPZIi8oh7SyCMsTpR8S1k3St6tgZQmCQOl44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0YxaRoSU9SvccJD749x1Y701pho1EoS4WSq+mtUqDWY1YBeKaCdTU7OoNzTHMh1ra
	 bX9/ox2sH7PE12m2DELhEhU6kY3/N7eRlxJSDm0X0RsUIiyhoQEo+IV/k8EMEiweYW
	 aRnFnTFT6T2uIjWSnM6gEfAVNj+bvWg9V7yQ6On8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 061/731] auxdisplay: panel: Fix an API misuse in panel.c
Date: Tue,  8 Apr 2025 12:39:18 +0200
Message-ID: <20250408104915.693172186@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



