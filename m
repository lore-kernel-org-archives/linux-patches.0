Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CF635971B;
	Fri,  9 Jan 2026 12:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961216; cv=none; b=d+D5eBuv1O3HIapWea58ur1gkapM/TFdL3WdZePXoJ2MOfo2hf417y907o4/uDihKNrc4fkRU+rGnaCXG+Q4h8E14q8qgkOVDf0k80QEcCuxz0xV7VvkjAeZ6GYZC1rqUuNrHVdHuBoEWQ8P4MyGSdjFYZ7WklPJMRY3w1sWaZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961216; c=relaxed/simple;
	bh=nHZRJvfK7oVJBf2ydpTVY5/iFBluFsdsS8iEhlmowgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCnVgL073Q7omtqYMi2y9tqBVgeUTVOV/YB0kfbdFPiPTtrPozX2tP98SpLY3WKSK3u6PNSXXLUsz1GyvxFyaZoEAvfVhEQrNtenik0Gmb+Pfy5NWyAEFKTwJcH8o59YN7S2AvM6yGAVpjn2mYkmNJvyZQTk4Qa3ZpC1beckMQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DJRR0VDL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DJRR0VDL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA7EC4CEF1;
	Fri,  9 Jan 2026 12:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961216;
	bh=nHZRJvfK7oVJBf2ydpTVY5/iFBluFsdsS8iEhlmowgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DJRR0VDLN7HIbahqvVm3AsRpe3zXyNDN5csjR9UUt7LLz5HE5GRBqN74xOdbXhPif
	 fuvPijzss1JtLtrgdq+MRE8dOsL2iOyrD6no2LZiYXGEcoYt/wJfYlu5dkQuMrHhv3
	 AgLxQgyFVewqXM8zmB+kK+by8fU1qpXgYGO1jkbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seunghwan Baek <sh8267.baek@samsung.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 643/737] scsi: ufs: core: Add ufshcd_update_evt_hist() for UFS suspend error
Date: Fri,  9 Jan 2026 12:43:02 +0100
Message-ID: <20260109112158.202608671@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Seunghwan Baek <sh8267.baek@samsung.com>

[ Upstream commit c9f36f04a8a2725172cdf2b5e32363e4addcb14c ]

If UFS resume fails, the event history is updated in ufshcd_resume(), but
there is no code anywhere to record UFS suspend. Therefore, add code to
record UFS suspend error event history.

Fixes: dd11376b9f1b ("scsi: ufs: Split the drivers/scsi/ufs directory")
Cc: stable@vger.kernel.org
Signed-off-by: Seunghwan Baek <sh8267.baek@samsung.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Link: https://patch.msgid.link/20251210063854.1483899-2-sh8267.baek@samsung.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufshcd.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10182,7 +10182,7 @@ static int ufshcd_suspend(struct ufs_hba
 	ret = ufshcd_setup_clocks(hba, false);
 	if (ret) {
 		ufshcd_enable_irq(hba);
-		return ret;
+		goto out;
 	}
 	if (ufshcd_is_clkgating_allowed(hba)) {
 		hba->clk_gating.state = CLKS_OFF;
@@ -10193,6 +10193,9 @@ static int ufshcd_suspend(struct ufs_hba
 	ufshcd_vreg_set_lpm(hba);
 	/* Put the host controller in low power mode if possible */
 	ufshcd_hba_vreg_set_lpm(hba);
+out:
+	if (ret)
+		ufshcd_update_evt_hist(hba, UFS_EVT_SUSPEND_ERR, (u32)ret);
 	return ret;
 }
 


