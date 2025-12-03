Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BEC2FB62A;
	Wed,  3 Dec 2025 16:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779307; cv=none; b=TAxJmwwsCrmY0gfjbln1sgXdcDV3WMkCkYnkv5cMoC8Ejm3r7Ud8H9PzE8Pbd/aaZLpXYzrn/+075GEdiJ2iiJNGFCyXj1q0tfsiGaglWisRFsT02tzH5xfw5s+ISSJcBYC56VkDSHW/gD/vBNA6BZFq/m4VBbQPy4osTyZ+48g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779307; c=relaxed/simple;
	bh=nOq08zCshsXFJs+T6e3kUvgTAOUyPc8zY3QpsOSVf50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGNJ+cvXZtLasVfbn0bN9wF0bbmuKKjFiWa3bynPV5vd7qgBPToCDe8uevvHPvHDoftaIDpH1v4G0o8YewC6fooN3DVlye3dYPg9ccm/qsaiS2DXPkYbRQbIfYhtDc3ezktUxuL3GTSrjXT8kcMTd3C8V8YBxI28PwePFGR5oBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZGm8XLAo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZGm8XLAo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E83AC4CEF5;
	Wed,  3 Dec 2025 16:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779306;
	bh=nOq08zCshsXFJs+T6e3kUvgTAOUyPc8zY3QpsOSVf50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZGm8XLAojhafNy/IXMS8zIkOgQMzHJSaXSs0xZ9hFNl4TT32WJlJf6WVOrtEXBerA
	 sqOzSUcDjxvy31e/R4fCVlvWKvx8cVRES104ru/4KxtHm7yFtlJvF043P50+WLrwSt
	 THw/xzwEQfMPzqWivgOoOYt+qD+zAHB86m4CeiD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Palmer <daniel@thingy.jp>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 219/568] eth: 8139too: Make 8139TOO_PIO depend on !NO_IOPORT_MAP
Date: Wed,  3 Dec 2025 16:23:41 +0100
Message-ID: <20251203152448.743922935@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



