Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1163081C6;
	Mon,  1 Dec 2025 11:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588486; cv=none; b=mv9wgJNDdFsH0jY/dbLxFmiE6FVrSnYlWhn949egWG+0o+5/yLH/m0lQYBzpA3F8JjthCyb3P31cqQkkFBYkNuf/MRRHQTgX1n2EGikZlaRJ+cW707X6GLTXfaBk7pNOYhd5gubDhXf3iLY9xY4xC69Zj83qdRc/Q8XH1kooj7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588486; c=relaxed/simple;
	bh=IfWdrLM3NsQ4xNTEjysF3xbOmGOuTlgXb7GkiBfQ8dI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CmkPDPT6Rd8iJ2Cfbl0AehvyOspVESp3mNsAQAjd+UMaljp2tc4ZC65KkCACopb3zmrrl7HZVaL+untvI2kPhpSwXsuxK3Z8dXyNEVSi6kfwxQGEKI13VJhhw60Jm2vaJZsQTD1RY6WEUZVMjq2zKDmjpJLUy48tLA7FOse1Dm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xw1K5M2s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xw1K5M2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59CDC4CEF1;
	Mon,  1 Dec 2025 11:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588484;
	bh=IfWdrLM3NsQ4xNTEjysF3xbOmGOuTlgXb7GkiBfQ8dI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xw1K5M2s63vGpGGFX4bprVXSnTWPx3UiZuarRvsACnU1U3VpQas+selLOX4cH6BE+
	 Ox6ZCZGjZYZqZZo+Emx+pPpucZqO7OY+sSS+5VUtBWyFIIega3FuI8HhJUTwrEE4lO
	 1eKZXGpw7ma9ca/X2KriSmJGjCSS0C02hwJgIMk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungho Kim <sungho.kim@furiosa.ai>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 064/187] PCI/P2PDMA: Fix incorrect pointer usage in devm_kfree() call
Date: Mon,  1 Dec 2025 12:22:52 +0100
Message-ID: <20251201112243.553948925@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 0153abdbbc8dd..fe50d147e74ef 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -215,7 +215,7 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
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



