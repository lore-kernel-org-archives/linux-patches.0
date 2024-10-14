Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2EF01AAC4;
	Mon, 14 Oct 2024 14:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916131; cv=none; b=lj9EmW77DCbBNqcpebxqpwQyj/kzmevI4W4Hq6Mfi8I22Bf6XRBRzsG+EfR8Ep//mJs3hQWjgPxKHdBHBnoaI1b7mqqglerJiX1wGHCXFIsK9PgOJDXRwAx6PJPUy+rNSv+XCPPeg/bkLl+7h8ZxdR1dw8sROd80f1qnXAdQ7tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916131; c=relaxed/simple;
	bh=esL/GuGXURYy9OncXEbhBFVxmC4wdaa8Ti429tAOptY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P52mSLsMMQT3q9WDfXi34hP4hJj/ZGGZmlH68572a73gkGY8FO7w1Q4Ecx1dlQewySpIUQo9qMaXQLuv7ne5rFqixdaK1184veesB0AG4r2LrCnIqf0qPG7TxLwPTxRc03J0+SN6u2W+fwmKqZ3aMI51j+O7tRACSPJ/7OC9g4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QsPRZTq3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QsPRZTq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A163C4CEC3;
	Mon, 14 Oct 2024 14:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916131;
	bh=esL/GuGXURYy9OncXEbhBFVxmC4wdaa8Ti429tAOptY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QsPRZTq3gt3k7HCixwwxszHPIa0S9JpsHe+VBnkh872CT4aMKp3OBcfK4cRqBD76f
	 vWQpvV3MmUUjtWani3/ayxPCBarhRnFS55FOrljPZIuOAVIPtxm6NUxLAbCIQ/V+Ls
	 1XChGcI0l8CiNENiLsUrN78AfPweog3/Iy1s5Cq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuli Wang <wangyuli@uniontech.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 062/214] LoongArch: Fix memleak in pci_acpi_scan_root()
Date: Mon, 14 Oct 2024 16:18:45 +0200
Message-ID: <20241014141047.410697280@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 365f7de771cbb..1da4dc46df43e 100644
--- a/arch/loongarch/pci/acpi.c
+++ b/arch/loongarch/pci/acpi.c
@@ -225,6 +225,7 @@ struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
 	if (bus) {
 		memcpy(bus->sysdata, info->cfg, sizeof(struct pci_config_window));
 		kfree(info);
+		kfree(root_ops);
 	} else {
 		struct pci_bus *child;
 
-- 
2.43.0



