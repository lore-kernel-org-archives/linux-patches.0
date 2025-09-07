Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507F6315D54;
	Sun,  7 Sep 2025 20:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277372; cv=none; b=br44tQMXyBCPWD0+Fz2/OzXPNhTySDcv7hx21i1HYc8MYDzn/dxKs2fuctPvKlq8ihsWpole4+mlQ0jhjbI313Zi8NAXKk+w2GX3RZ+V0fXKyc3q2YUOCPw+jy8PG3cye7a5WCB9fhtB7yMc1BFKxmc850regQ4K5dlHEWx8CQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277372; c=relaxed/simple;
	bh=qZ0SqWuGT2GwuB6b8UZ4WArN+yF5AQWqxorRGT3UXpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cxf4fs7l+7Z8FfrZsodd0gyZ35S1qzn+gGZlTcFZ8hDlzxabpzm1GX6X8ReepyTyaLI432D8lxrNUTS5AMJhx12qHDNxpFx5oTZ0EdZvK4WQ3M4cH4v7U+5ek2q3vMoKDi2hxP1gf7xZsIQSvgxWD21CRObVwiVLGq5PlcBE38w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fcp30mqJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fcp30mqJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA33BC4CEF0;
	Sun,  7 Sep 2025 20:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277372;
	bh=qZ0SqWuGT2GwuB6b8UZ4WArN+yF5AQWqxorRGT3UXpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fcp30mqJ5WMBsSKZRDfEfw1P2n5o/1MofWOn2P1ywbzJJBKe0IKvYQIgd4mXx5GCh
	 R79ZOBPNCQQyuwbDHlEbvySFBjHSgo8lfsCradpeY+717cy2fVaZcgKVOe1cJ8nWKl
	 aMpXRGZMJLhUabSQAWY6aHHoEyIiHoySJiaf9Kwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.12 169/175] riscv: Only allow LTO with CMODEL_MEDANY
Date: Sun,  7 Sep 2025 21:59:24 +0200
Message-ID: <20250907195618.858117898@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 41f9049cff324b7033e6ed1ded7dfff803cf550a upstream.

When building with CONFIG_CMODEL_MEDLOW and CONFIG_LTO_CLANG, there is a
series of errors due to some files being unconditionally compiled with
'-mcmodel=medany', mismatching with the rest of the kernel built with
'-mcmodel=medlow':

  ld.lld: error: Function Import: link error: linking module flags 'Code Model': IDs have conflicting values: 'i32 3' from vmlinux.a(init.o at 899908), and 'i32 1' from vmlinux.a(net-traces.o at 1014628)

Only allow LTO to be performed when CONFIG_CMODEL_MEDANY is enabled to
ensure there will be no code model mismatch errors. An alternative
solution would be disabling LTO for the files with a different code
model than the main kernel like some specialized areas of the kernel do
but doing that for individual files is not as sustainable than
forbidding the combination altogether.

Cc: stable@vger.kernel.org
Fixes: 021d23428bdb ("RISC-V: build: Allow LTO to be selected")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202506290255.KBVM83vZ-lkp@intel.com/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20250710-riscv-restrict-lto-to-medany-v1-1-b1dac9871ecf@kernel.org
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -61,7 +61,7 @@ config RISCV
 	select ARCH_SUPPORTS_DEBUG_PAGEALLOC if MMU
 	select ARCH_SUPPORTS_HUGETLBFS if MMU
 	# LLD >= 14: https://github.com/llvm/llvm-project/issues/50505
-	select ARCH_SUPPORTS_LTO_CLANG if LLD_VERSION >= 140000
+	select ARCH_SUPPORTS_LTO_CLANG if LLD_VERSION >= 140000 && CMODEL_MEDANY
 	select ARCH_SUPPORTS_LTO_CLANG_THIN if LLD_VERSION >= 140000
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK if MMU
 	select ARCH_SUPPORTS_PER_VMA_LOCK if MMU


