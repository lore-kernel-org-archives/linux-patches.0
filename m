Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D409225390;
	Tue, 26 Aug 2025 14:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217698; cv=none; b=WD5O/te9keGimJrRdiEGki88T0yOVjiG+pki8VVu34TDWAYF5We9iTkUjAQ6BGqttTpo2eACqcS1J35R+rr+IoGV1z51eC6yElsm2Cu2uNlgwWN574m87OlNcY1mv1Ao+4EfUgDnKINOxrWkM9dmh3DdaDeQU85insAR72OF3Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217698; c=relaxed/simple;
	bh=F7X7vOIw2AFiNLTDVB2RCdU/HCdDGK80ldKt4L2ngnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l909LX7nEyeWH/w4R6KO/6m7RenIUftztIKwLzk5RheZCw8BLFn3XU8tLtxQZTHJ3ua1DyO3kTJ8uZWYHPWtBpRmBDgVaMn4RJpxeQvccSiblzBngpyXymnKVL9YTxkL8bZa7E/xjln7KS9SK6F8S6oOCWTNzx+KNCu7SolGN7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I4eJ43ai; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I4eJ43ai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296BFC4CEF1;
	Tue, 26 Aug 2025 14:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217698;
	bh=F7X7vOIw2AFiNLTDVB2RCdU/HCdDGK80ldKt4L2ngnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I4eJ43aimOS0JacidI/2M/wpBE/aW8we7zJ0X1G0zHRgdvm29BwuxgI1aGSNj/OQe
	 z2uIvk4Cr+n2alHD/0dZOclOsXoBvVbxCyIXRe0JIcNvhWQEwacyR15sPYj1G3tu+z
	 pBHRE9VSiFhPi2h5fPlu6b58KQNI2NFHAKbitGek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 234/523] ARM: tegra: Use I/O memcpy to write to IRAM
Date: Tue, 26 Aug 2025 13:07:24 +0200
Message-ID: <20250826110930.221258607@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



