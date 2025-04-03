Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4752C24CEE2;
	Thu,  3 Apr 2025 15:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693785; cv=none; b=JKM+yYuz0q7WQ2qR2wu4ILACkc7jF19+6ZgzLN6lHo+ng44lA34ccxKPnVKuq34UvEUOdqBvu2+SSQnm+86QEcHofvFy28ALBp7rRbtDUyGSpIC9R79ItbS9mrvSR9rpEqdVBp6FgYbERkETTyV3l9R0R0dImt3HQZDFEqovczg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693785; c=relaxed/simple;
	bh=AUZl+9X0gq2/SFmm9H91W1TTTs0TgFnY6iXPYO6W928=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EUOCMxcapige1iN0Jotw3MtSQ1IMcWNIGqJJm88AqKY9htWx7seH0XxGSvZjpO+BvxaFb5yuflzEAMDC3jVC9rg9Ta8ZR3GKqNu3NTz0DWjq8Qm/K3rpdEi7inZNDgyD3uRNNdMHX5fu40o6r8ujBvd6hGS5rNj80xxEOdcd/vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RpJnrpbU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RpJnrpbU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A42C4CEE3;
	Thu,  3 Apr 2025 15:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693784;
	bh=AUZl+9X0gq2/SFmm9H91W1TTTs0TgFnY6iXPYO6W928=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RpJnrpbU4tiuj+ACCd2QJ0JOtXHrkCuvFdsWra8BBXK6gscF9NSuU9zyNKSTcfuKd
	 G4E52qIANlvwjjUV7lQxfEO1eID/HnSmyToLdp7CHN9jF/mxpFYh3N+FFO5Hckdnb6
	 rd3s3iSQVLFRn0RmDAdfI45NwnVNmsOry2LyHEIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Ard Biesheuvel <ardb@kernel.org>,
	Wang Kefeng <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ben Hutchings <ben@decadent.org.uk>,
	linux-arm-kernel@lists.infradead.org,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.1 04/22] ARM: 9350/1: fault: Implement copy_from_kernel_nofault_allowed()
Date: Thu,  3 Apr 2025 16:19:59 +0100
Message-ID: <20250403151621.074020689@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151620.960551909@linuxfoundation.org>
References: <20250403151620.960551909@linuxfoundation.org>
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

From: Kees Cook <keescook@chromium.org>

commit 169f9102f9198b04afffa6164372a4ba4070f412 upstream.

Under PAN emulation when dumping backtraces from things like the
LKDTM EXEC_USERSPACE test[1], a double fault (which would hang a CPU)
would happen because of dump_instr() attempting to read a userspace
address. Make sure copy_from_kernel_nofault() does not attempt this
any more.

Closes: https://lava.sirena.org.uk/scheduler/job/497571
Link: https://lore.kernel.org/all/202401181125.D48DCB4C@keescook/ [1]

Reported-by: Mark Brown <broonie@kernel.org>
Suggested-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Tested-by: Mark Brown <broonie@kernel.org>
Cc: Wang Kefeng <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mm/fault.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -25,6 +25,13 @@
 
 #include "fault.h"
 
+bool copy_from_kernel_nofault_allowed(const void *unsafe_src, size_t size)
+{
+	unsigned long addr = (unsigned long)unsafe_src;
+
+	return addr >= TASK_SIZE && ULONG_MAX - addr >= size;
+}
+
 #ifdef CONFIG_MMU
 
 /*


