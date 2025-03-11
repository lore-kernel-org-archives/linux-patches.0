Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DE81E9B06;
	Tue, 11 Mar 2025 15:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707303; cv=none; b=Wv1rMtypDPk8+00wnEgiW3I3LXecpta6NkTA6E7DiqxSFocdzDjHLCXumqy9O7Dwt6+vDz+xEdyaT3KH4RKTTheHdwMaHbEyueXOP7XE6de1uVv/kd6VaJVR2pb5HwReOYBsLBzNcFxZLy7D6B85hz81OKJdSgxxk57+XOVy+nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707303; c=relaxed/simple;
	bh=kDzOph7E7RgZbuac6dOhjgb+oG4sVt0LhTmKEmRdik0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WhAZ/oDzBtE5i/xYVjOpPUCaVoEnFD/4ZydiRAxHPT+Up3rnIDXD43hgCNsRgw2aelo3N5/n12hxxovBwZ/+GS5rczLASumZDXQ2z+CiCYs6hNhkQUau9yNG2vwut00DSremDirs03NyJYaF9zf9AoxfIZLm6hOppAWATHds+0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HouMISvp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HouMISvp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09EE9C4CEE9;
	Tue, 11 Mar 2025 15:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707303;
	bh=kDzOph7E7RgZbuac6dOhjgb+oG4sVt0LhTmKEmRdik0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HouMISvpqkkLrPJIQllM/MNVd+ePdZHALryh3tCHdt21aAqV7cyPt1yOuybuUjnrB
	 laKgJme0yI7YEn1vCMCA38niGC/6uIGk3QuNF2HwBRjxWf5Gdx1AOF8VpB83dTZGMM
	 mKDBGU1KAIP6FtsS0MOhDtGE7E56v6iMZn21CIyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yan Zhai <yan@cloudflare.com>,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 342/462] bpf: skip non exist keys in generic_map_lookup_batch
Date: Tue, 11 Mar 2025 16:00:08 +0100
Message-ID: <20250311145811.875099933@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b5d9bba738347..008bb4e5c4ddc 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1406,8 +1406,6 @@ int generic_map_update_batch(struct bpf_map *map,
 	return err;
 }
 
-#define MAP_LOOKUP_RETRIES 3
-
 int generic_map_lookup_batch(struct bpf_map *map,
 				    const union bpf_attr *attr,
 				    union bpf_attr __user *uattr)
@@ -1417,8 +1415,8 @@ int generic_map_lookup_batch(struct bpf_map *map,
 	void __user *values = u64_to_user_ptr(attr->batch.values);
 	void __user *keys = u64_to_user_ptr(attr->batch.keys);
 	void *buf, *buf_prevkey, *prev_key, *key, *value;
-	int err, retry = MAP_LOOKUP_RETRIES;
 	u32 value_size, cp, max_count;
+	int err;
 
 	if (attr->batch.elem_flags & ~BPF_F_LOCK)
 		return -EINVAL;
@@ -1464,14 +1462,8 @@ int generic_map_lookup_batch(struct bpf_map *map,
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
@@ -1486,12 +1478,12 @@ int generic_map_lookup_batch(struct bpf_map *map,
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



