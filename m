Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679562AE68;
	Mon, 30 Dec 2024 15:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573811; cv=none; b=WZUkau1cJn5doizMUiuTvPgZbraAKFsHGw0fan8nT2MqoTfwtYvxT8qtUvJJjfzXgkKgZ9+R0RSesn4G1VyBrDGkwONJ2jEPETDDNyV9vXCSd1J6AGfTKnxDvajf3ijziD+BxdY+4A3WsTI9d6HZ4qqqCY+a/G3vga5Gbh2Gr18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573811; c=relaxed/simple;
	bh=kCR4VPICakEOeAf8qLR8X7JXpKmx+LsCsgnoX37r4/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/sqzRhTtYo9Myx9skh5UxEsnAatopjlGn7xXjlVLeG9yKyCvVyu53tDtY3Wwsl3eDDEBhcFz4mkBP2QehHJD9xlwooIy2Shu5iqfdBegR5BBP9htFdnlct+ZGCoeZV5n+vMUNa/MLWKmT45uX+UuCoKRgxOBw0zNcoxxuybxlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wzErkcH7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wzErkcH7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C864DC4CED0;
	Mon, 30 Dec 2024 15:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573811;
	bh=kCR4VPICakEOeAf8qLR8X7JXpKmx+LsCsgnoX37r4/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wzErkcH7WYoWgDEiTurzFQFP9S5ZxUvtFKH/yDCXipX7fKqUYx5o3UEaHROCCL2qa
	 z8gASmY9iwmlrzZ8Ojf8e6+zR+MUB2jjKP5v9sXl1fn/BbxMWvuqhdx3D4Sa0FX9gf
	 5pPhzm8yMljBqLcZf6EEt6ucvAibrtdH3jaX19f4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuefeng Zhao <zhaoxuefeng@loongson.cn>,
	Jianmin Lv <lvjianmin@loongson.cn>,
	Tianyang Zhang <zhangtianyang@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 41/86] LoongArch: Fix reserving screen info memory for above-4G firmware
Date: Mon, 30 Dec 2024 16:42:49 +0100
Message-ID: <20241230154213.276218169@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index de4f3def4af0..4ae77e9300d5 100644
--- a/arch/loongarch/kernel/efi.c
+++ b/arch/loongarch/kernel/efi.c
@@ -90,7 +90,7 @@ static void __init init_screen_info(void)
 	memset(si, 0, sizeof(*si));
 	early_memunmap(si, sizeof(*si));
 
-	memblock_reserve(screen_info.lfb_base, screen_info.lfb_size);
+	memblock_reserve(__screen_info_lfb_base(&screen_info), screen_info.lfb_size);
 }
 
 void __init efi_init(void)
-- 
2.39.5



