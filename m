Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE234F68B8;
	Tue, 13 Oct 2026 12:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894550; cv=none; b=hkron/lCRbZ6ZKYndhG0mic3PgXsqPyl1jMnNWsbBDvpQLipowtYYGEX4jCNKOkGEQWEay8jXvyOtAXcXmDbxMW5fvhZNZzbXxdh0FOfo9commVucGG89ySfYtVGqEkSoSeJc1k32MXVNDvxkgTwIdyo1zZjjvUbLLFKImtlUXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894550; c=relaxed/simple;
	bh=0zogg2aIk7UrflfY1YOBSdYKO6IfKBW6yxGDAYg7TjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bCvAdlhcWRWow1U5/yLBQ6m/smNwqXAEwuXAJBmNJqYEuEmzEu9jGIHEMXg4eArdPodI24AsqGBum+qbypxtRmB9WZhqogklE+NSRa2f1bBouK4v/Q1LGDIKyeTPj370Z6eEtPGajgSrcX+OVBDfcUJ4Iq/InxlStFNvr/1Hzls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jhKit8iH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jhKit8iH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E91D1F00893;
	Tue, 13 Oct 2026 12:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894549;
	bh=/6LVAXrdBPNLZD/iIL9Z95Mg6Uov670rp3agLkkkg3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jhKit8iHgdl7RAZh5fvESo5JUsSbVgNiwihy50JMYhth/UotgJ5eB+PkDAQyb3Sen
	 PGv5DFwZLTufEQin22KauY23Wif/wY3vG1N0rM55fy3Y2bx5M5K67H9Hu0x8etIunM
	 y8XMX8lMnC2RNXx64ch/71RCdFScA2thzGiuBlxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 598/621] ptp: ocp: fix PCIe delay estimation calculation
Date: Tue, 13 Oct 2026 13:39:53 +0200
Message-ID: <20261013112934.993924724@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vadim Fedorenko <vadim.fedorenko@linux.dev>

[ Upstream commit f8c8bd159a9bf626dd4921b7746ff481fce8c758 ]

The commit in fixes introduced a high cap for delayas U64_MAX value
while ktime_t is actually s64. This is wrong cap as it becomes negative
value and any comparison to a real delay will fail to update delay
value. Use KTIME_MAX constant as correct max cap for PCIe delay.

The issue was hit in production (a negative value is observed):

  # cat /sys/class/timecard/ocp0/ts_window_adjust
  -3

Fixes: aa05fe67bcd64 ("ptp: ocp: Improve PCIe delay estimation")
Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261007203359.417270-1-vadim.fedorenko@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_ocp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 5260cbf56d115..1893ccee570e3 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -1564,7 +1564,7 @@ ptp_ocp_watchdog(struct timer_list *t)
 static void
 ptp_ocp_estimate_pci_timing(struct ptp_ocp *bp)
 {
-	ktime_t start, end, delay = U64_MAX;
+	ktime_t start, end, delay = KTIME_MAX;
 	u32 ctrl;
 	int i;
 
-- 
2.53.0



