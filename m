Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92D3188A3A;
	Thu,  3 Apr 2025 15:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743694021; cv=none; b=iY9OBzKHDIVyQp3GaNGBaXtua1QdOWm+cT0gy9f8EG9DwO0F4eUoGzGf5kyP2YA5VSxOY1CTeG/tqz60dhyqEmvHLkS77x1sz6qR+ZN37j4ssJ4GtGZ2Np2PNuiA0TYp23w8KNWZhgBLSBnB7ZxCkwegkZocy+VBccCYnNF9hSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743694021; c=relaxed/simple;
	bh=kjYe3Efpepfsnv/dl7n86aP47rLOVYOWZwcmApiikYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KmuvjXAGNRZznet+ik9GNXySY593PBEzUAP6D7bPvUglG/P9cg/PJHDg2EEEHZKtjWEkAHDs5sT79TSprXjLXutzcAoN4Tv+6yGZjF2j8p73+h5qUXp7JHtb0R0N2u81btsn+ME0wXpsIvceTlf7WmW2D2+4CZnOsPuUGswodfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f3wtWsyY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f3wtWsyY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DBFAC4CEE3;
	Thu,  3 Apr 2025 15:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743694021;
	bh=kjYe3Efpepfsnv/dl7n86aP47rLOVYOWZwcmApiikYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f3wtWsyYT3oILFBi98oYA69XS5/LWk9PHDwAtvItDk6m66+diWQ5OkNgLZWf9cm0p
	 AecJOgm0Kn5sASxKgGD0YEV0YlL0iKNppgjvhRsMCRiF2eUrf7xTOeJ6GbTXD2+VA7
	 1zuLJSfw5mkgCxNPqQxI/r1sPUiNzmSxytK/Bi18=
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
Subject: [PATCH 6.6 04/26] ARM: 9350/1: fault: Implement copy_from_kernel_nofault_allowed()
Date: Thu,  3 Apr 2025 16:20:25 +0100
Message-ID: <20250403151622.542513914@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151622.415201055@linuxfoundation.org>
References: <20250403151622.415201055@linuxfoundation.org>
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


