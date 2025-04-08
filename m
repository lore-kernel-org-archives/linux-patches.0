Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D038E268C6F;
	Tue,  8 Apr 2025 11:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111796; cv=none; b=Y2JI96thvo8I2fY+pYYIJ45eeFz84P67CWkT9mfpOk3u1qnwwl286IzLx9DtUxJ5ZB/JjdghBuNHsK/V9ZPVhAUIz4IBVmSvCjD9J+dsXxQpfjBP/H6zSQD9nsd5/DFY8SyGyNnuFadA7wRkSBGGpsp81YpJIG+gMpxIyxj6prA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111796; c=relaxed/simple;
	bh=VngpwjOEA/QstkXDnKrDQez8w4mfMvUqpkNuMCAQqac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKbH8ztW2WB8WKfL1BrKxmWxDvCSyfHWeazY/cvAsCAZhdX6a+XQQtOxhSDDANoppTpNL2e2cxrwwXTuwRZiTTvRCmOj1DZVQx4BpceYzmH4kAGKtNTDpvnc2r7GjAkEMLCugT9715A8Won6rwffQ3T8j+jsX/FMRrQ5K00FgHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nzObbVna; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nzObbVna"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E58C4CEE5;
	Tue,  8 Apr 2025 11:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111796;
	bh=VngpwjOEA/QstkXDnKrDQez8w4mfMvUqpkNuMCAQqac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nzObbVnacNBObVJJ7mHPAw8LtPc4Z5jJ2PkRGnKnDaobzDdDt0yo2HNp8Qq8XdHzK
	 6ySw535VwBxij9NdBvhV/YbTk85tbOS+fGLX23Q231jRR4xVSOeaKbcQq8hCC2iRNq
	 q9RyukEeK13d7Jmds231TdA8xRc7Viy2gHJO1yvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 564/731] LoongArch: Fix device node refcount leak in fdt_cpu_clk_init()
Date: Tue,  8 Apr 2025 12:47:41 +0200
Message-ID: <20250408104927.392323921@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 2e3bc71e4f394ecf8f499d21923cf556b4bfa1e7 ]

Add missing of_node_put() to properly handle the reference count of the
device node obtained from of_get_cpu_node().

Fixes: 44a01f1f726a ("LoongArch: Parsing CPU-related information from DTS")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/env.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/loongarch/kernel/env.c b/arch/loongarch/kernel/env.c
index 2f1f5b08638f8..27144de5c5fe4 100644
--- a/arch/loongarch/kernel/env.c
+++ b/arch/loongarch/kernel/env.c
@@ -68,6 +68,8 @@ static int __init fdt_cpu_clk_init(void)
 		return -ENODEV;
 
 	clk = of_clk_get(np, 0);
+	of_node_put(np);
+
 	if (IS_ERR(clk))
 		return -ENODEV;
 
-- 
2.39.5



