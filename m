Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08968350D53;
	Tue, 26 Aug 2025 13:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216102; cv=none; b=hg/ydin8HuhWcWG01jCPjnb1k+gRzOHCSvPZVdhBAyq6eSZHKqS9CLmkTOL9e8nCbGS5WElYWnDg4fScbTneByi+bPUv+EfJ70+IBz6YehAr7LLo4yUTBK+nw9l6t8ySQCDO57mnRxrVtjo5VSzB0YKK915vC54fQT2D5DrgfpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216102; c=relaxed/simple;
	bh=FvoSwOaG+ku76fmQuhiCRFBncNYuKby6luEAlULyKPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pTmbyiq4BngRmt5469vAhDbV5NNNAYUJgFgTWJ60bXAK0kB4xTjsaSdAbhk/+WSli2+Fo2b/VfJkx4hRLhhJktULbXuW1GSMQzSHtKucv/Vvmof5ZblMMyfzcWIlBbfv2hzzFX4P3gvCXsPaMaMKSTXbh6GrxMGon/+G21QhIQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O9RrJ5aD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O9RrJ5aD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F408C4CEF1;
	Tue, 26 Aug 2025 13:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216100;
	bh=FvoSwOaG+ku76fmQuhiCRFBncNYuKby6luEAlULyKPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O9RrJ5aD/R+pcX7T2D8lh3tz9cwjksWo/IDqg6JXia100aRKKtpRcB4BW62I6AHxo
	 XCGTdt9OGW4OYm8I5nNxn4XeHlt3c1VrBS9Reczq6kwDgAS5+ONYay/il3Jhby5EwY
	 Ek0vqoO+hHF6UOarD2xFWxuoOGHqP+ijdiN0PS6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 284/644] arm64: Handle KCOV __init vs inline mismatches
Date: Tue, 26 Aug 2025 13:06:15 +0200
Message-ID: <20250826110953.418485534@linuxfoundation.org>
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

From: Kees Cook <kees@kernel.org>

[ Upstream commit 65c430906efffee9bd7551d474f01a6b1197df90 ]

GCC appears to have kind of fragile inlining heuristics, in the
sense that it can change whether or not it inlines something based on
optimizations. It looks like the kcov instrumentation being added (or in
this case, removed) from a function changes the optimization results,
and some functions marked "inline" are _not_ inlined. In that case,
we end up with __init code calling a function not marked __init, and we
get the build warnings I'm trying to eliminate in the coming patch that
adds __no_sanitize_coverage to __init functions:

WARNING: modpost: vmlinux: section mismatch in reference: acpi_get_enable_method+0x1c (section: .text.unlikely) -> acpi_psci_present (section: .init.text)

This problem is somewhat fragile (though using either __always_inline
or __init will deterministically solve it), but we've tripped over
this before with GCC and the solution has usually been to just use
__always_inline and move on.

For arm64 this requires forcing one ACPI function to be inlined with
__always_inline.

Link: https://lore.kernel.org/r/20250724055029.3623499-1-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/acpi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index 702587fda70c..8cbbd08cc8c5 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -128,7 +128,7 @@ acpi_set_mailbox_entry(int cpu, struct acpi_madt_generic_interrupt *processor)
 {}
 #endif
 
-static inline const char *acpi_get_enable_method(int cpu)
+static __always_inline const char *acpi_get_enable_method(int cpu)
 {
 	if (acpi_psci_present())
 		return "psci";
-- 
2.39.5



