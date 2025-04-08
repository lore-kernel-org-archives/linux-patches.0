Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7286269B0E;
	Tue,  8 Apr 2025 12:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114934; cv=none; b=PX390CfmmbE0fqgT3CIHMDd+H54YzVPAAOTV4Isi05/9TVQuI1ZmAycQn+vEYr2BLjKK2+QHYoqUMRCiHne3mvo64cFqAHoKTymgVIY54ITMAeIRCbDltwz2P5j0baYUYN+4EWa0O5n+6lrMwK64Td7OrfI06pd9KzUEwnBXs7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114934; c=relaxed/simple;
	bh=ymoogGwLlbShOh5YSUhjIcnQFS7X3+QPy5Q2NHnODuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dW0yK67slr/b1mFnYh8nlpQDxGW87fknTKv9Z0H9qTU8O6KC2ij/y6V+T3lgWolYWkU+DLLaQLg0Rjg/mE+xp5sxLtueD2InSrJ9rBnurP36mCmW0q0m+VpU7Vxl07ewIU1EBBxwQnQC8GHHMye6e+Lm0SP6HxSJ71U3Fv/KfB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VHY6WktN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VHY6WktN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2EAC4CEE5;
	Tue,  8 Apr 2025 12:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114934;
	bh=ymoogGwLlbShOh5YSUhjIcnQFS7X3+QPy5Q2NHnODuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHY6WktNHDe2Y0vIYKqfayVEsGVz84Qe9FjIfZzknF2s0tqKzJoU/6zSs62UIVyqR
	 KiQbptIflPwNv1w30H1ADxncxRurfDxLNa48Yp6ivjgRr1m+Bt6Mm5TAOOpKfw7jge
	 q6QpOO5B/Oz1ovBj6PWBjomfYmOyhD+yIH4/znPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 288/499] LoongArch: Fix device node refcount leak in fdt_cpu_clk_init()
Date: Tue,  8 Apr 2025 12:48:20 +0200
Message-ID: <20250408104858.400433898@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



