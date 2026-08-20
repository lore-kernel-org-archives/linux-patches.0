Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B1047F2C3;
	Thu, 20 Aug 2026 17:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248478; cv=none; b=WC89e1eMadqxXQVYYjr8mpA/vhJhNfMRKEW8NGssPzHRk9Wk6z/Sfnq0PWfIynn6mTCoaKmu5iQEGakz56t57+ogk2kVkWSqiohZRm7Lkdv1gbhWyWrRx5DprB0dct1nOFRuAqgnwPxcbx56wl0TPcDwQdBShpu6pz/PJvXMJB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248478; c=relaxed/simple;
	bh=LHH17vjrkGmrtSfMPScMOvf2m6UITJDgueU/40EEntM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u1lhQGCIVKoFOP1TY8bXtp4Ka8Y+AYQwvcDIp+UpdQo0g3FDz0K9oLeAu3//6HvQPNLnPfj+dOynTrTOI7c+bYTec4Ix3RHGtY/FNr1GKLZKNT/e8qoouMi+3/hpKAzVfwXe2cQNUitqnxYaF/iCNpySo/FQIBWbeHBH2szLHbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t1FN1+Kx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t1FN1+Kx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40EFE1F00A3A;
	Thu, 20 Aug 2026 17:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248476;
	bh=dhXaQ4xCn7CUBF1ufJM5qT3eF8faEjEifKJ+fJxVkNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t1FN1+KxlB+URlVzL2E5PMFAfdR8DghWaNXvpyORGtjwTL7eAHTUSAXMiqjTpxv9m
	 897OQXdw1SkSR7P65n+xRF/BIGWv6frpO51Ndn4zEGGH/rtQIEH6MYBsc2fZjMoH21
	 aY2KHhTcQdyTYfP9JGZ+FnXKhZP4ym1vRNNzjLTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 242/303] overflow: Change DEFINE_FLEX to take __counted_by member
Date: Thu, 20 Aug 2026 16:56:18 +0200
Message-ID: <20260820145300.722849257@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit d8e45f2929b94099913eb66c3ebb18b5063e9421 ]

The norm should be flexible array structures with __counted_by
annotations, so DEFINE_FLEX() is updated to expect that. Rename
the non-annotated version to DEFINE_RAW_FLEX(), and update the
few existing users. Additionally add selftests for the macros.

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/r/20240306235128.it.933-kees@kernel.org
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Stable-dep-of: cdc36db204ff ("Bluetooth: hci_sync: Fix advertising data UAFs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/overflow.h |   68 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

--- a/include/linux/overflow.h
+++ b/include/linux/overflow.h
@@ -246,4 +246,72 @@ static inline size_t __must_check size_s
 		sizeof(*(p)) + flex_array_size(p, member, count),	\
 		size_add(sizeof(*(p)), flex_array_size(p, member, count)))
 
+/**
+ * struct_size_t() - Calculate size of structure with trailing flexible array
+ * @type: structure type name.
+ * @member: Name of the array member.
+ * @count: Number of elements in the array.
+ *
+ * Calculates size of memory needed for structure @type followed by an
+ * array of @count number of @member elements. Prefer using struct_size()
+ * when possible instead, to keep calculations associated with a specific
+ * instance variable of type @type.
+ *
+ * Return: number of bytes needed or SIZE_MAX on overflow.
+ */
+#define struct_size_t(type, member, count)					\
+	struct_size((type *)NULL, member, count)
+
+/**
+ * _DEFINE_FLEX() - helper macro for DEFINE_FLEX() family.
+ * Enables caller macro to pass (different) initializer.
+ *
+ * @type: structure type name, including "struct" keyword.
+ * @name: Name for a variable to define.
+ * @member: Name of the array member.
+ * @count: Number of elements in the array; must be compile-time const.
+ * @initializer: initializer expression (could be empty for no init).
+ */
+#define _DEFINE_FLEX(type, name, member, count, initializer...)			\
+	_Static_assert(__builtin_constant_p(count),				\
+		       "onstack flex array members require compile-time const count"); \
+	union {									\
+		u8 bytes[struct_size_t(type, member, count)];			\
+		type obj;							\
+	} name##_u initializer;							\
+	type *name = (type *)&name##_u
+
+/**
+ * DEFINE_RAW_FLEX() - Define an on-stack instance of structure with a trailing
+ * flexible array member, when it does not have a __counted_by annotation.
+ *
+ * @type: structure type name, including "struct" keyword.
+ * @name: Name for a variable to define.
+ * @member: Name of the array member.
+ * @count: Number of elements in the array; must be compile-time const.
+ *
+ * Define a zeroed, on-stack, instance of @type structure with a trailing
+ * flexible array member.
+ * Use __struct_size(@name) to get compile-time size of it afterwards.
+ */
+#define DEFINE_RAW_FLEX(type, name, member, count)	\
+	_DEFINE_FLEX(type, name, member, count, = {})
+
+/**
+ * DEFINE_FLEX() - Define an on-stack instance of structure with a trailing
+ * flexible array member.
+ *
+ * @TYPE: structure type name, including "struct" keyword.
+ * @NAME: Name for a variable to define.
+ * @MEMBER: Name of the array member.
+ * @COUNTER: Name of the __counted_by member.
+ * @COUNT: Number of elements in the array; must be compile-time const.
+ *
+ * Define a zeroed, on-stack, instance of @TYPE structure with a trailing
+ * flexible array member.
+ * Use __struct_size(@NAME) to get compile-time size of it afterwards.
+ */
+#define DEFINE_FLEX(TYPE, NAME, MEMBER, COUNTER, COUNT)	\
+	_DEFINE_FLEX(TYPE, NAME, MEMBER, COUNT, = { .obj.COUNTER = COUNT, })
+
 #endif /* __LINUX_OVERFLOW_H */


