Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86EEA35C6B2;
	Sat, 12 Sep 2026 09:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206025; cv=none; b=f6gG111pfMQ133aG0TnhiPZVayYOo+HMbDMcAFfP4jnjGaP+w6Ij2SYb5mWUgqrc3+C2ir//pEPN9SCRSTHJybeFBoUda+gWQIQxEtoRpyYcNem8IYhKSu7kcinHfdYfiBVdQOiZOGEZSi+46wc/x+JfSJ4EPdQKkZYNElofJUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206025; c=relaxed/simple;
	bh=ZJmJLDV4LXG9lSmZU5FZwPyeFdenxKYw6HUpmtSoSUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qsDG+9YNeubhQv02CCnixwAwEWjKQvNHAeA6LoQR6XFUg4i9DQhwIvJAJ2LAv9aOD5G3WL1IzesFxfqkke0t236S30YbA08I0/oKZvZJQmCCmF+iwZSxSN0ZGo0UHKOWRINxHsn1n4s5lHYedV+8N3oL5WoZg8O0hZjX9dYhlcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JamTWcvP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JamTWcvP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B1C1F000FF;
	Sat, 12 Sep 2026 09:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206023;
	bh=Z2jWEbmtv3lsE7zsyJbgmEm5vJsC9x9Cji04EkD6tyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JamTWcvPy1F2W/ffSi1v8qJtZeOTASd0P40VgNsVIYq5z42hvnZWRBAwaqDDo4Hm3
	 L3nPAiYkpHrQeKiLlpCemdjDijIejJld1pl9rpEABkdrTLVSzBCkFnXgtgr71+K7pv
	 OaiJahllD+fRgan1/AyKfDdS5N9xkdYYXsVUX8uE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christos Maragkos <whitetowersoftware@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0120/1518] HID: nintendo: Fix imu_timestamp_us double increment per report
Date: Sat, 12 Sep 2026 08:38:09 +0200
Message-ID: <20260912065626.203441941@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index d5f049424f080..34642352b439d 100644
--- a/drivers/hid/hid-nintendo.c
+++ b/drivers/hid/hid-nintendo.c
@@ -1453,7 +1453,6 @@ static void joycon_parse_imu_report(struct joycon_ctlr *ctlr,
 		dropped_threshold = ctlr->imu_avg_delta_ms * 3 / 2;
 		dropped_pkts = (delta - min(delta, dropped_threshold)) /
 				ctlr->imu_avg_delta_ms;
-		ctlr->imu_timestamp_us += 1000 * ctlr->imu_avg_delta_ms;
 		if (dropped_pkts > JC_IMU_DROPPED_PKT_WARNING) {
 			hid_warn_ratelimited(ctlr->hdev,
 				 "compensating for %u dropped IMU reports\n",
-- 
2.53.0



