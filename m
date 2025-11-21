Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7B434DB4A;
	Fri, 21 Nov 2025 13:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732544; cv=none; b=PetJOd9JZ9oCEzQrv+Mxc38PlFjkwHUkTsUmyE4w66IEUtXPqrrgfht1ESjyBsglh406a+EvA4dSGqMRjU1iVuFhVWJq4RdjW6bw72rd5MzENO64vqqnRQ6hp349Ae/hNDiY8/sQfj1/WEfY4NOrMaKLJg/rV7u/Z6vqtX4QH8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732544; c=relaxed/simple;
	bh=ijIranvC4FyW/XMQ3fm2CKXfRfGrTMrIXf1nQ698fmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cUT6A+Fst/lZE1h18mYy7/YM43nP9IXMXHKHlALZb3SIItig4Dl7VFpMQCeZvlGPboCin+VzzgZfZOz5PNgkSBHnbYVaPBIlW3vLryfcNjSvqvOGpM8eIUMtA/ryBj9wEN9QRji9syVudwO1DwmJWdbDgjiTV9TnuOdfNRGI8P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fvtjqdNQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fvtjqdNQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35BDCC4CEF1;
	Fri, 21 Nov 2025 13:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732544;
	bh=ijIranvC4FyW/XMQ3fm2CKXfRfGrTMrIXf1nQ698fmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fvtjqdNQ2oEA0i93rPMPyGsjEQHA+z1Za2hZcWi3WaRXVEBTTks/Xc9bvAQ/FQ4WS
	 OnjH+thqoZQCNNZIKyq39Fl7pcAzCczxG/Er6m9jCJwKRIoxdqJAhCR1gw00szOLux
	 1uDJshIvWFDvys6olCMk35j8J0JNO2j6rlQvb8pQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungho Kim <sungho.kim@furiosa.ai>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 158/529] PCI/P2PDMA: Fix incorrect pointer usage in devm_kfree() call
Date: Fri, 21 Nov 2025 14:07:37 +0100
Message-ID: <20251121130236.641009498@linuxfoundation.org>
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
index b8becc7257cda..0f1e431bbfc20 100644
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



