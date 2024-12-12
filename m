Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93416236942;
	Thu, 12 Dec 2024 16:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021950; cv=none; b=GSMTGT9pUzpwvVzY3eNJ8PsCpqcYSVW3kqgr5bsERqiH5gCXQAO3fADkpsmoFofgB/SEWNcsSdfdyOYDBSKMPmAWN07KsdCGWrELUvXE1drSTg/PRR03EwLnFQLt9lUBk4wCTyCrt9TMtLnI/ryHkw+73ZsTM49fo/260pLBHys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021950; c=relaxed/simple;
	bh=Z1cP6uYQlH214bnzZaQfqwXW4Q23RB76Q9RbMFSVpmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N9WsSIlWnTa7Z0B6mAdIHxZT29hJrjAaKiAePkgP9Nbe9J01gIFmJ4dz7gbKFV8xBR0uMxEyF+LLAGcOxlzHiMbsN1p/XhqhMAFMD7l5n47zTTW68TPOl95hiFW8gGP5HEAlDb2FuVZzegQZhilfxNsgbfY9b+phAwF7H8sVI0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nnQPYFvZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nnQPYFvZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903E4C4CECE;
	Thu, 12 Dec 2024 16:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021950;
	bh=Z1cP6uYQlH214bnzZaQfqwXW4Q23RB76Q9RbMFSVpmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nnQPYFvZTOr0ILVm61mDWjm7VTa9JmDur8mjXF0XxMFio24MvYyW0EkP13Dmpnmox
	 uGvRDDLvtIl2ba0MQiLuwuVBphOuzTPJmYnwf7M2E3BTU6KyHw43XuiNCPi+CVWobK
	 6HN2sOvQ/6JGc9a6yupmGJ7wGgTg4zXjBX6MpyCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 089/565] s390/syscalls: Avoid creation of arch/arch/ directory
Date: Thu, 12 Dec 2024 15:54:44 +0100
Message-ID: <20241212144315.005648391@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 0708967e2d56e370231fd07defa0d69f9ad125e8 ]

Building the kernel with ARCH=s390 creates a weird arch/arch/ directory.

  $ find arch/arch
  arch/arch
  arch/arch/s390
  arch/arch/s390/include
  arch/arch/s390/include/generated
  arch/arch/s390/include/generated/asm
  arch/arch/s390/include/generated/uapi
  arch/arch/s390/include/generated/uapi/asm

The root cause is 'targets' in arch/s390/kernel/syscalls/Makefile,
where the relative path is incorrect.

Strictly speaking, 'targets' was not necessary in the first place
because this Makefile uses 'filechk' instead of 'if_changed'.

However, this commit keeps it, as it will be useful when converting
'filechk' to 'if_changed' later.

Fixes: 5c75824d915e ("s390/syscalls: add Makefile to generate system call header files")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Link: https://lore.kernel.org/r/20241111134603.2063226-1-masahiroy@kernel.org
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/syscalls/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/syscalls/Makefile b/arch/s390/kernel/syscalls/Makefile
index b98f25029b8e6..7b77ed779c7b2 100644
--- a/arch/s390/kernel/syscalls/Makefile
+++ b/arch/s390/kernel/syscalls/Makefile
@@ -12,7 +12,7 @@ kapi-hdrs-y := $(kapi)/unistd_nr.h
 uapi-hdrs-y := $(uapi)/unistd_32.h
 uapi-hdrs-y += $(uapi)/unistd_64.h
 
-targets += $(addprefix ../../../,$(gen-y) $(kapi-hdrs-y) $(uapi-hdrs-y))
+targets += $(addprefix ../../../../,$(gen-y) $(kapi-hdrs-y) $(uapi-hdrs-y))
 
 PHONY += kapi uapi
 
-- 
2.43.0



