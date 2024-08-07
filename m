Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19666FE16;
	Wed,  7 Aug 2024 15:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043138; cv=none; b=pE/yBa73WnFe5IjuNfdQaiRmK00vTJ5c0qKILu4/wxQpw3JJzBuWjD6suQDOZAtc/Y6usoXB0siDu+MehZGjKouDIrmr+IqPdl/07GC8A1uPmL8IFeJFMYeoW2eFZYSsnpIiq9SA6g83IGRiGX6lnsGe0cOvnuxbtJ4U2YKU0Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043138; c=relaxed/simple;
	bh=R7SFmPg1pULcvtkmtdWfdyyQLOA4txiZl2TOZHSVdF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKecYBZ+iULiFX6Q1NioG1ozqXSs2em/AZ1spNnEi79k4FFtNfp4LN4xqa7NXD1eCz/hktb7gn+KPVY8P58GFb3oihYR9jVWGfBVfIrwi2W9DM5uxl02OinAZqiFqtQTwVY+kHPupUXBjcdDt1JTQWKeLwS1tjeR0H1w0mYFW3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JDWIuigg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JDWIuigg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36BEC32781;
	Wed,  7 Aug 2024 15:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043138;
	bh=R7SFmPg1pULcvtkmtdWfdyyQLOA4txiZl2TOZHSVdF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JDWIuiggIWw25xXi2hdPBp63il3Dwr9qRu8J6IjG3OsmbXutd/4iJkLkIZSAXrFzZ
	 Hxb30emzLepmZ3k6iPMgSk0JxBlH4HTa1jhrz0btAZU4/vRu7uNBx8nbnkk+HQ+v1/
	 zbWqCHbGHm5JQQN3Y3VdewPffzZ9b4OJ00fasLqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Maslowski <cyrevolt@gmail.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 068/123] riscv/purgatory: align riscv_kernel_entry
Date: Wed,  7 Aug 2024 16:59:47 +0200
Message-ID: <20240807150023.002754942@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Maslowski <cyrevolt@googlemail.com>

[ Upstream commit fb197c5d2fd24b9af3d4697d0cf778645846d6d5 ]

When alignment handling is delegated to the kernel, everything must be
word-aligned in purgatory, since the trap handler is then set to the
kexec one. Without the alignment, hitting the exception would
ultimately crash. On other occasions, the kernel's handler would take
care of exceptions.
This has been tested on a JH7110 SoC with oreboot and its SBI delegating
unaligned access exceptions and the kernel configured to handle them.

Fixes: 736e30af583fb ("RISC-V: Add purgatory")
Signed-off-by: Daniel Maslowski <cyrevolt@gmail.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20240719170437.247457-1-cyrevolt@gmail.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/purgatory/entry.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/riscv/purgatory/entry.S b/arch/riscv/purgatory/entry.S
index 5bcf3af903daa..0e6ca6d5ae4b4 100644
--- a/arch/riscv/purgatory/entry.S
+++ b/arch/riscv/purgatory/entry.S
@@ -7,6 +7,7 @@
  * Author: Li Zhengyu (lizhengyu3@huawei.com)
  *
  */
+#include <asm/asm.h>
 #include <linux/linkage.h>
 
 .text
@@ -34,6 +35,7 @@ SYM_CODE_END(purgatory_start)
 
 .data
 
+.align LGREG
 SYM_DATA(riscv_kernel_entry, .quad 0)
 
 .end
-- 
2.43.0



