Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B1347CC8A;
	Tue, 16 Jun 2026 18:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632816; cv=none; b=ZGH7XAunFnyhvc2Xm/1fw4wFK339jkJb2KPo1XLETvOXjZKm4CeTRD8sQKxpNxR95SwxXz0a0GbeOtj/q4v8ZS9NPfrKSzm4KaIqcvDQk6Ee/iXSB+daOLdOj53unF0Ttv6vuEzVy+bad6piNxSJxWXIb2T7S2vQwfISTkfUwPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632816; c=relaxed/simple;
	bh=T6UNG3caFh+C3cgmy74CtXxtBmLmf4wZpvCxArLEbxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nx55u3TglhI3eYwv705r5HdVj92Xb7yX+Hy058uAnJeZKIH+/iFJRIYu42dQkF7ej0NhXJKodXTETyvv7Ux2fT5zuBGLbBNEpibb5nKNRskfY98WYXdi7H6UVevjtt1I7nQe7y9sryErYDxTQZ0MM5klGKLjxwV/E3ayetCpOKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q2psJ936; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q2psJ936"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A32A1F000E9;
	Tue, 16 Jun 2026 18:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632812;
	bh=fwXGn9HZczPYUUgTq6jw9Dw5wtUecsJAzw75zP+gI3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q2psJ936xMtr9ZFAA8/uuupHAx50OvwR3qUezGKWfbF7ZlzvN5/t0Vf8to7cIIcjB
	 zCzrPXFd6strTwnJ2SP04DX/Gm28227O14M8zLUW3RVZoL6enxwbY08EdSSrADGZEl
	 rjtQppwoc4DbQY+Ewm/s0o9/cOWwVtS+sjMgtn4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David E. Box" <david.e.box@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 448/522] platform/x86/intel/vsec: Create wrapper to walk PCI config space
Date: Tue, 16 Jun 2026 20:29:55 +0530
Message-ID: <20260616145146.882278735@linuxfoundation.org>
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

[ Upstream commit b0631f8a5740c55b52d02174cc4c9c84cc7a16a1 ]

Combine three PCI config space walkers — intel_vsec_walk_dvsec(),
intel_vsec_walk_vsec(), and intel_vsec_walk_header() — into a new wrapper
function, intel_vsec_feature_walk().  This refactoring simplifies the probe
logic and lays the groundwork for future patches that will loop over these
calls. No functional changes.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Link: https://lore.kernel.org/r/20250703022832.1302928-4-david.e.box@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: 348ccc754d89 ("platform/x86/intel/vsec: Fix enable_cnt imbalance on PCIe error recovery")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/vsec.c |   38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

--- a/drivers/platform/x86/intel/vsec.c
+++ b/drivers/platform/x86/intel/vsec.c
@@ -376,11 +376,35 @@ static bool intel_vsec_walk_vsec(struct
 	return have_devices;
 }
 
+static bool intel_vsec_get_features(struct pci_dev *pdev,
+				    struct intel_vsec_platform_info *info)
+{
+	bool found = false;
+
+	/*
+	 * Both DVSEC and VSEC capabilities can exist on the same device,
+	 * so both intel_vsec_walk_dvsec() and intel_vsec_walk_vsec() must be
+	 * called independently. Additionally, intel_vsec_walk_header() is
+	 * needed for devices that do not have VSEC/DVSEC but provide the
+	 * information via device_data.
+	 */
+	if (intel_vsec_walk_dvsec(pdev, info))
+		found = true;
+
+	if (intel_vsec_walk_vsec(pdev, info))
+		found = true;
+
+	if (info && (info->quirks & VSEC_QUIRK_NO_DVSEC) &&
+	    intel_vsec_walk_header(pdev, info))
+		found = true;
+
+	return found;
+}
+
 static int intel_vsec_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct intel_vsec_platform_info *info;
 	struct vsec_priv *priv;
-	bool have_devices = false;
 	int ret;
 
 	ret = pcim_enable_device(pdev);
@@ -399,17 +423,7 @@ static int intel_vsec_pci_probe(struct p
 	priv->info = info;
 	pci_set_drvdata(pdev, priv);
 
-	if (intel_vsec_walk_dvsec(pdev, info))
-		have_devices = true;
-
-	if (intel_vsec_walk_vsec(pdev, info))
-		have_devices = true;
-
-	if (info && (info->quirks & VSEC_QUIRK_NO_DVSEC) &&
-	    intel_vsec_walk_header(pdev, info))
-		have_devices = true;
-
-	if (!have_devices)
+	if (!intel_vsec_get_features(pdev, info))
 		return -ENODEV;
 
 	return 0;


