Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBD36FDE1;
	Mon, 29 Jan 2024 17:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548494; cv=none; b=r2TJHt1qHq/1BIpECNDW5CR/oA08zeyRzw4ZFLSN/aJgQ7U+x21Jujolr2+Yz/Bu4BuU5y7uYlfii2+USEtmNqQMwfTCQSTYPQhCSvXMS8XQfTSPP8cZBGWEaIrVH2FfRPa9uL4inPnBFRsEjNCBjJZUEU/BAvs/VaC05LD8IGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548494; c=relaxed/simple;
	bh=0YxIldNuyZ0Y0ZFPRDtUIN6Cl6XmCmnJNEEvSLwsZxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WEx1N5sPV0qwwXhRcNj9tRQg7NXMhlLfzuKtV+F2tX/OXfhogMrCEt1p409NMjkqyjwvo65c7S939PT0blMV7AeNL76YPB4U5/2B3d87SRniE5XRK3zcajkXIvJvQRdxa5kxlbR/qXCgri0QH7fGJKMGBesc+eEVTYhuuegRRHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oFmE1mzo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oFmE1mzo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38667C433F1;
	Mon, 29 Jan 2024 17:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548494;
	bh=0YxIldNuyZ0Y0ZFPRDtUIN6Cl6XmCmnJNEEvSLwsZxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oFmE1mzoN8ta/E1mRzq/c4JhzVNM2P06pZgfoGOIl/knKHiC8HD17z7Y5wEhRrNXz
	 Lrofn7ba7gH02E4oyy/MDexwSR0F0ogWUnzesS/E10M2sGcC2nwT7dhXxqlcxw2ch8
	 PoUARKS8sRrXjtZULe8kNOSvE2/0kPJ53Zu+UwMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carsten Hatger <xmb8dsv4@gmail.com>,
	=?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.6 119/331] rtc: Extend timeout for waiting for UIP to clear to 1s
Date: Mon, 29 Jan 2024 09:03:03 -0800
Message-ID: <20240129170018.413978019@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit cef9ecc8e938dd48a560f7dd9be1246359248d20 upstream.

Specs don't say anything about UIP being cleared within 10ms. They
only say that UIP won't occur for another 244uS. If a long NMI occurs
while UIP is still updating it might not be possible to get valid
data in 10ms.

This has been observed in the wild that around s2idle some calls can
take up to 480ms before UIP is clear.

Adjust callers from outside an interrupt context to wait for up to a
1s instead of 10ms.

Cc:  <stable@vger.kernel.org> # 6.1.y
Fixes: ec5895c0f2d8 ("rtc: mc146818-lib: extract mc146818_avoid_UIP")
Reported-by: Carsten Hatger <xmb8dsv4@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217626
Tested-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Reviewed-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Acked-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20231128053653.101798-5-mario.limonciello@amd.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/rtc.c          |    2 +-
 drivers/base/power/trace.c     |    2 +-
 drivers/rtc/rtc-cmos.c         |    2 +-
 drivers/rtc/rtc-mc146818-lib.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -67,7 +67,7 @@ void mach_get_cmos_time(struct timespec6
 		return;
 	}
 
-	if (mc146818_get_time(&tm, 10)) {
+	if (mc146818_get_time(&tm, 1000)) {
 		pr_err("Unable to read current time from RTC\n");
 		now->tv_sec = now->tv_nsec = 0;
 		return;
--- a/drivers/base/power/trace.c
+++ b/drivers/base/power/trace.c
@@ -120,7 +120,7 @@ static unsigned int read_magic_time(void
 	struct rtc_time time;
 	unsigned int val;
 
-	if (mc146818_get_time(&time, 10) < 0) {
+	if (mc146818_get_time(&time, 1000) < 0) {
 		pr_err("Unable to read current time from RTC\n");
 		return 0;
 	}
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -231,7 +231,7 @@ static int cmos_read_time(struct device
 	if (!pm_trace_rtc_valid())
 		return -EIO;
 
-	ret = mc146818_get_time(t, 10);
+	ret = mc146818_get_time(t, 1000);
 	if (ret < 0) {
 		dev_err_ratelimited(dev, "unable to read current time\n");
 		return ret;
--- a/drivers/rtc/rtc-mc146818-lib.c
+++ b/drivers/rtc/rtc-mc146818-lib.c
@@ -93,7 +93,7 @@ EXPORT_SYMBOL_GPL(mc146818_avoid_UIP);
  */
 bool mc146818_does_rtc_work(void)
 {
-	return mc146818_avoid_UIP(NULL, 10, NULL);
+	return mc146818_avoid_UIP(NULL, 1000, NULL);
 }
 EXPORT_SYMBOL_GPL(mc146818_does_rtc_work);
 


