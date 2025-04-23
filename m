Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F151528E5EA;
	Wed, 23 Apr 2025 15:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422097; cv=none; b=uVp6EHXGQaigZuXP7Cc8ICZrO72WFqxBWqDFGOZ1TfBk+owfSMMWpGGMzVMffT7Ugvg9Xwr+qSWHIMAEkohR3b6o6I4Ip744dz9ebgZY1JmKCNBQdM+R5z0KCrYsdMVgSM9MD16nqrXA6HseOScyz/efuwt/sQvQIRCT/pit2H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422097; c=relaxed/simple;
	bh=Tpz9skYqOhXz+Jwx5rxIPcVaZVudSW+BcFQK/lX5Dfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PxqRJYuZttwZHc2E4ZpNJfXE0KeZ2u/D4O00FPbQEMYAeQfpiDotuSRXf85m9tg89n7GXcWrmTeCnNFbo/Xt/wd1P6Zt9ocHVrT+utvIE1/jByZy+TeyHw4OZZg7GeP9pa8U/F+elCEWKTXjWLTfuhlJRIK/p/3ctsj63x6kp1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HYMZJkLn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HYMZJkLn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D95C4CEE2;
	Wed, 23 Apr 2025 15:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422096;
	bh=Tpz9skYqOhXz+Jwx5rxIPcVaZVudSW+BcFQK/lX5Dfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HYMZJkLn5zhxyZweM0s2q9ncB+y9ROHldnsJGnfZQZBSBwlkpwOC5BfC9tLfFtDSI
	 tp5XuSrW1xhRRE1Xa9d+nh2RZEkXVP6kF/17ukd7ACiyXl/FNJLTgI1ETpTxBvO7wJ
	 ct88qe7OT9pGZSbOFc4Dl/FX51ahdxkgImiH0ozU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donald Hunter <donald.hunter@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 277/393] tools: ynl-gen: re-sort ignoring recursive nests
Date: Wed, 23 Apr 2025 16:42:53 +0200
Message-ID: <20250423142654.795883611@linuxfoundation.org>
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

[ Upstream commit aa75783b95a1e7fc09129f5364476e6effe47392 ]

We try to keep the structures and helpers "topologically sorted",
to avoid forward declarations. When recursive nests are at play
we need to sort twice, because structs which end up being marked
as recursive will get a full set of forward declarations, so we
should ignore them for the purpose of sorting.

Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
Link: https://lore.kernel.org/r/20231213231432.2944749-7-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: ce6cb8113c84 ("tools: ynl-gen: individually free previous values on double set")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 52 +++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 21 deletions(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index e5a3e0bb5a39d..502d03b8a758a 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -909,6 +909,33 @@ class Family(SpecFamily):
                 self.root_sets[op['attribute-set']]['request'].update(req_attrs)
                 self.root_sets[op['attribute-set']]['reply'].update(rsp_attrs)
 
+    def _sort_pure_types(self):
+        # Try to reorder according to dependencies
+        pns_key_list = list(self.pure_nested_structs.keys())
+        pns_key_seen = set()
+        rounds = len(pns_key_list) ** 2  # it's basically bubble sort
+        for _ in range(rounds):
+            if len(pns_key_list) == 0:
+                break
+            name = pns_key_list.pop(0)
+            finished = True
+            for _, spec in self.attr_sets[name].items():
+                if 'nested-attributes' in spec:
+                    nested = spec['nested-attributes']
+                    # If the unknown nest we hit is recursive it's fine, it'll be a pointer
+                    if self.pure_nested_structs[nested].recursive:
+                        continue
+                    if nested not in pns_key_seen:
+                        # Dicts are sorted, this will make struct last
+                        struct = self.pure_nested_structs.pop(name)
+                        self.pure_nested_structs[name] = struct
+                        finished = False
+                        break
+            if finished:
+                pns_key_seen.add(name)
+            else:
+                pns_key_list.append(name)
+
     def _load_nested_sets(self):
         attr_set_queue = list(self.root_sets.keys())
         attr_set_seen = set(self.root_sets.keys())
@@ -948,27 +975,8 @@ class Family(SpecFamily):
                     if attr in rs_members['reply']:
                         self.pure_nested_structs[nested].reply = True
 
-        # Try to reorder according to dependencies
-        pns_key_list = list(self.pure_nested_structs.keys())
-        pns_key_seen = set()
-        rounds = len(pns_key_list)**2  # it's basically bubble sort
-        for _ in range(rounds):
-            if len(pns_key_list) == 0:
-                break
-            name = pns_key_list.pop(0)
-            finished = True
-            for _, spec in self.attr_sets[name].items():
-                if 'nested-attributes' in spec:
-                    if spec['nested-attributes'] not in pns_key_seen:
-                        # Dicts are sorted, this will make struct last
-                        struct = self.pure_nested_structs.pop(name)
-                        self.pure_nested_structs[name] = struct
-                        finished = False
-                        break
-            if finished:
-                pns_key_seen.add(name)
-            else:
-                pns_key_list.append(name)
+        self._sort_pure_types()
+
         # Propagate the request / reply / recursive
         for attr_set, struct in reversed(self.pure_nested_structs.items()):
             for _, spec in self.attr_sets[attr_set].items():
@@ -984,6 +992,8 @@ class Family(SpecFamily):
                 if attr_set in struct.child_nests:
                     struct.recursive = True
 
+        self._sort_pure_types()
+
     def _load_attr_use(self):
         for _, struct in self.pure_nested_structs.items():
             if struct.request:
-- 
2.39.5



