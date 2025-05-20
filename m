Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869EF2907;
	Tue, 20 May 2025 14:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750880; cv=none; b=ORDRARvLJ48MuxNNSMQmGKuLDpJbX8RGRKEvHQQaNUAW5pSWAb40lmvDQGfjkTKLebBdG1TdFNSB4Ti7pXY+fFh03sJ8O6WiTa7ARrRf8EpjUKDSwH68WL2QZnDd57B0tCG//6Mc2cI16YNXXfrCjuhfFV58s3MrpEA+z6Hxdao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750880; c=relaxed/simple;
	bh=FAaR2N4UinVLlqwuIKwTM5wa84mpAljnj9z1uuh3dpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dwlvov2E/O7adSt+HwrOQFf64qRVh0MweqTc75URwl5fcIrY5hZ0TSRHXrq/bqMhDoE2xS8UrbGofeTCmaVjBCoZyXdihZ0JzMWiS2/tabz0rFNiiH4iDPoSxuGgZ8Glr5a6/hINID8xT1hLci4k39lkneLcyK9K3Mo4VXtvlbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U8Q0E/hq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U8Q0E/hq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18FF5C4CEEB;
	Tue, 20 May 2025 14:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750880;
	bh=FAaR2N4UinVLlqwuIKwTM5wa84mpAljnj9z1uuh3dpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U8Q0E/hq0TC91jvRUhjkhL79Ddbsrb6BWP9OOw8GaRm4SnVNbW42owTBnJ1Kgdfnu
	 LFSL/xZaovNhgWTtW4MliuFz+5FDFm4UrXuQ5CALdNg17YPwjwBlIDC44WtXRZKUWa
	 xv8VA2+A0lwDCdGj6UxrFlYNuzbQD/nZzUgjpRCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: [PATCH 6.14 144/145] perf tools: Fix build error for LoongArch
Date: Tue, 20 May 2025 15:51:54 +0200
Message-ID: <20250520125816.185875334@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

There exists the following error when building perf tools on LoongArch:

  CC      util/syscalltbl.o
In file included from util/syscalltbl.c:16:
tools/perf/arch/loongarch/include/syscall_table.h:2:10: fatal error: asm/syscall_table_64.h: No such file or directory
    2 | #include <asm/syscall_table_64.h>
      |          ^~~~~~~~~~~~~~~~~~~~~~~~
compilation terminated.

This is because the generated syscall header is syscalls_64.h rather
than syscall_table_64.h. The above problem was introduced from v6.14,
then the header syscall_table.h has been removed from mainline tree
in commit af472d3c4454 ("perf syscalltbl: Remove syscall_table.h"),
just fix it only for the linux-6.14.y branch of stable tree.

By the way, no need to fix the mainline tree and there is no upstream
git id for this patch.

How to reproduce:

  git clone https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
  cd linux && git checkout origin/linux-6.14.y
  make JOBS=1 -C tools/perf

Fixes: fa70857a27e5 ("perf tools loongarch: Use syscall table")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/arch/loongarch/include/syscall_table.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/arch/loongarch/include/syscall_table.h
+++ b/tools/perf/arch/loongarch/include/syscall_table.h
@@ -1,2 +1,2 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#include <asm/syscall_table_64.h>
+#include <asm/syscalls_64.h>


