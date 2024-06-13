Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9971F1E519;
	Thu, 13 Jun 2024 12:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282336; cv=none; b=G9ltw5DHAS95cWny5C8GC+Hk1jZZ3XuEQq8y23Ao9zo9bDP5vFDLM3DaScLmqMYbyYQ3FiKLC5FiKVO4VUobWGmcFpcX2B8MCeYK9lX6jnlkSL7lNNvuBHOlJYlXtA4dXxv7ctEyhOEOtg14QPOHqk5wKWYXOi5C6G6dVuCD580=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282336; c=relaxed/simple;
	bh=dh9HAISk6q3ousFpbbXn+EWjWMVClaDNqXpYIg4WxmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sVZaQZDnABph1plYapq+pB94BTIw5QLtUYWMHHX0Y5rdNSGA6EmjBWsUle4+MladU8nCRWHsJfbL4tnGn4mSIOkR0riTw8xQQaiKcEhimoVz8X6XvnGfTk2FvQ86wodX28dI1kYn51w83ZZYDxjLNJ7lcoUgX+rbMZVJzZ8Xo8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ltgKCnXg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ltgKCnXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2ABC2BBFC;
	Thu, 13 Jun 2024 12:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282336;
	bh=dh9HAISk6q3ousFpbbXn+EWjWMVClaDNqXpYIg4WxmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ltgKCnXgmDuyYTXZ8Ct+MJHU1olzbK1+VNfqaWQlJYefpDiS0tzzr98tQcIFqRkjJ
	 JVNV+TLnVTUc7jcYn820KQFSzrrWcA3R3OYsORePicLXg4c+JsyG8+ZES47IglQn/v
	 hV63TsEPq3sU6mzhU6ap5YIfE254KV/oVcEhpG2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Remus <jremus@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 242/402] s390/vdso: Use standard stack frame layout
Date: Thu, 13 Jun 2024 13:33:19 +0200
Message-ID: <20240613113311.588190637@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 185445c7c137822ad856aae91a41e199370cb534 ]

By default user space is compiled with standard stack frame layout and not
with the packed stack layout. The vdso code however inherited the
-mpacked-stack compiler option from the kernel. Remove this option to make
sure the vdso is compiled with standard stack frame layout.

This makes sure that the stack frame backchain location for vdso generated
stack frames is the same like for calling code (if compiled with default
options). This allows to manually walk stack frames without DWARF
information, like the kernel is doing it e.g. with arch_stack_walk_user().

Fixes: 4bff8cb54502 ("s390: convert to GENERIC_VDSO")
Reviewed-by: Jens Remus <jremus@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/vdso32/Makefile | 1 +
 arch/s390/kernel/vdso64/Makefile | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/s390/kernel/vdso32/Makefile b/arch/s390/kernel/vdso32/Makefile
index 66f7b0c8e6117..6056f2ae02632 100644
--- a/arch/s390/kernel/vdso32/Makefile
+++ b/arch/s390/kernel/vdso32/Makefile
@@ -20,6 +20,7 @@ KBUILD_AFLAGS_32 := $(filter-out -m64,$(KBUILD_AFLAGS))
 KBUILD_AFLAGS_32 += -m31 -s
 
 KBUILD_CFLAGS_32 := $(filter-out -m64,$(KBUILD_CFLAGS))
+KBUILD_CFLAGS_32 := $(filter-out -mpacked-stack,$(KBUILD_CFLAGS))
 KBUILD_CFLAGS_32 := $(filter-out -mno-pic-data-is-text-relative,$(KBUILD_CFLAGS_32))
 KBUILD_CFLAGS_32 := $(filter-out -fno-asynchronous-unwind-tables,$(KBUILD_CFLAGS_32))
 KBUILD_CFLAGS_32 += -m31 -fPIC -shared -fno-common -fno-builtin -fasynchronous-unwind-tables
diff --git a/arch/s390/kernel/vdso64/Makefile b/arch/s390/kernel/vdso64/Makefile
index e520c548d303e..498d56757c4dc 100644
--- a/arch/s390/kernel/vdso64/Makefile
+++ b/arch/s390/kernel/vdso64/Makefile
@@ -25,6 +25,7 @@ KBUILD_AFLAGS_64 := $(filter-out -m64,$(KBUILD_AFLAGS))
 KBUILD_AFLAGS_64 += -m64 -s
 
 KBUILD_CFLAGS_64 := $(filter-out -m64,$(KBUILD_CFLAGS))
+KBUILD_CFLAGS_64 := $(filter-out -mpacked-stack,$(KBUILD_CFLAGS_64))
 KBUILD_CFLAGS_64 := $(filter-out -mno-pic-data-is-text-relative,$(KBUILD_CFLAGS_64))
 KBUILD_CFLAGS_64 := $(filter-out -munaligned-symbols,$(KBUILD_CFLAGS_64))
 KBUILD_CFLAGS_64 := $(filter-out -fno-asynchronous-unwind-tables,$(KBUILD_CFLAGS_64))
-- 
2.43.0



