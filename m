Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AC52288CB;
	Tue,  8 Apr 2025 11:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112562; cv=none; b=U4QKCwNr7zBNVpLpxWiy+pfTz5CsBRnu164JRP59ctURE/cA+R9xbwFtGqnq5OZUmdoEJOqtPXHj8Tkm0FttCgmtst6MBhB5UkPEFAt6Gjg0+uJBelxBQoiACvAUXYZv16E0dPqZBWGDGveEyRBDZwWg6EHxvVYmHfFUW06wA54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112562; c=relaxed/simple;
	bh=E3kJhKCYWfHqXreF27z87MG0nJUDiKKvzCqnE/3WopE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZgSEFKxR/YFVhFrLIW2wCsrFwKtlmsoG+Cc94gyB69gLDDZ3oMJoA7BGjvFJB+wB8ldOXZMBRHx2Kf5Y7gagjn+My3fkhxRi46iUHLzGLP//fHQ1b4wD4RATrO+7VYUoaDCKWDJgdQsH4Frt1LaBf35c/mH9M2W7jOj87joQQX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cDM4TwEF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cDM4TwEF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A61F9C4CEE5;
	Tue,  8 Apr 2025 11:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112562;
	bh=E3kJhKCYWfHqXreF27z87MG0nJUDiKKvzCqnE/3WopE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cDM4TwEFf8NKAWAYYxJEw4CKnMmaFKxxrarUTGdk6RxlxE31IGmv2pqqngTk4PhT/
	 tbzHkesUjdrK5pMnvbiXaue2hLGJ3RszSOAPvVDRn/GiJWeyJDW3dg/dQTLwCQtqJT
	 D+LDP8St0HYXO3FbU8go5x2zSJV9QxkxiRRIXkDU=
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
Subject: [PATCH 5.15 113/279] ARM: 9350/1: fault: Implement copy_from_kernel_nofault_allowed()
Date: Tue,  8 Apr 2025 12:48:16 +0200
Message-ID: <20250408104829.397723163@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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
@@ -24,6 +24,13 @@
 
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


