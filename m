Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5EA304BC2;
	Wed,  3 Dec 2025 15:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776219; cv=none; b=Dlc1HAwbKaNrqIk84kBlEwX7aO9EVFHoi9VV/MkRYMYafIKpIi0oVH3B11MFgCrZImU4+md/IlXP6BlCyj3E95nkLoJN8tE0zx0aF2Y2SCybePL1iwd7lHLkI8pLbSbMaZlF7bycMp7F8El0j08+jOvYWQGPv39sH9fqFNFrq+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776219; c=relaxed/simple;
	bh=1BC9FHrRDGzZbkCf7fZ1bo2/EndcVRipUfR0m+Uma3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K4G16BqjxbZzoGn5hEBz1mTn4xeMsHG2UjOaf+oYZWaiNo5pYq/ZjIJR69zLoJ/1fWSvKSr1vxxJDDazOkCH2cVs5x0xZ52Pt10Vf8EHoBjMONgtT+ZKoOp7K3LcvdaARZxCRxzJP1PyNA0sKXSCi93h3ytDFACApTAl6K/cqVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ebjaUPst; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ebjaUPst"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8719C116B1;
	Wed,  3 Dec 2025 15:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776219;
	bh=1BC9FHrRDGzZbkCf7fZ1bo2/EndcVRipUfR0m+Uma3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ebjaUPstKbwuRwQ6MCdtaKUgaaVH/xVrZvpmwdg9P13nfoF2skaQOMadiXOnrYvgQ
	 945Q/3fx8/iN8FP2TyR46SlqhHQ7ueQkYVpl+syxx7vIZOBBsAhM/Ozt28Y//keP5S
	 kTO1+lt/uRHiuQflReZdsKoVExrV8PHDLGyptzGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Palmer <daniel@thingy.jp>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 116/300] eth: 8139too: Make 8139TOO_PIO depend on !NO_IOPORT_MAP
Date: Wed,  3 Dec 2025 16:25:20 +0100
Message-ID: <20251203152404.916421075@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

From: Daniel Palmer <daniel@thingy.jp>

[ Upstream commit 43adad382e1fdecabd2c4cd2bea777ef4ce4109e ]

When 8139too is probing and 8139TOO_PIO=y it will call pci_iomap_range()
and from there __pci_ioport_map() for the PCI IO space.
If HAS_IOPORT_MAP=n and NO_GENERIC_PCI_IOPORT_MAP=n, like it is on my
m68k config, __pci_ioport_map() becomes NULL, pci_iomap_range() will
always fail and the driver will complain it couldn't map the PIO space
and return an error.

NO_IOPORT_MAP seems to cover the case where what 8139too is trying
to do cannot ever work so make 8139TOO_PIO depend on being it false
and avoid creating an unusable driver.

Signed-off-by: Daniel Palmer <daniel@thingy.jp>
Link: https://patch.msgid.link/20250907064349.3427600-1-daniel@thingy.jp
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/Kconfig b/drivers/net/ethernet/realtek/Kconfig
index 93d9df55b361a..01811924c4db4 100644
--- a/drivers/net/ethernet/realtek/Kconfig
+++ b/drivers/net/ethernet/realtek/Kconfig
@@ -58,7 +58,7 @@ config 8139TOO
 config 8139TOO_PIO
 	bool "Use PIO instead of MMIO"
 	default y
-	depends on 8139TOO
+	depends on 8139TOO && !NO_IOPORT_MAP
 	help
 	  This instructs the driver to use programmed I/O ports (PIO) instead
 	  of PCI shared memory (MMIO).  This can possibly solve some problems
-- 
2.51.0



