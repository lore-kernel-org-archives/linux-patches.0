Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FCA1219CA1;
	Tue, 12 Nov 2024 10:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408310; cv=none; b=K4207P7q3aAu7tKUt12WIvdb9SX9l4ECcUaGVbwWAjj5ZMTWDFg5y9EFunxgTYaZLzpehr9sORg+pS2447kcGvzXmtnEK2o6Qi76oaWHGstfetKtom6LKFAs8dbIjYhO3ZQPZds6LFJ42hMyxoLveaFchZEN2xcrpxthTFOINY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408310; c=relaxed/simple;
	bh=OEeVy9XabaFem20dzXpojZHfHiygc3PCa2a8SSm8f1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=geXBfvhyvcE0FJ12+23rCX6yLVwW2hRowqqIVPfHsjfKK4Eu+v/1329+OAvh4JN6TAlnMmXdFGuc6grM/gSi5tqw4PanwgKD3iI9qvGLYu9mvd8dqxao/lhboV6gGCS6yOb7Qe7mdKJ5cykkDgqrfeBJl9fOPjpZdCHMyLeMvIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Np4kUpgM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Np4kUpgM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59BEC4CED6;
	Tue, 12 Nov 2024 10:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408310;
	bh=OEeVy9XabaFem20dzXpojZHfHiygc3PCa2a8SSm8f1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Np4kUpgMO6umHRcKZmSifThwy814ErV98WiYCxzv6Y4DNQfvX+x/3DeOdR8M1G+yc
	 jF76UKOR7rZSqg1VgHparyGa+9rE0ia6McHFqWCm2boERVH11BbjQiqFYc48U68OJd
	 vIPRk/jFDXt83KudGk/J6j97MtrPtChSBH0paxno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bean Huo <beanhuo@micron.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.11 123/184] scsi: ufs: core: Start the RTC update work later
Date: Tue, 12 Nov 2024 11:21:21 +0100
Message-ID: <20241112101905.586328610@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit 54c814c8b23bc7617be3d46abdb896937695dbfa upstream.

The RTC update work involves runtime resuming the UFS controller. Hence,
only start the RTC update work after runtime power management in the UFS
driver has been fully initialized. This patch fixes the following kernel
crash:

Internal error: Oops: 0000000096000006 [#1] PREEMPT SMP
Workqueue: events ufshcd_rtc_work
Call trace:
 _raw_spin_lock_irqsave+0x34/0x8c (P)
 pm_runtime_get_if_active+0x24/0x9c (L)
 pm_runtime_get_if_active+0x24/0x9c
 ufshcd_rtc_work+0x138/0x1b4
 process_one_work+0x148/0x288
 worker_thread+0x2cc/0x3d4
 kthread+0x110/0x114
 ret_from_fork+0x10/0x20

Reported-by: Neil Armstrong <neil.armstrong@linaro.org>
Closes: https://lore.kernel.org/linux-scsi/0c0bc528-fdc2-4106-bc99-f23ae377f6f5@linaro.org/
Fixes: 6bf999e0eb41 ("scsi: ufs: core: Add UFS RTC support")
Cc: Bean Huo <beanhuo@micron.com>
Cc: stable@vger.kernel.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20241031212632.2799127-1-bvanassche@acm.org
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufshcd.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8641,6 +8641,14 @@ static int ufshcd_add_lus(struct ufs_hba
 		ufshcd_init_clk_scaling_sysfs(hba);
 	}
 
+	/*
+	 * The RTC update code accesses the hba->ufs_device_wlun->sdev_gendev
+	 * pointer and hence must only be started after the WLUN pointer has
+	 * been initialized by ufshcd_scsi_add_wlus().
+	 */
+	schedule_delayed_work(&hba->ufs_rtc_update_work,
+			      msecs_to_jiffies(UFS_RTC_UPDATE_INTERVAL_MS));
+
 	ufs_bsg_probe(hba);
 	scsi_scan_host(hba->host);
 
@@ -8800,8 +8808,6 @@ static int ufshcd_device_init(struct ufs
 	ufshcd_force_reset_auto_bkops(hba);
 
 	ufshcd_set_timestamp_attr(hba);
-	schedule_delayed_work(&hba->ufs_rtc_update_work,
-			      msecs_to_jiffies(UFS_RTC_UPDATE_INTERVAL_MS));
 
 	/* Gear up to HS gear if supported */
 	if (hba->max_pwr_info.is_valid) {


