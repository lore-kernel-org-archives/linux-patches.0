Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87438346FB8;
	Tue,  6 Jan 2026 17:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720328; cv=none; b=GkNpdf8T5ZweI0XgQPgw+PGsyOiudIE4uiTZTVC69QfPHDYQlcFg0fERAbWVYKhQep68DT0rJhQoheNJtoJjCPGLa5YniqbmT7cymmf56cBAxoEkNRI4DKZULHoEFY/u0nlv0KP4kydKg2ZQSrNtLILeJ5jg5hcXZAQbPfpEdcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720328; c=relaxed/simple;
	bh=hpNgxLfm1xzbAkYy/VpehEkqwV84KcNTBjjFbicOyxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvA0z5acDxC4znXQtJpYU6vjuUi6j+EGaksBLJAPtNhr5+gkBK5Z+lGbSJ2jbQJ0ZbsJFr6WvU12/DdBgzmI9e83kTcoxVHnFOI5D8XNWc3/7DPWPLJPTNNv3VfTZJUC54P8kDE1XGYgZ1V8LqARp9kSUI9HTO+/9omyZGqbkCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=14rG9LAZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="14rG9LAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F0AC19423;
	Tue,  6 Jan 2026 17:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720328;
	bh=hpNgxLfm1xzbAkYy/VpehEkqwV84KcNTBjjFbicOyxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=14rG9LAZBpYfNsvCYrNEUdX7eWGmRHEfXYHdqkOMPa8cJYC+Na3px83Wxk2KchDoP
	 hkyS472HsfKRj5Lq9dUf2qdt6f2LLwW6UQ1cSuvE+kRlTY7LpOP1i/258r88f7r0JN
	 ZGtRw1ogUMGDJiaWVJwqAvSGcH7/psL0XwteaxQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seunghwan Baek <sh8267.baek@samsung.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 202/567] scsi: ufs: core: Add ufshcd_update_evt_hist() for UFS suspend error
Date: Tue,  6 Jan 2026 17:59:44 +0100
Message-ID: <20260106170458.797762864@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Seunghwan Baek <sh8267.baek@samsung.com>

commit c9f36f04a8a2725172cdf2b5e32363e4addcb14c upstream.

If UFS resume fails, the event history is updated in ufshcd_resume(), but
there is no code anywhere to record UFS suspend. Therefore, add code to
record UFS suspend error event history.

Fixes: dd11376b9f1b ("scsi: ufs: Split the drivers/scsi/ufs directory")
Cc: stable@vger.kernel.org
Signed-off-by: Seunghwan Baek <sh8267.baek@samsung.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Link: https://patch.msgid.link/20251210063854.1483899-2-sh8267.baek@samsung.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufshcd.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10112,7 +10112,7 @@ static int ufshcd_suspend(struct ufs_hba
 	ret = ufshcd_setup_clocks(hba, false);
 	if (ret) {
 		ufshcd_enable_irq(hba);
-		return ret;
+		goto out;
 	}
 	if (ufshcd_is_clkgating_allowed(hba)) {
 		hba->clk_gating.state = CLKS_OFF;
@@ -10124,6 +10124,9 @@ static int ufshcd_suspend(struct ufs_hba
 	/* Put the host controller in low power mode if possible */
 	ufshcd_hba_vreg_set_lpm(hba);
 	ufshcd_pm_qos_update(hba, false);
+out:
+	if (ret)
+		ufshcd_update_evt_hist(hba, UFS_EVT_SUSPEND_ERR, (u32)ret);
 	return ret;
 }
 


