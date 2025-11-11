Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709A326056C;
	Tue, 11 Nov 2025 01:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823397; cv=none; b=T/noUtzFXeBKoDfxTOWajJGcJKH10pa8FSMsGDa9XX99wea9pFVhj6oFvMMtbSLmj6GkbyG3XD8QwBnQGL2AgZF8bK4vu08xDIwkliEKURPvURyUgNGHqPDNbe0hWB10OFlnHVq6oJCdyNhw8C7IiDd2TzejY3JuQ/5KG6NCI20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823397; c=relaxed/simple;
	bh=UEZ+xLtQODELrP4NI0QV9qO/tinaNO/tE1a+vS42bGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k54B0u2lS9cQvPazNVnqDYUNWoxcp4SjAaANDuADRexkMTRfMIMPIreIFuJBe4URzw8buUt4C/MktS8BPCIdyAGvsQAEQV7eVF4DipkyEL7/16V7Y9HKh41sUZsa0/fyQnKeZ1yocWNL9gc6JNRcJxSwnJOU2ADBtc58UKXSYes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q1IH01cf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q1IH01cf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6C6C19422;
	Tue, 11 Nov 2025 01:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823397;
	bh=UEZ+xLtQODELrP4NI0QV9qO/tinaNO/tE1a+vS42bGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q1IH01cf9ZqvkOPJAf2PmHnuJptdaE+bEluX9Sz0JnjYMVYvS+1dav11hSWAZeNkg
	 kPwDyFGO/HDtwu66UeWzYStzvXLl4Vb9OXFW8Vb3mN7FsKMsQa+hVWxhzVO4cXNrTe
	 7Zvku99RHyUYgYPGRu2Ndtvi7cmMXvEkgQNKditc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungho Kim <sungho.kim@furiosa.ai>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 239/565] PCI/P2PDMA: Fix incorrect pointer usage in devm_kfree() call
Date: Tue, 11 Nov 2025 09:41:35 +0900
Message-ID: <20251111004532.291331162@linuxfoundation.org>
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
index 4f47a13cb500f..52e1564eadd0b 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -351,7 +351,7 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
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



