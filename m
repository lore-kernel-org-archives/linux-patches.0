Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBF733FE26
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300937; cv=none; b=tVV82b+aV4oYeU0k2VBYHkxvlDvJFex7ayvKFjiEpxTwA3RgSycDN7ndbyksHU+6phfA2yzRd7ML8yKCXExa8F6OLolWa6kj0ndYs12qIJMde+cHRSKxcKewTAHF51CUiLpNsXbQSXOzbCfT2IjH0baD1MV9nUbpXdqFegL6yMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300937; c=relaxed/simple;
	bh=fc3Kh2yBtdNTbOHCVECzb73vhKH0BfQwURlu6fT9Hl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RGJXBmD7gnwNDzOsuJoUbXMRNvl+Cnvdf1YOcw4U1aExKEFKTznuuxdY/CaW2LI9K+cdJx4ogjCMH85YPXjMdv/LT9ifaIusUt6e6ThbQxjv8AEqRJNpmNg9LX8zzo5l4j51Q+IzgGTxZ9LIb64011f/S8yjk8vgVe6dxzW5NRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fR2HRg5J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fR2HRg5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4135EC19424;
	Sat, 28 Feb 2026 17:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300937;
	bh=fc3Kh2yBtdNTbOHCVECzb73vhKH0BfQwURlu6fT9Hl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fR2HRg5JciNoIsaf5MgeMAEJhrEHPkg3cWm6QAnTuBUlLr+OvZ4KJlDOxhWTbdN8u
	 Zgu2UswZ+uuOAqmNfWYn1o4ynyY5E2FhV+jJIR2bOCstLhIXATDxN5kbMR+20GAJ7C
	 za+nAPf951hsjruM5qwdnswpFvXYULJ6qZNaP0ggf4LelWQkooe2emzFOw44wQ3Mj1
	 mDD0s3NQl8sYDCCJ5iUza7dWWNSUIeUgh6H7apFGbo3s2Lfg7ozM7OpmSFuV8WbCcp
	 yObcWJ9SaqQRMUpjplxuk0gk6x90dmD3ojb//Xha4HdhkU1EQ2h+akJBV8gEjnoaHn
	 6RebJSAoW/Duw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Daniel Tang <danielzgtg.opensource@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 058/752] powercap: intel_rapl: Add PL4 support for Ice Lake
Date: Sat, 28 Feb 2026 12:36:09 -0500
Message-ID: <20260228174750.1542406-58-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Daniel Tang <danielzgtg.opensource@gmail.com>

[ Upstream commit 54b3cd55a515c7c0fcfa0c1f0b10d62c11d64bcc ]

Microsoft Surface Pro 7 firmware throttles the processor upon
boot/resume. Userspace needs to be able to restore the correct value.

Link: https://github.com/linux-surface/linux-surface/issues/706
Signed-off-by: Daniel Tang <danielzgtg.opensource@gmail.com>
Link: https://patch.msgid.link/6088605.ChMirdbgyp@daniel-desktop3
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/intel_rapl_msr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/powercap/intel_rapl_msr.c b/drivers/powercap/intel_rapl_msr.c
index c6b9a7debc354..e827247683dbf 100644
--- a/drivers/powercap/intel_rapl_msr.c
+++ b/drivers/powercap/intel_rapl_msr.c
@@ -140,6 +140,7 @@ static int rapl_msr_write_raw(int cpu, struct reg_action *ra)
 
 /* List of verified CPUs. */
 static const struct x86_cpu_id pl4_support_ids[] = {
+	X86_MATCH_VFM(INTEL_ICELAKE_L, NULL),
 	X86_MATCH_VFM(INTEL_TIGERLAKE_L, NULL),
 	X86_MATCH_VFM(INTEL_ALDERLAKE, NULL),
 	X86_MATCH_VFM(INTEL_ALDERLAKE_L, NULL),
-- 
2.51.0

