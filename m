Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FDB36CE19;
	Sat, 17 Oct 2026 17:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258254; cv=none; b=REi+r5MxubUeXuLarCz5SNup/KU1pr+G+LbjLv/+LzZc8tl293eXqNDD7YP0mWbKssh+TeehLos+ZyxxTiDk0a/VeEJEUU+xZ5KM8ung3aI91mmrAEhkyN1pboUbAYXgaCw5wEd0ZHq4pdMoHpC5sJfkXZpiDb4W5gw08hC1kJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258254; c=relaxed/simple;
	bh=N0f4FE2SjTCmIRco0KJKVDKdLJkW6ezD9+Fq5/HdUw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/pXQJN3GEAdEjJ8ab+I7+ijmayzZSZFxQ+hPu5S488vNcZ6PgwtUe13xz1GYCvgzN6SvnZa4tyl2DLDPy2Fr+YBoyhsjSs74WTnnUbQJv+KF7bZmbzNIxq060d3H92YadX4GBKoD5xQubM1QKeCRorzxspUME0fFAoljVxNZQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WCK3aIyd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WCK3aIyd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2DA01F000C4;
	Sat, 17 Oct 2026 17:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258253;
	bh=BITMzxxh/hIofNSx7UBaiwgNlwXkH3dGseCOWkcdVD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WCK3aIyd6dSZL+1DKEd7fNLKwOFyNBVWiHDrKulM+oNbcNNgvAJIcFYqtI0EGS6tM
	 ISEmA7NmMXt3vAqxtSA8aDjnGe7asqNTciJGf7lYFvLQ7xRCUUwhNrfdJDAMOZ+Mgl
	 RlHeFGrdXHOZMnJjk6pATqS37y3L9pa7fGNPTT0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Rawat <nitin.rawat@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0823/1674] scsi: ufs: ufs-qcom: Fix UFS OCP issue during UFS power down (PC=3)
Date: Sat, 17 Oct 2026 17:51:35 +0200
Message-ID: <20261017160452.252247567@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Nitin Rawat <nitin.rawat@oss.qualcomm.com>

[ Upstream commit 5127be409c6c3815c4a7d8f6d88043e44f9b9543 ]

According to UFS specifications, the power-off sequence for a UFS device
includes:

 - Sending an SSU command with Power_Condition=3 and await a response.

 - Asserting RST_N low.

 - Turning off REF_CLK.

 - Turning off VCC.

 - Turning off VCCQ/VCCQ2.

As part of ufs shutdown, after the SSU command completion, asserting
hardware reset (HWRST) triggers the device firmware to wake up and
execute its reset routine. This routine initializes hardware blocks and
takes a few milliseconds to complete. During this time, the ICCQ draws a
large current.

This large ICCQ current may cause issues for the regulator which is
supplying power to UFS, because the turn off request from UFS driver to
the regulator framework will be immediately followed by low power
mode(LPM) request by regulator framework. This is done by framework
because UFS which is the only client is requesting for disable. So if
the rail is still in the process of shutting down while ICCQ exceeds LPM
current thresholds, and LPM mode is activated in hardware during this
state, it may trigger an overcurrent protection (OCP) fault in the
regulator.

To prevent this, a 10ms delay is added after asserting HWRST. This
allows the reset operation to complete while power rails remain active
and in high-power mode.

Currently there is no way for Host to query whether the reset is
completed or not and hence this the delay is based on experiments with
Qualcomm UFS controllers across multiple UFS vendors.

Signed-off-by: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20251012173828.9880-1-nitin.rawat@oss.qualcomm.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-qcom.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index c9bd44ef64870..d639df475bcab 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -740,8 +740,21 @@ static int ufs_qcom_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
 
 
 	/* reset the connected UFS device during power down */
-	if (ufs_qcom_is_link_off(hba) && host->device_reset)
+	if (ufs_qcom_is_link_off(hba) && host->device_reset) {
 		ufs_qcom_device_reset_ctrl(hba, true);
+		/*
+		 * After sending the SSU command, asserting the rst_n
+		 * line causes the device firmware to wake up and
+		 * execute its reset routine.
+		 *
+		 * During this process, the device may draw current
+		 * beyond the permissible limit for low-power mode (LPM).
+		 * A 10ms delay, based on experimental observations,
+		 * allows the UFS device to complete its hardware reset
+		 * before transitioning the power rail to LPM.
+		 */
+		usleep_range(10000, 11000);
+	}
 
 	return ufs_qcom_ice_suspend(host);
 }
-- 
2.53.0



