Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4D21C5F2C;
	Wed,  5 Mar 2025 17:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197285; cv=none; b=tcHbeWZfyO8p25Z4zePeyTLa7NzCjweaf+ZoNSyUgFxi58Sumz/eTxDa+DyU+mK2SivqdV8zlwFqiBk41Ch/4T6Z568iO/XRfdR9eJEQo7aEt9lVwJPxnaX5vymyZ8WWEUH0l8P0smgD1C2EAOH/DLnuIH02CNida0KZ3GFyJ6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197285; c=relaxed/simple;
	bh=V2sqC9QgsLx7I97rF3V93XR500H3a846FBVuCVZy7WM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t3FUS6ypzlbnFTt2aadhhV3qRKHQmo2IZt66PIaCibbqRaqctEfsNXdIg3b/8tj9pn6VW5koJ0cQ9s71t48zevq78K+EG6YKh02DMna5W+Ww4S9iYnJoJmu4qGQInldLnOBgh4YJTDIVfZG2S4i4NZaI70SH/ZU9gwhpV7HSO7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u7XB5jFc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u7XB5jFc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A7BC4CED1;
	Wed,  5 Mar 2025 17:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197285;
	bh=V2sqC9QgsLx7I97rF3V93XR500H3a846FBVuCVZy7WM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u7XB5jFcmjyGnRzrRxb4TJiXlGm/dOAWi6o0gikbOTp1GNBbVWqo5MtBokxRlbNd4
	 J49jT6SXEQpb8mtnddoXR9Og7i2XZ/zUpbf982qPK1FnbKkXPS1xNLAcVqdyRTlZDl
	 LsTYBYiStlpv/KgFvXDebyqMHOvUogA33BOYBJL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yan Zhai <yan@cloudflare.com>,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 071/176] bpf: skip non exist keys in generic_map_lookup_batch
Date: Wed,  5 Mar 2025 18:47:20 +0100
Message-ID: <20250305174508.308882634@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yan Zhai <yan@cloudflare.com>

[ Upstream commit 5644c6b50ffee0a56c1e01430a8c88e34decb120 ]

The generic_map_lookup_batch currently returns EINTR if it fails with
ENOENT and retries several times on bpf_map_copy_value. The next batch
would start from the same location, presuming it's a transient issue.
This is incorrect if a map can actually have "holes", i.e.
"get_next_key" can return a key that does not point to a valid value. At
least the array of maps type may contain such holes legitly. Right now
these holes show up, generic batch lookup cannot proceed any more. It
will always fail with EINTR errors.

Rather, do not retry in generic_map_lookup_batch. If it finds a non
existing element, skip to the next key. This simple solution comes with
a price that transient errors may not be recovered, and the iteration
might cycle back to the first key under parallel deletion. For example,
Hou Tao <houtao@huaweicloud.com> pointed out a following scenario:

For LPM trie map:
(1) ->map_get_next_key(map, prev_key, key) returns a valid key

(2) bpf_map_copy_value() return -ENOMENT
It means the key must be deleted concurrently.

(3) goto next_key
It swaps the prev_key and key

(4) ->map_get_next_key(map, prev_key, key) again
prev_key points to a non-existing key, for LPM trie it will treat just
like prev_key=NULL case, the returned key will be duplicated.

With the retry logic, the iteration can continue to the key next to the
deleted one. But if we directly skip to the next key, the iteration loop
would restart from the first key for the lpm_trie type.

However, not all races may be recovered. For example, if current key is
deleted after instead of before bpf_map_copy_value, or if the prev_key
also gets deleted, then the loop will still restart from the first key
for lpm_tire anyway. For generic lookup it might be better to stay
simple, i.e. just skip to the next key. To guarantee that the output
keys are not duplicated, it is better to implement map type specific
batch operations, which can properly lock the trie and synchronize with
concurrent mutators.

Fixes: cb4d03ab499d ("bpf: Add generic support for lookup batch op")
Closes: https://lore.kernel.org/bpf/Z6JXtA1M5jAZx8xD@debian.debian/
Signed-off-by: Yan Zhai <yan@cloudflare.com>
Acked-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/r/85618439eea75930630685c467ccefeac0942e2b.1739171594.git.yan@cloudflare.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index cfb361f4b00ea..7a4004f09bae7 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1713,8 +1713,6 @@ int generic_map_update_batch(struct bpf_map *map,
 	return err;
 }
 
-#define MAP_LOOKUP_RETRIES 3
-
 int generic_map_lookup_batch(struct bpf_map *map,
 				    const union bpf_attr *attr,
 				    union bpf_attr __user *uattr)
@@ -1724,8 +1722,8 @@ int generic_map_lookup_batch(struct bpf_map *map,
 	void __user *values = u64_to_user_ptr(attr->batch.values);
 	void __user *keys = u64_to_user_ptr(attr->batch.keys);
 	void *buf, *buf_prevkey, *prev_key, *key, *value;
-	int err, retry = MAP_LOOKUP_RETRIES;
 	u32 value_size, cp, max_count;
+	int err;
 
 	if (attr->batch.elem_flags & ~BPF_F_LOCK)
 		return -EINVAL;
@@ -1771,14 +1769,8 @@ int generic_map_lookup_batch(struct bpf_map *map,
 		err = bpf_map_copy_value(map, key, value,
 					 attr->batch.elem_flags);
 
-		if (err == -ENOENT) {
-			if (retry) {
-				retry--;
-				continue;
-			}
-			err = -EINTR;
-			break;
-		}
+		if (err == -ENOENT)
+			goto next_key;
 
 		if (err)
 			goto free_buf;
@@ -1793,12 +1785,12 @@ int generic_map_lookup_batch(struct bpf_map *map,
 			goto free_buf;
 		}
 
+		cp++;
+next_key:
 		if (!prev_key)
 			prev_key = buf_prevkey;
 
 		swap(prev_key, key);
-		retry = MAP_LOOKUP_RETRIES;
-		cp++;
 		cond_resched();
 	}
 
-- 
2.39.5



