Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722E7134A4
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDFE9C433EF;
	Mon, 12 Jun 2023 10:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566501;
	bh=89SpB0GH8SY+G4dD41Fm3mZYm5mUMKzPfL+B3GMYZ9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jXdnkaE31aVkU5rzz/bbNpwmB4T//SRwKtu82JlSDWwPjjk3tgmNHJM+6u/kdhJoI
	 eaOl8DRubJSniNq5hdNbNzmjaVz8rIAG9pjHx3dAhxbOEydVV+IoUGMUYQd7GWotYF
	 om4F3C2a+vAF8D+z1mQjKldvG1Q1/k40p3s8eDz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Vikas Gupta <vikas.gupta@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/132] bnxt_en: Skip firmware fatal error recovery if chip is not accessible
Date: Mon, 12 Jun 2023 12:26:29 +0200
Message-ID: <20230612101712.764724565@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101710.279705932@linuxfoundation.org>
References: <20230612101710.279705932@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vikas Gupta <vikas.gupta@broadcom.com>

[ Upstream commit 83474a9b252ab23e6003865c2775024344cb9c09 ]

Driver starts firmware fatal error recovery by detecting
heartbeat failure or fw reset count register changing.  But
these checks are not reliable if the device is not accessible.
This can happen while DPC (Downstream Port containment) is in
progress.  Skip firmware fatal recovery if pci_device_is_present()
returns false.

Fixes: acfb50e4e773 ("bnxt_en: Add FW fatal devlink_health_reporter.")
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 93c3b8316c46a..f7b2c4e94e898 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11576,6 +11576,7 @@ static void bnxt_tx_timeout(struct net_device *dev, unsigned int txqueue)
 static void bnxt_fw_health_check(struct bnxt *bp)
 {
 	struct bnxt_fw_health *fw_health = bp->fw_health;
+	struct pci_dev *pdev = bp->pdev;
 	u32 val;
 
 	if (!fw_health->enabled || test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
@@ -11589,7 +11590,7 @@ static void bnxt_fw_health_check(struct bnxt *bp)
 	}
 
 	val = bnxt_fw_health_readl(bp, BNXT_FW_HEARTBEAT_REG);
-	if (val == fw_health->last_fw_heartbeat) {
+	if (val == fw_health->last_fw_heartbeat && pci_device_is_present(pdev)) {
 		fw_health->arrests++;
 		goto fw_reset;
 	}
@@ -11597,7 +11598,7 @@ static void bnxt_fw_health_check(struct bnxt *bp)
 	fw_health->last_fw_heartbeat = val;
 
 	val = bnxt_fw_health_readl(bp, BNXT_FW_RESET_CNT_REG);
-	if (val != fw_health->last_fw_reset_cnt) {
+	if (val != fw_health->last_fw_reset_cnt && pci_device_is_present(pdev)) {
 		fw_health->discoveries++;
 		goto fw_reset;
 	}
-- 
2.39.2



