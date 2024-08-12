Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2CF1494B8;
	Mon, 12 Aug 2024 16:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480433; cv=none; b=G7+t7Eyl5ZjfPv0/gDFUdLFQc6r5r1dBz0PXAfwUHBKrmu+xD2kkjnJNwj8S06ORuLIFuDEqNUATnUIwAlinSgMsg0sgxCdm8FpDRd1lQh+N751MDiR5kysy26asZFA49+SRZEpbJ74Stjfi8RVnhiq6NlqDPK6o1dFs962O2Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480433; c=relaxed/simple;
	bh=4gOR3IiO3z4uewJFLrKZgcOVyMjMsjbtfIBTon6oOHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNJjg0gltXcgGSLqkEW6e4jGQdi4+by6oO+pr6BK0i40uzhHgxu6zkoH8oA2lV4Z9ugAhf60gMDvyzQdrVMN+1R8UBGZLABkl0294Na2EHYZLZsF5KiPvTcZM3f1rAdCGA9n7dgMwm6pYeyp9Q/Xw2BHE+5jQ7PQMJYbf7/0xKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1/cKX4IG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1/cKX4IG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19DFBC32782;
	Mon, 12 Aug 2024 16:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480433;
	bh=4gOR3IiO3z4uewJFLrKZgcOVyMjMsjbtfIBTon6oOHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1/cKX4IGs/4qblGoeiVcptheHHngriVJ4ddaUHcWpeXxXQxpHdqf7AlSzy15lf/WP
	 jospJpdFqeDv/Zg01aE+wk0DREWeBf/kLOAQRkhmmt1lVG/t+oxCHyI//vH4R1Giq9
	 aj4D9jDHK3eFAxCZfqSOld50D6WEvNSuSsjqJvls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.10 195/263] scsi: ufs: core: Fix deadlock during RTC update
Date: Mon, 12 Aug 2024 18:03:16 +0200
Message-ID: <20240812160154.009344740@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Wang <peter.wang@mediatek.com>

commit 3911af778f208e5f49d43ce739332b91e26bc48e upstream.

There is a deadlock when runtime suspend waits for the flush of RTC work,
and the RTC work calls ufshcd_rpm_get_sync() to wait for runtime resume.

Here is deadlock backtrace:

kworker/0:1     D 4892.876354 10 10971 4859 0x4208060 0x8 10 0 120 670730152367
ptr            f0ffff80c2e40000 0 1 0x00000001 0x000000ff 0x000000ff 0x000000ff
<ffffffee5e71ddb0> __switch_to+0x1a8/0x2d4
<ffffffee5e71e604> __schedule+0x684/0xa98
<ffffffee5e71ea60> schedule+0x48/0xc8
<ffffffee5e725f78> schedule_timeout+0x48/0x170
<ffffffee5e71fb74> do_wait_for_common+0x108/0x1b0
<ffffffee5e71efe0> wait_for_completion+0x44/0x60
<ffffffee5d6de968> __flush_work+0x39c/0x424
<ffffffee5d6decc0> __cancel_work_sync+0xd8/0x208
<ffffffee5d6dee2c> cancel_delayed_work_sync+0x14/0x28
<ffffffee5e2551b8> __ufshcd_wl_suspend+0x19c/0x480
<ffffffee5e255fb8> ufshcd_wl_runtime_suspend+0x3c/0x1d4
<ffffffee5dffd80c> scsi_runtime_suspend+0x78/0xc8
<ffffffee5df93580> __rpm_callback+0x94/0x3e0
<ffffffee5df90b0c> rpm_suspend+0x2d4/0x65c
<ffffffee5df91448> __pm_runtime_suspend+0x80/0x114
<ffffffee5dffd95c> scsi_runtime_idle+0x38/0x6c
<ffffffee5df912f4> rpm_idle+0x264/0x338
<ffffffee5df90f14> __pm_runtime_idle+0x80/0x110
<ffffffee5e24ce44> ufshcd_rtc_work+0x128/0x1e4
<ffffffee5d6e3a40> process_one_work+0x26c/0x650
<ffffffee5d6e65c8> worker_thread+0x260/0x3d8
<ffffffee5d6edec8> kthread+0x110/0x134
<ffffffee5d616b18> ret_from_fork+0x10/0x20

Skip updating RTC if RPM state is not RPM_ACTIVE.

Fixes: 6bf999e0eb41 ("scsi: ufs: core: Add UFS RTC support")
Cc: stable@vger.kernel.org # 6.9.x
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Link: https://lore.kernel.org/r/20240715063831.29792-1-peter.wang@mediatek.com
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufshcd-priv.h |    5 +++++
 drivers/ufs/core/ufshcd.c      |    5 ++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -329,6 +329,11 @@ static inline int ufshcd_rpm_get_sync(st
 	return pm_runtime_get_sync(&hba->ufs_device_wlun->sdev_gendev);
 }
 
+static inline int ufshcd_rpm_get_if_active(struct ufs_hba *hba)
+{
+	return pm_runtime_get_if_active(&hba->ufs_device_wlun->sdev_gendev);
+}
+
 static inline int ufshcd_rpm_put_sync(struct ufs_hba *hba)
 {
 	return pm_runtime_put_sync(&hba->ufs_device_wlun->sdev_gendev);
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8171,7 +8171,10 @@ static void ufshcd_update_rtc(struct ufs
 	 */
 	val = ts64.tv_sec - hba->dev_info.rtc_time_baseline;
 
-	ufshcd_rpm_get_sync(hba);
+	/* Skip update RTC if RPM state is not RPM_ACTIVE */
+	if (ufshcd_rpm_get_if_active(hba) <= 0)
+		return;
+
 	err = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR, QUERY_ATTR_IDN_SECONDS_PASSED,
 				0, 0, &val);
 	ufshcd_rpm_put_sync(hba);


