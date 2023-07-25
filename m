Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9751D301
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:20:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B37C433C8;
	Tue, 25 Jul 2023 11:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284046;
	bh=Lxf0HLEY3XJTn7BGE3RCZAEaeoqGxZU2CEaceTPJ0rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a3U4uJYRvhWvJab4VZwJfzHAz0uTvtfPQN8WsEnNvcRFwaH0UsbvOSsnRaLJJOErY
	 67pQBW59hbUTyU56gLAjsYbvkgSfPoefR3/IMr2HDtJspX0IVHUVPkxLpLqTvGcl3z
	 B9BGedL9rlpTOXofGK6HLKSyEYi2TAghvHHFQzm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Elver <elver@google.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 186/509] kcsan: Dont expect 64 bits atomic builtins from 32 bits architectures
Date: Tue, 25 Jul 2023 12:42:05 +0200
Message-ID: <20230725104602.227140944@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 353e7300a1db928e427462f2745f9a2cd1625b3d ]

Activating KCSAN on a 32 bits architecture leads to the following
link-time failure:

    LD      .tmp_vmlinux.kallsyms1
  powerpc64-linux-ld: kernel/kcsan/core.o: in function `__tsan_atomic64_load':
  kernel/kcsan/core.c:1273: undefined reference to `__atomic_load_8'
  powerpc64-linux-ld: kernel/kcsan/core.o: in function `__tsan_atomic64_store':
  kernel/kcsan/core.c:1273: undefined reference to `__atomic_store_8'
  powerpc64-linux-ld: kernel/kcsan/core.o: in function `__tsan_atomic64_exchange':
  kernel/kcsan/core.c:1273: undefined reference to `__atomic_exchange_8'
  powerpc64-linux-ld: kernel/kcsan/core.o: in function `__tsan_atomic64_fetch_add':
  kernel/kcsan/core.c:1273: undefined reference to `__atomic_fetch_add_8'
  powerpc64-linux-ld: kernel/kcsan/core.o: in function `__tsan_atomic64_fetch_sub':
  kernel/kcsan/core.c:1273: undefined reference to `__atomic_fetch_sub_8'
  powerpc64-linux-ld: kernel/kcsan/core.o: in function `__tsan_atomic64_fetch_and':
  kernel/kcsan/core.c:1273: undefined reference to `__atomic_fetch_and_8'
  powerpc64-linux-ld: kernel/kcsan/core.o: in function `__tsan_atomic64_fetch_or':
  kernel/kcsan/core.c:1273: undefined reference to `__atomic_fetch_or_8'
  powerpc64-linux-ld: kernel/kcsan/core.o: in function `__tsan_atomic64_fetch_xor':
  kernel/kcsan/core.c:1273: undefined reference to `__atomic_fetch_xor_8'
  powerpc64-linux-ld: kernel/kcsan/core.o: in function `__tsan_atomic64_fetch_nand':
  kernel/kcsan/core.c:1273: undefined reference to `__atomic_fetch_nand_8'
  powerpc64-linux-ld: kernel/kcsan/core.o: in function `__tsan_atomic64_compare_exchange_strong':
  kernel/kcsan/core.c:1273: undefined reference to `__atomic_compare_exchange_8'
  powerpc64-linux-ld: kernel/kcsan/core.o: in function `__tsan_atomic64_compare_exchange_weak':
  kernel/kcsan/core.c:1273: undefined reference to `__atomic_compare_exchange_8'
  powerpc64-linux-ld: kernel/kcsan/core.o: in function `__tsan_atomic64_compare_exchange_val':
  kernel/kcsan/core.c:1273: undefined reference to `__atomic_compare_exchange_8'

32 bits architectures don't have 64 bits atomic builtins. Only
include DEFINE_TSAN_ATOMIC_OPS(64) on 64 bits architectures.

Fixes: 0f8ad5f2e934 ("kcsan: Add support for atomic builtins")
Suggested-by: Marco Elver <elver@google.com>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Marco Elver <elver@google.com>
Acked-by: Marco Elver <elver@google.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/d9c6afc28d0855240171a4e0ad9ffcdb9d07fceb.1683892665.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kcsan/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/kcsan/core.c b/kernel/kcsan/core.c
index 762df6108c589..473dc04591b8e 100644
--- a/kernel/kcsan/core.c
+++ b/kernel/kcsan/core.c
@@ -1035,7 +1035,9 @@ EXPORT_SYMBOL(__tsan_init);
 DEFINE_TSAN_ATOMIC_OPS(8);
 DEFINE_TSAN_ATOMIC_OPS(16);
 DEFINE_TSAN_ATOMIC_OPS(32);
+#ifdef CONFIG_64BIT
 DEFINE_TSAN_ATOMIC_OPS(64);
+#endif
 
 void __tsan_atomic_thread_fence(int memorder);
 void __tsan_atomic_thread_fence(int memorder)
-- 
2.39.2



