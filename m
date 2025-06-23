Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127B725486A;
	Mon, 23 Jun 2025 13:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684973; cv=none; b=C20PjdM2lzpH/cSqie4/1vMruJbdivlPXOYTdyiSxIDB+k9x5VNbzl1S/o9XPvHabJp+AkeCjxAsjXyLIiyOKvp6Vt87QoFK0U7SrKB9jzdbxGCKEo9BvGgMDjDfRexy/p7FD4fEi01Q4VgocQZoQeGWKWsMQMYjPxOEOc0WJzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684973; c=relaxed/simple;
	bh=X9iJZhjdTezgtzUr5hLc0P1dsv9J2F6n7vwsS0c4RG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IM7Kwj4QOZj2hcn7P3DmI2HRfZNYOkf1/tZYJysalW/8s2Ek/iuTseKlJvGrk3dIREDLs3xDH3Axbgp8vaXnUJtsSBelIzXQg2JV5j/rNzGxxUF6B+lgA2AHnXqo3bm0gjyaz7Omj4I9BLYUj/Uw2upTXSmPYGngLJuWAUyjGas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F4/yd7MR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F4/yd7MR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC32C4CEF0;
	Mon, 23 Jun 2025 13:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684972;
	bh=X9iJZhjdTezgtzUr5hLc0P1dsv9J2F6n7vwsS0c4RG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F4/yd7MRHkCog+ssfgFy8+V9cniwRafS/I1Z6cX/ojXoDN4Rhq80h4jVxLt/0nT+u
	 nvuK+2XFdBHfXS6YbO2T8+ohOL4dUrBA2rXOoxc9/SvUldbtaLQQVg5FEy59riZEqU
	 4IfNeSejX8KhRRXvnABDvxYZWlsFbGPTnMkgIuso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Mark Brown <broonie@kernel.org>,
	WangYuli <wangyuli@uniontech.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 053/222] randstruct: gcc-plugin: Remove bogus void member
Date: Mon, 23 Jun 2025 15:06:28 +0200
Message-ID: <20250623130613.690704225@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit e136a4062174a9a8d1c1447ca040ea81accfa6a8 ]

When building the randomized replacement tree of struct members, the
randstruct GCC plugin would insert, as the first member, a 0-sized void
member. This appears as though it was done to catch non-designated
("unnamed") static initializers, which wouldn't be stable since they
depend on the original struct layout order.

This was accomplished by having the side-effect of the "void member"
tripping an assert in GCC internals (count_type_elements) if the member
list ever needed to be counted (e.g. for figuring out the order of members
during a non-designated initialization), which would catch impossible type
(void) in the struct:

security/landlock/fs.c: In function ‘hook_file_ioctl_common’:
security/landlock/fs.c:1745:61: internal compiler error: in count_type_elements, at expr.cc:7075
 1745 |                         .u.op = &(struct lsm_ioctlop_audit) {
      |                                                             ^

static HOST_WIDE_INT
count_type_elements (const_tree type, bool for_ctor_p)
{
  switch (TREE_CODE (type))
...
    case VOID_TYPE:
    default:
      gcc_unreachable ();
    }
}

However this is a redundant safety measure since randstruct uses the
__designated_initializer attribute both internally and within the
__randomized_layout attribute macro so that this would be enforced
by the compiler directly even when randstruct was not enabled (via
-Wdesignated-init).

A recent change in Landlock ended up tripping the same member counting
routine when using a full-struct copy initializer as part of an anonymous
initializer. This, however, is a false positive as the initializer is
copying between identical structs (and hence identical layouts). The
"path" member is "struct path", a randomized struct, and is being copied
to from another "struct path", the "f_path" member:

        landlock_log_denial(landlock_cred(file->f_cred), &(struct landlock_request) {
                .type = LANDLOCK_REQUEST_FS_ACCESS,
                .audit = {
                        .type = LSM_AUDIT_DATA_IOCTL_OP,
                        .u.op = &(struct lsm_ioctlop_audit) {
                                .path = file->f_path,
                                .cmd = cmd,
                        },
                },
	...

As can be seen with the coming randstruct KUnit test, there appears to
be no behavioral problems with this kind of initialization when the void
member is removed from the randstruct GCC plugin, so remove it.

Reported-by: "Dr. David Alan Gilbert" <linux@treblig.org>
Closes: https://lore.kernel.org/lkml/Z_PRaKx7q70MKgCA@gallifrey/
Reported-by: Mark Brown <broonie@kernel.org>
Closes: https://lore.kernel.org/lkml/20250407-kbuild-disable-gcc-plugins-v1-1-5d46ae583f5e@kernel.org/
Reported-by: WangYuli <wangyuli@uniontech.com>
Closes: https://lore.kernel.org/lkml/337D5D4887277B27+3c677db3-a8b9-47f0-93a4-7809355f1381@uniontech.com/
Fixes: 313dd1b62921 ("gcc-plugins: Add the randstruct plugin")
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gcc-plugins/randomize_layout_plugin.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/scripts/gcc-plugins/randomize_layout_plugin.c b/scripts/gcc-plugins/randomize_layout_plugin.c
index c7ff92b4189cb..a5aea51ecca99 100644
--- a/scripts/gcc-plugins/randomize_layout_plugin.c
+++ b/scripts/gcc-plugins/randomize_layout_plugin.c
@@ -377,29 +377,13 @@ static int relayout_struct(tree type)
 
 	shuffle(type, (tree *)newtree, shuffle_length);
 
-	/*
-	 * set up a bogus anonymous struct field designed to error out on unnamed struct initializers
-	 * as gcc provides no other way to detect such code
-	 */
-	list = make_node(FIELD_DECL);
-	TREE_CHAIN(list) = newtree[0];
-	TREE_TYPE(list) = void_type_node;
-	DECL_SIZE(list) = bitsize_zero_node;
-	DECL_NONADDRESSABLE_P(list) = 1;
-	DECL_FIELD_BIT_OFFSET(list) = bitsize_zero_node;
-	DECL_SIZE_UNIT(list) = size_zero_node;
-	DECL_FIELD_OFFSET(list) = size_zero_node;
-	DECL_CONTEXT(list) = type;
-	// to satisfy the constify plugin
-	TREE_READONLY(list) = 1;
-
 	for (i = 0; i < num_fields - 1; i++)
 		TREE_CHAIN(newtree[i]) = newtree[i+1];
 	TREE_CHAIN(newtree[num_fields - 1]) = NULL_TREE;
 
 	main_variant = TYPE_MAIN_VARIANT(type);
 	for (variant = main_variant; variant; variant = TYPE_NEXT_VARIANT(variant)) {
-		TYPE_FIELDS(variant) = list;
+		TYPE_FIELDS(variant) = newtree[0];
 		TYPE_ATTRIBUTES(variant) = copy_list(TYPE_ATTRIBUTES(variant));
 		TYPE_ATTRIBUTES(variant) = tree_cons(get_identifier("randomize_performed"), NULL_TREE, TYPE_ATTRIBUTES(variant));
 		TYPE_ATTRIBUTES(variant) = tree_cons(get_identifier("designated_init"), NULL_TREE, TYPE_ATTRIBUTES(variant));
-- 
2.39.5



