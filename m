Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286A6501F26;
	Thu, 17 Sep 2026 15:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659195; cv=none; b=lW7uw7xmME69v/KqKCZW2ZhpWnxYFlSF9+02BZJXPF8kM5/YGGGO+PcSndDNrhbzhjnR1oO890xQIpaM4lu8FDv8S3vIu22K0/KNnJnGbbp93JPAQzu03KZupovePX/jlKW/LJUBqb4E6XJ/bWa2QnIaMrGn5SfubBhrq6Og+gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659195; c=relaxed/simple;
	bh=0eIgROSitIwbtVruNbvk6YbHxBSGjhRqq8VFlGqSS+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mi2DTxbQXMJTCAHjMfr+2V0rGFlnFSSsrgOrU2+aMKuOF5/P0xWyZVKUXlZ2xTmNAZw/a2ARggoyYiJy/IS4AnOlOg6aYovZRtE+PG6x90klO9rUscEWGTGPTKUnOaOWIz+CF1iFoqymcCng4X4QgPjvJQApkzrKHV4eynstmNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=alNIzp+K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="alNIzp+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D91EA1F00899;
	Thu, 17 Sep 2026 15:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659188;
	bh=l4usEtjq6uzACPahaexdHsFw4EfsnSme2pVvjUvQjW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=alNIzp+KU4Z/4EyeoalkrLPR8cZ9LYo+y85tEIfsbYDAK7GEczjVy7nYR3+8NoFJQ
	 DPfS+yMy0OY+X/LzVzI4dh1xcp3C6u3x/MCYMAg17jd7YP4ZIZMNu/SqaY0pGRN+Fj
	 PFbZva/uDpb+yEP96nB+j+ihOb1NcPnt1xGWbdiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Goutham <sgoutham@marvell.com>,
	Nitin Shetty J <nshettyj@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 174/733] octeontx2-af: Fix limiting SRIOV VF count logic
Date: Thu, 17 Sep 2026 16:08:02 +0100
Message-ID: <20260917151355.442862551@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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
index 74c041ab5280a..937b085582b5f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -3468,6 +3468,8 @@ int rvu_get_num_lbk_chans(void)
 	return ret;
 }
 
+#define PCI_DEVID_OCTEONTX2_RVU_AFVF	0xA0F8
+
 static int rvu_enable_sriov(struct rvu *rvu)
 {
 	struct pci_dev *pdev = rvu->pdev;
@@ -3486,24 +3488,27 @@ static int rvu_enable_sriov(struct rvu *rvu)
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



