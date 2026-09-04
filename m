Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A205D405C3F;
	Fri,  4 Sep 2026 06:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501898; cv=none; b=JibkHsxAVyvgIF+kIzwaKdq8WV+BQLQFxIp5IfZV052Oxtjlt8DEzbXrT2dILeEnbmSPjQ8bqJnTIllLC1xinsUGwSlSLf9lhu3Lic8zHi6Ak4J+HRzJnbIiTJBGoPAw5K17h6dTyTREVWhS4XjxZXFb/VhFlwMe7NHNZCjZVjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501898; c=relaxed/simple;
	bh=A2EAoorRShiq/hCs2W61a3hYPYWqzc57yu/NVzeA7DU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dwTLS+63LcQTD8g9JqRtUHKnJOHZA1WSxlaktJ1MOcOYoMAhAAfPhYTr5ES2nGh2jYrtQ132tgL3PCAzJ2s3MF/dE+PRBi4PMYlH9oGnL6h/aRwNKdvIQvf4RyxUXLciA6q6dxzI/CXR/l9Rd5G06io4s2M8CIN5NTUaG1/BYN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R9oP5p0l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R9oP5p0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B9CE1F00A3D;
	Fri,  4 Sep 2026 06:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501897;
	bh=0Mrlcoqum+T/aXo1nag9+kFvuKIwjq1rD2VvncpNa5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R9oP5p0lrcrT8zE/rCpPc+0cdDRa6UWAn37Asp0YoMs9Hw9oR7KE9qC9qLWnxv5Ev
	 t2W4iWUT7IbzD0uQ9Lhb78XlS4hTi85/GiZna13ld1kbXyRpa9hc8qH1NJxemJlhls
	 rDTmEckrY24Xa6uyAphA88+3Nz2OD2PUSAzQcLAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordan R Abrahams-Whitehead <ajordanr@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Giuliano Procida <gprocida@google.com>,
	Yabin Cui <yabinc@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 019/403] include/linux/list.h: mark list_add and __list_add as __always_inline
Date: Fri,  4 Sep 2026 06:57:02 +0200
Message-ID: <20260904045735.249443879@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jordan R Abrahams-Whitehead <ajordanr@google.com>

commit 2780860eddecba9ffe210bb9436eee3cf22bfcdd upstream.

This commit resolves an issue where modpost section verification fails due
to section mismatches between list_add and its callers.

At present, list_add (and its internal __list_add) are called from both
.text and .init code sections.  Since inlining can vary per call site,
list_add can be 4 different states:

  list_add in text with arguments to non-.init.data values
  list_add in init with arguments to static .init.data values
  list_add in init with arguments to non-.init.data values
  list_add in text with arguments to static .init.data values

It is last instance that ends up causing the section mismatch caused by
constant propagation of the address of static libs inside the `dir_add` as
seen below (with the dir_list being defined statically in initramfs.c,
resting in .init.data).

  WARNING: modpost: vmlinux.o: section mismatch in reference: __list_add
  (section: .text.unlikely.) -> dir_list (section: .init.data)

Because of these section matching requirements, semantically, __list_add
and list_add MUST be inlined.  This will then ensure callers inside .init
will receive a list_add that exists and refers to only .init data, and
list_add code in .text sections will only refer to non-init data.

This issue manifests predominently in AutoFDO with clang, which is very
hesitant to inline cold functions such as list_add even when marked
`inline`.  Marking them as `__always_inline` therefore matches the
existing semantic constraints imposed by modpost's section mismatch
checks.

Link: https://lore.kernel.org/20260731-always-inline-list-add-v1-1-d29f54ce5477@google.com
Link: https://lore.kernel.org/all/CANn89iJVQe=wedLheJmjZjOTJsWHijT0jZs=iRxKssJZbjAxHw@mail.gmail.com/
Signed-off-by: Jordan R Abrahams-Whitehead <ajordanr@google.com>
Suggested-by: Nathan Chancellor <nathan@kernel.org>
Suggested-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Reported-by: Giuliano Procida <gprocida@google.com>
Reported-by: Yabin Cui <yabinc@google.com>
Closes: https://github.com/ClangBuiltLinux/linux/issues/2173
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/list.h |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -142,10 +142,13 @@ static inline bool __list_del_entry_vali
  *
  * This is only for internal list manipulation where we know
  * the prev/next entries already!
+ *
+ * Must be inlined to ensure it can be safely called
+ * with initdata arguments.
  */
-static inline void __list_add(struct list_head *new,
-			      struct list_head *prev,
-			      struct list_head *next)
+static __always_inline void __list_add(struct list_head *new,
+				       struct list_head *prev,
+				       struct list_head *next)
 {
 	if (!__list_add_valid(new, prev, next))
 		return;
@@ -163,8 +166,12 @@ static inline void __list_add(struct lis
  *
  * Insert a new entry after the specified head.
  * This is good for implementing stacks.
+ *
+ * Must be inlined to ensure it can be safely called
+ * with initdata arguments.
  */
-static inline void list_add(struct list_head *new, struct list_head *head)
+static __always_inline void list_add(struct list_head *new,
+				     struct list_head *head)
 {
 	__list_add(new, head, head->next);
 }


