Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7812FA655;
	Tue, 17 Jun 2025 16:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178516; cv=none; b=iz8YTeiG5LtXoag+zIJuYDIzmbJdZ5egrY1W5/iKWMvdRwpFA1qGZ6opjVtUS+8tOU+9y8Q5VfJY7Hq5ohAiTdNv75UJQ/9mDlKIOQeyKovcum27yVmjOoKV/qS1iqQ+bcUkD0cqWq+XfPgq3942HreORIj9zlJcmFoY0oOdfQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178516; c=relaxed/simple;
	bh=rwOAQCRTtGFtG9avlpyDc0hNe146JwTbDpxdfMMdn4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+v2Kd4lhrhsfqfXlLmKVPeIXxj3sYRv1iejaNgLq+qCvDnhPOq15R2Bauz/f0ZrTVVvbQJPliiCz4OopRm81NmbCXmyc525bK6XifavBihhUpRtHvDchmh2rs8tnWdYdnZ4s+xtAGP2DNGvj+SFPQtE0CK8XsVobZo4OKprOeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sqRIiAY2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sqRIiAY2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75D8C4CEE3;
	Tue, 17 Jun 2025 16:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178516;
	bh=rwOAQCRTtGFtG9avlpyDc0hNe146JwTbDpxdfMMdn4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sqRIiAY2aGT/ghUh+om3URGI12bef8PP5KgJRQrAEIxEDIT/BzSBkwLX7CdupjpXJ
	 C8oPH3MsnWL3DXkC/uG2iSVSlk+sZrZBY1drQwLZ2pPiz8YjxJ5yjLSG0vmhfF4pJc
	 uP/DGPKifgTsDvwhRUsg6PHCu0vZFrPsqdZ90fRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>
Subject: [PATCH 6.12 510/512] overflow: Introduce __DEFINE_FLEX for having no initializer
Date: Tue, 17 Jun 2025 17:27:56 +0200
Message-ID: <20250617152440.279873565@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kees Cook <kees@kernel.org>

commit 5c78e793f78732b60276401f75cc1a101f9ad121 upstream.

While not yet in the tree, there is a proposed patch[1] that was
depending on the prior behavior of _DEFINE_FLEX, which did not have an
explicit initializer. Provide this via __DEFINE_FLEX now, which can also
have attributes applied (e.g. __uninitialized).

Examples of the resulting initializer behaviors can be seen here:
https://godbolt.org/z/P7Go8Tr33

Link: https://lore.kernel.org/netdev/20250520205920.2134829-9-anthony.l.nguyen@intel.com [1]
Fixes: 47e36ed78406 ("overflow: Fix direct struct member initialization in _DEFINE_FLEX()")
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/overflow.h |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

--- a/include/linux/overflow.h
+++ b/include/linux/overflow.h
@@ -389,25 +389,38 @@ static inline size_t __must_check size_s
 	struct_size((type *)NULL, member, count)
 
 /**
- * _DEFINE_FLEX() - helper macro for DEFINE_FLEX() family.
- * Enables caller macro to pass (different) initializer.
+ * __DEFINE_FLEX() - helper macro for DEFINE_FLEX() family.
+ * Enables caller macro to pass arbitrary trailing expressions
  *
  * @type: structure type name, including "struct" keyword.
  * @name: Name for a variable to define.
  * @member: Name of the array member.
  * @count: Number of elements in the array; must be compile-time const.
- * @initializer: Initializer expression (e.g., pass `= { }` at minimum).
+ * @trailer: Trailing expressions for attributes and/or initializers.
  */
-#define _DEFINE_FLEX(type, name, member, count, initializer...)			\
+#define __DEFINE_FLEX(type, name, member, count, trailer...)			\
 	_Static_assert(__builtin_constant_p(count),				\
 		       "onstack flex array members require compile-time const count"); \
 	union {									\
 		u8 bytes[struct_size_t(type, member, count)];			\
 		type obj;							\
-	} name##_u = { .obj initializer };					\
+	} name##_u trailer;							\
 	type *name = (type *)&name##_u
 
 /**
+ * _DEFINE_FLEX() - helper macro for DEFINE_FLEX() family.
+ * Enables caller macro to pass (different) initializer.
+ *
+ * @type: structure type name, including "struct" keyword.
+ * @name: Name for a variable to define.
+ * @member: Name of the array member.
+ * @count: Number of elements in the array; must be compile-time const.
+ * @initializer: Initializer expression (e.g., pass `= { }` at minimum).
+ */
+#define _DEFINE_FLEX(type, name, member, count, initializer...)			\
+	__DEFINE_FLEX(type, name, member, count, = { .obj initializer })
+
+/**
  * DEFINE_RAW_FLEX() - Define an on-stack instance of structure with a trailing
  * flexible array member, when it does not have a __counted_by annotation.
  *
@@ -421,7 +434,7 @@ static inline size_t __must_check size_s
  * Use __struct_size(@name) to get compile-time size of it afterwards.
  */
 #define DEFINE_RAW_FLEX(type, name, member, count)	\
-	_DEFINE_FLEX(type, name, member, count, = {})
+	__DEFINE_FLEX(type, name, member, count, = { })
 
 /**
  * DEFINE_FLEX() - Define an on-stack instance of structure with a trailing


