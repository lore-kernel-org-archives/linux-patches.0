Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E129F34B193;
	Wed,  3 Dec 2025 16:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777684; cv=none; b=BKNZKoUDCs8pW5wxanMTPAuqLZlcI0wABBTpfs6iSd4RwcPCWitLBYkHBEXuQFQnijnjs3ncLmZKRxLfkCspZdW2OvY0dJHnqR7cbfc/uHpAVayNQT0WDXWQiBlhfRfFSxx7Bgkhp8dI5fCT8ilqgdbd2QcEqwKmsC7QW+FVpSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777684; c=relaxed/simple;
	bh=mH5AYjGNzZxFTLs5ObaIB1MJg+ZpODBaW1O+p65yO+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckxuRkguZ7Bxc7OuuBDBqxy2D2r4zZ5kkADQW9mhtNIohR6mv3QeqK03zWHQXntQHExM61+HDscs3SRW/ETDW8Q+gejl1HAb1odu52sRWIhraRtgyfXoaEHJNob2kzIKSgwW3hieayXfn/5FDZrjtDX2vPq5/w5Iswe4rx8aS4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r8ISNlYc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r8ISNlYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52AA5C4CEF5;
	Wed,  3 Dec 2025 16:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777683;
	bh=mH5AYjGNzZxFTLs5ObaIB1MJg+ZpODBaW1O+p65yO+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r8ISNlYcZuYf9GfJKQswylMbzf85AZBrWhh/5+YH+pzD4UniBV5Za68lRz02dEfRo
	 2UAVliGBU+Wyf4cp/cQrNSoCqrygLS5/wbRiT+u8U5yrchwb1wgbwclYHu7zbH4xyO
	 T4h7MOwyMCO4fGCU7PhoVSqG1sa13bpj/iypbMYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungho Kim <sungho.kim@furiosa.ai>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 114/392] PCI/P2PDMA: Fix incorrect pointer usage in devm_kfree() call
Date: Wed,  3 Dec 2025 16:24:24 +0100
Message-ID: <20251203152418.293252004@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sungho Kim <sungho.kim@furiosa.ai>

[ Upstream commit 6238784e502b6a9fbeb3a6b77284b29baa4135cc ]

The error handling path in pci_p2pdma_add_resource() contains a bug in its
`pgmap_free` label.

Memory is allocated for the `p2p_pgmap` struct, and the pointer is stored
in `p2p_pgmap`. However, the error path calls devm_kfree() with `pgmap`,
which is a pointer to a member field within the `p2p_pgmap` struct, not the
base pointer of the allocation.

Correct the bug by passing the correct base pointer, `p2p_pgmap`, to
devm_kfree().

Signed-off-by: Sungho Kim <sungho.kim@furiosa.ai>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Link: https://patch.msgid.link/20250820105714.2939896-1-sungho.kim@furiosa.ai
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/p2pdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 57654c82b08e8..e70993730728b 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -231,7 +231,7 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 pages_free:
 	devm_memunmap_pages(&pdev->dev, pgmap);
 pgmap_free:
-	devm_kfree(&pdev->dev, pgmap);
+	devm_kfree(&pdev->dev, p2p_pgmap);
 	return error;
 }
 EXPORT_SYMBOL_GPL(pci_p2pdma_add_resource);
-- 
2.51.0



