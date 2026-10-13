Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41224EBAD7;
	Tue, 13 Oct 2026 11:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892598; cv=none; b=Bwp764rSzxJmBnFgg9J/U3b7+JFldybDB9K+INX7EEwhx7oEIQ+mnkXSWdklFv84b9bL1TgZGOV9UgiEJ27haJgOJ4fjMjGSErvTG6RQVxeU1o/QKSnyANIl39DTRNVL0Y9yjyqgB+59UrdEPQfopGPHFNZncirNL/DQcohj2Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892598; c=relaxed/simple;
	bh=jhbwSbIyl/bEUpl9n1VbggR4T3uTYT7MAIU8+bkibLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jVqsJxiBRHaMVkYY5itmDlxMTbR+4KBePD3/RWGIXgu+mQMayZGNyBzq+HxwuP7MMFSvoPKnaabM485BgPXZxSIStA8P/njPgytIlrIAJaKtuFX9Rifwr73Nts9EU51LUztSSbeHgqCp9+0IP0ENLl/cMDSxcv+ug9O8WuiAj1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gXYnxcwA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gXYnxcwA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22FF21F00899;
	Tue, 13 Oct 2026 11:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892596;
	bh=5GY279LmnRn+L/O30PdZZSLLI0y18+1X59ppH2KgdWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gXYnxcwAkGfZaVN+cfd+XZZYiapib1yDWQwtIs1UuIPDGgJzF3Ww8kEeeOo+Y5htP
	 Awi3CUbdpUoG1XtcktukXryNALsLbWpnIgwwNN7oGrxFYXPqvkbFgeySEJ8pJ0sIvO
	 rlhqji0+qQaAdd28B5eywNHj4N0W/kFFIRJq4PoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Stanley Jhu <stanleyjhu@google.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 227/281] scsi: ufs: mediatek: Handle mPHY power-on failures
Date: Tue, 13 Oct 2026 13:39:03 +0200
Message-ID: <20261013112900.664220250@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <hppiscas@163.com>

[ Upstream commit 78e04810542da416d3bead707b60cec773f1524d ]

The MediaTek helper enables VA09 before powering on the mPHY, but ignores
the PHY result. A failure can leave VA09 enabled and publish
mphy_powered_on as true, so a later power-on attempt is skipped.

Check phy_power_on(), attempt to unwind VA09 on failure, and leave the
state flag unchanged. Propagate the helper result from host initialization
as well as its existing resume caller. Keep the original PHY error if the
supply rollback also fails, and report that rollback separately.

The issue was found by our static-analysis tool.

Fixes: 561e3a8726b2 ("scsi: ufs-mediatek: Fix unbalanced clock on/off")
Fixes: cf137b3ea49a ("scsi: ufs-mediatek: Support VA09 regulator operations")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Stanley Jhu <stanleyjhu@google.com>
Link: https://patch.msgid.link/20260920034953.19535-1-hppiscas@163.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-mediatek.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 3991a51263a6d..a2defbe3b7483 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -509,6 +509,7 @@ static int ufs_mtk_mphy_power_on(struct ufs_hba *hba, bool on)
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 	struct phy *mphy = host->mphy;
 	struct arm_smccc_res res;
+	int err;
 	int ret = 0;
 
 	if (!mphy || !(on ^ host->mphy_powered_on))
@@ -523,7 +524,18 @@ static int ufs_mtk_mphy_power_on(struct ufs_hba *hba, bool on)
 			usleep_range(200, 210);
 			ufs_mtk_va09_pwr_ctrl(res, 1);
 		}
-		phy_power_on(mphy);
+		ret = phy_power_on(mphy);
+		if (ret) {
+			if (ufs_mtk_is_va09_supported(hba)) {
+				ufs_mtk_va09_pwr_ctrl(res, 0);
+				err = regulator_disable(host->reg_va09);
+				if (err)
+					dev_err(hba->dev,
+						"failed to unwind va09: %d\n", err);
+			}
+			dev_err(hba->dev, "failed to enable mphy: %d\n", ret);
+			return ret;
+		}
 	} else {
 		phy_power_off(mphy);
 		if (ufs_mtk_is_va09_supported(hba)) {
@@ -1295,7 +1307,9 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 	 *
 	 * Enable phy clocks specifically here.
 	 */
-	ufs_mtk_mphy_power_on(hba, true);
+	err = ufs_mtk_mphy_power_on(hba, true);
+	if (err)
+		goto out_variant_clear;
 
 	if (ufs_mtk_is_rtff_mtcmos(hba)) {
 		/* First Restore here, to avoid backup unexpected value */
-- 
2.53.0



