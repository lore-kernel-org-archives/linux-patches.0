Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A255C2E9753;
	Tue, 17 Jun 2025 15:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175502; cv=none; b=SazrWlrqmC5R17gGq5paN4JU1pBqYvpWtBqdW1R3u0VQLXQisH0yk5Kd0KN5qAoty3y5Cf4httsN5Yt+07kcCrorE/9y3t78hTZ2yYm3GszjGkqGU3gQIvO74qMGV5vv8RaB5rq7Dk0f+qgQDgB8baBMlQuuYIaEAdPcY83Ur4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175502; c=relaxed/simple;
	bh=M12dxQy0491kS0/affHWFca/tUBLtFXFt8QPWeMuQEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rPAHQMM5PVxMqsY7cSt2wbZtvukbDcyRLwlwGFr3bb4VWmw9WdSZuVAqWiWhXV6sM6Nl+Q4Lb8lTQEsO/ytiiz4eH1TrDEkC6r8POkvDomKyRhljaxgJNLbLVHXCZGbtVOwKQ97elAoIhetkD1tKmuayYcaKKKlvs+UBwqLNt1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TRB1E5Zr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TRB1E5Zr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12CE9C4CEE3;
	Tue, 17 Jun 2025 15:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175502;
	bh=M12dxQy0491kS0/affHWFca/tUBLtFXFt8QPWeMuQEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TRB1E5ZrmtuahBm+VC2mZoITXtyw2UfBg8y/22g2JGxTEITgpiakDnGS7/S4Syed8
	 DVw2kwArA5u4HBVRnLko6TO5N+6np87mA7++4TZU9tCH6QxzSHg2MHVYP6VGObiRfQ
	 Wj5iAzRgN2yvEBHaRA5lLziybnW4EVnf3Ra/PwBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Badal Nilawar <badal.nilawar@intel.com>,
	Anshuman Gupta <anshuman.gupta@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 094/780] drm/xe/d3cold: Set power state to D3Cold during s2idle/s3
Date: Tue, 17 Jun 2025 17:16:42 +0200
Message-ID: <20250617152455.341516718@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Badal Nilawar <badal.nilawar@intel.com>

[ Upstream commit f945dd89fa8da3f662508165453dafdb4035d9d3 ]

According to pci core guidelines, pci_save_config is recommended when the
driver explicitly needs to set the pci power state. As of now xe kmd is
only doing pci_save_config while entering to s2idle/s3 state, which makes
pci core think that device driver has already applied required pci power
state. This leads to GPU remain in D0 state. To fix the issue setting
the pci power state to D3Cold.

Fixes:dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")

Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Badal Nilawar <badal.nilawar@intel.com>
Signed-off-by: Anshuman Gupta <anshuman.gupta@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://lore.kernel.org/r/20250327161914.432552-1-badal.nilawar@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/xe/xe_pci.c b/drivers/gpu/drm/xe/xe_pci.c
index f4d108dc49b1b..30f7ce06c8969 100644
--- a/drivers/gpu/drm/xe/xe_pci.c
+++ b/drivers/gpu/drm/xe/xe_pci.c
@@ -922,6 +922,7 @@ static int xe_pci_suspend(struct device *dev)
 
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
+	pci_set_power_state(pdev, PCI_D3cold);
 
 	return 0;
 }
-- 
2.39.5



