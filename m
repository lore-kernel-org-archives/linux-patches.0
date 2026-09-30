Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12474327BEC;
	Wed, 30 Sep 2026 18:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794164; cv=none; b=d3P/9JkIy/4YrJo5kRg2+LR86FPmS+kPVBPTvZPXqYztEIspEAkg2r/rxPeRxh2D7NY8WDkkoZazwhL3yv6hRDuM917mBK4bv8F3aehVqVNqtIjK0pTrD6+HVSQpZ/kL3BHtoRUgXloqQQDSyB75dLmBLW5p4lrnofqdS3LhInY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794164; c=relaxed/simple;
	bh=p4vR+R5HNs8svl3AAJrxWOt6IaT1fGO5sETbB7793qM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hVAYTZscIXPsW/hSp2ZW7S+f7HqwoDubQd6tSVNVRkMJni/vJmvVZGP2kRNQV0hcREoT1J153kNa//MpNHD9uie54VniuRBw1cb6bOuu/0VQk172qsf12QfjdYeELsy1AhzRpSAbHgelGgcLwpq3KqjMjYtOsV2mzZbOqR6Rc0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1wreP4F7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1wreP4F7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 638F31F000FF;
	Wed, 30 Sep 2026 18:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794162;
	bh=Sw5xTYgFVl1y1zSC666QR3Kj2Mv7R+bUNO6G81IWi4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1wreP4F7V+RDQBXh7JRWyoUGMQz456C9gq4t2WlmcUU2zhw88WIKD0egYEvwLfnJF
	 tnJ3HbccKEqM7SJyWsN/QKg+9RV2cqrVLGGAS890sYBQiKqTkab89En6v3Q/KJ8KFj
	 0epkJWVjoPGb1C5vRsdXsvBcoym0WYF3ZcCyui6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0115/1193] net: thunderx: fix PTP device ref leak in nicvf_probe()
Date: Wed, 30 Sep 2026 17:13:19 +0200
Message-ID: <20260930152436.780618522@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

[ Upstream commit 2bcf59eefb9f00a2b1d426b639ee49c305a80695 ]

cavium_ptp_get() acquires a reference to the PTP PCI device
through pci_get_device(). If any initialization step fails
after cavium_ptp_get(), the PTP PCI device reference is leaked.
Add a common error path to release the PTP reference before
returning from probe failures.

Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Link: https://patch.msgid.link/20260525082611.61817-1-lihaoxiang@isrc.iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/thunder/nicvf_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index eff350e0bc2a8..75e732f32560c 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -2110,8 +2110,10 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	err = pci_enable_device(pdev);
-	if (err)
-		return dev_err_probe(dev, err, "Failed to enable PCI device\n");
+	if (err) {
+		err = dev_err_probe(dev, err, "Failed to enable PCI device\n");
+		goto err_put_ptp;
+	}
 
 	err = pci_request_regions(pdev, DRV_NAME);
 	if (err) {
@@ -2265,6 +2267,8 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_release_regions(pdev);
 err_disable_device:
 	pci_disable_device(pdev);
+err_put_ptp:
+	cavium_ptp_put(ptp_clock);
 	return err;
 }
 
-- 
2.53.0



