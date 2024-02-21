Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834F253816;
	Wed, 21 Feb 2024 13:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521818; cv=none; b=oqOfT45Fw/AZhzyqkVBWEsgjrmHLC4fFLiX8wfXYe0vTeQ1toJAIFbMo4iZGSSgUPxoSJMlhAGUrqKZVsNyzIjC+jUi2uzXgcrIhG7QzLyQqLA+/BhiM4xYZBe0r9jAn3W5rPXkFjEr8uOp46TxAV4X1683dXCx8iXBrstiReSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521818; c=relaxed/simple;
	bh=vmzbBcMqqvXaDRddqcBX/7h25Gs6wqNQoDBghNXr5QQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fx2TdRUaL5AnarS5Onl6fvbEHxqUjkJyJ571iw7reoWaMmWrXDPf+yTKtmO8vzT7REOrwdfureDVk+ia34q2KBOm7rwyaFNus67CRYVwBpFNbQwRfwq61Nm/uaL0aaySzSLSUYQUUFeRfwUwpUtrB62dYpq0HGPXhcNusd/Hexc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gslk/9ss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gslk/9ss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E502EC433C7;
	Wed, 21 Feb 2024 13:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521818;
	bh=vmzbBcMqqvXaDRddqcBX/7h25Gs6wqNQoDBghNXr5QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gslk/9ssQKtI5lvvRvLIRZURfO7szP7lZ2uhll82FEyedYmkBQPZpKRNfsbkHA3+Q
	 n89+xE5vOGFT6aPuRgZONOYVSZNJG1TGrELc4akH4WE2fvhhf7bF8hF4N8v/qrAio1
	 BO/cBgOMy4r/JTRS15faDLiV4uxpeQgBaIo5H9wU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Can Guo <quic_cang@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 010/476] scsi: ufs: core: Simplify power management during async scan
Date: Wed, 21 Feb 2024 14:01:01 +0100
Message-ID: <20240221130008.250433087@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit daf7795406bf307997366f694888bd317ae5b5fa ]

ufshcd_init() calls pm_runtime_get_sync() before it calls
async_schedule(). ufshcd_async_scan() calls pm_runtime_put_sync() directly
or indirectly from ufshcd_add_lus(). Simplify ufshcd_async_scan() by always
calling pm_runtime_put_sync() from ufshcd_async_scan().

Cc: <stable@vger.kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20231218225229.2542156-2-bvanassche@acm.org
Reviewed-by: Can Guo <quic_cang@quicinc.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: ee36710912b2 ("scsi: ufs: core: Remove the ufshcd_hba_exit() call from ufshcd_async_scan()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e78461f66400..0354e3bce455 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7896,7 +7896,6 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 	ufs_bsg_probe(hba);
 	ufshpb_init(hba);
 	scsi_scan_host(hba->host);
-	pm_runtime_put_sync(hba->dev);
 
 out:
 	return ret;
@@ -8018,15 +8017,15 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 
 	/* Probe and add UFS logical units  */
 	ret = ufshcd_add_lus(hba);
+
 out:
+	pm_runtime_put_sync(hba->dev);
 	/*
 	 * If we failed to initialize the device or the device is not
 	 * present, turn off the power/clocks etc.
 	 */
-	if (ret) {
-		pm_runtime_put_sync(hba->dev);
+	if (ret)
 		ufshcd_hba_exit(hba);
-	}
 }
 
 static const struct attribute_group *ufshcd_driver_groups[] = {
-- 
2.43.0



