Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4224E9C20;
	Thu, 17 Sep 2026 18:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789669073; cv=none; b=sOK4RN3R4mJHhx8nvTQe8v05qeQssxuWtejgGkrl8H05LM3rhhNxH0jYHDPKWmxUjknjd2wEVCnGh3+eG6cjQgonoQYq/81Xhl7tmuXwIgHUO6g8P1aNKZU2HvWmXV3jwhKZ/+q5RZ7tBeZebF/LhVxxMBkqGxvcbZYNDPszZq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789669073; c=relaxed/simple;
	bh=TittC0evq7/YypvmoP+fofTbuHryhhTZFppIWElLsgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OfzdU9NlReoEB0hO188N6yHh5SCfFQoZSWnQCnFy07y1CjhI8MRJ899jQHvHF5oYL0YQhCRnAEWAdwFv4lqLMQ+tOMadqokNP1w6GyGvEPgpt46JGHwnq1yWZ5Yiar9EvbV+vCF1A4Hact5T3R8akzZiPRgJaavjrKHJopxzLNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=htZR/XAI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="htZR/XAI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E24D1F000FF;
	Thu, 17 Sep 2026 18:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789669072;
	bh=yfYDesJUvqao39kTybrh7Hf7HKZMyX10B3jmwEQaJqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=htZR/XAIxP9kDMWAOjddV1UHr+FFLRDLYhOTiZRY2OZs8LNKTNbHO3VBSWPEKMslr
	 XhrzLNQJ7ECG5G3qmkrSkxHQFxy0LWaNQPgNHl4B/TKK2LnFEt+GnbYEwr9mZCLCME
	 2PFAPXSwQUH95o0R2Sqb0U+gwfUdd/npkKS+6sXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Goutham <sgoutham@marvell.com>,
	Nitin Shetty J <nshettyj@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0598/1102] octeontx2-af: Fix limiting SRIOV VF count logic
Date: Thu, 17 Sep 2026 16:09:01 +0100
Message-ID: <20260917151555.007416286@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Sunil Goutham <sgoutham@marvell.com>

[ Upstream commit f695390ea63941a9e412bf1f3afe65ab245fc681 ]

When RVU PF0/AF's VFs are SDP instead of LBK, limiting the VF count
based on the LBK channel count is incorrect.

Apply LBK channel-based VF limits only when the VF device ID matches
the LBK RVU AFVF device.

Fixes: 9bd6caf33567 ("octeontx2-af: Enable sriov on AF to create VFs")
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Nitin Shetty J <nshettyj@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/af/rvu.c   | 33 +++++++++++--------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index f64171359ec8c..dc2f1900d4a95 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -3280,6 +3280,8 @@ int rvu_get_num_lbk_chans(void)
 	return ret;
 }
 
+#define PCI_DEVID_OCTEONTX2_RVU_AFVF	0xA0F8
+
 static int rvu_enable_sriov(struct rvu *rvu)
 {
 	struct pci_dev *pdev = rvu->pdev;
@@ -3298,24 +3300,27 @@ static int rvu_enable_sriov(struct rvu *rvu)
 		return 0;
 	pci_read_config_word(pdev, pos + PCI_SRIOV_VF_DID, &rvu->vf_devid);
 
-	chans = rvu_get_num_lbk_chans();
-	if (chans < 0)
-		return chans;
-
 	vfs = pci_sriov_get_totalvfs(pdev);
-
-	/* Limit VFs in case we have more VFs than LBK channels available. */
-	if (vfs > chans)
-		vfs = chans;
-
 	if (!vfs)
 		return 0;
 
-	/* LBK channel number 63 is used for switching packets between
-	 * CGX mapped VFs. Hence limit LBK pairs till 62 only.
-	 */
-	if (vfs > 62)
-		vfs = 62;
+	if (rvu->vf_devid == PCI_DEVID_OCTEONTX2_RVU_AFVF) {
+		chans = rvu_get_num_lbk_chans();
+		if (chans < 0)
+			return chans;
+
+		/* The last LBK channel is reserved for switching packets between
+		 * CGX mapped VFs. Also, since LBK VFs work in pairs, limit VF
+		 * count to available LBK channels minus 2.
+		 */
+		vfs = min(vfs, chans - 2);
+
+		if (vfs <= 0) {
+			dev_warn(&pdev->dev,
+				 "Skipping SRIOV enablement, not enough LBK channels available\n");
+			return 0;
+		}
+	}
 
 	/* Save VFs number for reference in VF interrupts handlers.
 	 * Since interrupts might start arriving during SRIOV enablement
-- 
2.53.0



