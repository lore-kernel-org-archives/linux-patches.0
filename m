Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063505;
	b=33r+h5MpXdIcPYwyDRn3ev78zyZNvjGgQR38nJ8lXLV+hV7BKlZr8d9qTBQUHrFyknl5
	 dG+JdmcHOc9O2MHM7Q2ZsLAgEBxP1bfBrOTIT2pZMXHrU4DN6y4Tv0A/pFFUcmfnTtrNQ
	 1LuHHHSAE8KSFbeQdSoaoIyiSrQ7InaydjsLX6YdV6g0CsEOnSpErGSVQTYSFZlvakW1R
	 Aq9YeYL7xYK3/qjqnyMZiLCMhUflO7B72Sok7f2eaWulGfCG3rFKfoXActXNRdsrsab0m
	 TpRP1hFGUr+fB6RL+mk5YSuTbiUjHPOT419nfQtdkioRNz9UtZl0V8M7y2oz5UPugrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063505;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ltaYXsZ8V/N6Q11B9PL6M+HLLqxqxE2gzF5RsGzDFr0=;
	b=d7tumxR81+aAOO091iJTQN/Vu2R9960sYO42gxq3lXteZ54bxE7c/tZ23PZ7mtrsby/i
	 My3ywoZyT698WVnUwaDd5PdcFGgPtAor0cl7fZ6aMjq3kTrpuZFPd/05zJiKLTg2dr/BY
	 EOHPivlQnE4eob5TpVujf/QWoxsz1MDBmkkb/8SvaQSTWd3mqjmsyU1EH5C12UmlwbtyY
	 btSdAcx2YE+ENNlcg9O0pXOeOLsZhl1FKrk69++P7LPgIDU8In39yz4WHSBuyFjtzkABq
	 PtD11FtXg6wATigkoePdacD+4gAlZCIpUvVwO1XH60sT85ojUVRYCg9A8yhFgtZUc4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jhWVUwm2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9432B606A338;
	Sat,  7 Nov 2026 14:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jhWVUwm2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414DE1F008A1;
	Sat,  7 Nov 2026 14:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063505;
	bh=ltaYXsZ8V/N6Q11B9PL6M+HLLqxqxE2gzF5RsGzDFr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jhWVUwm2pPm2RhYDwi3wd9atcv+1u5Wfs4JivFpnbWJn31ECPqh6ZaKb4myc5ACV1
	 oO9dv43bVbtzZCTQV176ey+fQR+bBj9qSOXxdOgMtEl18Vh+9LftgPCxlgQBEUHLh2
	 xGwi1HIlKnSFRdo6Y7WR7GZ6sYlRL6yUFnLAJLe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 650/869] platform/x86/amd/pmc: Fix RTC reference leak in amd_pmc_verify_czn_rtc()
Date: Sat,  7 Nov 2026 08:55:32 -0500
Message-ID: <20261107134915.080410436@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make_ruc2021@163.com>

[ Upstream commit 22b9306f1fcf86f80b55f05f08d10a9951ba970a ]

amd_pmc_verify_czn_rtc() opens the RTC with rtc_class_open(), which
takes both a device reference and a module reference on the RTC
driver. The matching release is rtc_class_close(), and it is never
called. Every return path after the device has been opened, the ones
that return 0 as well as the ones that report an error, leaves both
references behind, so each S0i3 suspend leaks them.

Release the reference with a __free() cleanup on the declaration,
which covers every return path without adding labels.

rtc_class_close() does not accept a NULL argument, so the cleanup
helper has to guard against one: rtc_class_open() may fail and the
declaration still has to be cleaned up.

Found by code review.

Fixes: 59348401ebed ("platform/x86: amd-pmc: Add special handling for timer based S0i3 wakeup")
Cc: stable@vger.kernel.org
Signed-off-by: Ma Ke <make_ruc2021@163.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/20261011121759.3267678-1-make_ruc2021@163.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc/pmc.c | 5 +++--
 include/linux/rtc.h                | 2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/amd/pmc/pmc.c b/drivers/platform/x86/amd/pmc/pmc.c
index fea41c8c1899a..8abb80e1803f9 100644
--- a/drivers/platform/x86/amd/pmc/pmc.c
+++ b/drivers/platform/x86/amd/pmc/pmc.c
@@ -14,6 +14,7 @@
 #include <linux/array_size.h>
 #include <linux/bitfield.h>
 #include <linux/bits.h>
+#include <linux/cleanup.h>
 #include <linux/debugfs.h>
 #include <linux/delay.h>
 #include <linux/dmi.h>
@@ -554,7 +555,6 @@ static int amd_pmc_wa_irq1(struct amd_pmc_dev *pdev)
 
 static int amd_pmc_verify_czn_rtc(struct amd_pmc_dev *pdev, u32 *arg)
 {
-	struct rtc_device *rtc_device;
 	time64_t then, now, duration;
 	struct rtc_wkalrm alarm;
 	struct rtc_time tm;
@@ -570,7 +570,8 @@ static int amd_pmc_verify_czn_rtc(struct amd_pmc_dev *pdev, u32 *arg)
 	if (pdev->major < 64 || (pdev->major == 64 && pdev->minor < 53))
 		return 0;
 
-	rtc_device = rtc_class_open("rtc0");
+	struct rtc_device *rtc_device __free(rtc_class_close) =
+		rtc_class_open("rtc0");
 	if (!rtc_device)
 		return 0;
 	rc = rtc_read_alarm(rtc_device, &alarm);
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 95da051fb155d..116ac3cd5d54e 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -13,6 +13,7 @@
 #define _LINUX_RTC_H_
 
 
+#include <linux/cleanup.h>
 #include <linux/types.h>
 #include <linux/interrupt.h>
 #include <linux/nvmem-provider.h>
@@ -199,6 +200,7 @@ extern void rtc_update_irq(struct rtc_device *rtc,
 
 extern struct rtc_device *rtc_class_open(const char *name);
 extern void rtc_class_close(struct rtc_device *rtc);
+DEFINE_FREE(rtc_class_close, struct rtc_device *, if (_T) rtc_class_close(_T));
 
 extern int rtc_irq_set_state(struct rtc_device *rtc, int enabled);
 extern int rtc_irq_set_freq(struct rtc_device *rtc, int freq);
-- 
2.53.0



