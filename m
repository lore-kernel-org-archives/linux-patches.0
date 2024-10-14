Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13B21AA793;
	Mon, 14 Oct 2024 14:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916111; cv=none; b=eLqXG26tRwaGsT+q78JnXAu5Zk9KaVx5Qo3zZpXqVAdGzlESmy0CgMBUPHA6Fm42FqAJRTMf+bfIKQlXMgjgSllL0oua2DXBUfgIYRpaqcKlBpECMtuFLXNBMZ87+d0QgBCgc8gLvivPQ8oC516nrt4B9zEqmy0aEKVssEiA0E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916111; c=relaxed/simple;
	bh=+ryevX4ee89OFn4L3F4FkUpcyUlkj6X5xMWkXgIpfio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=beP9UQelQad73kkZp719XNGKZiJtxTBf25GULzlT3MpWtcUkLQ04dx9qaVOSsLL7Hf/E3DZXcopaLVxRCZi/95LyN9nXJ7Dhv4QEksrvacBvhl9e2IT1D9vvI9zwn1NcPc+TPPsc1koI+fV+1wxHg/Ib2zNc98fxqHhRBFoVQBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jOjmt6mq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jOjmt6mq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B30CC4CEC3;
	Mon, 14 Oct 2024 14:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916111;
	bh=+ryevX4ee89OFn4L3F4FkUpcyUlkj6X5xMWkXgIpfio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jOjmt6mq5qPQFvDFA2ACoL8CsdoD2RNhijMhgEyoBeCa/WC7mV9xndy/K+Fk4wC48
	 /JhMacv04UnuHC8n+++rmZ5MyPZpnxGWj3xViQwA13vbuASVatyk5VZJsFQ4Aa7vfh
	 lL4OElPGcXQZQ+D5CkFpEVlvnkhNpjAXCcn0BppM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 060/214] usb: host: xhci-plat: Parse xhci-missing_cas_quirk and apply quirk
Date: Mon, 14 Oct 2024 16:18:43 +0200
Message-ID: <20241014141047.331795982@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit a6cd2b3fa89468b5f28b83d211bd25cc589f9eba ]

Parse software managed property 'xhci-skip-phy-init-quirk' and
'xhci-skip-phy-init-quirk' to apply related quirk. It allows usb glue layer
driver apply these quirk.

Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20240906-dwc-mp-v5-1-ea8ec6774e7b@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-plat.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 31bdfa52eeb25..ecaa75718e592 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -259,6 +259,12 @@ int xhci_plat_probe(struct platform_device *pdev, struct device *sysdev, const s
 		if (device_property_read_bool(tmpdev, "write-64-hi-lo-quirk"))
 			xhci->quirks |= XHCI_WRITE_64_HI_LO;
 
+		if (device_property_read_bool(tmpdev, "xhci-missing-cas-quirk"))
+			xhci->quirks |= XHCI_MISSING_CAS;
+
+		if (device_property_read_bool(tmpdev, "xhci-skip-phy-init-quirk"))
+			xhci->quirks |= XHCI_SKIP_PHY_INIT;
+
 		device_property_read_u32(tmpdev, "imod-interval-ns",
 					 &xhci->imod_interval);
 	}
-- 
2.43.0



