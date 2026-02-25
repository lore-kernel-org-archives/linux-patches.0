Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2E22C11CD;
	Wed, 25 Feb 2026 06:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002592; cv=none; b=eab8n338HNI4wRF3zUy78d15YCFc9Zy9uI5aQcj8tvx02ihZmkLVg7hJwMx2f7ierakces7EC1tSc1cLQhXpyhOYVLpXbXmv9gEW4x7b6G1JGK7iDqnRSz/YBS7iOLUVAG7ShYJxhAJ3P58TVrgey6YX+OW3ijSg5EvYo77LCXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002592; c=relaxed/simple;
	bh=HhpHl69Q7YIztPTHyw4ZuAHJHPtaI7OcQTMBiOZPqEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z0XuAWIo0oVjP04F9Kl04sZIBcRwtGPxo/Y7NMx7HyzPR4lTFK5Uk286YuKTcnojUyq802pFj6SdwyMX/IxOrMaYROyr9aFQu1Gg+g/d7djFwEFA70euGIxtDXaN3n8u4fw6xsXCRKlBTvUcSJ3za6z93ASJTdfvGqvpQiokyP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1KxFjIDP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1KxFjIDP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 402DBC116D0;
	Wed, 25 Feb 2026 06:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002592;
	bh=HhpHl69Q7YIztPTHyw4ZuAHJHPtaI7OcQTMBiOZPqEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1KxFjIDPzsZgJUE4YrvWxz6uOITMtDAFeRVxN8C/HNrueSj7+LOFX4Lx8M0761Kjt
	 OzzowKj5tGAYn3I9TBFYn6KUBCnOWQKjpy+oBkXUFewJHPOJxp9SGXjb25qtrfQ7yi
	 invCx+aSDfKgsIr4ZotSwvrnCg12OrhEWG7/DjcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@auroraos.dev>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 282/641] PCI: Check parent for NULL in of_pci_bus_release_domain_nr()
Date: Tue, 24 Feb 2026 17:20:08 -0800
Message-ID: <20260225012355.607090768@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Shtylyov <s.shtylyov@auroraos.dev>

[ Upstream commit f7245901de8978d829f80b3d8e36ed9a8fd18049 ]

of_pci_bus_find_domain_nr() allows its parent parameter to be NULL but
of_pci_bus_release_domain_nr() (that undoes its effect) doesn't -- that
means it's going to blow up while calling of_get_pci_domain_nr() if the
parent parameter indeed happens to be NULL.  Add the missing NULL check.

Found by Linux Verification Center (linuxtesting.org) with the Svace static
analysis tool.

Fixes: c14f7ccc9f5d ("PCI: Assign PCI domain IDs by ida_alloc()")
Signed-off-by: Sergey Shtylyov <s.shtylyov@auroraos.dev>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260127203944.28588-1-s.shtylyov@auroraos.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 08a8c17ba4b12..82e323b5aaa25 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -6717,7 +6717,7 @@ static void of_pci_bus_release_domain_nr(struct device *parent, int domain_nr)
 		return;
 
 	/* Release domain from IDA where it was allocated. */
-	if (of_get_pci_domain_nr(parent->of_node) == domain_nr)
+	if (parent && of_get_pci_domain_nr(parent->of_node) == domain_nr)
 		ida_free(&pci_domain_nr_static_ida, domain_nr);
 	else
 		ida_free(&pci_domain_nr_dynamic_ida, domain_nr);
-- 
2.51.0



