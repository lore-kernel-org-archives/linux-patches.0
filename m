Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94217CF32;
	Wed, 21 Feb 2024 14:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525228; cv=none; b=DBrzFRi2WilH6Yv0G/qrViur7OkxurFVV6YidAheJhEgRFivKhd56cgml2SQYdik+VAvBbI8z2mKeq703bwtY6e0T8tIP/4lJlhkzonQ97a6GxkN3CMRO3OZnoW8xlvrN0t9MrNUI6cyFcnBZ+yied/HOYmm6auJhU8U1mfZqvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525228; c=relaxed/simple;
	bh=XWSPHUip6dxsGiHg5wv/DN11MjTRJxG7luEkmZmgm+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZW4N8ADnMkay0tJnOYZhOH6dO5Tifk6W0eNRJtWpEk94FFpMpFiUQW3B8liSn54Qu2jAkVv7GWzlR60mMwf7bJ0LzHCKlgxC4D4TvvgtHfuzKkwnV3tJNcJYeXc4dfNB4OEVujj3QYWLtc9F7IgJjkI7KT4qK5VRTgtWFLpBppk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rk0PdeeJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rk0PdeeJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF829C433C7;
	Wed, 21 Feb 2024 14:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525225;
	bh=XWSPHUip6dxsGiHg5wv/DN11MjTRJxG7luEkmZmgm+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rk0PdeeJGjCH0lT0cRNlzwVTbIx0D6WeGcifDDKZuvqT5gPfxvIfnplWV76z9PcTS
	 rUE1KhsX6CeP469v90E+IuoeiSKTTi4IIq+VpYktSsgkaqoC5zIgC2jZxKNpuKsGVs
	 Rf3+rRsAhWUYxx0WRqUBCjx/gO7XvaDII8asAM58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Petr Machata <petrm@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 095/267] PCI: Add no PM reset quirk for NVIDIA Spectrum devices
Date: Wed, 21 Feb 2024 14:07:16 +0100
Message-ID: <20240221125942.934340083@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 3ed48c80b28d8dcd584d6ddaf00c75b7673e1a05 ]

Spectrum-{1,2,3,4} devices report that a D3hot->D0 transition causes a
reset (i.e., they advertise NoSoftRst-). However, this transition does
not have any effect on the device: It continues to be operational and
network ports remain up. Advertising this support makes it seem as if a
PM reset is viable for these devices. Mark it as unavailable to skip it
when testing reset methods.

Before:

 # cat /sys/bus/pci/devices/0000\:03\:00.0/reset_method
 pm bus

After:

 # cat /sys/bus/pci/devices/0000\:03\:00.0/reset_method
 bus

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index cc8f2ce1e881..d1fab1d27e4d 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3626,6 +3626,19 @@ static void quirk_no_pm_reset(struct pci_dev *dev)
 DECLARE_PCI_FIXUP_CLASS_HEADER(PCI_VENDOR_ID_ATI, PCI_ANY_ID,
 			       PCI_CLASS_DISPLAY_VGA, 8, quirk_no_pm_reset);
 
+/*
+ * Spectrum-{1,2,3,4} devices report that a D3hot->D0 transition causes a reset
+ * (i.e., they advertise NoSoftRst-). However, this transition does not have
+ * any effect on the device: It continues to be operational and network ports
+ * remain up. Advertising this support makes it seem as if a PM reset is viable
+ * for these devices. Mark it as unavailable to skip it when testing reset
+ * methods.
+ */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MELLANOX, 0xcb84, quirk_no_pm_reset);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MELLANOX, 0xcf6c, quirk_no_pm_reset);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MELLANOX, 0xcf70, quirk_no_pm_reset);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MELLANOX, 0xcf80, quirk_no_pm_reset);
+
 /*
  * Thunderbolt controllers with broken MSI hotplug signaling:
  * Entire 1st generation (Light Ridge, Eagle Ridge, Light Peak) and part
-- 
2.43.0



