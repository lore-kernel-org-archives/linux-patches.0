Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808D7136E00;
	Thu, 13 Jun 2024 12:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280889; cv=none; b=gSke4jWEDfm7g7jqTuKln2V+JzjOVG/lDBuJbjja7wXmiWiJ7CDG7lwLeh6gISBQxg1kgsi0A+0NfJFC/Rqn0nqacr9Z1J6TvLW/ioFjT3jKLgXtAqWrPWL+96SbqfhJOD9s6uHLyF1nYlNbpYXiY6stopzk+OXKiQ/ZKxv7m0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280889; c=relaxed/simple;
	bh=dwCppj40wsaMi3BUUyD7xF1w2mzJ/CEfMsnB65H+gds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ECWzZ6iqTViF5rUlekNQr35sedVV0mhXZ08QUbDi+2Tl+TqEI0CIH8LCjCAPAgoyxCVWSOs0MGs40gXFJC9Y8I65O65mqLxTFHylpQOhTblXUwPAxhOVyR+ST0TqAbWtbF6ObW4diDyQedUfGm2FohNF9k0DzGuOwj34aQtWNy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yXVnQZ/C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yXVnQZ/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3AB7C2BBFC;
	Thu, 13 Jun 2024 12:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280889;
	bh=dwCppj40wsaMi3BUUyD7xF1w2mzJ/CEfMsnB65H+gds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yXVnQZ/CKTmIEprPfXCEH8wsss+cITGH93XZvYTGJb3tXn8AbG1BrCa0cYDKr3nbz
	 gJ4WPQDPOSEzTmpUmQ4momdsV5tLcLObG9vK55XQalbR4shNtQ2CApEwENb+x3oJTE
	 rUSFyk99jPZAreUDdR+IVzDa88ONgvJWbLC1DlcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avri Altman <avri.altman@wdc.com>,
	Ziqi Chen <ziqichen@codeaurora.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/317] scsi: ufs-qcom: Fix ufs RST_n spec violation
Date: Thu, 13 Jun 2024 13:30:56 +0200
Message-ID: <20240613113249.021341250@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ziqi Chen <ziqichen@codeaurora.org>

[ Upstream commit b61d0414136853fc38898829cde837ce5d691a9a ]

According to the spec (JESD220E chapter 7.2), while powering off/on the ufs
device, RST_n signal should be between VSS(Ground) and VCCQ/VCCQ2.

Link: https://lore.kernel.org/r/1610103385-45755-3-git-send-email-ziqichen@codeaurora.org
Acked-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Ziqi Chen <ziqichen@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: a862fafa263a ("scsi: ufs: qcom: Perform read back after writing REG_UFS_SYS1CLK_1US")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 08331ecbe91fb..a432c561c3df0 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -578,6 +578,17 @@ static int ufs_qcom_link_startup_notify(struct ufs_hba *hba,
 	return err;
 }
 
+static void ufs_qcom_device_reset_ctrl(struct ufs_hba *hba, bool asserted)
+{
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
+
+	/* reset gpio is optional */
+	if (!host->device_reset)
+		return;
+
+	gpiod_set_value_cansleep(host->device_reset, asserted);
+}
+
 static int ufs_qcom_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 {
 	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
@@ -592,6 +603,9 @@ static int ufs_qcom_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		ufs_qcom_disable_lane_clks(host);
 		phy_power_off(phy);
 
+		/* reset the connected UFS device during power down */
+		ufs_qcom_device_reset_ctrl(hba, true);
+
 	} else if (!ufs_qcom_is_link_active(hba)) {
 		ufs_qcom_disable_lane_clks(host);
 	}
@@ -1441,10 +1455,10 @@ static int ufs_qcom_device_reset(struct ufs_hba *hba)
 	 * The UFS device shall detect reset pulses of 1us, sleep for 10us to
 	 * be on the safe side.
 	 */
-	gpiod_set_value_cansleep(host->device_reset, 1);
+	ufs_qcom_device_reset_ctrl(hba, true);
 	usleep_range(10, 15);
 
-	gpiod_set_value_cansleep(host->device_reset, 0);
+	ufs_qcom_device_reset_ctrl(hba, false);
 	usleep_range(10, 15);
 
 	return 0;
-- 
2.43.0



