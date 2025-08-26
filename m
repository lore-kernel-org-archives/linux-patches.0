Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBD4350D47;
	Tue, 26 Aug 2025 13:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216168; cv=none; b=VX7htjKugCjJRY9525hyoCbe68+Fd5Jf6KriRsYbIEUavnFZ3RKjZIy5ewqCH1nHRbv1bXBANAefm/Q+BI5JXGWx4cAELb2FTDGeyYo6cjJ2hvuxKb3gy7odNivMPRfJrvWOw0osjqmYhTrtDIbN0c4FotBK7OrL1j2wumUzzx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216168; c=relaxed/simple;
	bh=BRPYqSg5XzxkxwoXrHT8aOpEHcmJU/tYihz97jxjBuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GaS/X8MN/h3aPIN00dgmcklTbaa+C+78EVaqKOnpuIeBCEVF//oYdrthI5bFalXHVug05y3c+nq3BBk9WX7C+OZ9EWH5WhjMWuNabslYFng0LgT6t+Cj8KVEcAd8Fkg6+KuX8IPlhRttFtghQacOm3jyofekX1av74mzNhmcpKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QaG4Axbe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QaG4Axbe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE94C4CEF1;
	Tue, 26 Aug 2025 13:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216168;
	bh=BRPYqSg5XzxkxwoXrHT8aOpEHcmJU/tYihz97jxjBuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QaG4AxbevkCcMK9m1nUoi2X+8uqqW1oP0WBZird6tXKnLNiS6BZ/+4ZDwUI+IuLPG
	 OmcvG0q7c+bV7fnTZ/DaXOmCl7NFoy7Y6StcTf85r8nCNLgbqs+nCopSbudNNSda7f
	 8rhEz/jQljLIyu4LRw2D3nOQ3CbUtVc8JwIkajPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 311/644] ARM: tegra: Use I/O memcpy to write to IRAM
Date: Tue, 26 Aug 2025 13:06:42 +0200
Message-ID: <20250826110954.090872496@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



