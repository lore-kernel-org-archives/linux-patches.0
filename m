Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8E71DE4EF;
	Sat, 12 Sep 2026 14:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222372; cv=none; b=pyeGMyPvxVTBymoJIICPWIWSXyDmyYJggMv0RxhoOUeF7xr+QyORUqd7dUBQTYzDer/nyS1cgxHfPgarXLIsnyhoQXSk1cBfNebZEMsUqT8+9nIahUdlkcD8ubp037wE2c8dnHyJN0Lrd3poB6dWF2Wp9Fwjmbw7U25xMNgG3I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222372; c=relaxed/simple;
	bh=JkFhAidlgQOcmuohNLWVrwWCuz93oV+CvQmuc5//xx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GKr4FKljKCKFu0P9wDkZyrMDd44lypaxEZOC/hLpr3tZJXzW5mkt8KOVqY2xCkrzDJDww528pra4FQQvz2Rl4Ke5mVNh89TSo1u8a33Wi2B+WrUP6Cis8/9Z+/Sxgs0j2SStbb9rwaPrbYkmoeazlRBni0MbQAAOf29JYHE8g84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CuEgUM7N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CuEgUM7N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28AF1F000FF;
	Sat, 12 Sep 2026 14:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222371;
	bh=gTxg9OnLdIebmBNjhl9mkIjvodUmvCIuaL47FiWgp1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CuEgUM7NVJzXnUmeWoG120wV2HlTr7Pi1VbKmkR0uHW3cbtSDz2tnEQi4ljxFnVkA
	 clTUiSAMr1NjHUY65/oOtsUZlDveHOOun8QFkdYk2BkPobKN1nkmN8pgVHaN/mC5j4
	 BVRR5rrE425/bvP6WfwwUnlPtihPRn9Sz7TOCWyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christos Maragkos <whitetowersoftware@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0572/1424] HID: nintendo: Fix imu_timestamp_us double increment per report
Date: Sat, 12 Sep 2026 08:50:04 +0200
Message-ID: <20260912065620.110406938@linuxfoundation.org>
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
index a69b04ffbb2be..115f496368e58 100644
--- a/drivers/hid/hid-nintendo.c
+++ b/drivers/hid/hid-nintendo.c
@@ -1164,7 +1164,6 @@ static void joycon_parse_imu_report(struct joycon_ctlr *ctlr,
 		dropped_threshold = ctlr->imu_avg_delta_ms * 3 / 2;
 		dropped_pkts = (delta - min(delta, dropped_threshold)) /
 				ctlr->imu_avg_delta_ms;
-		ctlr->imu_timestamp_us += 1000 * ctlr->imu_avg_delta_ms;
 		if (dropped_pkts > JC_IMU_DROPPED_PKT_WARNING) {
 			hid_warn(ctlr->hdev,
 				 "compensating for %u dropped IMU reports\n",
-- 
2.53.0



