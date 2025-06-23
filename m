Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD62E1E51FA;
	Mon, 23 Jun 2025 21:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714047; cv=none; b=Ywd51tLtoIqZflzrrDE04Zt16TC03B5BX2SGTdao6HS18ANVLHEzoJSa6bEEV0HyclC9xpLhekG/yXIafXCdubPNOwQpEUHXEzzhWeYmaeBUE9XY7QOYzisNNiLueIF4bgSnli3AtzR10lvtEcYBuJUENIuZyb9Wl9fUCCdxEN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714047; c=relaxed/simple;
	bh=Vl/DKnb89In8Al0iWiSVWXbVlY9zV5qU04Ej850BAbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=siFgycN+Is8ibJ6zmq9uQLk25fDPwd/iY7pwwdbdGG0NIaC73oRqC8/LPRsqOQ127CIBR8+wydbkn4xnO3N5FIfXBLyAr1RXRp5Ibl7P5Zz+y3qexIe6xe2AmaB+r5fzBE4DEv5XZZ0E7V6jZ5CgkD0Byn7d/6JmUAmqUSv26nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mHi0AMR1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mHi0AMR1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47DBEC4CEEA;
	Mon, 23 Jun 2025 21:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714047;
	bh=Vl/DKnb89In8Al0iWiSVWXbVlY9zV5qU04Ej850BAbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mHi0AMR1HSQWE3JCr41vsDsXTe8ZbvVsFMTdFwzggLfDgrX6t8XGPpKm2yKWKFMpY
	 CVoyHSWa+OmzQZk2Y0uYvMl1NBWsWsvvUxKaW5J1Uzll37DDabWqad0mc6CVVSgH9n
	 /JaMR7SIbfDkJiGcQJHIMF41CPhi+N2uKlt47688=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 6.6 110/290] PCI: Fix lock symmetry in pci_slot_unlock()
Date: Mon, 23 Jun 2025 15:06:11 +0200
Message-ID: <20250623130630.264524331@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5823,7 +5823,8 @@ static void pci_slot_unlock(struct pci_s
 			continue;
 		if (dev->subordinate)
 			pci_bus_unlock(dev->subordinate);
-		pci_dev_unlock(dev);
+		else
+			pci_dev_unlock(dev);
 	}
 }
 


