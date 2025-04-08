Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF3C26E14C;
	Tue,  8 Apr 2025 12:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116159; cv=none; b=k7hR3p2MJ0/a6jw1hvaSdsPoJVRgXvKpWB1t1yVwmfLtI/a4dInlL+hdWyA+p6OtKK/FQnCr19oQ4WEVFEyoS2nd69MlohygMqAEIeqnSS6BmGuWD/dy25HwV1eKGzZFswypYOVl9HqIiaAKTMtLgac3OsCAUAxlR6gYRDUZ8lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116159; c=relaxed/simple;
	bh=947DHtIFq+ESa4TyOk0Rw7gzyJ3o9SC80aPbeNd4zck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HWwUC9bGflc1JEU5xESpX2fgsp5O2/kZl4p2CD7+pooygPtWlJzf1sA190Zvw1bv32KmDzQcli3322PVM0LOUD4KFVenVNd4Mekls4rsrkWy+nSNY3TbpKi659U0IQynCA+WuZjlSh+zaMkNTtQRD0XGnbWPMGWaj+vtbFIVCxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JU1k9NEn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JU1k9NEn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C68C4CEE5;
	Tue,  8 Apr 2025 12:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116159;
	bh=947DHtIFq+ESa4TyOk0Rw7gzyJ3o9SC80aPbeNd4zck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JU1k9NEnzoZqxctA28GHKE676ibYMd4RuRimSFrvSYgX3qIAwPrv/ifBut8/tG6WH
	 0iD5N1FnPRqkZ/RptOVkjWloHwd/bz+kCTTYGTy4azws48GOmke6AMAhBIJ3eIN9dP
	 b0NHFJrm3DVho59f9nlu7hMRuFFVn2ReQrjB8+No=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 036/423] auxdisplay: panel: Fix an API misuse in panel.c
Date: Tue,  8 Apr 2025 12:46:02 +0200
Message-ID: <20250408104846.590634593@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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



