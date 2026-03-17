Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5274B264A9D;
	Tue, 17 Mar 2026 16:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765438; cv=none; b=aF1Gw5GkBjUim47xS7QV456h4t1SVEeW4ZdQ2TGT++9EYrqwOmDR3PDSOdxlAzbQlPsP+EUFt/LHp9PB6f811wAmzulOcWexpEUrSwHVc97jJu5SOaM2c+IZo2k40BqNuSbspbKgVsqUfWc+K/YgHNHTFeLu2DtrSfATjv0uVRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765438; c=relaxed/simple;
	bh=Nt1QBZbpBfk71m2yN58VkX7lhapHB3GWhFJbntOCJig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S4MzglKl9DouqzPKvqu1/+Va8kr6I4E7wH34kVXYAaf1oe4cCfweFm8/eDi/rmuDbmNvYcEtVlUOlRYIUuxpB3wnR6a6oK3XqFl1R1aQQrO4jIbdlbY6WJGaBQSNncezHpmto08nDtIQj8wfLhCpAGL6P4PbjqT81UCiqI66sds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dWKtYxj5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dWKtYxj5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D0AC4CEF7;
	Tue, 17 Mar 2026 16:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765437;
	bh=Nt1QBZbpBfk71m2yN58VkX7lhapHB3GWhFJbntOCJig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dWKtYxj5i0VvveHC1JVetaSzV8B4BysENtPQnt6vqYTt9g35iREA+kUtEnyAfygpn
	 C6YSxtnnjtnBXvMDMKgwzem81KGJlZExyqemVww3CuQ46ava36ieMVyEm4mQvBb3X9
	 uQcjM2+18Hp0qp2Z2k+VLhxMZkTUw4ds2k9lK5yE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Won Jung <wone.jung@samsung.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 011/378] scsi: ufs: core: Reset urgent_bkops_lvl to allow runtime PM power mode
Date: Tue, 17 Mar 2026 17:29:28 +0100
Message-ID: <20260317163007.387491798@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Won Jung <wone.jung@samsung.com>

[ Upstream commit 5b313760059c9df7d60aba7832279bcb81b4aec0 ]

Ensures that UFS Runtime PM can achieve power saving after System PM
suspend by resetting hba->urgent_bkops_lvl. Also modify the
ufshcd_bkops_exception_event_handler to avoid setting urgent_bkops_lvl when
status is 0, which helps maintain optimal power management.

On UFS devices supporting UFSHCD_CAP_AUTO_BKOPS_SUSPEND, a BKOPS exception
event can lead to a situation where UFS Runtime PM can't enter low-power
mode states even after the BKOPS exception has been resolved.

BKOPS exception with bkops status 0 occurs, the driver logs:

 "ufshcd_bkops_exception_event_handler: device raised urgent BKOPS exception for bkops status 0"

When a BKOPS exception occurs, ufshcd_bkops_exception_event_handler() reads
the BKOPS status and sets hba->urgent_bkops_lvl to BKOPS_STATUS_NO_OP(0).
This allows the device to perform Runtime PM without changing the UFS power
mode.  (__ufshcd_wl_suspend(hba, UFS_RUNTIME_PM))

During system PM suspend, ufshcd_disable_auto_bkops() is called, disabling
auto bkops. After UFS System PM Resume, when runtime PM attempts to suspend
again, ufshcd_urgent_bkops() is invoked. Since hba->urgent_bkops_lvl
remains at BKOPS_STATUS_NO_OP(0), ufshcd_enable_auto_bkops() is triggered.

However, in ufshcd_bkops_ctrl(), the driver compares the current BKOPS
status with hba->urgent_bkops_lvl, and only enables auto bkops if
curr_status >= hba->urgent_bkops_lvl.  Since both values are 0, the
condition is met

As a result, __ufshcd_wl_suspend(hba, UFS_RUNTIME_PM) skips power mode
transitions and remains in an active state, preventing power saving even
though no urgent BKOPS condition exists.

Signed-off-by: Won Jung <wone.jung@samsung.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Link: https://patch.msgid.link/1891546521.01770806581968.JavaMail.epsvc@epcpadp2new
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 80fafad339c75..6f9c5d7012812 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5971,6 +5971,7 @@ static int ufshcd_disable_auto_bkops(struct ufs_hba *hba)
 
 	hba->auto_bkops_enabled = false;
 	trace_ufshcd_auto_bkops_state(hba, "Disabled");
+	hba->urgent_bkops_lvl = BKOPS_STATUS_PERF_IMPACT;
 	hba->is_urgent_bkops_lvl_checked = false;
 out:
 	return err;
@@ -6074,7 +6075,7 @@ static void ufshcd_bkops_exception_event_handler(struct ufs_hba *hba)
 	 * impacted or critical. Handle these device by determining their urgent
 	 * bkops status at runtime.
 	 */
-	if (curr_status < BKOPS_STATUS_PERF_IMPACT) {
+	if ((curr_status > BKOPS_STATUS_NO_OP) && (curr_status < BKOPS_STATUS_PERF_IMPACT)) {
 		dev_err(hba->dev, "%s: device raised urgent BKOPS exception for bkops status %d\n",
 				__func__, curr_status);
 		/* update the current status as the urgent bkops level */
-- 
2.51.0



