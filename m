Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2F32DBF75;
	Tue, 21 Jul 2026 18:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657233; cv=none; b=pXoVVB9Rxs59BEMazOtsopsA2aaIzEjJSeFxCQ8nidOcZFHRWHf91wG+uhL7+LXrxQCEQAft/COzFKK4AoGPMUshhm4o9PVQJLVZlijQdXeY3w/bhJ1gq2bdtiC5vB5FGtBGMJsnUQZjo57lAMyxaG8Zy0qfXzvuwnD6eqZWs1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657233; c=relaxed/simple;
	bh=o+HVVmpq0CTRN2ozg6C/Euo3O35ulRxLz06SCxkswuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QIyRYwK4ZTdE/ECJ+YGcvqhztEfqk6rMoDpZu2nnBf5AII1mpIn/u617eQsDwPQuJdBdEftHCF5MJ1CFlbhex9C23TH3IZvx3HRycoclZ2XhDf70lVk00pv8A+SXP/NDTOMumAL/WeRoiOf7aJvpG1JjpTaF0mFkHaYpYVuwEpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iMeQFLlP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iMeQFLlP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC7D1F00A3A;
	Tue, 21 Jul 2026 18:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657231;
	bh=HK014uJC6Gp+xjUCMVzXGSX1xHpquo1+CzcE89apzs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iMeQFLlPQetHi0zRPl9sZVN0dFiTsSPqVpCjnY0sxsUErRLOeoqyOfBm6bbNg+3Zj
	 +Oxvhntx9u0jtvFLJGxgMZ9eQSDNq14PuvQBQn181cfKkdRvhJeOhBA4ptyPDHoEME
	 ECLsDfv2H/un/z761MxK6b0gJ9NfhlnWdA6YNWXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"David E. Box" <david.e.box@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0686/1611] platform/x86/intel/vsec: Return real error codes from registration path
Date: Tue, 21 Jul 2026 17:13:22 +0200
Message-ID: <20260721152530.812820975@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David E. Box <david.e.box@linux.intel.com>

[ Upstream commit a6ce8bf3c993d8c2e8a6aeb2596429c101fe4462 ]

Stop collapsing registration results into booleans. Make
intel_vsec_walk_header() return int and propagate the first non-zero error
from intel_vsec_register_device(). intel_vsec_register() now returns that
error directly and 0 on success.

This preserves success behavior while surfacing meaningful errors instead
of hiding them behind a bool/-ENODEV, which makes debugging and probe
ordering issues clearer.

Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Link: https://patch.msgid.link/20260313015202.3660072-6-david.e.box@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: 375bbbbd112a ("platform/x86/intel/vsec: Restore BAR fallback for header walk")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/vsec.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/platform/x86/intel/vsec.c b/drivers/platform/x86/intel/vsec.c
index cb065de62f8f02..4e2e9f6a586b11 100644
--- a/drivers/platform/x86/intel/vsec.c
+++ b/drivers/platform/x86/intel/vsec.c
@@ -461,20 +461,19 @@ static int intel_vsec_register_device(struct device *dev,
 	return -EAGAIN;
 }
 
-static bool intel_vsec_walk_header(struct device *dev,
-				   const struct intel_vsec_platform_info *info)
+static int intel_vsec_walk_header(struct device *dev,
+				  const struct intel_vsec_platform_info *info)
 {
 	struct intel_vsec_header **header = info->headers;
-	bool have_devices = false;
 	int ret;
 
 	for ( ; *header; header++) {
 		ret = intel_vsec_register_device(dev, *header, info, info->base_addr);
-		if (!ret)
-			have_devices = true;
+		if (ret)
+			return ret;
 	}
 
-	return have_devices;
+	return 0;
 }
 
 static bool intel_vsec_walk_dvsec(struct pci_dev *pdev,
@@ -580,10 +579,7 @@ int intel_vsec_register(struct device *dev,
 	if (!dev || !info || !info->headers)
 		return -EINVAL;
 
-	if (!intel_vsec_walk_header(dev, info))
-		return -ENODEV;
-	else
-		return 0;
+	return intel_vsec_walk_header(dev, info);
 }
 EXPORT_SYMBOL_NS_GPL(intel_vsec_register, "INTEL_VSEC");
 
-- 
2.53.0



