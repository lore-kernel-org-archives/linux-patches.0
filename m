Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D214198E96;
	Wed,  6 Nov 2024 12:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896427; cv=none; b=hxXGiMcu3jeqPJWh4C4CTpXdgmi3pGLgSKqe7dVx5FyVu/kTPAJYABbvYWiBR0AuY2VPJitGc7gxRGgIbx39ez1tWBHARriVIO+f4SUXwcYNnHqKt6VjrAo2Ps9R/tOLK8u6pTtfoIzVI0/ZodkbrUkEp4fOEACGrdmuVwbil5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896427; c=relaxed/simple;
	bh=4OG3QqFtdzhKGCexZt/gZXUjzQdX7lPlUiGOAPEtkgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0YUjhxQZv5p5L2BR3N4FEG1bgFVIUK3uc0F/kIUJgvVL9cCcqLHhRL4qDPKnlG4VFoEPwStNw/wxJSDarGYkEf4v7wyccI9fzNmqLTJO6Snv2q/LKGQONS7C/pyiaNTveKv1ZpA0EUhGrLocSglomM7bOne41boYjK1Cd1WiJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PqB1UXPR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PqB1UXPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7921C4CECD;
	Wed,  6 Nov 2024 12:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896427;
	bh=4OG3QqFtdzhKGCexZt/gZXUjzQdX7lPlUiGOAPEtkgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PqB1UXPRi7qBuWvTQVBAOzD/pnWYXOInF1TI4WWQouILbhllrFQUdHVCIl4vCvqnd
	 nkZZn3D1ttzkU6o4Sipyrg/4I0/sv21eYjnD7ihaALGf7PjqXoZji1BW7rIrYnC/mV
	 tmMx0YF6wMd2mqKQKT1WFGzy5J1oNk9MCVuPOKrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 161/245] scsi: ufs: core: Fix another deadlock during RTC update
Date: Wed,  6 Nov 2024 13:03:34 +0100
Message-ID: <20241106120323.199405208@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

From: Peter Wang <peter.wang@mediatek.com>

[ Upstream commit cb7e509c4e0197f63717fee54fb41c4990ba8d3a ]

If ufshcd_rtc_work calls ufshcd_rpm_put_sync() and the pm's usage_count
is 0, we will enter the runtime suspend callback.  However, the runtime
suspend callback will wait to flush ufshcd_rtc_work, causing a deadlock.

Replace ufshcd_rpm_put_sync() with ufshcd_rpm_put() to avoid the
deadlock.

Fixes: 6bf999e0eb41 ("scsi: ufs: core: Add UFS RTC support")
Cc: stable@vger.kernel.org #6.11.x
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Link: https://lore.kernel.org/r/20241024015453.21684-1-peter.wang@mediatek.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 09408642a6efb..83567388a7b58 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8224,7 +8224,7 @@ static void ufshcd_update_rtc(struct ufs_hba *hba)
 
 	err = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR, QUERY_ATTR_IDN_SECONDS_PASSED,
 				0, 0, &val);
-	ufshcd_rpm_put_sync(hba);
+	ufshcd_rpm_put(hba);
 
 	if (err)
 		dev_err(hba->dev, "%s: Failed to update rtc %d\n", __func__, err);
-- 
2.43.0



