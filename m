Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A03220323;
	Mon, 14 Oct 2024 15:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919811; cv=none; b=CHorLf2Vtk8q5ng/hGt4NdmyZVx6pctANlh5t47ljiJzFRvGDLcAAZq9hq5/KuygjkflOrJ4Pi2U71Fc15QmA+bAisu4wt5E13n+AHsk7h+OFJwwLo0Um5qmxkIXGRZd7xGC44m/gGm4i3ijGwo1LmKzrjbSeS1lvSZUfdiEzSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919811; c=relaxed/simple;
	bh=nO4sN3gN167JjI03w/BncRNUTAur4QvTmibXLzn7owY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AF68LHIRa+XPpsC91IBrDW+BhdOlvRWeACW6ejTDFPXExIyHZXFbni72sZulj3/sks1g4TWU8F0PXjB+7QyVzxRlYzGWhWyHse7NVnx8ShOSVykdE93iJojqqVBQE8ElIRdHEQg3CM2RPCsuu7FQwQVfS0/FihRrgE/yzp8I/nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eYe8YBIk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eYe8YBIk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90892C4CEC3;
	Mon, 14 Oct 2024 15:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919811;
	bh=nO4sN3gN167JjI03w/BncRNUTAur4QvTmibXLzn7owY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eYe8YBIkIoNVrDAVPzaahpaMb7hKpFKttXP9ui4ELboY5kEsXMI5c+SZbG5FT5NJa
	 adtvAjUo/2GOVFtcCjYn0rPV0Irqr8Wd6K5VQA1nM+lkV4F5cQdhsyansZpxELpnrQ
	 UFvZx6Yr1OfEL776/HvzBr79qP//jYj/hr82IwFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuli Wang <wangyuli@uniontech.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 714/798] LoongArch: Fix memleak in pci_acpi_scan_root()
Date: Mon, 14 Oct 2024 16:21:08 +0200
Message-ID: <20241014141246.118248087@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Guan <guanwentao@uniontech.com>

[ Upstream commit 5016c3a31a6d74eaf2fdfdec673eae8fcf90379e ]

Add kfree(root_ops) in this case to avoid memleak of root_ops,
leaks when pci_find_bus() != 0.

Signed-off-by: Yuli Wang <wangyuli@uniontech.com>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/pci/acpi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/loongarch/pci/acpi.c b/arch/loongarch/pci/acpi.c
index 8235ec92b41fe..debd79f712860 100644
--- a/arch/loongarch/pci/acpi.c
+++ b/arch/loongarch/pci/acpi.c
@@ -222,6 +222,7 @@ struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
 	if (bus) {
 		memcpy(bus->sysdata, info->cfg, sizeof(struct pci_config_window));
 		kfree(info);
+		kfree(root_ops);
 	} else {
 		struct pci_bus *child;
 
-- 
2.43.0



