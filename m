Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99B8199FAB;
	Tue, 13 Oct 2026 12:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895642; cv=none; b=B/R0U2+wHC3nIPbkE9xE+xKdEVgAkvq6mJlNYD5Pmq6j3CxLWorLM+2X+XPAFpE+FxeUpHvI3N5YFGGOwYsHeBDe7d8cx0umtj8t2cTGF9hDKsXwM6euEIvisDSOPjBpMYhx4afNfRO7gdvpSYUygjQBSM/187lfkYF2XY++lWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895642; c=relaxed/simple;
	bh=lQlKE2nkaAc3agPxhwsTcfjzldN9wQBiOB32x2pydKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYlvQtOwYWs5+ubM1Y+VAdSr2KmP855DUz7oQ0k1DjCdRi5VpQrhZiyOxoeN3/BMogVhcQsfL417ppEz4nCt2Phw3uJWDGswdAb+JEE8rFlpbMUuLMV1VQc7T+BVrQo2GMOByGaoIZcaHPZLzvWiezSomOKFtrWlSabZbKLsdJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PHqVAFtb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PHqVAFtb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF1D1F000FF;
	Tue, 13 Oct 2026 12:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895640;
	bh=as+P+eog1U8pxCQsoqPpz53rvxBhoVFUYcVeJWcS5OM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PHqVAFtbNAbc9sQVthPNi2mOE1oKKQIOr70RqYWWsKureMGrn94KtZkNEL801dYct
	 zy3EynUVyaZUSz60xUU/UMqRoJZ9GC/mOHq/TxIgTIjEdmSoFE3vuU/kCqbiMEydjZ
	 6uwfuhqPvcST+8gFPLKT7y9Ws89H/8pMoJBpArQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Anton Danilov <littlesmilingcloud@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 343/497] tools: ynl: add scope qualifier for definitions
Date: Tue, 13 Oct 2026 13:38:30 +0200
Message-ID: <20261013112916.045228931@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

commit fbf5df34a4dbcd09d433dd4f0916bf9b2ddb16de upstream.

Using definitions in kernel policies is awkward right now.
On one hand we want defines for max values and such.
On the other we don't have a way of adding kernel-only defines.
Adding unnecessary defines to uAPI is a bad idea, we won't
be able to delete them. And when it comes to policy user
space should just query it via the policy dump, not use
hard coded defines.

