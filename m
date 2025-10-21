Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B424C1A3029;
	Tue, 21 Oct 2025 20:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077491; cv=none; b=A5TMb2tiLb3wdtRwXdm6IojB7XLjcuNbMfmBhoOw7cwwUM1PpCq5eImW0/QhlOJsiwg1Y/0wukPiEZVLa+hWvLStUKCdCFfZuTHkcuILc2MBT6klwG/Zh791sKQ4OKPjqGMOAZNMp0WH2KhKiZWV/6yTCWpKPaL/yxYNRiaHnXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077491; c=relaxed/simple;
	bh=9K571ufwIIbj+kFB2xUsh06ZnwJsrN/JyAK895KZpQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gy7mxu0Qed4Er6pOVxxvj5eFUM8SrLcSpIuifCa8P+YGoMaXf/C9cQZ8QxHjJiWWPcYDmO/hAIPfKyrIGS12CMomMemRagLb4GY1nt2FHbbKEj3LZFFuG9wOj9YMehLT9afzvbVDaw5syj5HjjYWn7XXK9QU/DkCBj9ujyeBUmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IC9zIrqt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IC9zIrqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB645C4CEF1;
	Tue, 21 Oct 2025 20:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077491;
	bh=9K571ufwIIbj+kFB2xUsh06ZnwJsrN/JyAK895KZpQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IC9zIrqt45bHscWpKIdwFO/DQZ641AvTZjY2KrUG8yRUSAwV43D06bBEqPpAShdeF
	 o/dadl5CTvTWWVuM2aGlUWfAnkgSA9x1EcyiOSbvJ4KBgrTJ0Wy7hwiqhUA0VMY+q9
	 8jBUFu56EYis0xYAas6D4Zt8hoJexfWp/TanHQZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Carl Vanderlip <carl.vanderlip@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 121/159] accel/qaic: Fix bootlog initialization ordering
Date: Tue, 21 Oct 2025 21:51:38 +0200
Message-ID: <20251021195046.067614985@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeffrey Hugo <quic_jhugo@quicinc.com>

[ Upstream commit fd6e385528d8f85993b7bfc6430576136bb14c65 ]

As soon as we queue MHI buffers to receive the bootlog from the device,
we could be receiving data. Therefore all the resources needed to
process that data need to be setup prior to queuing the buffers.

We currently initialize some of the resources after queuing the buffers
which creates a race between the probe() and any data that comes back
from the device. If the uninitialized resources are accessed, we could
see page faults.

Fix the init ordering to close the race.

Fixes: 5f8df5c6def6 ("accel/qaic: Add bootlog debugfs")
Signed-off-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Signed-off-by: Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Reviewed-by: Carl Vanderlip <carl.vanderlip@oss.qualcomm.com>
Signed-off-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251007115750.332169-1-youssef.abdulrahman@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/qaic/qaic_debugfs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/accel/qaic/qaic_debugfs.c b/drivers/accel/qaic/qaic_debugfs.c
index a991b8198dc40..8dc4fe5bb560e 100644
--- a/drivers/accel/qaic/qaic_debugfs.c
+++ b/drivers/accel/qaic/qaic_debugfs.c
@@ -218,6 +218,9 @@ static int qaic_bootlog_mhi_probe(struct mhi_device *mhi_dev, const struct mhi_d
 	if (ret)
 		goto destroy_workqueue;
 
+	dev_set_drvdata(&mhi_dev->dev, qdev);
+	qdev->bootlog_ch = mhi_dev;
+
 	for (i = 0; i < BOOTLOG_POOL_SIZE; i++) {
 		msg = devm_kzalloc(&qdev->pdev->dev, sizeof(*msg), GFP_KERNEL);
 		if (!msg) {
@@ -233,8 +236,6 @@ static int qaic_bootlog_mhi_probe(struct mhi_device *mhi_dev, const struct mhi_d
 			goto mhi_unprepare;
 	}
 
-	dev_set_drvdata(&mhi_dev->dev, qdev);
-	qdev->bootlog_ch = mhi_dev;
 	return 0;
 
 mhi_unprepare:
-- 
2.51.0



