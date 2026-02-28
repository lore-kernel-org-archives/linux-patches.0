Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB1134403E
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301798; cv=none; b=S5eskYR1gl08xqGlsgnJSzjyU2jjEo0rkgl2GaC7n9Jx0JTMGOlnlJvXl8q59wYYXz1L2QAfO4tymb35zXuRt0aIcdTJ3W3uPprVBnNkjbOR8V7XFF/FUuvbJ5ZSUEquvwRHy9hs5aSu4OrRWwMDBGUiYV1dh2xPxvqy2Wfgz2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301798; c=relaxed/simple;
	bh=FF9CNziUjYSZgix2cXjHSw0/6+JnODZ204a47vfJczQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJgQupgc38mM/b0kHZlG55sw3P+XVtJujZOaSiQIZJz9H7YJC2IsHifPogSupHx2RYJMiyLPjqfTQiOU7nxRdPTzOCJ/GcIOyYjGnuUL4NVmq4FPewIDPGHfrZt4/ZCzdxGpXPCT8guP03ZHK1h0tdLJBeRl/jLji8wQg9MuaDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i8Wg6ZM3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i8Wg6ZM3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2837C19423;
	Sat, 28 Feb 2026 18:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301798;
	bh=FF9CNziUjYSZgix2cXjHSw0/6+JnODZ204a47vfJczQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i8Wg6ZM3KywjDNPncUJ+LlZaj7DwBvAgbzdYo2n6tBDxkv/fSk/LfSzDiINlhJ1WU
	 J2BPrVVSB2+l8n0vlEmaieyzROj2sRMnrTwxWCehoXGO7CfsbRNUvxHEFat6qpC3lI
	 gjgRK3ItTHqDjDa/39CrT/sE7uvY7p3NKfAi/2LmTESNn8p9lVB5v6a3W06rd0i8NI
	 H6N58R3ygR5GyfgjmUrN/U8AXr+/wivRjnBADVcKnatZiGbGQVFh1QhvjXDRWuWQg9
	 k5//8WbzvLtbK1Uf7NZOy5DVRJ8nJK5CLD5VqbZApPmcPXkqB4eV8T7IcUAomaACtQ
	 FNorULJp/5HGw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sergey Shtylyov <s.shtylyov@auroraos.dev>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 209/385] PCI: Check parent for NULL in of_pci_bus_release_domain_nr()
Date: Sat, 28 Feb 2026 12:57:11 -0500
Message-ID: <20260228180011.1568201-209-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index cc6e0377a998a..aad6cb7949ff9 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -6886,7 +6886,7 @@ static void of_pci_bus_release_domain_nr(struct device *parent, int domain_nr)
 		return;
 
 	/* Release domain from IDA where it was allocated. */
-	if (of_get_pci_domain_nr(parent->of_node) == domain_nr)
+	if (parent && of_get_pci_domain_nr(parent->of_node) == domain_nr)
 		ida_free(&pci_domain_nr_static_ida, domain_nr);
 	else
 		ida_free(&pci_domain_nr_dynamic_ida, domain_nr);
-- 
2.51.0

