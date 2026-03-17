Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856392FFDEA;
	Tue, 17 Mar 2026 17:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767174; cv=none; b=RuZPPZnxhG7vXD+8LQnhchHJCOR+ZNFoz5Z0WadPusd2PQaie/adXkdv7dtaIe0bxsHQSZ6VcTv+4sPbJWH9xUWzOOQvS/g/Dxg6xrwvpHINHjwyWt8wpP7QzDb45Wnzl8ixfMACmLuKneK5IXtAsAo1fBvNX0v6hyVzaYl5NCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767174; c=relaxed/simple;
	bh=oGwMvBdv2hRGD4agtBZDULxYKk/FQtulUwOem8MmoNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ey0ErFYpqiENqiL36Upk1r4WzszO56GikBTZCMojSs3f2waAO5jUQnfNc0mWS8ouxGN6VfZM3JvZWkMYir57FZK+snwKsy8sChq1Hd89D6OPB2ghzxZ/UWSZxUAbIxOhP/vh4rNPw+jaUiIUJMiiBEE1rqIDjQB7UlMT657bZLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PnuU92pN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PnuU92pN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D85C19424;
	Tue, 17 Mar 2026 17:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767174;
	bh=oGwMvBdv2hRGD4agtBZDULxYKk/FQtulUwOem8MmoNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PnuU92pNZuZiUoqCmNDPxeoxOoKevYs0iI4SO3XZQ15uG4TvT3DcR3EIyK9uV7CMn
	 0nIuSJf4+FA41Jtw88HyYtSibuk0EhMmQ0O0Pss+Sp7Nl0Xo6AFAeid6VMZpXjTTMU
	 3l/rvKhnxCoNtGtNyOlWEgCsn+mWENvWtBZcSmdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Won Jung <wone.jung@samsung.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 003/333] scsi: ufs: core: Reset urgent_bkops_lvl to allow runtime PM power mode
Date: Tue, 17 Mar 2026 17:30:32 +0100
Message-ID: <20260317162959.482673791@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index dae23ec4fcea8..4f7fc28207245 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5946,6 +5946,7 @@ static int ufshcd_disable_auto_bkops(struct ufs_hba *hba)
 
 	hba->auto_bkops_enabled = false;
 	trace_ufshcd_auto_bkops_state(hba, "Disabled");
+	hba->urgent_bkops_lvl = BKOPS_STATUS_PERF_IMPACT;
 	hba->is_urgent_bkops_lvl_checked = false;
 out:
 	return err;
@@ -6049,7 +6050,7 @@ static void ufshcd_bkops_exception_event_handler(struct ufs_hba *hba)
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



