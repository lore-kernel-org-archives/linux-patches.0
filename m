Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CBC44AB9F;
	Tue, 21 Jul 2026 22:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674589; cv=none; b=XXIE7EIXlURcL8wu6Yd2B37IAQ0eauH82fOMJYo+toU8zDBGBAzXbX6ipTLLHHUO8cLaoJIQ7FQPAxcQV5Y13dJKgApnHCl96hvJpKxPCJuzHPR0H2OddIRikkp3XPFMzBZJ+oj4NENy+/SatpeOE2fErnsePYhRttAob1CRWvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674589; c=relaxed/simple;
	bh=dSTH9mrTDvam8e9RrQ5eEX63/H3vu/DKh3S+s8ibEl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=izEbIBKtcd8XDASzO5WAJ+ha1vwck9h+ChiW7k+kNe5bVLgLKHBAfeSLYINTXcXDERCVNo8dK417OMAYL9gkTr4NjIrwUd2mFqtbhM17iQAxkqmcapzawTOGU5CrrnXAbLeJ5DydLPDn5rooorCSbAmuKPL/yUF3WptS8aDPDjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0HRVUyNL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0HRVUyNL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 498321F00A3A;
	Tue, 21 Jul 2026 22:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674588;
	bh=04GSSgxNM8IjS2UnqVLrXaG6e7kDDwONgw4idPKIl1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0HRVUyNLZQXvDjxsGpxbI7ufXx7QKxjBQ9954ceE0FSQgVAgzHebmbRAXwhRTux5O
	 knBAiPSE1dNswyiZRaGqmPCduusDnFm+CKY9Bqnx0nY+i3BE6vaClvAmNkZObNRiy6
	 I41/OCssSl5pp+NmFzbgL5f+1kQWk3yknJ3G9uB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Williamson <alex.williamson@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 599/699] vfio/pci: Release the VGA arbiter client on register_device() failure
Date: Tue, 21 Jul 2026 17:25:58 +0200
Message-ID: <20260721152409.242978322@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@nvidia.com>

[ Upstream commit daedde7f024ecf88bc8e832ed40cf2c795f0796a ]

The re-order in the Fixes commit below displaced vfio_pci_vga_init() as
the last failure point of what is now vfio_pci_core_register_device()
without introducing an unwind for the VGA arbiter registration.

In current kernels this is mostly benign because vfio_pci_set_decode()
only uses pci_dev state, but the original failure path could leave a
callback with a freed vdev cookie.  The stale registration also becomes
unsafe again once the callback follows drvdata to the vfio device.

Add the required VGA unwind callout.

Fixes: 4aeec3984ddc ("vfio/pci: Re-order vfio_pci_probe()")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Alex Williamson <alex.williamson@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20260615191241.688297-3-alex.williamson@nvidia.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/pci/vfio_pci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -2094,6 +2094,7 @@ static int vfio_pci_probe(struct pci_dev
 out_power:
 	if (!disable_idle_d3)
 		vfio_pci_set_power_state(vdev, PCI_D0);
+	vfio_pci_vga_uninit(vdev);
 out_vf:
 	vfio_pci_vf_uninit(vdev);
 out_reflck:


