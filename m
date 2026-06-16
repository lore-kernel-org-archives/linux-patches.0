Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB8C47CC87;
	Tue, 16 Jun 2026 18:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632810; cv=none; b=bJ8eeWw5ZJ3rad+4D4o0Ie/ls+wkFqDaPxOrkKfIbY+vbtgau+TpNtvm/346Lfy5W7A6GoNEW+UtivuApAdyKMvKs1sua8ashXG5UK+jH1sIUFfah6r2zQfpWGF68dlcsNbiK7cOcLBkI3kCA+J+DxqMb8qCTn6bFAh0tbeiU40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632810; c=relaxed/simple;
	bh=QZCMXydysoiPwmpSaftrTawaHqFli4VWWLcjA7KwQdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ta/8i9K2nu3YxGxg+sJtS0o1tNpVn3fOUmJZ5MrswqzCnAEKs0ELJSbh56tU8vEzlkVPqmBiK4C5qnpqAGRlW1PIyrmLm616wYlL9g7f7+CfD+6nOuFniPOlCVS4y2z3pJa6Fp8QRDFAUmr8T5FakzlvEIXLT2SKHB0b810rJTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HSSj6L+i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HSSj6L+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C3181F000E9;
	Tue, 16 Jun 2026 18:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632807;
	bh=YyfCyxi+aCZOg1gqysjX4oU1IvV5nHKTk9n6kXk04yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HSSj6L+iaZpfd765mO0CiFnTvhcSt0y0xSQcjIZGux1qQ9yx9Ja0kKw/Pvw+0BSIz
	 rELyxY9SMaqNY12z29OV5anI+DVDaMSszz0xi6y1Ndtekx8c8bY1ZsG/piZe5kpUd0
	 8Z3DD4cCF2ZFQkqrwB1MQbXuIqfObi2Du743Vn8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David E. Box" <david.e.box@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 447/522] platform/x86/intel/vsec: Add private data for per-device data
Date: Tue, 16 Jun 2026 20:29:54 +0530
Message-ID: <20260616145146.838578907@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David E. Box" <david.e.box@linux.intel.com>

[ Upstream commit dc957ab6aa05c118c3da0542428a4d6602aa2d2d ]

Introduce a new private structure, struct vsec_priv, to hold a pointer to
the platform-specific information. Although the driver didn’t previously
require this per-device data, adding it now lays the groundwork for
upcoming patches that will manage such data. No functional changes.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Link: https://lore.kernel.org/r/20250703022832.1302928-3-david.e.box@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: 348ccc754d89 ("platform/x86/intel/vsec: Fix enable_cnt imbalance on PCIe error recovery")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/vsec.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/platform/x86/intel/vsec.c
+++ b/drivers/platform/x86/intel/vsec.c
@@ -73,6 +73,10 @@ static enum intel_vsec_id intel_vsec_all
 	VSEC_ID_SDSI,
 };
 
+struct vsec_priv {
+	struct intel_vsec_platform_info *info;
+};
+
 static const char *intel_vsec_name(enum intel_vsec_id id)
 {
 	switch (id) {
@@ -375,6 +379,7 @@ static bool intel_vsec_walk_vsec(struct
 static int intel_vsec_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct intel_vsec_platform_info *info;
+	struct vsec_priv *priv;
 	bool have_devices = false;
 	int ret;
 
@@ -387,6 +392,13 @@ static int intel_vsec_pci_probe(struct p
 	if (!info)
 		return -EINVAL;
 
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->info = info;
+	pci_set_drvdata(pdev, priv);
+
 	if (intel_vsec_walk_dvsec(pdev, info))
 		have_devices = true;
 


