Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCFD306B39;
	Tue, 11 Nov 2025 01:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823892; cv=none; b=ecjwFtbxGpeDFPpTKZtWYVeNDii9hUSlyqaW7bIXMTXQA2eTL4HzV61wrQDE1X/xou6zHlr+ziNmqt/pCn0O9HmBB1fXB5Jyhm8mjkzjZC6fgRspcRzgA27nQ4oSnRo1W4ZIbuq7AMO7wngaPvPWALN7P9fl2zylUm36B0WVLFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823892; c=relaxed/simple;
	bh=1TNWhKOPDoIeREK8uu7dOR8RUsZ07OKAmsopFzv6jQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nqwet3HOa/E5rnQP37TxLPXBjfSrtvZY5M3teCqGC/EatpuuPcJ4iCf/4jn0LEfgQBB4OYLmLGakeNpckS6vEQwlUzmiwYtN6JEG69FHHnTYyja0JrIeWb+zVpQpPuFlSclF0/5ARbGZDKqzuCai9ikHybw/7lQPKfFsobP7jNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KMwOt+iK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KMwOt+iK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD54FC4AF0B;
	Tue, 11 Nov 2025 01:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823890;
	bh=1TNWhKOPDoIeREK8uu7dOR8RUsZ07OKAmsopFzv6jQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KMwOt+iKDZMVHeRycOj+DYO/teBJYn+y/UtMMC6jxSjhJNUv33FR31I92QNKupTNo
	 nvXTGqqIePvgVxKWyDbeOQCV9gWkSoWHly1peydx21yS8DzATiccvfZ0w2364OZkn1
	 lPWGtfsBZy8vaF0NxQmPrAPLhMD1RItlNS5Dysag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Palmer <daniel@thingy.jp>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 344/565] eth: 8139too: Make 8139TOO_PIO depend on !NO_IOPORT_MAP
Date: Tue, 11 Nov 2025 09:43:20 +0900
Message-ID: <20251111004534.614089718@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8a8ea51c639e9..9c1247ddc238f 100644
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



