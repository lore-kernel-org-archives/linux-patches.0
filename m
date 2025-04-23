Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BC92BCF56;
	Wed, 23 Apr 2025 15:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422092; cv=none; b=HdwOer5CE9MeD7Chuyf7TLNbKqDa+RD049GZ1DieK7wO7mcmf2EE8wxWX5EbhcfvRQ8FFrjWMuKbVcOPAK9zU1FFIvRowYgtNDqtN7AOmV45JJjWFty4Ip/lBgPG5KN9nOZ3j8HhXCErDSjnONuA6d1G9oX7S1MSWTyN02qFkRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422092; c=relaxed/simple;
	bh=5dpZCSIg4wMcx2qmYewYBrPvHDmrZd1Pmonogtju0Bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qkh7eUnAaXPwxP10xYhO0E8EHQ7+xAl6sONRVVp287hRQ0ANYPGq8kdGSMMJCV19JBHm6Qz2tQb2nj5gaRdqYC++CAG++UUGJ1RgOwVIEik36VjYmOTqon9F94QnTotE/z2mUq2x8xlgpWJ/VSRxWvqHy84tGhcv4IwCf0VxcCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x9SSKt9f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x9SSKt9f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD1AC4CEE3;
	Wed, 23 Apr 2025 15:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422091;
	bh=5dpZCSIg4wMcx2qmYewYBrPvHDmrZd1Pmonogtju0Bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x9SSKt9f3rvSw45dQjV9NPmjXh4utLdOkmj1C60T14jOhECl6Fg56SLhCTyES3wfk
	 4vPrVsG1NeuIlOVoOx1liBAvAj6JlNupd1ETzVN3ZMlR8Q6fPEI8SPKN2BjgRnVmlE
	 fAtc8qA0DLrj+KnGvnHfq52LaiNx0RzlEwDsxbMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donald Hunter <donald.hunter@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 276/393] tools: ynl-gen: record information about recursive nests
Date: Wed, 23 Apr 2025 16:42:52 +0200
Message-ID: <20250423142654.755967631@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 38329fcfb757b8215c07a77b6657721cc7e9530e ]

Track which nests are recursive. Non-recursive nesting gets
rendered in C as directly nested structs. For recursive
ones we need to put a pointer in, rather than full struct.

Track this information, no change to generated code, yet.

Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
Link: https://lore.kernel.org/r/20231213231432.2944749-6-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: ce6cb8113c84 ("tools: ynl-gen: individually free previous values on double set")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 4c86fe0cd1179..e5a3e0bb5a39d 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -80,6 +80,9 @@ class Type(SpecAttr):
     def is_scalar(self):
         return self.type in {'u8', 'u16', 'u32', 'u64', 's32', 's64'}
 
+    def is_recursive(self):
+        return False
+
     def presence_type(self):
         return 'bit'
 
@@ -440,6 +443,9 @@ class TypeBinary(Type):
 
 
 class TypeNest(Type):
+    def is_recursive(self):
+        return self.family.pure_nested_structs[self.nested_attrs].recursive
+
     def _complex_member_type(self, ri):
         return self.nested_struct_type
 
@@ -615,9 +621,12 @@ class Struct:
         if self.nested and space_name in family.consts:
             self.struct_name += '_'
         self.ptr_name = self.struct_name + ' *'
+        # All attr sets this one contains, directly or multiple levels down
+        self.child_nests = set()
 
         self.request = False
         self.reply = False
+        self.recursive = False
 
         self.attr_list = []
         self.attrs = dict()
@@ -960,14 +969,20 @@ class Family(SpecFamily):
                 pns_key_seen.add(name)
             else:
                 pns_key_list.append(name)
-        # Propagate the request / reply
+        # Propagate the request / reply / recursive
         for attr_set, struct in reversed(self.pure_nested_structs.items()):
             for _, spec in self.attr_sets[attr_set].items():
                 if 'nested-attributes' in spec:
-                    child = self.pure_nested_structs.get(spec['nested-attributes'])
+                    child_name = spec['nested-attributes']
+                    struct.child_nests.add(child_name)
+                    child = self.pure_nested_structs.get(child_name)
                     if child:
+                        if not child.recursive:
+                            struct.child_nests.update(child.child_nests)
                         child.request |= struct.request
                         child.reply |= struct.reply
+                if attr_set in struct.child_nests:
+                    struct.recursive = True
 
     def _load_attr_use(self):
         for _, struct in self.pure_nested_structs.items():
-- 
2.39.5



