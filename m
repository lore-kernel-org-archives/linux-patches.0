Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED33C25DB0A;
	Tue, 26 Aug 2025 14:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219019; cv=none; b=oneyNQkL3JFPY82UGSKmVwDuHTOzOP3TUcf/Ow3K8CszK7ihHOmNQx7VpAaOrOWawUb/t1k90M+Gcp8GEz1OjOVkxWzxL6NMNqc9WVrC84u/DIS7LxzY9Uk/dpgySD2oUfNkfRNjjXZRGipEe838O6v9LgPgHGGdlu9d6PJVHtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219019; c=relaxed/simple;
	bh=V00XOKQuvShrlOyg+HawaU64p5mVEkWMC/zBjhYkOFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxJNZtycig5wgAd/xcU++8Qw0Ivj97Zu6HMPsPBZctxIYDaRlmjD5EGMyT9ab+jjy2IbR2N6umpQOHJgMnYXor1uzbM6lGbKqYJ29qFP4Nfbtv6a13qMp4y4YRtt5//KS+e4X7bYzqX12DUAkLEYM3q6zTB12AGlUxZs0OVAn7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bjCtX6NM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bjCtX6NM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E86C4CEF1;
	Tue, 26 Aug 2025 14:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219018;
	bh=V00XOKQuvShrlOyg+HawaU64p5mVEkWMC/zBjhYkOFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bjCtX6NMnWT4z56v8EMGPEZOVDJ+wdTo/lEwc7khGiNeDspYwvvTVnQP1M3OI9v1U
	 8CJsvAeqtMnQmc24hNTqcvCofyxbMi1ChyDxORWKbO593VhBaIarbsHjlGybMqd6cd
	 e+2fG+7cZZThb1UI6g0m4D0f1kjMUKwbCbOdhROM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 190/403] ARM: tegra: Use I/O memcpy to write to IRAM
Date: Tue, 26 Aug 2025 13:08:36 +0200
Message-ID: <20250826110912.124599368@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 76a65df42d10..dce0cb1fdd6f 100644
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



