Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3044F2AE96;
	Tue, 29 Apr 2025 18:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949709; cv=none; b=Ut7fWYV5bzy5fWPnewDMCpZExtxQGZSfqqvbpexhJsI7nHi9C5QKCeOapQiypKyW3HtYYM7OBSCEIF7P5rw6iFTKPDiz0rmJiZ5qqzkdWCpbbXcx+cv67W4fLyWUOu/IpQAwztrTfcj+xb5KKt5oziC09sSHZnDrG8CBFAGuXdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949709; c=relaxed/simple;
	bh=wcrilAOrq4g5cUz8hkh+YOyAK0PtBx48xVPBdTjj/3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dVsYJ25aXYMYsGhJIMvcGll/Lebam6Tl0WTv6aFrMCQy6yGF7TbLRD/zErgJEAZjgOU1KjvfX4iPtFW59MFbXktw9H8dCmhmlIZGVq0df5IYr8+3dXY0OdgiA/534bcLcL8b3fpr/v0HRhM9dhebEfzLJ1kQXtqcK7TGb5dL1p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QyH3ONoS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QyH3ONoS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14F2C4CEE9;
	Tue, 29 Apr 2025 18:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949709;
	bh=wcrilAOrq4g5cUz8hkh+YOyAK0PtBx48xVPBdTjj/3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QyH3ONoS7Y2pL6pLvktiFfXpuLU0V+BK5aBjyT41QR1y6tpotQFmuJDHQUHuhnX4y
	 pvR2hvRk1vvWabLNgEPMx2/Qlt/VXX7rDT+Yz3IAqNUiFeLg8sQTe+NuRPRrkayV9E
	 Sp40wUK5U4jf4bQbDSkUkD6YZgHhy1IHtF7X4CTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 009/167] auxdisplay: hd44780: Fix an API misuse in hd44780.c
Date: Tue, 29 Apr 2025 18:41:57 +0200
Message-ID: <20250429161052.128196319@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

[ Upstream commit 9b98a7d2e5f4e2beeff88f6571da0cdc5883c7fb ]

Variable allocated by charlcd_alloc() should be released
by charlcd_free(). The following patch changed kfree() to
charlcd_free() to fix an API misuse.

Fixes: 718e05ed92ec ("auxdisplay: Introduce hd44780_common.[ch]")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/auxdisplay/hd44780.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/auxdisplay/hd44780.c b/drivers/auxdisplay/hd44780.c
index 7ac0b1b1d5482..8b690f59df27d 100644
--- a/drivers/auxdisplay/hd44780.c
+++ b/drivers/auxdisplay/hd44780.c
@@ -313,7 +313,7 @@ static int hd44780_probe(struct platform_device *pdev)
 fail3:
 	kfree(hd);
 fail2:
-	kfree(lcd);
+	charlcd_free(lcd);
 fail1:
 	kfree(hdc);
 	return ret;
@@ -328,7 +328,7 @@ static void hd44780_remove(struct platform_device *pdev)
 	kfree(hdc->hd44780);
 	kfree(lcd->drvdata);
 
-	kfree(lcd);
+	charlcd_free(lcd);
 }
 
 static const struct of_device_id hd44780_of_match[] = {
-- 
2.39.5



