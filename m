Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4913922F
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:56:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C0BC433D2;
	Wed,  7 Jun 2023 20:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171398;
	bh=umhROVk5HbK0GY8bMHFwZTnWv+RBkSR3n7EVJKPijtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZyVPyVK0uyA0JQvuIiY06wG5Uoew98GzGqdW+VLXGv1GtZHOPswTSOGdqNvF2ScOK
	 LBtsIrDFooe7KOJpKepBV/dfOKJ/2KhzJkmlpxfZhlCqFU1JEHYxdHhGFAVtOgo0Mc
	 VJpGIDYrxkF6tcRDS7fk1vkQwOgYKCfyx+moKQSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nathan Chancellor <natechancellor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 78/99] kernel/extable.c: use address-of operator on section symbols
Date: Wed,  7 Jun 2023 22:17:10 +0200
Message-ID: <20230607200902.668816863@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200900.195572674@linuxfoundation.org>
References: <20230607200900.195572674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nathan Chancellor <natechancellor@gmail.com>

commit 63174f61dfaef58dc0e813eaf6602636794f8942 upstream.

Clang warns:

../kernel/extable.c:37:52: warning: array comparison always evaluates to
a constant [-Wtautological-compare]
        if (main_extable_sort_needed && __stop___ex_table > __start___ex_table) {
                                                          ^
1 warning generated.

These are not true arrays, they are linker defined symbols, which are just
addresses.  Using the address of operator silences the warning and does
not change the resulting assembly with either clang/ld.lld or gcc/ld
(tested with diff + objdump -Dr).

Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Link: https://github.com/ClangBuiltLinux/linux/issues/892
Link: http://lkml.kernel.org/r/20200219202036.45702-1-natechancellor@gmail.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/extable.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -34,7 +34,8 @@ u32 __initdata __visible main_extable_so
 /* Sort the kernel's built-in exception table */
 void __init sort_main_extable(void)
 {
-	if (main_extable_sort_needed && __stop___ex_table > __start___ex_table) {
+	if (main_extable_sort_needed &&
+	    &__stop___ex_table > &__start___ex_table) {
 		pr_notice("Sorting __ex_table...\n");
 		sort_extable(__start___ex_table, __stop___ex_table);
 	}


