Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA8A363C70;
	Tue, 16 Dec 2025 12:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887757; cv=none; b=Y4AXgZ78lmmoWF5Km9UIiB5X54zQR32pYVmjABWPI1SpHT5QYj1BZFw4e+TnwGVKM+PTKWCnWRywb6htS5bWxERwCOiOploLm7K4qugIvrNRlwCaHWf5lCbqE8kUhgoALE++LwtF0x+ytwOdshZFDvU3uH476/tKxgkw7tVRx94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887757; c=relaxed/simple;
	bh=8/XcvrO77IIY9Cmp6UBbkpNcUV0Bj2wwtuLk+uh7Rt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BVhvYHdhVnoYBOTPXhB+s2iE+V1W6ilpC1KMEAAY2WxcXuyxwsRgnN+/qRPMJgQv+mwjl1iUOmYBWRl5p/FC14GrExE7dnN5g2xoayxC0iKidnrdir6aAvz9YSjtZx/waTmofrmy8Md43b6hebP4wMlaR+5gdpnPj/gi31T4PUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cqKleGU5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cqKleGU5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B439C4CEF1;
	Tue, 16 Dec 2025 12:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887757;
	bh=8/XcvrO77IIY9Cmp6UBbkpNcUV0Bj2wwtuLk+uh7Rt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cqKleGU5UBkMNZKP7813eWSjsscGDSVN0EaxssCD9tbkat3xrQ5FgDOGNyDzFFkIP
	 y4D2ppgZFcvCw93cCg6uk/PlVnmbhWV3qWNUyAznVdOwOH28UFvzlorhnloZHl3rUG
	 QqGMasBkuiRDVnqHEDN1g2+UCnrqKbZekDRJBgEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 329/614] scsi: ufs: rockchip: Reset controller on PRE_CHANGE of hce enable notify
Date: Tue, 16 Dec 2025 12:11:36 +0100
Message-ID: <20251216111413.286408305@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Shawn Lin <shawn.lin@rock-chips.com>

[ Upstream commit b0ee72db9132bd19b1b80152b35e0cf6a6cbd9f2 ]

This fixes the dme-reset failed when doing recovery. Because device
reset is not enough, we could occasionally see the error below:

ufshcd-rockchip 2a2d0000.ufs: uic cmd 0x14 with arg3 0x0 completion timeout
ufshcd-rockchip 2a2d0000.ufs: dme-reset: error code -110
ufshcd-rockchip 2a2d0000.ufs: DME_RESET failed
ufshcd-rockchip 2a2d0000.ufs: ufshcd_host_reset_and_restore: Host init failed -110

Fix this by resetting the controller on PRE_CHANGE stage of hce enable
notify.

Fixes: d3cbe455d6eb ("scsi: ufs: rockchip: Initial support for UFS")
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Link: https://patch.msgid.link/1763009575-237552-1-git-send-email-shawn.lin@rock-chips.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-rockchip.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/ufs/host/ufs-rockchip.c b/drivers/ufs/host/ufs-rockchip.c
index 8754085dd0ccf..8cecb28cdce41 100644
--- a/drivers/ufs/host/ufs-rockchip.c
+++ b/drivers/ufs/host/ufs-rockchip.c
@@ -20,9 +20,17 @@
 #include "ufshcd-pltfrm.h"
 #include "ufs-rockchip.h"
 
+static void ufs_rockchip_controller_reset(struct ufs_rockchip_host *host)
+{
+	reset_control_assert(host->rst);
+	udelay(1);
+	reset_control_deassert(host->rst);
+}
+
 static int ufs_rockchip_hce_enable_notify(struct ufs_hba *hba,
 					 enum ufs_notify_change_status status)
 {
+	struct ufs_rockchip_host *host = ufshcd_get_variant(hba);
 	int err = 0;
 
 	if (status == POST_CHANGE) {
@@ -37,6 +45,9 @@ static int ufs_rockchip_hce_enable_notify(struct ufs_hba *hba,
 		return ufshcd_vops_phy_initialization(hba);
 	}
 
+	/* PRE_CHANGE */
+	ufs_rockchip_controller_reset(host);
+
 	return 0;
 }
 
@@ -156,9 +167,7 @@ static int ufs_rockchip_common_init(struct ufs_hba *hba)
 		return dev_err_probe(dev, PTR_ERR(host->rst),
 				"failed to get reset control\n");
 
-	reset_control_assert(host->rst);
-	udelay(1);
-	reset_control_deassert(host->rst);
+	ufs_rockchip_controller_reset(host);
 
 	host->ref_out_clk = devm_clk_get_enabled(dev, "ref_out");
 	if (IS_ERR(host->ref_out_clk))
@@ -282,9 +291,7 @@ static int ufs_rockchip_runtime_resume(struct device *dev)
 		return err;
 	}
 
-	reset_control_assert(host->rst);
-	udelay(1);
-	reset_control_deassert(host->rst);
+	ufs_rockchip_controller_reset(host);
 
 	return ufshcd_runtime_resume(dev);
 }
-- 
2.51.0



