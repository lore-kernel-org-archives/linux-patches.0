Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A2F363C59;
	Wed, 20 May 2026 16:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295349; cv=none; b=Es4jxW5sf+tZj4Kho8mGvTOtHA9ZWBFXNUhRTR0PnOfrvV6788tbKjbWDiWwI9N26LpzEIuWK6Ek5V4tSPnBbaH4Z5K3glsdodgDxkpl5yMdYDiNPh+ZTs5o88/w+oL5GKF2+kQHDt/z49rkaYZxuex006sDoguaC94K9I2TNQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295349; c=relaxed/simple;
	bh=a4dQUMgSfwTd5Plt37VlXmgp7N6kMw1csmGLVq2A6VU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SIv8eCPh7DJZUxV5Una9sPkwFVTHkDKGUFDkRzUcyzoVz8Fp3+XQstgCWFqonSWAbTopiRJ8GdkzsGS6U6LSG41lQzyzuJ7aB/y4ZXRlyIKKhBvWbPdBJlFBMYEHe3OhRAOwfiQMpiW2UiilEjRjAMHCOYh673YGyVWW5IjEzuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bPkpxo7n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bPkpxo7n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9E31F00893;
	Wed, 20 May 2026 16:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295348;
	bh=ujiSMbvzDJD+HNNIy3n40p7VaVNAnqU50nSsxv+8ZeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bPkpxo7nwIW+4zhjgpmk/Hv7SwowtXO+Gn8alqy7vUmjd1GDhqs6538JsqVc2xtus
	 XPhcTCfYzVMToSd3zF2jZpIw6KMQEofl5dWq7zlJzBQaDJSgWEoWHZ49WYQmpW9u5v
	 C+DS6TNGOCXq23UerQgPYysGdstUZBl0KVBUJ4VY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0383/1146] PCI: dwc: Fix type mismatch for kstrtou32_from_user() return value
Date: Wed, 20 May 2026 18:10:33 +0200
Message-ID: <20260520162156.867526931@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Zhang <18255117159@163.com>

[ Upstream commit 445588a3b18bb0702d746cb61f7a443639027651 ]

kstrtou32_from_user() returns int, but the return value was stored in
a u32 variable 'val', risking sign loss. Use a dedicated int variable
to correctly handle the return code.

Fixes: 4fbfa17f9a07 ("PCI: dwc: Add debugfs based Silicon Debug support for DWC")
Signed-off-by: Hans Zhang <18255117159@163.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20260401023048.4182452-1-18255117159@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../controller/dwc/pcie-designware-debugfs.c  | 21 +++++++++++--------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware-debugfs.c b/drivers/pci/controller/dwc/pcie-designware-debugfs.c
index 0d1340c9b3642..9461be0744907 100644
--- a/drivers/pci/controller/dwc/pcie-designware-debugfs.c
+++ b/drivers/pci/controller/dwc/pcie-designware-debugfs.c
@@ -208,10 +208,11 @@ static ssize_t lane_detect_write(struct file *file, const char __user *buf,
 	struct dw_pcie *pci = file->private_data;
 	struct dwc_pcie_rasdes_info *rinfo = pci->debugfs->rasdes_info;
 	u32 lane, val;
+	int ret;
 
-	val = kstrtou32_from_user(buf, count, 0, &lane);
-	if (val)
-		return val;
+	ret = kstrtou32_from_user(buf, count, 0, &lane);
+	if (ret)
+		return ret;
 
 	val = dw_pcie_readl_dbi(pci, rinfo->ras_cap_offset + SD_STATUS_L1LANE_REG);
 	val &= ~(LANE_SELECT);
@@ -347,10 +348,11 @@ static ssize_t counter_enable_write(struct file *file, const char __user *buf,
 	struct dw_pcie *pci = pdata->pci;
 	struct dwc_pcie_rasdes_info *rinfo = pci->debugfs->rasdes_info;
 	u32 val, enable;
+	int ret;
 
-	val = kstrtou32_from_user(buf, count, 0, &enable);
-	if (val)
-		return val;
+	ret = kstrtou32_from_user(buf, count, 0, &enable);
+	if (ret)
+		return ret;
 
 	mutex_lock(&rinfo->reg_event_lock);
 	set_event_number(pdata, pci, rinfo);
@@ -408,10 +410,11 @@ static ssize_t counter_lane_write(struct file *file, const char __user *buf,
 	struct dw_pcie *pci = pdata->pci;
 	struct dwc_pcie_rasdes_info *rinfo = pci->debugfs->rasdes_info;
 	u32 val, lane;
+	int ret;
 
-	val = kstrtou32_from_user(buf, count, 0, &lane);
-	if (val)
-		return val;
+	ret = kstrtou32_from_user(buf, count, 0, &lane);
+	if (ret)
+		return ret;
 
 	mutex_lock(&rinfo->reg_event_lock);
 	set_event_number(pdata, pci, rinfo);
-- 
2.53.0



