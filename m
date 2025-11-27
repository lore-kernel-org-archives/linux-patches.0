Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D6D3115A6;
	Thu, 27 Nov 2025 15:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255909; cv=none; b=rXbubzgcbhX0YiZcwTqZFNvtg1PXIHG8QUrgKQ6IO+02ZdN7SoWfhovHN3v0jNQPHttzExjUunX/g6kU9mWn1KwaY71yZ0LVIDk5iPBXw2TsKHTM0Lxj4HBEoz2TAv1wlCY/0MLltbH00QmQp5HRXnhSYIHTHGDKPml8AfKZI6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255909; c=relaxed/simple;
	bh=ivG98NkGe7rzidzrakgWxzV3U5OqOfPh9xpfYUxpHt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mdz7DlulV8TnnokRQfuoFnHpt7ZwimqVA9lDW2A2tiAI1gmsVZ9TqXPfjAkHNIc44yttjxvRZIsBVfXccqr/A6iRhquoMj15Eo+JligwgTm9ez8iQMQjOu/FqH95AoaITefY92TZLpnlBAIUjzl7eAoA/2MWfefq2MXaTMXlXjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hm51teLw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hm51teLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3496C4CEF8;
	Thu, 27 Nov 2025 15:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255909;
	bh=ivG98NkGe7rzidzrakgWxzV3U5OqOfPh9xpfYUxpHt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hm51teLwo6lhOfmOS29TO9J0S5zE4plSAGFSAWPL8jEdXjbsbCINayBJu99KvBB7F
	 fAn8yWOF/+syy6f9u/q6j5gn1B83s6bRBLV5ObLdjzmsyS7OxVf2L3nWbRGvtetqve
	 UNCPkftXlS+VL61PGlnI6DKdDs1A5KIo5E78z4qA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Rawat <nitin.rawat@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 156/175] scsi: ufs: ufs-qcom: Fix UFS OCP issue during UFS power down (PC=3)
Date: Thu, 27 Nov 2025 15:46:49 +0100
Message-ID: <20251127144048.651250493@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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
index 2b6eb377eec07..f14c124c103b3 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -744,8 +744,21 @@ static int ufs_qcom_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
 
 
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
2.51.0



