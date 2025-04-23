Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96EE8481CD;
	Wed, 23 Apr 2025 14:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420176; cv=none; b=cWr5SyehNoRCJTXCViUirsXkp0RP8ie/wLrA+rKNpzSVHyRAiivsSMTTy2oXKNWriWGyAcLc3lzK2DPPHLJyKJ8CDFxmrrgZhezMhCRkkmseFPkjFAvqp+f/K41GS1XeBqiRSUt9yyiZBf67jKveEK/u8n6f4cMy58kSQhQz3Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420176; c=relaxed/simple;
	bh=6QuTcLVXSxRdMkdWCC9ZazoMMusoNjGvJnA5N/ktqY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H37pfs6TISGdbPIlmFNIbqX3Dy7dnRU0BA0k7FOU0F3YyQtJra6/grsSXOQw1QqkgqBMGbqI4iXskj9Oux37XrBOEDq7xq5xYYI8WB55EagaYnHjuqdhPxt3Oxok8X8edKRBwoZFi4VOU7d2smlmnligTINh12IdB+bXVQhdI6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2lhgBnL0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2lhgBnL0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29454C4CEE2;
	Wed, 23 Apr 2025 14:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420176;
	bh=6QuTcLVXSxRdMkdWCC9ZazoMMusoNjGvJnA5N/ktqY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2lhgBnL0wHO76WXN+3ke5mlTKr5mpRcN/He01ALavI6kbKE1SZ7mKTEOOsCyTcual
	 /X4YdBM/GTxEoFMSu+Gf/oANdv/Wr7o7t7LKR9X9n5w5Hve44tUw722uG+sR7V6D49
	 FQwFIfq7o42t0Sbff+teElwWU0IGW2QhgA5q6mwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donald Hunter <donald.hunter@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 065/241] tools: ynl-gen: individually free previous values on double set
Date: Wed, 23 Apr 2025 16:42:09 +0200
Message-ID: <20250423142623.257470479@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit ce6cb8113c842b94e77364b247c4f85c7b34e0c2 ]

When user calls request_attrA_set() multiple times (for the same
attribute), and attrA is of type which allocates memory -
we try to free the previously associated values. For array
types (including multi-attr) we have only freed the array,
but the array may have contained pointers.

Refactor the code generation for free attr and reuse the generated
lines in setters to flush out the previous state. Since setters
are static inlines in the header we need to add forward declarations
for the free helpers of pure nested structs. Track which types get
used by arrays and include the right forwad declarations.

At least ethtool string set and bit set would not be freed without
this. Tho, admittedly, overriding already set attribute twice is likely
a very very rare thing to do.

Fixes: be5bea1cc0bf ("net: add basic C code generators for Netlink")
Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20250414211851.602096-4-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/ynl/pyynl/ynl_gen_c.py | 62 +++++++++++++++++++++++---------
 1 file changed, 45 insertions(+), 17 deletions(-)

diff --git a/tools/net/ynl/pyynl/ynl_gen_c.py b/tools/net/ynl/pyynl/ynl_gen_c.py
index c2eabc90dce8c..9c9a62a93afe7 100755
--- a/tools/net/ynl/pyynl/ynl_gen_c.py
+++ b/tools/net/ynl/pyynl/ynl_gen_c.py
@@ -157,9 +157,15 @@ class Type(SpecAttr):
     def free_needs_iter(self):
         return False
 
-    def free(self, ri, var, ref):
+    def _free_lines(self, ri, var, ref):
         if self.is_multi_val() or self.presence_type() == 'len':
-            ri.cw.p(f'free({var}->{ref}{self.c_name});')
+            return [f'free({var}->{ref}{self.c_name});']
+        return []
+
+    def free(self, ri, var, ref):
+        lines = self._free_lines(ri, var, ref)
+        for line in lines:
+            ri.cw.p(line)
 
     def arg_member(self, ri):
         member = self._complex_member_type(ri)
@@ -258,6 +264,10 @@ class Type(SpecAttr):
         var = "req"
         member = f"{var}->{'.'.join(ref)}"
 
+        local_vars = []
+        if self.free_needs_iter():
+            local_vars += ['unsigned int i;']
+
         code = []
         presence = ''
         for i in range(0, len(ref)):
@@ -267,6 +277,10 @@ class Type(SpecAttr):
             if i == len(ref) - 1 and self.presence_type() != 'bit':
                 continue
             code.append(presence + ' = 1;')
+        ref_path = '.'.join(ref[:-1])
+        if ref_path:
+            ref_path += '.'
+        code += self._free_lines(ri, var, ref_path)
         code += self._setter_lines(ri, member, presence)
 
         func_name = f"{op_prefix(ri, direction, deref=deref)}_set_{'_'.join(ref)}"
@@ -274,7 +288,8 @@ class Type(SpecAttr):
         alloc = bool([x for x in code if 'alloc(' in x])
         if free and not alloc:
             func_name = '__' + func_name
