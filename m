Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB06147ACDD;
	Sat, 12 Sep 2026 12:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214426; cv=none; b=Z8aAjfZmAhMy7eEEXnenM2ECuqoJpJgYo3yxX6B4YW7UhzWdh31bFu0AgUAN6sV1LYols2+iNpQ8jXZtrfd/GjaPfnyRc3VdJUgRm5OuiZyntKmXQhlp2WGEYuSPkBWOBqmC5r2H89PNwrX4G9zd0mPtt0C3kakWcq+7owlSzCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214426; c=relaxed/simple;
	bh=szbLnHCKNTzlUoBQa51/6CHDoj4W7lXSF+HVVkk5IE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sq33jIlEFJDvbvQkD15jp9pER0TiGv0bNfaQYC1FUN5TTWD/wgmxeouel8okvV6fYRhMQAr+olzztrLM0bSdA0pnRgLGairyz7rSEYq/RS4V/4NYvX81YHvbFV6nPbfvZiPf/vDwe+2LQ1yZ6hhJjeiWZBsC2oZTygKApm5Phnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xh2jgiY2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xh2jgiY2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D5C1F00893;
	Sat, 12 Sep 2026 12:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214423;
	bh=NJ1IdB1jSsvPIKFwtWtSjQLWsx6o3U4uL4xppDyx7wE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xh2jgiY2dZf/lYQUJOQzqvyS4IHb+d+tAIIg++GE7YYvp17b3R32wkSlqbOHuAYDC
	 EQAjzOiG8gECc57GtZNWwXIvHoXZ4d1fGPU82U2pEhv4gRtxtn8ZB6HLmw2XwDEJt1
	 jVF6WCrLFgCQRRHw+qOw0TwMy9+2iX+aeDxiiYPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christos Maragkos <whitetowersoftware@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0322/1376] HID: nintendo: Fix imu_timestamp_us double increment per report
Date: Sat, 12 Sep 2026 08:45:48 +0200
Message-ID: <20260912065614.724234594@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christos Maragkos <whitetowersoftware@gmail.com>

[ Upstream commit 1f9b25d3fb65b9384dec16d9db13a3e71abd9145 ]

Previously, the imu_timestamp_us variable was incremented twice per
report, causing it to advance by two times the desired amount.

This resulted in incorrect jumps in IMU timestamps reported using
MSC_TIMESTAMP, so userspace applications saw corrupted timing on
functions such as gyroscope-based aim and motion controls.

This is fixed by removing the redundant increment at the start of the
report handling so the remaining can account for the full report
interval.

Fixes: 4ff5b10840a88 ("HID: nintendo: add IMU support")
Signed-off-by: Christos Maragkos <whitetowersoftware@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-nintendo.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/hid/hid-nintendo.c b/drivers/hid/hid-nintendo.c
index 54a8bdcc0ef72..ea7751b3555c0 100644
--- a/drivers/hid/hid-nintendo.c
+++ b/drivers/hid/hid-nintendo.c
@@ -1457,7 +1457,6 @@ static void joycon_parse_imu_report(struct joycon_ctlr *ctlr,
 		dropped_threshold = ctlr->imu_avg_delta_ms * 3 / 2;
 		dropped_pkts = (delta - min(delta, dropped_threshold)) /
 				ctlr->imu_avg_delta_ms;
-		ctlr->imu_timestamp_us += 1000 * ctlr->imu_avg_delta_ms;
 		if (dropped_pkts > JC_IMU_DROPPED_PKT_WARNING) {
 			hid_warn(ctlr->hdev,
 				 "compensating for %u dropped IMU reports\n",
-- 
2.53.0



