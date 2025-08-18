Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEDD2264CA;
	Mon, 18 Aug 2025 13:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523353; cv=none; b=W6xXmZY0wBbzzsXJdZo4nsHV/yH6oJZygJeN/D6uyoLUEP0HYVtwYfWHv8JQFKJuAFxWu58jbhnnADp++qsfGp5ZjSnIKyG1ZcmQu/qKNZz9vIsj0ObKLCVZ+MXAzsinuR59ln5oX9qTzd3mkyRbQDJUwo/B4feLiGhl/m7A10w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523353; c=relaxed/simple;
	bh=l0ByJIU/rDDiK03sdHdffvvsauIe2BgWRDd4Ar8QcNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJfW3ReL4TWLDq7h44s0KKPuis1lnWF1T6aUb5vu8CmV2VRxKX6K5tUSnNP+t3XrQyWy+lUAAGQMErKM+FJ5nJU8mpq4jAZ5t4q2G+iPoDfD1eIUx9BsLOZPRR9o3J9dsIIzflqoBHk84JX0IksrgjGF3yR3a7ByLRTO7gb3hwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xukf4sGI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xukf4sGI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F56C4CEEB;
	Mon, 18 Aug 2025 13:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523353;
	bh=l0ByJIU/rDDiK03sdHdffvvsauIe2BgWRDd4Ar8QcNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xukf4sGI5OJfMRfdFeHKtPr0Qxme33de4pL/iX8pqiAFlHey5Dq1QSVHzDpJKHz93
	 QxVeqfDsdBMUPpKd23u0cI4OqbURTFU01NxqWcEF5xyWfBGD4TZ6XdkxwohFSU2VrM
	 vg/ahE5WyNoCM0WUCmoweRKq+upE4TrbDeDYUDuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 144/515] ARM: tegra: Use I/O memcpy to write to IRAM
Date: Mon, 18 Aug 2025 14:42:10 +0200
Message-ID: <20250818124503.933679894@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



