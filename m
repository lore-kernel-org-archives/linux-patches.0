Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05206214E;
	Mon,  8 Apr 2024 13:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581276; cv=none; b=s+1XBfqaZlkdgiypuRIp8YqePMttc4ibYyRWnI0iJOV9/Y/pKHZ2keKKXSp0grlGh25sd0B4M+YvdwN28FEx2W3O/xhtFIybfDphtH18ax1DWBmrAmufQh8XM1FBBXBEc17vy4XwH47xWfbTiaE3FLh0/kXaBRyKBou8RDBzU/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581276; c=relaxed/simple;
	bh=uXpcPycxOh+8UbN784v7V0+P3UH9QGsZ2pyovsn54f8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MjlThScUE6kNSDvPEqk8Ltsg8UmXKNHlsxIv71v5G8UW5WTmas9NBMN1IA+ivwVQX68aMM6MHQasUAaVEgDV5WLasq0xrJdkICXEvYBJA2PexToEWDo+h1eaTcBN7p2Hm/cNx9EZ/ueY1q2px+/ym7w0EtfWvpRTP8eIofZPYBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bfbYtgWA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bfbYtgWA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D642C433F1;
	Mon,  8 Apr 2024 13:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581276;
	bh=uXpcPycxOh+8UbN784v7V0+P3UH9QGsZ2pyovsn54f8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bfbYtgWAIzTGNfCmEWfRcmX7gby7elq0kGfscpjVqU/3kuHzaN0ktshqBzt42dUmf
	 Jc3gI18LXZwp7Wes4XNl5rPfWrzo0TRtUuqENAmJTaeDxgbswJMca60l9aBD7TOq0h
	 ZrYRr6TItkMAoSz7HLK7MWVccXr+URFI1LN3wiAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@redhat.com>,
	Arnd Bergmann <arnd@kernel.org>,
	Philipp Stanner <pstanner@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 017/690] pci_iounmap(): Fix MMIO mapping leak
Date: Mon,  8 Apr 2024 14:48:03 +0200
Message-ID: <20240408125400.183067079@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Stanner <pstanner@redhat.com>

[ Upstream commit 7626913652cc786c238e2dd7d8740b17d41b2637 ]

The #ifdef ARCH_HAS_GENERIC_IOPORT_MAP accidentally also guards iounmap(),
which means MMIO mappings are leaked.

Move the guard so we call iounmap() for MMIO mappings.

Fixes: 316e8d79a095 ("pci_iounmap'2: Electric Boogaloo: try to make sense of it all")
Link: https://lore.kernel.org/r/20240131090023.12331-2-pstanner@redhat.com
Reported-by: Danilo Krummrich <dakr@redhat.com>
Suggested-by: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Philipp Stanner <pstanner@redhat.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: <stable@vger.kernel.org> # v5.15+
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/pci_iomap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/pci_iomap.c b/lib/pci_iomap.c
index ce39ce9f3526e..2829ddb0e316b 100644
--- a/lib/pci_iomap.c
+++ b/lib/pci_iomap.c
@@ -170,8 +170,8 @@ void pci_iounmap(struct pci_dev *dev, void __iomem *p)
 
 	if (addr >= start && addr < start + IO_SPACE_LIMIT)
 		return;
-	iounmap(p);
 #endif
+	iounmap(p);
 }
 EXPORT_SYMBOL(pci_iounmap);
 
-- 
2.43.0



