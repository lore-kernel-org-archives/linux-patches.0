Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11614310782;
	Fri, 21 Nov 2025 13:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732722; cv=none; b=ChGufXvyOEHzqBqcPLr768rEt0GBklUBCzZvH/f04sHJxIUYI+b1R4YmifWY9Pc1hr+awQtkOMP4pF/PXJCWTPaHloz7CWJTqJqWEB25ccUBx0FDq0KYDH3zeOg+uX3usaYmjcYYtM6ivEx7Yp8RH5oGSdyVIGesjcuR97Bh+W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732722; c=relaxed/simple;
	bh=UyLAJW7HNwzF33JZtw2DTx4Sto1p5Z2UMlNPe6ZP7iQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUxaKxCE3B2Igpi45J62W88dvF3f4iimpIIeVvgeIR1pAqbHcmyMHbZMFS5sR8sn5hlzGaDWY4BijGXvkwNXuWc8ESzN3ymMOEA1XVJzBzmQKle+0TtW8ZKyI1uR3Pxla8YepN1kCXlcTXAl8NvnYJtZY6MXn1Vp0/zazvRa57k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0u5DdmW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0u5DdmW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 910AAC4CEF1;
	Fri, 21 Nov 2025 13:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732721;
	bh=UyLAJW7HNwzF33JZtw2DTx4Sto1p5Z2UMlNPe6ZP7iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S0u5DdmWkbQgMO+kdh1txRSI4cn5YTCJ/jJkBR/eNgVZCBGxufjbEkNuFBWW9KDbL
	 O81rp5g66bpsc2kBN6gca5a5snGy6zjFprh6hiavKQ4ArX7y4tY7Uo/3wRzGEYTiNi
	 CJJIIwGIApOpaouUBpSXUFBcd3u7KEXR0CLS3ELQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Palmer <daniel@thingy.jp>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 221/529] eth: 8139too: Make 8139TOO_PIO depend on !NO_IOPORT_MAP
Date: Fri, 21 Nov 2025 14:08:40 +0100
Message-ID: <20251121130238.876482429@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



