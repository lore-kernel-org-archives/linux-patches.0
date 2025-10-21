Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1879258EDF;
	Tue, 21 Oct 2025 20:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076942; cv=none; b=B9il85F+jonWGC90ipcFC+IBDewHft1YZoHVAundEz6PGdfmsJDsNY/OOhEQ/fy/usyOaizo+8HNB8Z2e0g3ZpcHxKIWkhoJhSQgbALhXAAIAfjVqhUZySmSxu8pqPDPIU5/hZojzscNRcLDIl7PQKueDdewJ7CJnXulKZD1x3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076942; c=relaxed/simple;
	bh=es6Ag6khfp4m9CWJamkrc+o5uPlVFhLCvcpejNHRDwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sk4yzD8EI+9v6OtIXJ8sg1UBsj0Y5QPCYMgUWSq5OVfCKzLIrR4ZcxILRsNO3e+UiVv/DvHjTo3wOeziq2HDVMEsEmx7NKAiL8gt7mVj90+/5HqobT2xbXvixIQi1zRm/wf3HYUOSO5kuZau+iuu+oc1cRheh19tJqeN5XfniSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CwC99rPn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CwC99rPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E20CC4CEF1;
	Tue, 21 Oct 2025 20:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076942;
	bh=es6Ag6khfp4m9CWJamkrc+o5uPlVFhLCvcpejNHRDwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CwC99rPnC6hxDpBNwZeFfR/YFE9S4rFnp4JmHOlHiQVGeJHUpW7aCeY4nCRE3qIc4
	 8oYh8Lb53D5RN2vfSCYZBReTjd6XOf7DZFN1FdRThBD5l/xcnQQk3CER6F1eW+homf
	 bstc1ZABxpYZGs10j+BjK/gt2VTdkW72myBoAG8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Carl Vanderlip <carl.vanderlip@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 084/136] accel/qaic: Fix bootlog initialization ordering
Date: Tue, 21 Oct 2025 21:51:12 +0200
Message-ID: <20251021195037.983870167@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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
index 20b653d99e524..5ed49daaf541f 100644
--- a/drivers/accel/qaic/qaic_debugfs.c
+++ b/drivers/accel/qaic/qaic_debugfs.c
@@ -251,6 +251,9 @@ static int qaic_bootlog_mhi_probe(struct mhi_device *mhi_dev, const struct mhi_d
 	if (ret)
 		goto destroy_workqueue;
 
+	dev_set_drvdata(&mhi_dev->dev, qdev);
+	qdev->bootlog_ch = mhi_dev;
+
 	for (i = 0; i < BOOTLOG_POOL_SIZE; i++) {
 		msg = devm_kzalloc(&qdev->pdev->dev, sizeof(*msg), GFP_KERNEL);
 		if (!msg) {
@@ -266,8 +269,6 @@ static int qaic_bootlog_mhi_probe(struct mhi_device *mhi_dev, const struct mhi_d
 			goto mhi_unprepare;
 	}
 
-	dev_set_drvdata(&mhi_dev->dev, qdev);
-	qdev->bootlog_ch = mhi_dev;
 	return 0;
 
 mhi_unprepare:
-- 
2.51.0



