Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FC014B09F;
	Thu, 23 May 2024 13:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470240; cv=none; b=j9+ADkao5ilEYoJxQSVLGqj+eKir5vmcxK5kgfWukYncwxcnfFfeXYjDtNbatw1dHdcdd58TkARcvQq1Wp60q2dFi81/UmS5BELRuDjkHNu2hE1ra+W3bfqmHvKuXdZvsHHPQAqp0c2gAYQys5Et+XBURDjA04nqb097dq0txoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470240; c=relaxed/simple;
	bh=K9t6j6LWERPDOtWj7sP3e9wGbf0XQfOyzbsKfvnrZ/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MVRIYPkfeirKPEB3kyjMNgZt3oSKnqXJG7E+AuN9lcZtiJ5hCFp8sNl1OJ0C7ZHo0eygDmuah58QUIJwskeh94dIQSaHvBYN+Mb+d/oX53KLjN1Xf3zGxHPDM332PUfnXraHq6Izds5RZnbC8bAGvea85AzOIF5vdaDjR/SY9sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zb/DUvoq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zb/DUvoq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B35ABC3277B;
	Thu, 23 May 2024 13:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470240;
	bh=K9t6j6LWERPDOtWj7sP3e9wGbf0XQfOyzbsKfvnrZ/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zb/DUvoqrmuUVAFX51biaQt5JCMg6aTvJKxh7jiE7NuTlwxHC+3aYRR5+24iVcO3O
	 Sqen3A7efe/W7E05cDWBBk6BVfWFp3dHFfqOqPhrhExauYFU4qpJeVJ4yPtl44JNeV
	 Ip2C9tw1qK+IinEF2yt3OetTxR7u9Stv60JLCfr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlemagne Lasse <charlemagnelasse@gmail.com>,
	Uros Bizjak <ubizjak@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.9 06/25] x86/percpu: Use __force to cast from __percpu address space
Date: Thu, 23 May 2024 15:12:51 +0200
Message-ID: <20240523130330.627500316@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130330.386580714@linuxfoundation.org>
References: <20240523130330.386580714@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uros Bizjak <ubizjak@gmail.com>

commit a55c1fdad5f61b4bfe42319694b23671a758cb28 upstream.

Fix Sparse warning when casting from __percpu address space by using
__force in the cast. x86 named address spaces are not considered to
be subspaces of the generic (flat) address space, so explicit casts
are required to convert pointers between these address spaces and the
generic address space (the application should cast to uintptr_t and
apply the segment base offset). The cast to uintptr_t removes
__percpu address space tag and Sparse reports:

  warning: cast removes address space '__percpu' of expression

Use __force to inform Sparse that the cast is intentional.

Fixes: 9a462b9eafa6 ("x86/percpu: Use compiler segment prefix qualifier")
Reported-by: Charlemagne Lasse <charlemagnelasse@gmail.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/20240402175058.52649-1-ubizjak@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Closes: https://lore.kernel.org/lkml/CAFGhKbzev7W4aHwhFPWwMZQEHenVgZUj7=aunFieVqZg3mt14A@mail.gmail.com/
---
 arch/x86/include/asm/percpu.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -70,7 +70,7 @@
 	unsigned long tcp_ptr__;				\
 	tcp_ptr__ = __raw_cpu_read(, this_cpu_off);		\
 								\
-	tcp_ptr__ += (unsigned long)(ptr);			\
+	tcp_ptr__ += (__force unsigned long)(ptr);		\
 	(typeof(*(ptr)) __kernel __force *)tcp_ptr__;		\
 })
 #else /* CONFIG_USE_X86_SEG_SUPPORT */
@@ -102,8 +102,8 @@
 #endif /* CONFIG_SMP */
 
 #define __my_cpu_type(var)	typeof(var) __percpu_seg_override
-#define __my_cpu_ptr(ptr)	(__my_cpu_type(*ptr) *)(uintptr_t)(ptr)
-#define __my_cpu_var(var)	(*__my_cpu_ptr(&var))
+#define __my_cpu_ptr(ptr)	(__my_cpu_type(*ptr)*)(__force uintptr_t)(ptr)
+#define __my_cpu_var(var)	(*__my_cpu_ptr(&(var)))
 #define __percpu_arg(x)		__percpu_prefix "%" #x
 #define __force_percpu_arg(x)	__force_percpu_prefix "%" #x
 


