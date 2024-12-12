Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E60A213E97;
	Thu, 12 Dec 2024 15:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016299; cv=none; b=k0yfcdW8JgJMV+7I05BZpqKtj2PnYi7XYHCN+0YK1pXuj2ihzmS6L3NU7ilr8rwNshqy2quD3l5ecEn9zm6EV1G/ketryWLfctuuojWAhA5/3NKkOpYJxX87HTkTfZUMx7C/o31IZt0/0ozc45SsRpoQIF89HOkxfmwYFXOqQjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016299; c=relaxed/simple;
	bh=7l8ie7/mOlyiFbWdhNFsR8cIgRFxnTFDSOa4TbVr/OI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFYjHKc/z9psjkROwpX+zQeU/u8hSfPfnD52vnV8yYRdBtur/TdwmUl1EijcDb4sE5meTcRC1frANYEvz70w27ylDpyA5V2cC5QwVOeDvC9ZcT9PqdvuS/szCaBY86LQgHgGqrxQLQRhGCI8z/9Hk27U6wQK/2ER9aBWBYwlT/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1daaKs1V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1daaKs1V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C9DC4CEE3;
	Thu, 12 Dec 2024 15:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016299;
	bh=7l8ie7/mOlyiFbWdhNFsR8cIgRFxnTFDSOa4TbVr/OI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1daaKs1VCzX/4yrgOsVnLRrDy3F2a3aJFLNE1XXuIp6ho+yR/1m7bRTYlXUUCZ2bH
	 ayq8Hr7Bhr4xNaSEQKSHLoRh5qbGn5ZE/pmgbTDfzdOD6M8hwBOnefzDvQ3ehhw2hb
	 5+NUagPFQU8vkj9ToORMHa00HhEq6wU/dSUfvw/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 151/466] scsi: ufs: core: Cancel RTC work during ufshcd_remove()
Date: Thu, 12 Dec 2024 15:55:20 +0100
Message-ID: <20241212144312.761888454@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

commit 1695c4361d35b7bdadd7b34f99c9c07741e181e5 upstream.

Currently, RTC work is only cancelled during __ufshcd_wl_suspend(). When
ufshcd is removed in ufshcd_remove(), RTC work is not cancelled. Due to
this, any further trigger of the RTC work after ufshcd_remove() would
result in a NULL pointer dereference as below:

Unable to handle kernel NULL pointer dereference at virtual address 00000000000002a4
Workqueue: events ufshcd_rtc_work
Call trace:
 _raw_spin_lock_irqsave+0x34/0x8c
 pm_runtime_get_if_active+0x24/0xb4
 ufshcd_rtc_work+0x124/0x19c
 process_scheduled_works+0x18c/0x2d8
 worker_thread+0x144/0x280
 kthread+0x11c/0x128
 ret_from_fork+0x10/0x20

Since RTC work accesses the ufshcd internal structures, it should be cancelled
when ufshcd is removed. So do that in ufshcd_remove(), as per the order in
ufshcd_init().

Cc: stable@vger.kernel.org # 6.8
Fixes: 6bf999e0eb41 ("scsi: ufs: core: Add UFS RTC support")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20241111-ufs_bug_fix-v1-1-45ad8b62f02e@linaro.org
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufshcd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10264,6 +10264,7 @@ void ufshcd_remove(struct ufs_hba *hba)
 	ufs_hwmon_remove(hba);
 	ufs_bsg_remove(hba);
 	ufs_sysfs_remove_nodes(hba->dev);
+	cancel_delayed_work_sync(&hba->ufs_rtc_update_work);
 	blk_mq_destroy_queue(hba->tmf_queue);
 	blk_put_queue(hba->tmf_queue);
 	blk_mq_free_tag_set(&hba->tmf_tag_set);


