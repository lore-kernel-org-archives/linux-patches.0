Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C054C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:50:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94ECFC433D6;
	Mon, 14 Nov 2022 12:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430243;
	bh=Nah7e92HDDskQ8piWknP096TgOyrTwtgJPniqgYEW14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l8OojCx6Pt4SVM7XYINTRb0V/o5oiiN0UDY5M7eSvZkns/V0cE4Ne4Ts2BSyzN7wU
	 T+2i4xyyZz7YKRbQyvO90wEZlaCES+KVWRWXrdqkBNMCd6s3HvH6CL+pq6YKqJNOs7
	 c2Pu69RrFiCV/C/v15Qsk0lVZs7NTK0Zl8ZMetac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Wenhui <zhaowenhui8@huawei.com>,
	xiafukun <xiafukun@huawei.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.10 67/95] vmlinux.lds.h: Fix placement of .data..decrypted section
Date: Mon, 14 Nov 2022 13:46:01 +0100
Message-Id: <20221114124445.315799893@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nathan Chancellor <nathan@kernel.org>

commit 000f8870a47bdc36730357883b6aef42bced91ee upstream.

Commit d4c639990036 ("vmlinux.lds.h: Avoid orphan section with !SMP")
fixed an orphan section warning by adding the '.data..decrypted' section
to the linker script under the PERCPU_DECRYPTED_SECTION define but that
placement introduced a panic with !SMP, as the percpu sections are not
instantiated with that configuration so attempting to access variables
defined with DEFINE_PER_CPU_DECRYPTED() will result in a page fault.

Move the '.data..decrypted' section to the DATA_MAIN define so that the
variables in it are properly instantiated at boot time with
CONFIG_SMP=n.

Cc: stable@vger.kernel.org
Fixes: d4c639990036 ("vmlinux.lds.h: Avoid orphan section with !SMP")
Link: https://lore.kernel.org/cbbd3548-880c-d2ca-1b67-5bb93b291d5f@huawei.com/
Debugged-by: Ard Biesheuvel <ardb@kernel.org>
Reported-by: Zhao Wenhui <zhaowenhui8@huawei.com>
Tested-by: xiafukun <xiafukun@huawei.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221108174934.3384275-1-nathan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/asm-generic/vmlinux.lds.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -328,6 +328,7 @@
 #define DATA_DATA							\
 	*(.xiptext)							\
 	*(DATA_MAIN)							\
+	*(.data..decrypted)						\
 	*(.ref.data)							\
 	*(.data..shared_aligned) /* percpu related */			\
 	MEM_KEEP(init.data*)						\
@@ -972,7 +973,6 @@
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 #define PERCPU_DECRYPTED_SECTION					\
 	. = ALIGN(PAGE_SIZE);						\
-	*(.data..decrypted)						\
 	*(.data..percpu..decrypted)					\
 	. = ALIGN(PAGE_SIZE);
 #else


