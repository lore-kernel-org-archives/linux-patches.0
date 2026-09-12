Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0FB30FF08;
	Sat, 12 Sep 2026 13:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221241; cv=none; b=WYeabOaP+b8ZQnOZ6uYyLnAsJTBLifVE2fh0/lqIFvZ03khNmJ67b43H9TJS9ssx/9Us/g9/CK1H9Sq1QkqNKsCyQ6PcoETmFbXHY/4AAi4Lpxrg5UPia8paXudFJAN8PO/LnX4MDbKG8tchK6GDS2HUlBKn+ccRaGSgXxNWB88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221241; c=relaxed/simple;
	bh=KYM+TEqNhbNq70k6UGrKzqeXIij6HL+jTeYgB+M2SMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SsXLfqZpEPHN5r02Ov19Ox0ixh5ECSN3lXnQ4GEYJp7VtdspJ3UFzRimmPdcmX/14L865tgL0JGmov5tFOl3E6EPKqgqIWZGeyyRfT88diy20CSOEkqtRKYGmUz62Bya8/on5fxhb3vFagTvwn5UPEYa1tYChOMlQetAW0ceAGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VhtBExEc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VhtBExEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA361F000FF;
	Sat, 12 Sep 2026 13:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221240;
	bh=3Cq44EKi4S9vrb2ag5dMrKin10ESSkeg04kvEMzyhVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VhtBExEcf49Ejj+yaRcDZLHTQdyWkH1PwX3tSlLJqM0qSIxhI/V2MDORBA1gLXbTB
	 Qlx6Lb13fDkPofi3UrZT9dEkmQi22gYyjIrQe4BF3IaoYMrSraAhuYb+3SvKVcdbkm
	 SAjb5P7R1uOAlVCdLClwdI5SWl5Zk9W4JRmG4Q3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 0340/1424] spi: bcm63xx: disable clock on resume failure
Date: Sat, 12 Sep 2026 08:46:12 +0200
Message-ID: <20260912065614.899367068@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Can Peng <pengcan@kylinos.cn>

commit 2b62c2c134fa32d9d3a9e7323c8ac74518eeb4ac upstream.

bcm63xx_spi_resume() enables the controller clock before restarting the
SPI controller queue.

If spi_controller_resume() fails, the function currently reports success
and leaves the clock enabled. Propagate the error and disable the clock
before returning.

Fixes: b42dfed83d95 ("spi: add Broadcom BCM63xx SPI controller driver")
Cc: stable@vger.kernel.org
Signed-off-by: Can Peng <pengcan@kylinos.cn>
Link: https://patch.msgid.link/20260804071831.860784-1-pengcan@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-bcm63xx.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -661,7 +661,11 @@ static int bcm63xx_spi_resume(struct dev
 	if (ret)
 		return ret;
 
-	spi_controller_resume(host);
+	ret = spi_controller_resume(host);
+	if (ret) {
+		clk_disable_unprepare(bs->clk);
+		return ret;
+	}
 
 	return 0;
 }


