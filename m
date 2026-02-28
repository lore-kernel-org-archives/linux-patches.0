Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B12A3D903F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301101; cv=none; b=JpWaUNGLm3jdiepV9nFv8aU7hrzsmYvigbyVvDZ5+S5fnB93y8vmbLr86tfetbFlt5LVPLpB2YrdmG57vvmR8Z8RuxT1Q6sVJ1oBmtllR2+t2CCsPE1zFlQL0UXYeWd5dBQ766vBX1BTDLbSUzgqAwOzL2xX7IdvtAjRXeRNUMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301101; c=relaxed/simple;
	bh=cSWzlnpqidfMV0fh8o4QeLP6rReA62/EY2yPIuusBFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V0/uOVTEBwvI5A/J++jlzdN6u5j9Kp1OJr8BPdX1W7iqcTGhAfohvTSwgqp9bTquJl2E+Vta1RumyWgLa5Oy6YYPVsgvQW5Ys5e4XgvvRIJC/vmx1VxFmQHDF9ohs3ClQS2KcHMxRDM2pGV34a2sIIW0alKKz4DHd6T+3vQAlF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jtipvc1D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jtipvc1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0E1C19424;
	Sat, 28 Feb 2026 17:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301100;
	bh=cSWzlnpqidfMV0fh8o4QeLP6rReA62/EY2yPIuusBFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jtipvc1DqZ4XuUxzXnCZCJHbFXHdQyf5DlQLmkE8/CoCq3hkLsyi+3vxDXKNLkrUb
	 OYrhx+0vJK3pRidyQJfPAif8EIMYrMfSNLUwEQGI47zyPKKgZQW03AJBsfBJ9WjoDe
	 Cm8PSxMELv5ef4b3pRmdhG7Ln2UiuaZBUWeW3N8UeutgmGeJi77IYWUuxciMKhiuoP
	 WzDqPxveBcEKTZ1vhLgnYGFQSCgjC7V4sQDZ+gKlgoH+e3tKel3TZOnsWfVm+jeIrU
	 hpcMrPKUR/antPMV+HK+yMVC5B3pZZqrwhk3aYsjdmI6I0AbYloOxF3++cEhzlbpVV
	 Y321A/jOZ+SJQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Brian Masney <bmasney@redhat.com>,
	kernel test robot <lkp@intel.com>,
	Stafford Horne <shorne@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 253/752] openrisc: define arch-specific version of nop()
Date: Sat, 28 Feb 2026 12:39:24 -0500
Message-ID: <20260228174750.1542406-253-sashal@kernel.org>
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

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit 0dfffa5479d6260d04d021f69203b1926f73d889 ]

When compiling a driver written for MIPS on OpenRISC that uses the nop()
function, it fails due to the following error:

    drivers/watchdog/pic32-wdt.c: Assembler messages:
    drivers/watchdog/pic32-wdt.c:125: Error: unrecognized instruction `nop'

The driver currently uses the generic version of nop() from
include/asm-generic/barrier.h:

    #ifndef nop
    #define nop()   asm volatile ("nop")
    #endif

Let's fix this on OpenRISC by defining an architecture-specific version
of nop().

This was tested by performing an allmodconfig openrisc cross compile on
an aarch64 host.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202601180236.BVy480We-lkp@intel.com/
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Stafford Horne <shorne@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/openrisc/include/asm/barrier.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/openrisc/include/asm/barrier.h b/arch/openrisc/include/asm/barrier.h
index 7538294721bed..8e592c9909023 100644
--- a/arch/openrisc/include/asm/barrier.h
+++ b/arch/openrisc/include/asm/barrier.h
@@ -4,6 +4,8 @@
 
 #define mb() asm volatile ("l.msync" ::: "memory")
 
+#define nop() asm volatile ("l.nop")
+
 #include <asm-generic/barrier.h>
 
 #endif /* __ASM_BARRIER_H */
-- 
2.51.0

