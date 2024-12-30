Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21EE15E8B;
	Mon, 30 Dec 2024 15:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573868; cv=none; b=sDdcxzTU3mUlBzGVr7V7QXlja+J8EGnlWuDCzrP4S+IvlEhO5ouL15gVDBZSLr/F2YWrwQkNyej7YGObuYZBOSY8Mei6xNSB8eIwJ0uOLgPlM4D47WjKXYXrvlNIbBO/j0OYwQyg7zdFiPLyKkWQs3gFXT9PrAvG6ZZLJ+KWKlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573868; c=relaxed/simple;
	bh=2y4KlTL82wF2dS8eMMjANpd50A2cNU9/QpaiIRz96kM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UgxBF85ZHTYQ1kz90k6NkUm8N8kR2jTgvqpgEjRfRmymuGuY2DKuW+79VH6WkJ8yVZAYm3lGn+gO1ICLqUf6JyN0lixsUItp1sTt/4OUaFhNdjr6gpHovaqx0ndV8Bq058xOoD2xihaYDT17Dn2hc0NGFmsk+1rm+qOqPvMz4GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mmWKRedq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mmWKRedq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20212C4CED0;
	Mon, 30 Dec 2024 15:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573868;
	bh=2y4KlTL82wF2dS8eMMjANpd50A2cNU9/QpaiIRz96kM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mmWKRedqWc8fuTJEo23juQJVApbeYSgQW+l1JrjJVfqR6JBh9w3pLDylRzOxtDojU
	 mV6ulLj29P4YNam3HomayplamdBCIQqqcM55cXYmurQX0BOCcz5jfAifpTHOYTL8qo
	 SP4SJPMp46iIT1WalJVLKimSyeG5ladRUFJdxAp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher Ferris <cferris@google.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 30/86] stddef: make __struct_group() UAPI C++-friendly
Date: Mon, 30 Dec 2024 16:42:38 +0100
Message-ID: <20241230154212.867663436@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Lobakin <aleksander.lobakin@intel.com>

[ Upstream commit 724c6ce38bbaeb4b3f109b0e066d6c0ecd15446c ]

For the most part of the C++ history, it couldn't have type
declarations inside anonymous unions for different reasons. At the
same time, __struct_group() relies on the latters, so when the @TAG
argument is not empty, C++ code doesn't want to build (even under
`extern "C"`):

../linux/include/uapi/linux/pkt_cls.h:25:24: error:
'struct tc_u32_sel::<unnamed union>::tc_u32_sel_hdr,' invalid;
an anonymous union may only have public non-static data members
[-fpermissive]

The safest way to fix this without trying to switch standards (which
is impossible in UAPI anyway) etc., is to disable tag declaration
for that language. This won't break anything since for now it's not
buildable at all.
Use a separate definition for __struct_group() when __cplusplus is
defined to mitigate the error, including the version from tools/.

Fixes: 50d7bd38c3aa ("stddef: Introduce struct_group() helper macro")
Reported-by: Christopher Ferris <cferris@google.com>
Closes: https://lore.kernel.org/linux-hardening/Z1HZpe3WE5As8UAz@google.com
Suggested-by: Kees Cook <kees@kernel.org> # __struct_group_tag()
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/r/20241219135734.2130002-1-aleksander.lobakin@intel.com
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/stddef.h       | 13 ++++++++++---
 tools/include/uapi/linux/stddef.h | 15 +++++++++++----
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/stddef.h b/include/uapi/linux/stddef.h
index 2ec6f35cda32..473ad86706d8 100644
--- a/include/uapi/linux/stddef.h
+++ b/include/uapi/linux/stddef.h
@@ -8,6 +8,13 @@
 #define __always_inline inline
 #endif
 
+/* Not all C++ standards support type declarations inside an anonymous union */
+#ifndef __cplusplus
+#define __struct_group_tag(TAG)		TAG
+#else
+#define __struct_group_tag(TAG)
+#endif
+
 /**
  * __struct_group() - Create a mirrored named and anonyomous struct
  *
@@ -20,13 +27,13 @@
  * and size: one anonymous and one named. The former's members can be used
  * normally without sub-struct naming, and the latter can be used to
  * reason about the start, end, and size of the group of struct members.
- * The named struct can also be explicitly tagged for layer reuse, as well
- * as both having struct attributes appended.
+ * The named struct can also be explicitly tagged for layer reuse (C only),
+ * as well as both having struct attributes appended.
  */
 #define __struct_group(TAG, NAME, ATTRS, MEMBERS...) \
 	union { \
 		struct { MEMBERS } ATTRS; \
-		struct TAG { MEMBERS } ATTRS NAME; \
+		struct __struct_group_tag(TAG) { MEMBERS } ATTRS NAME; \
 	} ATTRS
 
 #ifdef __cplusplus
diff --git a/tools/include/uapi/linux/stddef.h b/tools/include/uapi/linux/stddef.h
index bb6ea517efb5..c53cde425406 100644
--- a/tools/include/uapi/linux/stddef.h
+++ b/tools/include/uapi/linux/stddef.h
@@ -8,6 +8,13 @@
 #define __always_inline __inline__
 #endif
 
+/* Not all C++ standards support type declarations inside an anonymous union */
+#ifndef __cplusplus
+#define __struct_group_tag(TAG)		TAG
+#else
+#define __struct_group_tag(TAG)
+#endif
+
 /**
  * __struct_group() - Create a mirrored named and anonyomous struct
  *
@@ -20,14 +27,14 @@
  * and size: one anonymous and one named. The former's members can be used
  * normally without sub-struct naming, and the latter can be used to
  * reason about the start, end, and size of the group of struct members.
- * The named struct can also be explicitly tagged for layer reuse, as well
- * as both having struct attributes appended.
+ * The named struct can also be explicitly tagged for layer reuse (C only),
+ * as well as both having struct attributes appended.
  */
 #define __struct_group(TAG, NAME, ATTRS, MEMBERS...) \
 	union { \
 		struct { MEMBERS } ATTRS; \
-		struct TAG { MEMBERS } ATTRS NAME; \
-	}
+		struct __struct_group_tag(TAG) { MEMBERS } ATTRS NAME; \
+	} ATTRS
 
 /**
  * __DECLARE_FLEX_ARRAY() - Declare a flexible array usable in a union
-- 
2.39.5



