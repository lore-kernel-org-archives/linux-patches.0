Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5FA03BE175;
	Sat, 12 Sep 2026 07:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196935; cv=none; b=gkLQnRIlwJz62DJ6lKDj5EqOPEIpCuvl+gHjG19FPjiwrf8/T4BvFleU3FhcfZbseWgfmYzNepS4o2v9CcIhiEU3NehahgPtH1WBWzM/5Oq3hWdmGG1VwDj5RcFOKI4eJxVcnXRidnsO0RuAfnlg4faZEkZyJ9EMdtHavSwZ4fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196935; c=relaxed/simple;
	bh=hAn7w1jORgecdAmU+hrFXZqAh2GAeNZBWp7ZYtuAaQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VNfqHs25mjTlrY8mtVF7kqEEi4ftscCa/qlHhV4G3SGd6a3l1sDdAr4uXVfWJg9AvOAcKea4jAR1U/ZC77wa4CvBueKomTjwc0u5Dldn13Q12D7QuOpFT0+8BWu1VXJPnfOAC2Rxssp3Kx+zz5Wi7piLO7P4CJ/Jfv0CSBX9eCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DC+ct73g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DC+ct73g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76A51F000FF;
	Sat, 12 Sep 2026 07:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196933;
	bh=KvuHcCVkLQD/EC1xMkJNkTp/FXZ3K23EO3URDEcVxIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DC+ct73g9sdI3Cqi3h+N/lZOs0KIYKxoy67/rCImoq1mbEvSRrB6jSuUMPS7fu6Ax
	 UoaLP9uGXaGe0cKh3D1S7z2SPyyUsuYGTjn1kkqBFqbQeIzSIqmz6nw5zzcbj607BI
	 pd4SegUbtLS0+cY6UpeSy3kWYrhWgpRtisD7a9dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christos Maragkos <whitetowersoftware@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0067/1815] HID: nintendo: Fix imu_timestamp_us double increment per report
Date: Sat, 12 Sep 2026 08:30:17 +0200
Message-ID: <20260912065650.585890070@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index f3c8a4a364002..4ee402e2f9cab 100644
--- a/drivers/hid/hid-nintendo.c
+++ b/drivers/hid/hid-nintendo.c
@@ -1474,7 +1474,6 @@ static void joycon_parse_imu_report(struct joycon_ctlr *ctlr,
 		dropped_threshold = ctlr->imu_avg_delta_ms * 3 / 2;
 		dropped_pkts = (delta - min(delta, dropped_threshold)) /
 				ctlr->imu_avg_delta_ms;
-		ctlr->imu_timestamp_us += 1000 * ctlr->imu_avg_delta_ms;
 		if (dropped_pkts > JC_IMU_DROPPED_PKT_WARNING) {
 			hid_warn_ratelimited(ctlr->hdev,
 				 "compensating for %u dropped IMU reports\n",
-- 
2.53.0



