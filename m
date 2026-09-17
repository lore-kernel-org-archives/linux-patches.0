Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68EAD4F68C3;
	Thu, 17 Sep 2026 17:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665457; cv=none; b=nYhwK3ERTXk/GkH4/Zusa3P85Tjtg/3Saim8gSiSLyxUjpzJ2I53Fo36LFBm9fIOxiHn5RjfOX3F375KadU9SOcLKxwKJmUIXg1/7VkzefApxOLjq7wWOQoRr+wWiTW2JhV5OmA+z79a3F9zMVPZap+tjAfwlYiMFoNcdvFAsAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665457; c=relaxed/simple;
	bh=gxyzIWNRy9T3C3HqdRR4PC4tgB1s0lXDMOZcEiiqpVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JBSQxcjR4PanwfpYWnTmHXHKOKn6wOGUEjUm6fSR2XsRTH7ZlgQifzxVI6IIU3dhoDzHZL6D6PLzhveLFN0xrH7EgS59ItI65DbsFLiucixyrhxAjGa4UfCNEe3p2UdNrDkLpIMK029r5Y0ieR9xNKUIQ2MC+CIuhYB1mEF71vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hG/KMCuf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hG/KMCuf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA271F0089C;
	Thu, 17 Sep 2026 17:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665455;
	bh=0ccEEIOFs/GICHVL6Q/B6d6Teo0uHrjhvLhnlOHunAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hG/KMCufX+gv77DW0FNk0VyXIC9Uck5ChNHsFxYEff648FTIh+EbLMQQEw5alXNdJ
	 A1Y8v20tj5Kk7iRpTRVSDrnVdWsTwEpaqpEHTro4bw4uGl8L7neKZ7W9uGB59r5G9I
	 yc992njarP79SkKDtaCONLrNjQwAKBok7tzpXuxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Goutham <sgoutham@marvell.com>,
	Nitin Shetty J <nshettyj@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0710/1250] octeontx2-af: Fix limiting SRIOV VF count logic
Date: Thu, 17 Sep 2026 16:08:25 +0100
Message-ID: <20260917151611.140096353@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 019bd49015c60..0590313bcd81c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -3377,6 +3377,8 @@ int rvu_get_num_lbk_chans(void)
 	return ret;
 }
 
+#define PCI_DEVID_OCTEONTX2_RVU_AFVF	0xA0F8
+
 static int rvu_enable_sriov(struct rvu *rvu)
 {
 	struct pci_dev *pdev = rvu->pdev;
@@ -3395,24 +3397,27 @@ static int rvu_enable_sriov(struct rvu *rvu)
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



