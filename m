Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61C8762C1;
	Wed, 21 Feb 2024 13:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523815; cv=none; b=qGMpPLopcBg8AygcVKr7gNHq9GiTclk7UO6SXaLPb9pZjJBGJDZ4IizM6r8/Ib+OUIbu9E+481bwUiyYXvD911T0+LXjwtHzMTaBiAPVBqyZ4ASwAZxJflQb4wOQe0eyjYB3vLojt9vm/G79vQE65oZMkV/hK89neV15pTcsSPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523815; c=relaxed/simple;
	bh=gBla84KzREMsVDywJ92xiN0/Djw1dWGlHCutEmX/f/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PPvhFq6Bcq9CI4i7PNLSCMPeLrckX66hPv2ZXORu2/h+09xxBhGqN7SDa++ZcVYPJSQb2MlGKjbXnfDdg8CdsBdi29LiJEfPcd7qEN93XtmYURtYvjYVUnHFe7Kf211s9UtM6LdkDDr+eCBw8kL6yiX/kp7/tcx4UvIvmax2brg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WWj4VB4t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WWj4VB4t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36578C433F1;
	Wed, 21 Feb 2024 13:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523815;
	bh=gBla84KzREMsVDywJ92xiN0/Djw1dWGlHCutEmX/f/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WWj4VB4tC7KYCeqom5ZLbX6XoRALM5/HQ5F/9pHv+hPBxQHmNUT6f6CWkKZDrsduH
	 vrrZbFp1/ex8lCbui1+yilG4udOy/2QykgBPE0cQ1MWzgM5nx1lI3H5LQBTkjCFfph
	 B0b65A0eVh4IK6JyE1GyMRSPpOU3ZY0Yq0cbBxt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Vasiliy Kovalev <kovalev@altlinux.org>
Subject: [PATCH 5.10 038/379] stddef: Introduce DECLARE_FLEX_ARRAY() helper
Date: Wed, 21 Feb 2024 14:03:37 +0100
Message-ID: <20240221125956.042144003@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 3080ea5553cc909b000d1f1d964a9041962f2c5b upstream.

There are many places where kernel code wants to have several different
typed trailing flexible arrays. This would normally be done with multiple
flexible arrays in a union, but since GCC and Clang don't (on the surface)
allow this, there have been many open-coded workarounds, usually involving
neighboring 0-element arrays at the end of a structure. For example,
instead of something like this:

struct thing {
	...
	union {
		struct type1 foo[];
		struct type2 bar[];
	};
};

code works around the compiler with:

struct thing {
	...
	struct type1 foo[0];
	struct type2 bar[];
};

Another case is when a flexible array is wanted as the single member
within a struct (which itself is usually in a union). For example, this
would be worked around as:

union many {
	...
	struct {
		struct type3 baz[0];
	};
};

These kinds of work-arounds cause problems with size checks against such
zero-element arrays (for example when building with -Warray-bounds and
-Wzero-length-bounds, and with the coming FORTIFY_SOURCE improvements),
so they must all be converted to "real" flexible arrays, avoiding warnings
like this:

fs/hpfs/anode.c: In function 'hpfs_add_sector_to_btree':
fs/hpfs/anode.c:209:27: warning: array subscript 0 is outside the bounds of an interior zero-length array 'struct bplus_internal_node[0]' [-Wzero-length-bounds]
  209 |    anode->btree.u.internal[0].down = cpu_to_le32(a);
      |    ~~~~~~~~~~~~~~~~~~~~~~~^~~
In file included from fs/hpfs/hpfs_fn.h:26,
                 from fs/hpfs/anode.c:10:
