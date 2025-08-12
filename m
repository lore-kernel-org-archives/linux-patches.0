Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2EA2FE582;
	Tue, 12 Aug 2025 19:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026713; cv=none; b=Z8k3oZutLbv1WDfWwyOcVC88jThUNwo7EyZhYBVodhICW5ymniSBGFI7elbLxOv+tVkTyY5W4Im/eTtLtXEM3ti2ITaaoMGdmnjDUxIpbyTlR3mq2Ps6d6g+u9HVYZ6yOUoZdgwgBYPK9Paow/B0Okr+O0b2J2CeQTlTsb0mX5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026713; c=relaxed/simple;
	bh=/QRcsdU0Gx8j0KEXDmm1LN39z3Z2Q0zBUVojg7vERfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=axHW42nmjgD4HvFyzCceZwCfkKP8wMo5Vq2XxpOsxVk/MywL9krbzgLTbiGBZVXIiSm8v2KRRjVa6qLdmpv/kO2/bOILBj2+0K9aYWzTZG+pX3ZdrxOCeSDcTtXIVGbSZjzwY8PqBtO5SwheZKn2S9caI/TF7vJyxnvNpVIvSJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r3DMWOOR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r3DMWOOR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD9DC4CEF4;
	Tue, 12 Aug 2025 19:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026713;
	bh=/QRcsdU0Gx8j0KEXDmm1LN39z3Z2Q0zBUVojg7vERfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r3DMWOORTuK/dgp6RmixhPtV8zLewF0j9ylfL7RNupFYWwRZtt1bG73Lve7+4m17H
	 kEZ+r64gCqbxxhEvqR6ClNGtl2PPcYghUWGuxaa3c8nMY37NcpRp764Y4FSkBB887i
	 C5YeI6sO9zMHqJG0faJVeHm9jbUMqN/rYaOrN7iU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 419/480] s390/boot: Fix startup debugging log
Date: Tue, 12 Aug 2025 19:50:27 +0200
Message-ID: <20250812174414.690142692@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

From: Mikhail Zaslonko <zaslonko@linux.ibm.com>

[ Upstream commit e29409faec87ffd2de2ed20b6109f303f129281b ]

Fix 'kernel image' end address for kaslr case.

Fixes: ec6f9f7e5bbf ("s390/boot: Add startup debugging support")
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/boot/startup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/boot/startup.c b/arch/s390/boot/startup.c
index 06316fb8e0fa..6d4357441897 100644
--- a/arch/s390/boot/startup.c
+++ b/arch/s390/boot/startup.c
@@ -369,7 +369,7 @@ static unsigned long setup_kernel_memory_layout(unsigned long kernel_size)
 		kernel_start = round_down(kernel_end - kernel_size, THREAD_SIZE);
 		boot_debug("Randomization range: 0x%016lx-0x%016lx\n", vmax - kaslr_len, vmax);
 		boot_debug("kernel image:        0x%016lx-0x%016lx (kaslr)\n", kernel_start,
-			   kernel_size + kernel_size);
+			   kernel_start + kernel_size);
 	} else if (vmax < __NO_KASLR_END_KERNEL || vsize > __NO_KASLR_END_KERNEL) {
 		kernel_start = round_down(vmax - kernel_size, THREAD_SIZE);
 		boot_debug("kernel image:        0x%016lx-0x%016lx (constrained)\n", kernel_start,
-- 
2.39.5



