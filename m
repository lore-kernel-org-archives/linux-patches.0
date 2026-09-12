Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39E535677C;
	Sat, 12 Sep 2026 16:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228873; cv=none; b=u0uVpYtvHAri++bphVX7Kz5V59hLgD8I2jTB4DMH0tvx/mn375fVOIjFxAHFTsTBORHOuFqMRcErDgf6sLVU079SCat/0Ww0I973jjFAErpvilSWa5592U4YI5mw/D/g4RxSJzaUIf4hcyQZ1j7zlOBSk+a+f2zbMxauP65Iqrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228873; c=relaxed/simple;
	bh=OuuNrTZ1pq2e1ZmVahywlnNiBTez0NGt6I7z/FHKnzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ptpSimafN2YosJ5shSGYBOBK21Y5Bl0oxuvYUXEqLKRLM5YlBtQFkJzIRXWDbwNtHQ0lHlGFoOGlGic5Dq2gew6G9sIxWki66px/uLbBkWKOD+98lSQEis7mvIKvHj2nwBmT5vZbfvADwIAgkntOXXTDqO33lG3IbfyaxheebsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d6Hgj1hO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d6Hgj1hO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987C51F000FF;
	Sat, 12 Sep 2026 16:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228872;
	bh=d4mtQ2+sBL193SBPPqdsmSTKjt7EqZXLa6Obej8PV9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d6Hgj1hOmFYOfswZBz78fbdv5wwcE57lBcLwB9oKWmD1bQIKQ0WnjMIS46srSpeW6
	 AmxhYtWlidKCGmzCSiZohs3xjmj1DxrRMjQ+h96BkcL8MeIYV3ccD/FeTAlbUhp08m
	 ayDH1pvsENxHQvBd0+XuKVJ5PiOWPQ2F2Sbca81k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christos Maragkos <whitetowersoftware@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0475/1191] HID: nintendo: Fix imu_timestamp_us double increment per report
Date: Sat, 12 Sep 2026 08:53:23 +0200
Message-ID: <20260912065558.903298438@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 924f84a04dd04..44edc50be6e56 100644
--- a/drivers/hid/hid-nintendo.c
+++ b/drivers/hid/hid-nintendo.c
@@ -1127,7 +1127,6 @@ static void joycon_parse_imu_report(struct joycon_ctlr *ctlr,
 		dropped_threshold = ctlr->imu_avg_delta_ms * 3 / 2;
 		dropped_pkts = (delta - min(delta, dropped_threshold)) /
 				ctlr->imu_avg_delta_ms;
-		ctlr->imu_timestamp_us += 1000 * ctlr->imu_avg_delta_ms;
 		if (dropped_pkts > JC_IMU_DROPPED_PKT_WARNING) {
 			hid_warn(ctlr->hdev,
 				 "compensating for %u dropped IMU reports\n",
-- 
2.53.0



