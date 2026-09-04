Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD403A961E;
	Fri,  4 Sep 2026 05:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499209; cv=none; b=Grpq7pq3kjqk9c7VMbESQNMuR+sP732kWFfEH2nXkEIsXd2yR+Pu/fRYKLd9unMh5GDasYgIpIf26XqRjd2pZbTdaWobk7MtWBuoT8v4PBJiNrahc5ruLye9nTca7jsnxG43XygL1nTpEfSvZlpwvUupgmv5GsVeZUP/R0Xjta4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499209; c=relaxed/simple;
	bh=Tg4yErvpfo3NqX7b3i5cJSoFoGLlz6YOmdn+NudxLzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fkPpHxG0EGxMNeCDy5hUelDdxdMkTSoq4hurDk1nznunGPdKho67jgojqRGNqBKMGKXr6oHfefis2oLWHKGRpvWZMlYUcsLgrrCB+PDyw9GxMWYWIfEstWPiOwFOEUB3QmwGzaXlGgUhYwyhNX+wfccLWkNr28q3WagTBvkWCAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jUAvCLod; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jUAvCLod"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4331F00A3D;
	Fri,  4 Sep 2026 05:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499208;
	bh=KL/f2oXurJykPZb3vV+8/3JIR+v9+V2BJbEboKoNoBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jUAvCLodttrNxBnp3n4/T66BVnMUvfw7im/6tQLRH80YDZMrq29+QbSyA0ISgiKyl
	 pZroqZJsZj15WTsaTr5Ow4EeTcmvQcazVSeI/NjkJIQ+C73wv4Kq6jFo0c0aeB+tIg
	 xKeiTdAcRwKVxHD3NY5gby+kyJeOr7dI+OxEBsEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terry Bowman <terry.bowman@amd.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Richard Cheng <icheng@nvidia.com>,
	Alison Schofield <alison.schofield@intel.com>
Subject: [PATCH 7.2 336/713] cxl/ras: Fix cxl_rch_get_aer_severity() wrong severity register
Date: Fri,  4 Sep 2026 06:55:04 +0200
Message-ID: <20260904045811.359223357@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Terry Bowman <terry.bowman@amd.com>

commit 9d399526128bae184b153deab42b49f5f3eea2ed upstream.

cxl_rch_get_aer_severity() classifies RCH Downstream Port uncorrectable
errors as fatal or non-fatal by ANDing uncorrectable status with
PCI_ERR_ROOT_FATAL_RCV. This is wrong because PCI_ERR_ROOT_FATAL_RCV is a
Root Error Status register bit (bit 6), not a severity bit. ANDing it
against uncorrectable status tests a reserved bit and produces incorrect
severity classification.

Fix by ANDing the unmasked uncor_status against uncor_severity. Per
PCIe Base Spec r6.0 Section 7.8.4.4, each bit in the Uncorrectable
Error Severity register indicates whether the corresponding error is
fatal (1) or non-fatal (0).

Fixes: 6ac07883dbb5 ("cxl/pci: Add RCH downstream port error logging")
Cc: stable@vger.kernel.org
Signed-off-by: Terry Bowman <terry.bowman@amd.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Richard Cheng <icheng@nvidia.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260803221810.3685703-3-terry.bowman@amd.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/ras_rch.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/cxl/core/ras_rch.c
+++ b/drivers/cxl/core/ras_rch.c
@@ -94,11 +94,11 @@ static bool cxl_rch_get_aer_info(void __
 static bool cxl_rch_get_aer_severity(struct aer_capability_regs *aer_regs,
 				     int *severity)
 {
-	if (aer_regs->uncor_status & ~aer_regs->uncor_mask) {
-		if (aer_regs->uncor_status & PCI_ERR_ROOT_FATAL_RCV)
-			*severity = AER_FATAL;
-		else
-			*severity = AER_NONFATAL;
+	u32 uncor_status = aer_regs->uncor_status & ~aer_regs->uncor_mask;
+
+	if (uncor_status) {
+		*severity = (uncor_status & aer_regs->uncor_severity) ?
+			     AER_FATAL : AER_NONFATAL;
 		return true;
 	}
 


