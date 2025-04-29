Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333F2227E95;
	Tue, 29 Apr 2025 18:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950185; cv=none; b=IsJI5QkHWeWc8dHdQogqYBT7jl269+XQb28oL/V83wBiaHYoOgE0kF/FChW1eYXXY9x6oMrGnA+XonkCOxsoqSY/xq+HA4cT2Fq129u1rVurC8YPPUepqSrg/zzi/NwpeGz3VgR/kqEQj1P5V0G04N/C7SFlAQVmipSxGP+hpCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950185; c=relaxed/simple;
	bh=JyUDHCZNeGwkyOIIzY4Ihp4s5Dv5TqIulrNirTOnsdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c5vJJ4E71IRX6T3Hv3Q2EOpnwAIBL1PbRsm/3d1bLtfQ/604DMWakQ8LwghB13zmzlT83p8i/2cSpCOOGNddoWL9+yge85TnFeWE42wvS7TEbGU9a9zhsg65gxadwtZEMyuC4WE3uwaUs8zy5BLgFixNKhWWeDt2C8r+FFayN/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pj0GKBzh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pj0GKBzh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB3C8C4CEE3;
	Tue, 29 Apr 2025 18:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950185;
	bh=JyUDHCZNeGwkyOIIzY4Ihp4s5Dv5TqIulrNirTOnsdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pj0GKBzhixDXnHHh6JI80pnD8jhb8tAzY6U3TqMM8hmw/BhdAv1gA4zkT2LjrVxQA
	 OMdK/Oj2al2D9jgVZ4wJiWtSTSJMKtCkTjRC3AV4R/qtPdyzUnCNCElQ20LduU8zP8
	 iAeWCuEEtmqGPO8FttNny5EUJoRv6R+T3GYyEB5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/204] auxdisplay: hd44780: Fix an API misuse in hd44780.c
Date: Tue, 29 Apr 2025 18:41:43 +0200
Message-ID: <20250429161100.046167223@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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



