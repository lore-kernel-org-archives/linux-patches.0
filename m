Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5495C1C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB55C433D6;
	Wed, 23 Nov 2022 09:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194736;
	bh=NVFQtvPyfVtbTgbaEvepOrHZqev8fQOQaNc/B1Tgm3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F/im0kTPu1tRTg09ZfhMDkGbQ9jUFylbf8vRWzNfUWcVkTbcXJUfEwGmdJWWYOVa3
	 3NgcdPo++PkpPbYVV8YhFMxr+9TxOE0Opp8tykD9p9jYWdUbPHepbFC7hgpRcqopxz
	 ndEETaGWxaT6wnBN7j866m0JKj033J/YS7CeT5Ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Wenhui <zhaowenhui8@huawei.com>,
	xiafukun <xiafukun@huawei.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.4 047/156] vmlinux.lds.h: Fix placement of .data..decrypted section
Date: Wed, 23 Nov 2022 09:50:04 +0100
Message-Id: <20221123084559.609371233@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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
@@ -273,6 +273,7 @@
 #define DATA_DATA							\
 	*(.xiptext)							\
 	*(DATA_MAIN)							\
+	*(.data..decrypted)						\
 	*(.ref.data)							\
 	*(.data..shared_aligned) /* percpu related */			\
 	MEM_KEEP(init.data*)						\
@@ -883,7 +884,6 @@
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 #define PERCPU_DECRYPTED_SECTION					\
 	. = ALIGN(PAGE_SIZE);						\
-	*(.data..decrypted)						\
 	*(.data..percpu..decrypted)					\
 	. = ALIGN(PAGE_SIZE);
 #else


