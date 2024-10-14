Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772851AA7A5;
	Mon, 14 Oct 2024 14:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916890; cv=none; b=m0+PI4d0oqYM4q8Q7a76Bg/23oxJoKOlY/dCL0wOGCKmiJtY2nvMth2hlxR8f/TmEIzgHpb83VkUnAmd5fEvvYphO94abz9u3Bs3nnTbzAN9ey6gHpoQdldiebra7SEOTYz/xP8j5Ravn3UFfJj52WLLUL9MXGRzsw4tIYtax5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916890; c=relaxed/simple;
	bh=f7wzQBUinYt1JnCTDfeMb90bk0kFq6Y8UC/XScY8GBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FlwCatbUeW3pM1YedvXkwd5nCzjawOC0KZLUgcphhrvzkvkjgW29qvOBSv8Yd8gHTORcltvwDSNqzEbdZddRmsTxIPnrViesOLJTP91UoznLDilnMfDMiyWjv5JDiw5wCtdwS/gv7i9tKjgxSDS9IyeiGqtJ9EM6g9iFcBejVyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e8iWH28w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e8iWH28w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027E4C4CEC3;
	Mon, 14 Oct 2024 14:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916890;
	bh=f7wzQBUinYt1JnCTDfeMb90bk0kFq6Y8UC/XScY8GBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e8iWH28wSalc21qGMm3IsOt2hmJmBz/0uncu+1mHbpAor2tEnZwxK6t2j1m7Q6SUE
	 wB6fwhd3XHAWl2weyxGk3AL0etUCNpZYQ5nsFh5wGSkfghspRVH7MfiV5wFo2458Vj
	 8NM6upQvo9iv83riaOO9S3e9lhm6Z9Doiw7vVnsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuli Wang <wangyuli@uniontech.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 093/213] LoongArch: Fix memleak in pci_acpi_scan_root()
Date: Mon, 14 Oct 2024 16:19:59 +0200
Message-ID: <20241014141046.600555902@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



