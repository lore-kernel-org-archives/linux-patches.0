Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B77C1F75A5;
	Tue,  3 Dec 2024 15:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241579; cv=none; b=EYw1G613/jB6eOlK1c6peveuw88JPasI9h0a/3zhKYrmGHD5OVoCePXyECxfISlc7V1WQs5bv6dA+srazmvZbhEGR+10DygiqGw3yaTZ05dFM3wFxv4MnJ5T3U0uaPxZ/HWxd3V9VLOmSlO3EWIsWfs1XGAEFNQXUYJM1i0oFdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241579; c=relaxed/simple;
	bh=UTOYdG73x+18bi7rjWsEvYMKG9uw+broJ8dmOIj5G/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fvntTiTtDKazwioIPaWhHq4FF7YA56R63jBEAjhOm+HfJl41vFQHLw7CBpjZw0RSpASN8uY4g7uhvEcshiG5KHgfAfuu/6MeNiZom6FYjCNiCbx7A4HL0IhRAbg9ujeny/qg/zQ5mo/Pg+n85qBYmxiHTySMBoy96VzuzKIjmNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v6o392SR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v6o392SR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B76DC4CECF;
	Tue,  3 Dec 2024 15:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241578;
	bh=UTOYdG73x+18bi7rjWsEvYMKG9uw+broJ8dmOIj5G/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v6o392SRpHRaUrK3HqEV/XxOwQKhks3sSthCcK3uiv+FdDLsPb+dQzUZxQH1YK+N3
	 i7tbMOvzclGsZjfT5W1gEFaOGRMB8mJAW/oHpoDQdAiE/qEX8FkyI7eXhdxPQ7j/yX
	 u5m4yPf7sVgJ8r9Qr7TrUA+4ab1RNgcv/bQHPR18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 458/826] RDMA/bnxt_re: Correct the sequence of device suspend
Date: Tue,  3 Dec 2024 15:43:05 +0100
Message-ID: <20241203144801.622266519@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit 68b3bca2df00f0a63f0aa2db2b2adc795665229e ]

When in fatal error condition, mark device as detached first
and then complete all pending HWRM commands as firmware is not
going to process them and eventually time out. Move the device
to error only if suspend is called when device is in Fatal state.

Also, remove some outdated comments. Remove the stop_irq call
which is no longer required.

Fixes: cc5b9b48d447 ("RDMA/bnxt_re: Recover the device when FW error is detected")
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/1731660464-27838-4-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/main.c | 28 +++++-----------------------
 1 file changed, 5 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 9eb290ec71a85..2ac8ddbed576f 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -2033,12 +2033,6 @@ static int bnxt_re_suspend(struct auxiliary_device *adev, pm_message_t state)
 	rdev = en_info->rdev;
 	en_dev = en_info->en_dev;
 	mutex_lock(&bnxt_re_mutex);
-	/* L2 driver may invoke this callback during device error/crash or device
-	 * reset. Current RoCE driver doesn't recover the device in case of
-	 * error. Handle the error by dispatching fatal events to all qps
-	 * ie. by calling bnxt_re_dev_stop and release the MSIx vectors as
-	 * L2 driver want to modify the MSIx table.
-	 */
 
 	ibdev_info(&rdev->ibdev, "Handle device suspend call");
 	/* Check the current device state from bnxt_en_dev and move the
@@ -2046,17 +2040,12 @@ static int bnxt_re_suspend(struct auxiliary_device *adev, pm_message_t state)
 	 * This prevents more commands to HW during clean-up,
 	 * in case the device is already in error.
 	 */
-	if (test_bit(BNXT_STATE_FW_FATAL_COND, &rdev->en_dev->en_state))
+	if (test_bit(BNXT_STATE_FW_FATAL_COND, &rdev->en_dev->en_state)) {
 		set_bit(ERR_DEVICE_DETACHED, &rdev->rcfw.cmdq.flags);
-
-	bnxt_re_dev_stop(rdev);
-	bnxt_re_stop_irq(adev);
-	/* Move the device states to detached and  avoid sending any more
-	 * commands to HW
-	 */
-	set_bit(BNXT_RE_FLAG_ERR_DEVICE_DETACHED, &rdev->flags);
-	set_bit(ERR_DEVICE_DETACHED, &rdev->rcfw.cmdq.flags);
-	wake_up_all(&rdev->rcfw.cmdq.waitq);
+		set_bit(BNXT_RE_FLAG_ERR_DEVICE_DETACHED, &rdev->flags);
+		wake_up_all(&rdev->rcfw.cmdq.waitq);
+		bnxt_re_dev_stop(rdev);
+	}
 
 	if (rdev->pacing.dbr_pacing)
 		bnxt_re_set_pacing_dev_state(rdev);
@@ -2075,13 +2064,6 @@ static int bnxt_re_resume(struct auxiliary_device *adev)
 	struct bnxt_re_dev *rdev;
 
 	mutex_lock(&bnxt_re_mutex);
-	/* L2 driver may invoke this callback during device recovery, resume.
-	 * reset. Current RoCE driver doesn't recover the device in case of
-	 * error. Handle the error by dispatching fatal events to all qps
-	 * ie. by calling bnxt_re_dev_stop and release the MSIx vectors as
-	 * L2 driver want to modify the MSIx table.
-	 */
-
 	bnxt_re_add_device(adev, BNXT_RE_POST_RECOVERY_INIT);
 	rdev = en_info->rdev;
 	ibdev_info(&rdev->ibdev, "Device resume completed");
-- 
2.43.0