Add a "scope" property to definitions, which will let us tell
the codegen that a definition is for kernel use only. Support
following values:
  - uapi: render into the uAPI header (default, today's behavior)
  - kernel: render to kernel header only
  - user: same as kernel but for the user-side generated header

Definitions may have a header property (definition is "external",
provided by existing header). Extend the scope to headers, too.
If definition has both scope and header properties we will only
generate the includes in the right scope.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Link: https://patch.msgid.link/20260510192904.3987113-8-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ Anton: the generator is tools/net/ynl/ynl-gen-c.py in 6.12.y and its
  context differs, the hunks were applied by hand without changes.
  6.12.y lacks commit 3ff5258b9781 ("tools: ynl-gen: allow overriding
  name-prefix for constants"), so render_uapi() ignores name-prefix of
  constants while render_scoped_consts() honours it, as upstream does.
  No spec in 6.12.y has a constant with name-prefix. ]
Assisted-by: LLM
Signed-off-by: Anton Danilov <littlesmilingcloud@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/genetlink-c.yaml      |  9 ++++++
 Documentation/netlink/genetlink-legacy.yaml |  9 ++++++
 Documentation/netlink/genetlink.yaml        |  9 ++++++
 Documentation/netlink/netlink-raw.yaml      |  9 ++++++
 tools/net/ynl/ynl-gen-c.py                  | 31 +++++++++++++++++++--
 5 files changed, 65 insertions(+), 2 deletions(-)

diff --git a/Documentation/netlink/genetlink-c.yaml b/Documentation/netlink/genetlink-c.yaml
index 12c60a6d88a7f..228b6bacd3d07 100644
--- a/Documentation/netlink/genetlink-c.yaml
+++ b/Documentation/netlink/genetlink-c.yaml
@@ -69,6 +69,15 @@ properties:
         header:
           description: For C-compatible languages, header which already defines this value.
           type: string
+        scope:
+          description: |
+            Visibility of this definition. "uapi" (default) renders into
+            the uAPI header, "kernel" renders into the kernel-side
+            generated header, "user" renders into the user-side
+            generated header. When combined with `header:`, the
+            definition is not rendered, and the named header is
+            included only by code matching the scope.
+          enum: [ uapi, kernel, user ]
         type:
           enum: [ const, enum, flags ]
         doc:
diff --git a/Documentation/netlink/genetlink-legacy.yaml b/Documentation/netlink/genetlink-legacy.yaml
index d2ee1199bdf26..c9f1b8120912a 100644
--- a/Documentation/netlink/genetlink-legacy.yaml
+++ b/Documentation/netlink/genetlink-legacy.yaml
@@ -80,6 +80,15 @@ properties:
         header:
           description: For C-compatible languages, header which already defines this value.
           type: string
+        scope:
+          description: |
+            Visibility of this definition. "uapi" (default) renders into
+            the uAPI header, "kernel" renders into the kernel-side
+            generated header, "user" renders into the user-side
+            generated header. When combined with `header:`, the
+            definition is not rendered, and the named header is
+            included only by code matching the scope.
+          enum: [ uapi, kernel, user ]
         type:
           enum: [ const, enum, flags, struct ] # Trim
         doc:
diff --git a/Documentation/netlink/genetlink.yaml b/Documentation/netlink/genetlink.yaml
index e43e50dba2e48..179e6000c0a24 100644
--- a/Documentation/netlink/genetlink.yaml
+++ b/Documentation/netlink/genetlink.yaml
@@ -52,6 +52,15 @@ properties:
         header:
           description: For C-compatible languages, header which already defines this value.
           type: string
+        scope:
+          description: |
+            Visibility of this definition. "uapi" (default) renders into
+            the uAPI header, "kernel" renders into the kernel-side
+            generated header, "user" renders into the user-side
+            generated header. When combined with `header:`, the
+            definition is not rendered, and the named header is
+            included only by code matching the scope.
+          enum: [ uapi, kernel, user ]
         type:
           enum: [ const, enum, flags ]
         doc:
diff --git a/Documentation/netlink/netlink-raw.yaml b/Documentation/netlink/netlink-raw.yaml
index 914aa1c0a2736..d8ae7f7365b08 100644
--- a/Documentation/netlink/netlink-raw.yaml
+++ b/Documentation/netlink/netlink-raw.yaml
@@ -75,6 +75,15 @@ properties:
         header:
           description: For C-compatible languages, header which already defines this value.
           type: string
+        scope:
+          description: |
+            Visibility of this definition. "uapi" (default) renders into
+            the uAPI header, "kernel" renders into the kernel-side
+            generated header, "user" renders into the user-side
+            generated header. When combined with `header:`, the
+            definition is not rendered, and the named header is
+            included only by code matching the scope.
+          enum: [ uapi, kernel, user ]
         type:
           enum: [ const, enum, flags, struct ] # Trim
         doc:
diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 7e6b38ada78f4..07786d7e9b0b9 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -2432,6 +2432,8 @@ def render_uapi(family, cw):
     for const in family['definitions']:
         if const.get('header'):
             continue
+        if const.get('scope', 'uapi') != 'uapi':
+            continue
 
         if const['type'] != 'const':
             cw.writes_defines(defines)
@@ -2565,6 +2567,25 @@ def render_uapi(family, cw):
     cw.p(f'#endif /* {hdr_prot} */')
 
 
+def render_scoped_consts(family, cw, scope):
+    defines = []
+    for const in family['definitions']:
+        if const['type'] != 'const':
+            continue
+        if const.get('header'):
+            continue
+        if const.get('scope') != scope:
+            continue
+        name_pfx = const.get('name-prefix', f"{family.ident_name}-")
+        defines.append([
+            c_upper(family.get('c-define-name',
+                               f"{name_pfx}{const['name']}")),
+            const['value']])
+    if defines:
+        cw.writes_defines(defines)
+        cw.nl()
+
+
 def _render_user_ntf_entry(ri, op):
     ri.cw.block_start(line=f"[{op.enum_name}] = ")
     ri.cw.p(f".alloc_sz\t= sizeof({type_name(ri, 'event')}),")
@@ -2718,8 +2739,12 @@ def main():
             cw.p('#include "ynl.h"')
         headers = [parsed.uapi_header]
     for definition in parsed['definitions']:
-        if 'header' in definition:
-            headers.append(definition['header'])
+        if 'header' not in definition:
+            continue
+        scope = definition.get('scope', 'uapi')
+        if scope != 'uapi' and scope != args.mode:
+            continue
+        headers.append(definition['header'])
     for one in headers:
         cw.p(f"#include <{one}>")
     cw.nl()
@@ -2731,6 +2756,7 @@ def main():
             for one in args.user_header:
                 cw.p(f'#include "{one}"')
         else:
+            render_scoped_consts(parsed, cw, 'user')
             cw.p('struct ynl_sock;')
             cw.nl()
             render_user_family(parsed, cw, True)
@@ -2738,6 +2764,7 @@ def main():
 
     if args.mode == "kernel":
         if args.header:
+            render_scoped_consts(parsed, cw, 'kernel')
             for _, struct in sorted(parsed.pure_nested_structs.items()):
                 if struct.request:
                     cw.p('/* Common nested types */')
-- 
2.53.0



