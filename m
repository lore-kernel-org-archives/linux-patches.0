Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A8916419;
	Mon, 23 Jun 2025 13:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686017; cv=none; b=Xx+VefCeQbPiNAepWDdRhBIAD10bO3Bm3sBreFeeDhUrdHnNjlVJykYkzSnoBh6qfFbomOIQe4fSbrcJk6HGYkd1GTqB/F1lmMNLl+dODd0CFcMEmu3VbEtYGmqT0q2Z/am01z57Eo+MiCyE5ELTlFUEk4a07Rv4rtQ4GnVBiP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686017; c=relaxed/simple;
	bh=A656ntGMESRxQEBCKj+acHraTQ9RGYAQtindfRPwbEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h+P+gsjLIhCTR1beMhErXUQeT97AF9+gt6VtUdy4J7b8oNRmbdt5FQpvIJ8xnkz0IxdpalGw5C1S6NGn75WB3Ow8J1TRUX3F6cVDYciesD39UDVisWJO9toQNluxWZy6GrdYSfwC66VmNMDKFRsuo588wguKKP2tTm1N/j0UhjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P9p25ySs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P9p25ySs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15515C4CEEA;
	Mon, 23 Jun 2025 13:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686017;
	bh=A656ntGMESRxQEBCKj+acHraTQ9RGYAQtindfRPwbEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P9p25ySsT2GQpe2STvj4/q5fFSLEp+kOjTLBCcThzWpBxlTowgOanHdmKtNO7lWTx
	 bT4KG5MuDYClQJMv0W6z0kQpQfr+g422MvxB400Vvm1Cu0RVEdKW5BoP0D2ssqvWqo
	 xk+vR2/p7Tqs5r9WaAClFfuGQ6IVRNNfVHHI2UW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 5.4 133/222] PCI: Fix lock symmetry in pci_slot_unlock()
Date: Mon, 23 Jun 2025 15:07:48 +0200
Message-ID: <20250623130616.093500350@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit f3efb9569b4a21354ef2caf7ab0608a3e14cc6e4 upstream.

The commit a4e772898f8b ("PCI: Add missing bridge lock to pci_bus_lock()")
made the lock function to call depend on dev->subordinate but left
pci_slot_unlock() unmodified creating locking asymmetry compared with
pci_slot_lock().

Because of the asymmetric lock handling, the same bridge device is unlocked
twice. First pci_bus_unlock() unlocks bus->self and then pci_slot_unlock()
will unconditionally unlock the same bridge device.

Move pci_dev_unlock() inside an else branch to match the logic in
pci_slot_lock().

Fixes: a4e772898f8b ("PCI: Add missing bridge lock to pci_bus_lock()")
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250505115412.37628-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5296,7 +5296,8 @@ static void pci_slot_unlock(struct pci_s
 			continue;
 		if (dev->subordinate)
 			pci_bus_unlock(dev->subordinate);
-		pci_dev_unlock(dev);
+		else
+			pci_dev_unlock(dev);
 	}
 }
 


