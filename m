Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A285920A5C3;
	Tue,  8 Apr 2025 12:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116712; cv=none; b=ewrX77E0oQFWl8czfsBQTW0n9fmNl1BpeoBm/hI2pwaIqejrIxdIeNluNoOOQgFbu8csj7/sIUrkablNrGtekYaupMGtKdSFb/Udb0nDya/P0RdXs3SCmjjy00VgKznrOyirLsgJHuAqkLb9cxIdxSv1Uk0aLHkFn6gVX9b9bQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116712; c=relaxed/simple;
	bh=okT7HG4AIrroKni5+cIGlsCg4iC/A0a9Bxfvt6I4L2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i1EGzEBnK+I7YJVls8Urkuv664IqVV3Z8YUkPO1WeOHaHMj0iC4910bcDvitG1KxHG4XH5T5qtkwT/JbVsX1ChBd4ZXNB19kdGAjrX2SoTWKVlE3xLkEcmMPjf2UKlDGycFkNFUN8Y6OgRUtOPXIfCCKU6vghGiZDiAvfc22lS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vwc43uIP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vwc43uIP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335EAC4CEE7;
	Tue,  8 Apr 2025 12:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116712;
	bh=okT7HG4AIrroKni5+cIGlsCg4iC/A0a9Bxfvt6I4L2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vwc43uIPhBudsnjunU+uJOl39NgHJcYtysqgpdwFF35IL2mozj7S/unY5xomvE+CZ
	 UpjlsiE0BHms3Ra/zucnYeTWVmo797bWjJ+yvqVawAzKUasPHCmxzyT0sio5OIgaed
	 0hexejv0g4JBQWw6sJsuTPZP5CbYxf2jdi7O2r6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 241/423] LoongArch: Fix device node refcount leak in fdt_cpu_clk_init()
Date: Tue,  8 Apr 2025 12:49:27 +0200
Message-ID: <20250408104851.341668958@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



