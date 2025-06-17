Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9560F2EA16D;
	Tue, 17 Jun 2025 15:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175966; cv=none; b=X6rnDfP4iSXck/aaLKWZ5h1SYdVfQXTs23hHVgls6d11rnb3R9yz53nyYafRhkmdGykqqNgjrkymVpzkyTcZzZqC+5e5iGrOLTNfjO4Y4nS58+dNYZbtwvUjFT60n8H4HMPih1xCf2xFNUgdnhgkVztaFSXN1i3bTbhkgc2Td2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175966; c=relaxed/simple;
	bh=PfUJVSsumcsq1XsV7neHOst5x5PmxIypYL/fyTAS27k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQdUZSsxgzWph6OH+gI5aSjoF5RJCg4kiCwcZBgRKRyV+TiBah2yeGLCJTYMHpoTNvAaVvlxx+isgs/0V47Sy146HMoB6oDjujMfSnWqTmziL0hEi/s8Qq9yXonIbe/clnp9o3+8E65OTo7t6GoHVPnScewAOJCoJIvQnl52SqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JXp3lr9y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JXp3lr9y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5CD9C4CEE3;
	Tue, 17 Jun 2025 15:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175966;
	bh=PfUJVSsumcsq1XsV7neHOst5x5PmxIypYL/fyTAS27k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JXp3lr9yI92npNdMT1mXCsDDZBUp0RLTO0L6g4Pm/gbh/HlKPAeMQBU/1d1NcjOmQ
	 wjwv5521wR0Z/p6IZ6eIzj4Aet/zP/FzSUr3YrjXl1WO7krZik9ok6WfxmXKXByK0/
	 Zk82OgHUWpUBNchRZpODU5CcNBX0oidST9kcQwX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 139/780] overflow: Fix direct struct member initialization in _DEFINE_FLEX()
Date: Tue, 17 Jun 2025 17:17:27 +0200
Message-ID: <20250617152457.158845894@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit 47e36ed7840661a9f7fb53554a1b04a5f8daffea ]

Currently, to statically initialize the struct members of the `type`
object created by _DEFINE_FLEX(), the internal `obj` member must be
explicitly referenced at the call site. See:

struct flex {
        int a;
        int b;
        struct foo flex_array[];
};

_DEFINE_FLEX(struct flex, instance, flex_array,
                 FIXED_SIZE, = {
                        .obj = {
                                .a = 0,
                                .b = 1,
                        },
                });

This leaks _DEFINE_FLEX() internal implementation details and make
the helper harder to use and read.

Fix this and allow for a more natural and intuitive C99 init-style:

_DEFINE_FLEX(struct flex, instance, flex_array,
                 FIXED_SIZE, = {
                        .a = 0,
                        .b = 1,
                });

Note that before these changes, the `initializer` argument was optional,
but now it's required.

Also, update "counter" member initialization in DEFINE_FLEX().

Fixes: 26dd68d293fd ("overflow: add DEFINE_FLEX() for on-stack allocs")
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/r/aBQVeyKfLOkO9Yss@kspp
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/overflow.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/overflow.h b/include/linux/overflow.h
index 0c7e3dcfe8670..823a53cd9a193 100644
--- a/include/linux/overflow.h
+++ b/include/linux/overflow.h
@@ -396,7 +396,7 @@ static inline size_t __must_check size_sub(size_t minuend, size_t subtrahend)
  * @name: Name for a variable to define.
  * @member: Name of the array member.
  * @count: Number of elements in the array; must be compile-time const.
- * @initializer: initializer expression (could be empty for no init).
+ * @initializer: Initializer expression (e.g., pass `= { }` at minimum).
  */
 #define _DEFINE_FLEX(type, name, member, count, initializer...)			\
 	_Static_assert(__builtin_constant_p(count),				\
@@ -404,7 +404,7 @@ static inline size_t __must_check size_sub(size_t minuend, size_t subtrahend)
 	union {									\
 		u8 bytes[struct_size_t(type, member, count)];			\
 		type obj;							\
-	} name##_u initializer;							\
+	} name##_u = { .obj initializer };					\
 	type *name = (type *)&name##_u
 
 /**
@@ -438,6 +438,6 @@ static inline size_t __must_check size_sub(size_t minuend, size_t subtrahend)
  * Use __struct_size(@NAME) to get compile-time size of it afterwards.
  */
 #define DEFINE_FLEX(TYPE, NAME, MEMBER, COUNTER, COUNT)	\
-	_DEFINE_FLEX(TYPE, NAME, MEMBER, COUNT, = { .obj.COUNTER = COUNT, })
+	_DEFINE_FLEX(TYPE, NAME, MEMBER, COUNT, = { .COUNTER = COUNT, })
 
 #endif /* __LINUX_OVERFLOW_H */
-- 
2.39.5



