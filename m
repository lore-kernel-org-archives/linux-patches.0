Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F801C68AE;
	Tue, 27 Aug 2024 15:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772060; cv=none; b=nr1ccpSgcfNewDqGtm3RUCirIp04Dko4qdq1RcLylnfxCBr0wBkezN17awqToGIi/v/IOk+tOvV2jlvm+l6p3+gjVyObso1vPTsnT/CDs7CxcAKIJ4xUKVU0zCQjpn1X8ILJk78ggmd0PltHOr0jRyv86VppfGM6hc9/8+PxJHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772060; c=relaxed/simple;
	bh=9HTtO9Wo99P6IKcTT3JqsxXC6wClCyPJBymDEo8D4QY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mL3FXrx4+Hfx+a20tTtAeBp5e+W5pNk+NNueDr+s0IPc//3p9yJ9WxQcxu7T1wL7vhDZWyiVKXX0ep6Cm3SNeEX69iY4Amte3P6DsSRYnDM0qbP76zTnbAmdlpQjgI9M9DcAhL2sbkK7QNrPCipIRnf9hTzYW6+aHHXIUbWTp2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jARut/kD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jARut/kD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A918C4E66E;
	Tue, 27 Aug 2024 15:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772060;
	bh=9HTtO9Wo99P6IKcTT3JqsxXC6wClCyPJBymDEo8D4QY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jARut/kD3CxQIt5tnPjwwU7zqmILu04krxH4O9aULBuqhJhJ7DzhyH0g2u6GGwoKN
	 9BEX5Sv3s/hqfy/QiVxafs3Ut+rR7ubH6mOAXhi16YzWNsp+aG8qV0zRDTgjJe5Q6S
	 /6+RTep9Zc4uz5C4x8VpguApVAmyd8smCenow9uE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donald Hunter <donald.hunter@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 069/321] docs/bpf: Document BPF_MAP_TYPE_LPM_TRIE map
Date: Tue, 27 Aug 2024 16:36:17 +0200
Message-ID: <20240827143840.868364776@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donald Hunter <donald.hunter@gmail.com>

[ Upstream commit 83177c0dca3811faa051124731a692609caee7c7 ]

