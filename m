Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCCD8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:15:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72AC9C433C7;
	Sun, 16 Jul 2023 20:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538559;
	bh=U3nwGdPbT9I/ZVSItLdYNIIfVO3tJWnS+NU7PhdK4nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hgnYts9BzSBK8ydxuhcb2+wOZBl6XIns3ZT+p7K8CXq0H9Xx1flbyQG5QsSrRzuW7
	 yYqJoAI/HsAWbmOoB9G7LgtQPehcWAWofe++fuLu1vWiN5abWzUElUP6U36HEQE7lA
	 lBVeBgRqPWHknMDedV5GFyOt70onGkOdPR4LTIek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Elver <elver@google.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 463/800] kcsan: Dont expect 64 bits atomic builtins from 32 bits architectures
Date: Sun, 16 Jul 2023 21:45:16 +0200
Message-ID: <20230716194959.835533033@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
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
index 5a60cc52adc0c..8a7baf4e332e3 100644
--- a/kernel/kcsan/core.c
+++ b/kernel/kcsan/core.c
@@ -1270,7 +1270,9 @@ static __always_inline void kcsan_atomic_builtin_memorder(int memorder)
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



