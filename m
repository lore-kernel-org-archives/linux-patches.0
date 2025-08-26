Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D09823D7DD;
	Tue, 26 Aug 2025 13:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214376; cv=none; b=WNi4psl3A2pn57istMxqlyO9hHI+JHovymibbBlr1Ru1xnTONW3NF1PhihiwIr+cGQKjZvG40nb+Etkg44goJ6S6cMaCrdtsNNPCVHuL4W8e1AHU5AT4k+q0SCkGHA9amVdbsg5DD4wJEpe4SlPp9YrW5+GwUYyRZJpbEwPY2KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214376; c=relaxed/simple;
	bh=VUCCmcACO8l3/KyMdG7ZIVVWkyr5Rl5s3C6lMqX2dMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m5I98cE9ZvY3K9MyDqF4CawpmzpBAStSh3dK47ftjve2orePW53Y5GdSTXLolAhi+uoCUhfHqx1XiC7aL5dnI0QUbLSqPcZVY4RpstDf36lVxyXITxwIKyrz2QkWbl2werGgHHqpSobGo6f3mk4zzA4vPXBmayn/OWmqdPyo9H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NKO/azkS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NKO/azkS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C0BC4CEF1;
	Tue, 26 Aug 2025 13:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214376;
	bh=VUCCmcACO8l3/KyMdG7ZIVVWkyr5Rl5s3C6lMqX2dMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NKO/azkS7bRs3OHTGulBAQPHYkiX4jYbFG3AXczm2F2AYh/NNTMeU+ITSg6Vccf2g
	 InPpHij5xVseUaPxbTb3u9iFyqnSWh/RgAhHUUVkm7TEGNK+ntZ7h5zuF+FZSata2X
	 X9jeFoQb7gctYl/wXDWkGFmwmXlwWhp9jw8deS0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 083/482] ARM: tegra: Use I/O memcpy to write to IRAM
Date: Tue, 26 Aug 2025 13:05:36 +0200
Message-ID: <20250826110932.881495663@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Kling <webgeek1234@gmail.com>

[ Upstream commit 398e67e0f5ae04b29bcc9cbf342e339fe9d3f6f1 ]

Kasan crashes the kernel trying to check boundaries when using the
normal memcpy.

Signed-off-by: Aaron Kling <webgeek1234@gmail.com>
Link: https://lore.kernel.org/r/20250522-mach-tegra-kasan-v1-1-419041b8addb@gmail.com
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-tegra/reset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-tegra/reset.c b/arch/arm/mach-tegra/reset.c
index d5c805adf7a8..ea706fac6358 100644
--- a/arch/arm/mach-tegra/reset.c
+++ b/arch/arm/mach-tegra/reset.c
@@ -63,7 +63,7 @@ static void __init tegra_cpu_reset_handler_enable(void)
 	BUG_ON(is_enabled);
 	BUG_ON(tegra_cpu_reset_handler_size > TEGRA_IRAM_RESET_HANDLER_SIZE);
 
-	memcpy(iram_base, (void *)__tegra_cpu_reset_handler_start,
+	memcpy_toio(iram_base, (void *)__tegra_cpu_reset_handler_start,
 			tegra_cpu_reset_handler_size);
 
 	err = call_firmware_op(set_cpu_boot_addr, 0, reset_address);
-- 
2.39.5



