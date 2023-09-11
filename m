Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F6811718
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:31:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B54C433CA;
	Mon, 11 Sep 2023 14:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442678;
	bh=en448N2tMjfD87wHumQy1ONXXNW9qdwnoBO7/kL7zfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y8C/ZwSKNYf8FOpcLt3JSkf+283jSJNT90mJyl3W2h4IKfcdEjPhSk8PNSArbYHbz
	 pXq+jqYuCTFbQKNGASv1QOfq5Z4r86PXa5ZO+hoyk9cZMx6lWkOBv14fbVeu6HhUu6
	 UCx8bupsyPT859duT24sDWcv/g5d1eh+Az8tI4rA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlemagne Lasse <charlemagnelasse@gmail.com>,
	Uros Bizjak <ubizjak@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 109/737] locking/arch: Avoid variable shadowing in local_try_cmpxchg()
Date: Mon, 11 Sep 2023 15:39:28 +0200
Message-ID: <20230911134653.553585474@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uros Bizjak <ubizjak@gmail.com>

[ Upstream commit d6b45484c130f4095313ae3edeb4aae662c12fb1 ]

Several architectures define arch_try_local_cmpxchg macro using
internal temporary variables named ___old, __old or _old. Remove
temporary varible in local_try_cmpxchg to avoid variable shadowing.

No functional change intended.

Fixes: d994f2c8e241 ("locking/arch: Wire up local_try_cmpxchg()")
Closes: https://lore.kernel.org/lkml/CAFGhKbyxtuk=LoW-E3yLXgcmR93m+Dfo5-u9oQA_YC5Fcy_t9g@mail.gmail.com/
Reported-by: Charlemagne Lasse <charlemagnelasse@gmail.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20230708090048.63046-1-ubizjak@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/asm/local.h | 4 ++--
 arch/mips/include/asm/local.h      | 4 ++--
 arch/x86/include/asm/local.h       | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/loongarch/include/asm/local.h b/arch/loongarch/include/asm/local.h
index 83e995b30e472..c49675852bdcd 100644
--- a/arch/loongarch/include/asm/local.h
+++ b/arch/loongarch/include/asm/local.h
@@ -63,8 +63,8 @@ static inline long local_cmpxchg(local_t *l, long old, long new)
 
 static inline bool local_try_cmpxchg(local_t *l, long *old, long new)
 {
-	typeof(l->a.counter) *__old = (typeof(l->a.counter) *) old;
-	return try_cmpxchg_local(&l->a.counter, __old, new);
+	return try_cmpxchg_local(&l->a.counter,
+				 (typeof(l->a.counter) *) old, new);
 }
 
 #define local_xchg(l, n) (atomic_long_xchg((&(l)->a), (n)))
diff --git a/arch/mips/include/asm/local.h b/arch/mips/include/asm/local.h
index 5daf6fe8e3e9a..e6ae3df0349d2 100644
--- a/arch/mips/include/asm/local.h
+++ b/arch/mips/include/asm/local.h
@@ -101,8 +101,8 @@ static __inline__ long local_cmpxchg(local_t *l, long old, long new)
 
 static __inline__ bool local_try_cmpxchg(local_t *l, long *old, long new)
 {
-	typeof(l->a.counter) *__old = (typeof(l->a.counter) *) old;
-	return try_cmpxchg_local(&l->a.counter, __old, new);
+	return try_cmpxchg_local(&l->a.counter,
+				 (typeof(l->a.counter) *) old, new);
 }
 
 #define local_xchg(l, n) (atomic_long_xchg((&(l)->a), (n)))
diff --git a/arch/x86/include/asm/local.h b/arch/x86/include/asm/local.h
index 56d4ef604b919..635132a127782 100644
--- a/arch/x86/include/asm/local.h
+++ b/arch/x86/include/asm/local.h
@@ -127,8 +127,8 @@ static inline long local_cmpxchg(local_t *l, long old, long new)
 
 static inline bool local_try_cmpxchg(local_t *l, long *old, long new)
 {
-	typeof(l->a.counter) *__old = (typeof(l->a.counter) *) old;
-	return try_cmpxchg_local(&l->a.counter, __old, new);
+	return try_cmpxchg_local(&l->a.counter,
+				 (typeof(l->a.counter) *) old, new);
 }
 
 /* Always has a lock prefix */
-- 
2.40.1



