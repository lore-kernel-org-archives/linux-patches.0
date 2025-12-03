Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C663559D0;
	Wed,  3 Dec 2025 16:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779136; cv=none; b=q30Vszkd8G6I5aNHPFvl3pPFLocVilWI8CCUivC2B9Gwqxk1cHWPlgjztBmA9p1yQjGbfKqWJn0wmq4YH1/TGy1dm8/keHKZQotNazCbE1nc3rEOZpP9f6kFK89iJ5KtdC76Yl5eHBBKjzZZiN3229oDdvDN5ip7VB1RXV3inOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779136; c=relaxed/simple;
	bh=geNFQxD6hC24fuLSssbNcbPnnOa9jkqkO/3RpxHTFvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RNM9wZ5yzA4BzK1GksSacO0GStYF8LMFrfMcsW6N75Es0Ix/klX3F2UuwnnmNQsWlpyunBothmPambPumvKxU16fzaTF1XiQRoTf7iLGau9djJSk68/mtUYjXXYYqUi7r2ueKxWWHcli9me4OZnJkE4yvuI7rAdGRepVuUKhpGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aA3Sk626; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aA3Sk626"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283C6C4CEF5;
	Wed,  3 Dec 2025 16:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779135;
	bh=geNFQxD6hC24fuLSssbNcbPnnOa9jkqkO/3RpxHTFvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aA3Sk626ss4iK301kYHPctvk/uQtpMNoXwGfM2bopIVqEIOWEoKYkXVe+joa1ins+
	 msLNDZBjnDIBz6MLq4Ai2LqvJCOV1xLdNUuev1/AYWMRdhPw9Bkwhb2/HKC3nG/WnY
	 Ls+BQM+8jPNmee6E55pWdEw9oxreVV1r117X4aQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungho Kim <sungho.kim@furiosa.ai>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 165/568] PCI/P2PDMA: Fix incorrect pointer usage in devm_kfree() call
Date: Wed,  3 Dec 2025 16:22:47 +0100
Message-ID: <20251203152446.766192726@linuxfoundation.org>
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
index 88dc66ee1c467..d5e38c6a812f0 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -225,7 +225,7 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
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



