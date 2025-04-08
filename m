Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F249268685;
	Tue,  8 Apr 2025 11:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112219; cv=none; b=uM2J9miWmBZCtIGqylUQtl4e4KuALsQjuv4OnqGGe0DfxGnHxfiHicp+VH48aM1oQste5EydGUao2sVAygIlex2MR+L4wi25/Mat3+0UL59A/M3anJdiz05n4bnHs7k4cUpl8O4+PZizF+gSmpiFf2QWziI4qdtk5LT3/DmcAQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112219; c=relaxed/simple;
	bh=4DgITDyIKJ5wU3JeV6o4FXSOTXeZvWu+rYIyqk3WSdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RSw3gdqyMOEizs5R5xhmyq+ecwUYrUFtswwFvKScSpZWq/hbLu31g6xT9DX5mVQQFIQTMi7ZiR0HlsTgL8BtHA10oCYDI9n2bgIX6tpsjxgSpmmdZXoBesDKcmZnbjeFTYaZwyDXxBIac96wtgF92vKczG54i8zcnOm7CESur/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PjZWzLUI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PjZWzLUI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CFFBC4CEE5;
	Tue,  8 Apr 2025 11:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112218;
	bh=4DgITDyIKJ5wU3JeV6o4FXSOTXeZvWu+rYIyqk3WSdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PjZWzLUI7vTDPVLYKWoClisGrFno264m8qxPi9uog+CUzPH7aN8lz8OExq0u9InPY
	 OMyONzCmp0XX6HA/YpSIMpl7aXrb6x/UGHjgD/V4bVgYFp3AYUpCsNwxMz0J0+hoEm
	 KnzaYiu1rAii6oejuEhUWRc60Nw5rxzM5s0K7YHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wouter Bijlsma <wouter@wouterbijlsma.nl>,
	Lukas Wunner <lukas@wunner.de>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Subject: [PATCH 6.14 717/731] PCI/bwctrl: Fix NULL pointer dereference on bus number exhaustion
Date: Tue,  8 Apr 2025 12:50:14 +0200
Message-ID: <20250408104930.952804357@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

commit 667f053b05f00a007738cd7ed6fa1901de19dc7e upstream.

When BIOS neglects to assign bus numbers to PCI bridges, the kernel
attempts to correct that during PCI device enumeration.  If it runs out
of bus numbers, no pci_bus is allocated and the "subordinate" pointer in
the bridge's pci_dev remains NULL.

The PCIe bandwidth controller erroneously does not check for a NULL
subordinate pointer and dereferences it on probe.

Bandwidth control of unusable devices below the bridge is of questionable
utility, so simply error out instead.  This mirrors what PCIe hotplug does
since commit 62e4492c3063 ("PCI: Prevent NULL dereference during pciehp
probe").

The PCI core emits a message with KERN_INFO severity if it has run out of
bus numbers.  PCIe hotplug emits an additional message with KERN_ERR
severity to inform the user that hotplug functionality is disabled at the
bridge.  A similar message for bandwidth control does not seem merited,
given that its only purpose so far is to expose an up-to-date link speed
in sysfs and throttle the link speed on certain laptops with limited
Thermal Design Power.  So error out silently.

User-visible messages:

  pci 0000:16:02.0: bridge configuration invalid ([bus 00-00]), reconfiguring
  [...]
  pci_bus 0000:45: busn_res: [bus 45-74] end is updated to 74
  pci 0000:16:02.0: devices behind bridge are unusable because [bus 45-74] cannot be assigned for them
  [...]
  pcieport 0000:16:02.0: pciehp: Hotplug bridge without secondary bus, ignoring
  [...]
  BUG: kernel NULL pointer dereference
  RIP: pcie_update_link_speed
  pcie_bwnotif_enable
  pcie_bwnotif_probe
  pcie_port_probe_service
  really_probe

Fixes: 665745f27487 ("PCI/bwctrl: Re-add BW notification portdrv as PCIe BW controller")
Reported-by: Wouter Bijlsma <wouter@wouterbijlsma.nl>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219906
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Tested-by: Wouter Bijlsma <wouter@wouterbijlsma.nl>
Cc: stable@vger.kernel.org # v6.13+
Link: https://lore.kernel.org/r/3b6c8d973aedc48860640a9d75d20528336f1f3c.1742669372.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pcie/bwctrl.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/pci/pcie/bwctrl.c
+++ b/drivers/pci/pcie/bwctrl.c
@@ -294,6 +294,10 @@ static int pcie_bwnotif_probe(struct pci
 	struct pci_dev *port = srv->port;
 	int ret;
 
+	/* Can happen if we run out of bus numbers during enumeration. */
+	if (!port->subordinate)
+		return -ENODEV;
+
 	struct pcie_bwctrl_data *data = devm_kzalloc(&srv->device,
 						     sizeof(*data), GFP_KERNEL);
 	if (!data)


