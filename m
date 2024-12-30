Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A8915E8B;
	Mon, 30 Dec 2024 15:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574181; cv=none; b=loXNDD3ApMkCOPkjleAfNnuEZ27nBgaFhVrsqpTzR7wYtS4fz5iVvHywX+2sNdKitMO9FEAnPVRhyMLHnOcoMvdYurfSZdY75bsdgjPVQCBB6t/cs8+sQrcWPjoMWF6Lbxy397YfsD2HaapKt4URwz1Dn9LV/9snbsalnC0uiog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574181; c=relaxed/simple;
	bh=bHdF7fweE2M1CP11+2RWjg449RYjn1Jsjf+p0XYwZ/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CdolQqF/y3tWDiXJQY3xEa73FLUcB7eNHSDbQR9/M71G5BHXLxMfWbJtDYHuQK/QjXCoycKK/wIoJ8Dlh47NzJh/zzVB4NunYwpN1hxJ9iWu8ZJ9bkj3ICZQFwUxL3W5nkAACRcd423bUv6idKp+17goU9CHgN5u1mCL0WkJxpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P70/E/JG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P70/E/JG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32295C4CED0;
	Mon, 30 Dec 2024 15:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574181;
	bh=bHdF7fweE2M1CP11+2RWjg449RYjn1Jsjf+p0XYwZ/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P70/E/JGZvxUt6u8WwaxOGa2P9/cWI8eBYK9gfAVbBtAidmR82BW5NLOmxld3Rnmh
	 1KzPtTfFtKtjAnMno0tFni8zav8RmLQObdeyYDr93tAAz1M4J0qOXfqgvJzLDiPqtJ
	 dmDJ0mLX1LE3MH+h2+KZ3dgRTN/lADLkcrSKrHag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuefeng Zhao <zhaoxuefeng@loongson.cn>,
	Jianmin Lv <lvjianmin@loongson.cn>,
	Tianyang Zhang <zhangtianyang@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 061/114] LoongArch: Fix reserving screen info memory for above-4G firmware
Date: Mon, 30 Dec 2024 16:42:58 +0100
Message-ID: <20241230154220.443365081@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 55dc2f8f263448f1e6c7ef135d08e640d5a4826e ]

Since screen_info.lfb_base is a __u32 type, an above-4G address need an
ext_lfb_base to present its higher 32bits. In init_screen_info() we can
use __screen_info_lfb_base() to handle this case for reserving screen
info memory.

Signed-off-by: Xuefeng Zhao <zhaoxuefeng@loongson.cn>
Signed-off-by: Jianmin Lv <lvjianmin@loongson.cn>
Signed-off-by: Tianyang Zhang <zhangtianyang@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/efi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/kernel/efi.c b/arch/loongarch/kernel/efi.c
index 2bf86aeda874..de21e72759ee 100644
--- a/arch/loongarch/kernel/efi.c
+++ b/arch/loongarch/kernel/efi.c
@@ -95,7 +95,7 @@ static void __init init_screen_info(void)
 	memset(si, 0, sizeof(*si));
 	early_memunmap(si, sizeof(*si));
 
-	memblock_reserve(screen_info.lfb_base, screen_info.lfb_size);
+	memblock_reserve(__screen_info_lfb_base(&screen_info), screen_info.lfb_size);
 }
 
 void __init efi_init(void)
-- 
2.39.5



