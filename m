Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE83439341;
	Sat, 12 Sep 2026 13:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219633; cv=none; b=BD+2lorTh1BzOonrHpDW9EY0PyJe3mIAROw/bOdIgkqchdid3JGB7XyOPGRsW37yLHU4llXFyoP2OQhShegogrE4z1QPk3/Nfto2vcfas+PzstiC5dJvDI1oprQthi4SZf61kSIpv5n4zFBV/OT+Md9vI3S57WmZdpd6p4/cgA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219633; c=relaxed/simple;
	bh=TMy9bOLlJWCuZ3g5zTfG8AnOzIpF6d3e9bpgg6pMabk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VD1h6SrbIAizT4O58x8JC7KkEC/xHRQ/eX5ZO0rg/WQBFwWTPPrlrBGOdu4Tnmx4Cvju5oD9kZ4sWvQYiRu5i/fsXTw2snXPkAqNI3pPg1MVPBqapNN+y2jY5koEZy1DFip3ZUA04eFSyW23NI+UPuQ4dj3dD8aRobtDTbsDt+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iDKajnaR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iDKajnaR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F02BE1F000FF;
	Sat, 12 Sep 2026 13:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219631;
	bh=8+w4Ih8FglIHqNN0EwyBSdhwtc23bGcx5gHl2ySnAsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iDKajnaRLNCL2kAC2YUJCBB3RYceRUWgs8/D3OINuzwqJqZmtCyBObMWratMAUsYm
	 A90KgtRr6F7/1gDlC3j90gQQBGB33fF97geWi4g1bUq4nXx7EKSj7axcG2C4+nmbf8
	 QFi41n/C6blAaMNoARUfkxrkCYPz7Qg5WRFjU/DE=
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
Subject: [PATCH 6.6 0014/1424] include/linux/list.h: mark list_add and __list_add as __always_inline
Date: Sat, 12 Sep 2026 08:40:46 +0200
Message-ID: <20260912065607.613925535@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


