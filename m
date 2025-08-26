Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2EEF189BB0;
	Tue, 26 Aug 2025 12:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212790; cv=none; b=qWjvGdwuoovU/YenM/fk1rwGEvquR/63qJfXzluop7ckGM9eYBP8wLLsZwelUT5FqZWuj7Ss1YIPU8CJoFnAD5ntrUWgXyBNMMtXi1ETCV7UCYKl+Re+0/GQVRRkJ1v5uU7gUbjFNsj6s1WSg7wpyhD4lO7UpqEOzfjtwT/5LiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212790; c=relaxed/simple;
	bh=qr6uKAxZ/cEz8khLBBuxOzCE3owDnYXDOAj1BDYI9Dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avRlERr2Z1wZ6yvP/kubzdOIjzmjbsWaiSY8kqJk5z1ilJGHakNIPElaz6KkRRZLMUykOBcxfnj1IdNoCg8zZPr4TR2PxOsv5eKFpTo9I7iPtKklF2vLgaTwIvIg7aVAgZUrcazCCVCUDJ7H19OuPFnV07mgmR/mie3C3/7dHts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L9sn7nqh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L9sn7nqh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61BFFC4CEF1;
	Tue, 26 Aug 2025 12:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212790;
	bh=qr6uKAxZ/cEz8khLBBuxOzCE3owDnYXDOAj1BDYI9Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L9sn7nqhRRHP1bZGciSsRUF8RFC9aUm08rNL31zndD1bHgHWR4sw/hUlv3OE7IoTd
	 2HKJWUapxxROMuj+IvtWGAeC3afRe6RxdZ83/Z/nFXfCxpMLd9g2hOlkMwcSGK2abh
	 UoLYNCVT2/HmM5F1xJiP7YQKibtDBMgcOE55AO44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 104/587] ARM: tegra: Use I/O memcpy to write to IRAM
Date: Tue, 26 Aug 2025 13:04:13 +0200
Message-ID: <20250826110955.586180310@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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