fs/hpfs/hpfs.h:412:32: note: while referencing 'internal'
  412 |     struct bplus_internal_node internal[0]; /* (internal) 2-word entries giving
      |                                ^~~~~~~~

drivers/net/can/usb/etas_es58x/es58x_fd.c: In function 'es58x_fd_tx_can_msg':
drivers/net/can/usb/etas_es58x/es58x_fd.c:360:35: warning: array subscript 65535 is outside the bounds of an interior zero-length array 'u8[0]' {aka 'unsigned char[]'} [-Wzero-length-bounds]
  360 |  tx_can_msg = (typeof(tx_can_msg))&es58x_fd_urb_cmd->raw_msg[msg_len];
      |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from drivers/net/can/usb/etas_es58x/es58x_core.h:22,
                 from drivers/net/can/usb/etas_es58x/es58x_fd.c:17:
drivers/net/can/usb/etas_es58x/es58x_fd.h:231:6: note: while referencing 'raw_msg'
  231 |   u8 raw_msg[0];
      |      ^~~~~~~

However, it _is_ entirely possible to have one or more flexible arrays
in a struct or union: it just has to be in another struct. And since it
cannot be alone in a struct, such a struct must have at least 1 other
named member -- but that member can be zero sized. Wrap all this nonsense
into the new DECLARE_FLEX_ARRAY() in support of having flexible arrays
in unions (or alone in a struct).

As with struct_group(), since this is needed in UAPI headers as well,
implement the core there, with a non-UAPI wrapper.

Additionally update kernel-doc to understand its existence.

https://github.com/KSPP/linux/issues/137

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/stddef.h      |   13 +++++++++++++
 include/uapi/linux/stddef.h |   16 ++++++++++++++++
 scripts/kernel-doc          |    3 ++-
 3 files changed, 31 insertions(+), 1 deletion(-)

--- a/include/linux/stddef.h
+++ b/include/linux/stddef.h
@@ -84,4 +84,17 @@ enum {
 #define struct_group_tagged(TAG, NAME, MEMBERS...) \
 	__struct_group(TAG, NAME, /* no attrs */, MEMBERS)
 
+/**
+ * DECLARE_FLEX_ARRAY() - Declare a flexible array usable in a union
+ *
+ * @TYPE: The type of each flexible array element
+ * @NAME: The name of the flexible array member
+ *
+ * In order to have a flexible array member in a union or alone in a
+ * struct, it needs to be wrapped in an anonymous struct with at least 1
+ * named member, but that member can be empty.
+ */
+#define DECLARE_FLEX_ARRAY(TYPE, NAME) \
+	__DECLARE_FLEX_ARRAY(TYPE, NAME)
+
 #endif
--- a/include/uapi/linux/stddef.h
+++ b/include/uapi/linux/stddef.h
@@ -28,4 +28,20 @@
 		struct { MEMBERS } ATTRS; \
 		struct TAG { MEMBERS } ATTRS NAME; \
 	}
+
+/**
+ * __DECLARE_FLEX_ARRAY() - Declare a flexible array usable in a union
+ *
+ * @TYPE: The type of each flexible array element
+ * @NAME: The name of the flexible array member
+ *
+ * In order to have a flexible array member in a union or alone in a
+ * struct, it needs to be wrapped in an anonymous struct with at least 1
+ * named member, but that member can be empty.
+ */
+#define __DECLARE_FLEX_ARRAY(TYPE, NAME)	\
+	struct { \
+		struct { } __empty_ ## NAME; \
+		TYPE NAME[]; \
+	}
 #endif
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1232,7 +1232,8 @@ sub dump_struct($$) {
 	$members =~ s/DECLARE_KFIFO\s*\(([^,)]+),\s*([^,)]+),\s*([^,)]+)\)/$2 \*$1/gos;
 	# replace DECLARE_KFIFO_PTR
 	$members =~ s/DECLARE_KFIFO_PTR\s*\(([^,)]+),\s*([^,)]+)\)/$2 \*$1/gos;
-
+	# replace DECLARE_FLEX_ARRAY
+	$members =~ s/(?:__)?DECLARE_FLEX_ARRAY\s*\($args,\s*$args\)/$1 $2\[\]/gos;
 	my $declaration = $members;
 
 	# Split nested struct/union elements as newer ones


