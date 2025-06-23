Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7E3242D90;
	Mon, 23 Jun 2025 13:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684851; cv=none; b=Gk9e0ITZrv3YuvKnEQY6f+vLeiFTN2/cvYzn+ngD/vRUCzmuBtjr7jqJI0fbC3nKy0/2MjhZ7rCfjcDarAORxd0QJ3VU3PULuMMQTIvnO14Ps0xtdyE+cq9G0iLSeHFTHs8YHBQx001hpvck9dOZCprVgzg3cCYaCO2w+EKtoU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684851; c=relaxed/simple;
	bh=lMwWZW4Hpmo7Cw6RYxXgJDAcoeyfaeVIhX/tEidJ9sE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T7VAIagcjU5DfAD2iBaXALdZ2UgYVjB8pGbpTJhWS5bxYSLMbHAhWvAewW4MsyVLBEZuF9xsAo7paYLT4TLTCj/3cr2LFtvRKgL830gw/MV8QYL8iZ43B1aM2A53y0hn0fW9/Jz9UwaVsb3+XW42FZrk2aG8VZwCAIKTHzlQHs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R6aYcRE2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R6aYcRE2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F88BC4CEEA;
	Mon, 23 Jun 2025 13:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684851;
	bh=lMwWZW4Hpmo7Cw6RYxXgJDAcoeyfaeVIhX/tEidJ9sE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R6aYcRE2Nb8i4H52YoU8BIn7+eYEz9jToEIntH7g+2XipiZXT5OAP4gawcwHOuHeg
	 n5e7EGjwUvZDDO5FZcwhB96v/EBd62ki7krpgBD1PoRZpnqi+3fVxV7ox5zMmM2Ga0
	 dMmr5VM2aHjVu7YGsmJy20xrqep1BxtxDeSKQ7f8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 6.15 183/592] PCI: Fix lock symmetry in pci_slot_unlock()
Date: Mon, 23 Jun 2025 15:02:21 +0200
Message-ID: <20250623130704.636237018@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5538,7 +5538,8 @@ static void pci_slot_unlock(struct pci_s
 			continue;
 		if (dev->subordinate)
 			pci_bus_unlock(dev->subordinate);
-		pci_dev_unlock(dev);
+		else
+			pci_dev_unlock(dev);
 	}
 }
 