Add documentation for BPF_MAP_TYPE_LPM_TRIE including kernel
BPF helper usage, userspace usage and examples.

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20221101114542.24481-2-donald.hunter@gmail.com
Stable-dep-of: 59f2f841179a ("bpf: Avoid kfree_rcu() under lock in bpf_lpm_trie.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/bpf/map_lpm_trie.rst | 181 +++++++++++++++++++++++++++++
 1 file changed, 181 insertions(+)
 create mode 100644 Documentation/bpf/map_lpm_trie.rst

diff --git a/Documentation/bpf/map_lpm_trie.rst b/Documentation/bpf/map_lpm_trie.rst
new file mode 100644
index 0000000000000..31be1aa7ba2cb
--- /dev/null
+++ b/Documentation/bpf/map_lpm_trie.rst
@@ -0,0 +1,181 @@
+.. SPDX-License-Identifier: GPL-2.0-only
+.. Copyright (C) 2022 Red Hat, Inc.
+
+=====================
+BPF_MAP_TYPE_LPM_TRIE
+=====================
+
+.. note::
+   - ``BPF_MAP_TYPE_LPM_TRIE`` was introduced in kernel version 4.11
+
+``BPF_MAP_TYPE_LPM_TRIE`` provides a longest prefix match algorithm that
+can be used to match IP addresses to a stored set of prefixes.
+Internally, data is stored in an unbalanced trie of nodes that uses
+``prefixlen,data`` pairs as its keys. The ``data`` is interpreted in
+network byte order, i.e. big endian, so ``data[0]`` stores the most
+significant byte.
+
+LPM tries may be created with a maximum prefix length that is a multiple
+of 8, in the range from 8 to 2048. The key used for lookup and update
+operations is a ``struct bpf_lpm_trie_key``, extended by
+``max_prefixlen/8`` bytes.
+
+- For IPv4 addresses the data length is 4 bytes
+- For IPv6 addresses the data length is 16 bytes
+
+The value type stored in the LPM trie can be any user defined type.
+
+.. note::
+   When creating a map of type ``BPF_MAP_TYPE_LPM_TRIE`` you must set the
+   ``BPF_F_NO_PREALLOC`` flag.
+
+Usage
+=====
+
+Kernel BPF
+----------
+
+.. c:function::
+   void *bpf_map_lookup_elem(struct bpf_map *map, const void *key)
+
+The longest prefix entry for a given data value can be found using the
+``bpf_map_lookup_elem()`` helper. This helper returns a pointer to the
+value associated with the longest matching ``key``, or ``NULL`` if no
+entry was found.
+
+The ``key`` should have ``prefixlen`` set to ``max_prefixlen`` when
+performing longest prefix lookups. For example, when searching for the
+longest prefix match for an IPv4 address, ``prefixlen`` should be set to
+``32``.
+
+.. c:function::
+   long bpf_map_update_elem(struct bpf_map *map, const void *key, const void *value, u64 flags)
+
+Prefix entries can be added or updated using the ``bpf_map_update_elem()``
+helper. This helper replaces existing elements atomically.
+
+``bpf_map_update_elem()`` returns ``0`` on success, or negative error in
+case of failure.
+
+ .. note::
+    The flags parameter must be one of BPF_ANY, BPF_NOEXIST or BPF_EXIST,
+    but the value is ignored, giving BPF_ANY semantics.
+
+.. c:function::
+   long bpf_map_delete_elem(struct bpf_map *map, const void *key)
+
+Prefix entries can be deleted using the ``bpf_map_delete_elem()``
+helper. This helper will return 0 on success, or negative error in case
+of failure.
+
+Userspace
+---------
+
+Access from userspace uses libbpf APIs with the same names as above, with
+the map identified by ``fd``.
+
+.. c:function::
+   int bpf_map_get_next_key (int fd, const void *cur_key, void *next_key)
+
+A userspace program can iterate through the entries in an LPM trie using
+libbpf's ``bpf_map_get_next_key()`` function. The first key can be
+fetched by calling ``bpf_map_get_next_key()`` with ``cur_key`` set to
+``NULL``. Subsequent calls will fetch the next key that follows the
+current key. ``bpf_map_get_next_key()`` returns ``0`` on success,
+``-ENOENT`` if ``cur_key`` is the last key in the trie, or negative
+error in case of failure.
+
+``bpf_map_get_next_key()`` will iterate through the LPM trie elements
+from leftmost leaf first. This means that iteration will return more
+specific keys before less specific ones.
+
+Examples
+========
+
+Please see ``tools/testing/selftests/bpf/test_lpm_map.c`` for examples
+of LPM trie usage from userspace. The code snippets below demonstrate
+API usage.
+
+Kernel BPF
+----------
+
+The following BPF code snippet shows how to declare a new LPM trie for IPv4
+address prefixes:
+
+.. code-block:: c
+
+    #include <linux/bpf.h>
+    #include <bpf/bpf_helpers.h>
+
+    struct ipv4_lpm_key {
+            __u32 prefixlen;
+            __u32 data;
+    };
+
+    struct {
+            __uint(type, BPF_MAP_TYPE_LPM_TRIE);
+            __type(key, struct ipv4_lpm_key);
+            __type(value, __u32);
+            __uint(map_flags, BPF_F_NO_PREALLOC);
+            __uint(max_entries, 255);
+    } ipv4_lpm_map SEC(".maps");
+
+The following BPF code snippet shows how to lookup by IPv4 address:
+
+.. code-block:: c
+
+    void *lookup(__u32 ipaddr)
+    {
+            struct ipv4_lpm_key key = {
+                    .prefixlen = 32,
+                    .data = ipaddr
+            };
+
+            return bpf_map_lookup_elem(&ipv4_lpm_map, &key);
+    }
+
+Userspace
+---------
+
+The following snippet shows how to insert an IPv4 prefix entry into an
+LPM trie:
+
+.. code-block:: c
+
+    int add_prefix_entry(int lpm_fd, __u32 addr, __u32 prefixlen, struct value *value)
+    {
+            struct ipv4_lpm_key ipv4_key = {
+                    .prefixlen = prefixlen,
+                    .data = addr
+            };
+            return bpf_map_update_elem(lpm_fd, &ipv4_key, value, BPF_ANY);
+    }
+
+The following snippet shows a userspace program walking through the entries
+of an LPM trie:
+
+
+.. code-block:: c
+
+    #include <bpf/libbpf.h>
+    #include <bpf/bpf.h>
+
+    void iterate_lpm_trie(int map_fd)
+    {
+            struct ipv4_lpm_key *cur_key = NULL;
+            struct ipv4_lpm_key next_key;
+            struct value value;
+            int err;
+
+            for (;;) {
+                    err = bpf_map_get_next_key(map_fd, cur_key, &next_key);
+                    if (err)
+                            break;
+
+                    bpf_map_lookup_elem(map_fd, &next_key, &value);
+
+                    /* Use key and value here */
+
+                    cur_key = &next_key;
+            }
+    }
-- 
2.43.0