-        ri.cw.write_func('static inline void', func_name, body=code,
+        ri.cw.write_func('static inline void', func_name, local_vars=local_vars,
+                         body=code,
                          args=[f'{type_name(ri, direction, deref=deref)} *{var}'] + self.arg_member(ri))
 
 
@@ -477,8 +492,7 @@ class TypeString(Type):
                ['unsigned int len;']
 
     def _setter_lines(self, ri, member, presence):
-        return [f"free({member});",
-                f"{presence}_len = strlen({self.c_name});",
+        return [f"{presence}_len = strlen({self.c_name});",
                 f"{member} = malloc({presence}_len + 1);",
                 f'memcpy({member}, {self.c_name}, {presence}_len);',
                 f'{member}[{presence}_len] = 0;']
@@ -531,8 +545,7 @@ class TypeBinary(Type):
                ['unsigned int len;']
 
     def _setter_lines(self, ri, member, presence):
-        return [f"free({member});",
-                f"{presence}_len = len;",
+        return [f"{presence}_len = len;",
                 f"{member} = malloc({presence}_len);",
                 f'memcpy({member}, {self.c_name}, {presence}_len);']
 
@@ -569,12 +582,14 @@ class TypeNest(Type):
     def _complex_member_type(self, ri):
         return self.nested_struct_type
 
-    def free(self, ri, var, ref):
+    def _free_lines(self, ri, var, ref):
+        lines = []
         at = '&'
         if self.is_recursive_for_op(ri):
             at = ''
-            ri.cw.p(f'if ({var}->{ref}{self.c_name})')
-        ri.cw.p(f'{self.nested_render_name}_free({at}{var}->{ref}{self.c_name});')
+            lines += [f'if ({var}->{ref}{self.c_name})']
+        lines += [f'{self.nested_render_name}_free({at}{var}->{ref}{self.c_name});']
+        return lines
 
     def _attr_typol(self):
         return f'.type = YNL_PT_NEST, .nest = &{self.nested_render_name}_nest, '
@@ -627,15 +642,19 @@ class TypeMultiAttr(Type):
     def free_needs_iter(self):
         return 'type' not in self.attr or self.attr['type'] == 'nest'
 
-    def free(self, ri, var, ref):
+    def _free_lines(self, ri, var, ref):
+        lines = []
         if self.attr['type'] in scalars:
-            ri.cw.p(f"free({var}->{ref}{self.c_name});")
+            lines += [f"free({var}->{ref}{self.c_name});"]
         elif 'type' not in self.attr or self.attr['type'] == 'nest':
-            ri.cw.p(f"for (i = 0; i < {var}->{ref}n_{self.c_name}; i++)")
-            ri.cw.p(f'{self.nested_render_name}_free(&{var}->{ref}{self.c_name}[i]);')
-            ri.cw.p(f"free({var}->{ref}{self.c_name});")
+            lines += [
+                f"for (i = 0; i < {var}->{ref}n_{self.c_name}; i++)",
+                f'{self.nested_render_name}_free(&{var}->{ref}{self.c_name}[i]);',
+                f"free({var}->{ref}{self.c_name});",
+            ]
         else:
             raise Exception(f"Free of MultiAttr sub-type {self.attr['type']} not supported yet")
+        return lines
 
     def _attr_policy(self, policy):
         return self.base_type._attr_policy(policy)
@@ -661,8 +680,7 @@ class TypeMultiAttr(Type):
     def _setter_lines(self, ri, member, presence):
         # For multi-attr we have a count, not presence, hack up the presence
         presence = presence[:-(len('_present.') + len(self.c_name))] + "n_" + self.c_name
-        return [f"free({member});",
-                f"{member} = {self.c_name};",
+        return [f"{member} = {self.c_name};",
                 f"{presence} = n_{self.c_name};"]
 
 
@@ -747,6 +765,7 @@ class Struct:
         self.request = False
         self.reply = False
         self.recursive = False
+        self.in_multi_val = False  # used by a MultiAttr or and legacy arrays
 
         self.attr_list = []
         self.attrs = dict()
@@ -1114,6 +1133,10 @@ class Family(SpecFamily):
                     if attr in rs_members['reply']:
                         self.pure_nested_structs[nested].reply = True
 
+                if spec.is_multi_val():
+                    child = self.pure_nested_structs.get(nested)
+                    child.in_multi_val = True
+
         self._sort_pure_types()
 
         # Propagate the request / reply / recursive
@@ -1128,6 +1151,8 @@ class Family(SpecFamily):
                             struct.child_nests.update(child.child_nests)
                         child.request |= struct.request
                         child.reply |= struct.reply
+                        if spec.is_multi_val():
+                            child.in_multi_val = True
                 if attr_set in struct.child_nests:
                     struct.recursive = True
 
@@ -2921,6 +2946,9 @@ def main():
             for attr_set, struct in parsed.pure_nested_structs.items():
                 ri = RenderInfo(cw, parsed, args.mode, "", "", attr_set)
                 print_type_full(ri, struct)
+                if struct.request and struct.in_multi_val:
+                    free_rsp_nested_prototype(ri)
+                    cw.nl()
 
             for op_name, op in parsed.ops.items():
                 cw.p(f"/* ============== {op.enum_name} ============== */")
-- 
2.39.5



