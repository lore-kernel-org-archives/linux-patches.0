Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A278B1F93D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:12:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228D4C433C7;
	Fri, 21 Jul 2023 16:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955920;
	bh=b4FfLj9ts42f31xrg4+UTEhT6tlJ8MqWZFQZn0vlAy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QAgD7z2HkgQ/w2DurOel7RUqz6JoMJM/SwB8uT4PBLN7I0YrjZn1bpHGOgKNRyyhY
	 3RC8xhRPeux+D+ZBwdBbfyKVH3QOtlDapKUttDBDhiscio3Bl731cujcgnYdPDDdwF
	 KNpywPWWoVwaDYZavwNYVqEQVXDAPBTvrXGlWrZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naveen Mamindlapalli <naveenm@marvell.com>,
	Sunil Goutham <sgoutham@marvell.com>,
	Sai Krishna <saikrishnag@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 049/292] octeontx2-af: Move validation of ptp pointer before its usage
Date: Fri, 21 Jul 2023 18:02:38 +0200
Message-ID: <20230721160530.910442638@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sai Krishna <saikrishnag@marvell.com>

[ Upstream commit 7709fbd4922c197efabda03660d93e48a3e80323 ]

Moved PTP pointer validation before its use to avoid smatch warning.
Also used kzalloc/kfree instead of devm_kzalloc/devm_kfree.

Fixes: 2ef4e45d99b1 ("octeontx2-af: Add PTP PPS Errata workaround on CN10K silicon")
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/af/ptp.c   | 19 +++++++++----------
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |  2 +-
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
index 3411e2e47d46b..0ee420a489fc4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
@@ -208,7 +208,7 @@ struct ptp *ptp_get(void)
 	/* Check driver is bound to PTP block */
 	if (!ptp)
 		ptp = ERR_PTR(-EPROBE_DEFER);
-	else
+	else if (!IS_ERR(ptp))
 		pci_dev_get(ptp->pdev);
 
 	return ptp;
@@ -388,11 +388,10 @@ static int ptp_extts_on(struct ptp *ptp, int on)
 static int ptp_probe(struct pci_dev *pdev,
 		     const struct pci_device_id *ent)
 {
-	struct device *dev = &pdev->dev;
 	struct ptp *ptp;
 	int err;
 
-	ptp = devm_kzalloc(dev, sizeof(*ptp), GFP_KERNEL);
+	ptp = kzalloc(sizeof(*ptp), GFP_KERNEL);
 	if (!ptp) {
 		err = -ENOMEM;
 		goto error;
@@ -428,20 +427,19 @@ static int ptp_probe(struct pci_dev *pdev,
 	return 0;
 
 error_free:
-	devm_kfree(dev, ptp);
+	kfree(ptp);
 
 error:
 	/* For `ptp_get()` we need to differentiate between the case
 	 * when the core has not tried to probe this device and the case when
-	 * the probe failed.  In the later case we pretend that the
-	 * initialization was successful and keep the error in
+	 * the probe failed.  In the later case we keep the error in
 	 * `dev->driver_data`.
 	 */
 	pci_set_drvdata(pdev, ERR_PTR(err));
 	if (!first_ptp_block)
 		first_ptp_block = ERR_PTR(err);
 
-	return 0;
+	return err;
 }
 
 static void ptp_remove(struct pci_dev *pdev)
@@ -449,16 +447,17 @@ static void ptp_remove(struct pci_dev *pdev)
 	struct ptp *ptp = pci_get_drvdata(pdev);
 	u64 clock_cfg;
 
-	if (cn10k_ptp_errata(ptp) && hrtimer_active(&ptp->hrtimer))
-		hrtimer_cancel(&ptp->hrtimer);
-
 	if (IS_ERR_OR_NULL(ptp))
 		return;
 
+	if (cn10k_ptp_errata(ptp) && hrtimer_active(&ptp->hrtimer))
+		hrtimer_cancel(&ptp->hrtimer);
+
 	/* Disable PTP clock */
 	clock_cfg = readq(ptp->reg_base + PTP_CLOCK_CFG);
 	clock_cfg &= ~PTP_CLOCK_CFG_PTP_EN;
 	writeq(clock_cfg, ptp->reg_base + PTP_CLOCK_CFG);
+	kfree(ptp);
 }
 
 static const struct pci_device_id ptp_id_table[] = {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index b26b013216933..73932e2755bca 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -3253,7 +3253,7 @@ static int rvu_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	rvu->ptp = ptp_get();
 	if (IS_ERR(rvu->ptp)) {
 		err = PTR_ERR(rvu->ptp);
-		if (err == -EPROBE_DEFER)
+		if (err)
 			goto err_release_regions;
 		rvu->ptp = NULL;
 	}
-- 
2.39.2



