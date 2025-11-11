Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC742DA757;
	Tue, 11 Nov 2025 01:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823624; cv=none; b=m5o+XxUA+Z7T6d4lbfMu6OE5yQWJ0mZ/F9zGx7KoTDpMT/sKl1OgrjkDFm8HTqQCuxrFnGZEkqNhBffNyWubxsjuLrYD0wp6AlS0S4Ucn5ObRvXrS6SFkDRQUl+9TGsyMXr4YBoYkuCbCLQDo9UxBBZjXqkheA8FMZiy8rXkums=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823624; c=relaxed/simple;
	bh=nsAPtHZnTeTNbwUi5+Y4olP3eQ4YcA+MHiacYFhRxcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SVqZFFjOVDePuQnh3i7bBANNPeCtg+D8w9OgWIlCMmERyGzxJA9YpizNsJm80K+axC4scNZbCC2KzDeZLhOkFUQtAiv4wSOLmFFZoyH33b+lc+jpNbWCszQ6+lDHRsUfsxeALQeREgjPJsj0P3S5IjQe3GWMoEvXhVFTPxog9Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C53glXtX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C53glXtX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6598FC4CEF5;
	Tue, 11 Nov 2025 01:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823624;
	bh=nsAPtHZnTeTNbwUi5+Y4olP3eQ4YcA+MHiacYFhRxcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C53glXtXLRxh312Ack874+syPZkOO9Y4yOgP5R0PbMnkv9Y0SJ36b5A7QfnJ4bGq7
	 /dozh3oKtVCDdpew8PYXT/3jcoA6gAefCnVvHWhjrp5LD3zHJc9xa0H6oq+SKU/xTE
	 u2xN3QH4vlUrZ91GWY0PNWXe4PJ8epyjDqFcL4Hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungho Kim <sungho.kim@furiosa.ai>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 338/849] PCI/P2PDMA: Fix incorrect pointer usage in devm_kfree() call
Date: Tue, 11 Nov 2025 09:38:28 +0900
Message-ID: <20251111004544.591764753@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index da5657a020074..1cb5e423eed4f 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -360,7 +360,7 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
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



