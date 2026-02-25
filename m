Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D02431195D;
	Wed, 25 Feb 2026 06:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002760; cv=none; b=uGexxaALpsia1fPX1jf0F3TDEm2c2Ttx2k1FuOodIBIpwMLEsYXM3Zf/3sqZNqXM5baWX0FTn4ro+j9MMs2AMXDnSvV7z1hlyNQ86JvH68sWNX0hUZcnQ4N5sdETir/u4/zHwrdeRUAJBj4aN2EqTzbT1B6i4Ay75DF99612tE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002760; c=relaxed/simple;
	bh=ACEcUwkISlTtTPmKAOMLf8jM0tJQKYUQre3rnp2UJQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mvGjeUtc5wCvG6LmdWgDQJwBG1m05mnl82bk2VStXGEGFiYM10i19tq+jQanel/yFxlRmtstniV9bJ0kY0ay52JhrOOCuWRrzACIQF9jDLfRvnHIVIBBhEeUsrNFDPlBUhOG8+Vd2NDsYrcERDBZVQkohD6P+hop6yJYc9jE0Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LC7ytvpx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LC7ytvpx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C19C116D0;
	Wed, 25 Feb 2026 06:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002760;
	bh=ACEcUwkISlTtTPmKAOMLf8jM0tJQKYUQre3rnp2UJQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LC7ytvpxLH5g2+LNnceJcNxEnLp79txdLVzkhpUkef78UhDX1RY2wm8fTgfUSia54
	 zMG/WcmgeXB2nJRSmf8pAMGaNE7Yu85iyvAFIEYquZIZFftIB+tHs6W/OacFpUkAc2
	 fr8fX19h52pq3OKM8qlauAdIwjYV+FhkVlhxSAL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai-Heng Feng <kaihengf@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 589/641] PCI: Validate window resource type in pbus_select_window_for_type()
Date: Tue, 24 Feb 2026 17:25:15 -0800
Message-ID: <20260225012402.785363313@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Kai-Heng Feng <kaihengf@nvidia.com>

[ Upstream commit e5f72cb9cea599dc9f5a9b80a33560a1d06f01cc ]

After ebe091ad81e1 ("PCI: Use pbus_select_window_for_type() during IO
window sizing") and ae88d0b9c57f ("PCI: Use pbus_select_window_for_type()
during mem window sizing"), many bridge windows can't get resources
assigned:

  pci 0006:05:00.0: bridge window [??? 0x00001000-0x00001fff flags 0x20080000]: can't assign; no space
  pci 0006:05:00.0: bridge window [??? 0x00001000-0x00001fff flags 0x20080000]: failed to assign

Those commits replace find_bus_resource_of_type() with
pbus_select_window_for_type(), and the latter lacks resource type
validation.

Add the resource type validation back to pbus_select_window_for_type() to
match the original behavior.

Fixes: 74afce3dfcba ("PCI: Add bridge window selection functions")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=221072
Signed-off-by: Kai-Heng Feng <kaihengf@nvidia.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://patch.msgid.link/20260210142058.82701-1-kaihengf@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/setup-bus.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 4f4890196e63e..cc592ccff5424 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -221,14 +221,21 @@ static struct resource *pbus_select_window_for_type(struct pci_bus *bus,
 
 	switch (iores_type) {
 	case IORESOURCE_IO:
-		return pci_bus_resource_n(bus, PCI_BUS_BRIDGE_IO_WINDOW);
+		win = pci_bus_resource_n(bus, PCI_BUS_BRIDGE_IO_WINDOW);
+		if (win && (win->flags & IORESOURCE_IO))
+			return win;
+		return NULL;
 
 	case IORESOURCE_MEM:
 		mmio = pci_bus_resource_n(bus, PCI_BUS_BRIDGE_MEM_WINDOW);
 		mmio_pref = pci_bus_resource_n(bus, PCI_BUS_BRIDGE_PREF_MEM_WINDOW);
 
-		if (!(type & IORESOURCE_PREFETCH) ||
-		    !(mmio_pref->flags & IORESOURCE_MEM))
+		if (mmio && !(mmio->flags & IORESOURCE_MEM))
+			mmio = NULL;
+		if (mmio_pref && !(mmio_pref->flags & IORESOURCE_MEM))
+			mmio_pref = NULL;
+
+		if (!(type & IORESOURCE_PREFETCH) || !mmio_pref)
 			return mmio;
 
 		if ((type & IORESOURCE_MEM_64) ||
-- 
2.51.0



