Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFFE3043B7;
	Sat, 25 Oct 2025 16:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408838; cv=none; b=Qbv4/i4MNPpBgZ4+fiIhaalY3oiO6s7e8VsP8WG1+QS9KdP9dFSufa2LETR9Z5G3i+dYWZkZV3JS++OTKsVDdNc0WEq8gwqDQiEG/tKtQnE5kth8k6Sy/II7Y29L+wEMrvKFCeBfmDaBvu91ZCNdrzgDtLJGXIqHfe0AX/fo7TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408838; c=relaxed/simple;
	bh=nrapjmA7M3Dr/9BWfufzxZxVh8c9KYj9lkcmoQHrBw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cpQAJaWh/mQpNES7vQCS5iovX6QnfEbusTZZBTxfUgYRk5b2FuCagkoLs/4+8G/KQam42CFcB9XMbzG8SkN8MALZNavzykC4Yq6BXon02nf7efmTq+y6q3m20tNTbU/PnjqPo749cXBfE2YMfLMkLIW97yqX6TCRWGoPF6Fa1y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tzFRGq/T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tzFRGq/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2C7C4CEFF;
	Sat, 25 Oct 2025 16:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408837;
	bh=nrapjmA7M3Dr/9BWfufzxZxVh8c9KYj9lkcmoQHrBw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tzFRGq/Tr1H3s08LF1m1inPVf2nwC6MXXQqPHfZr2sieg+NmfYuUS/HOk0l+UdNaq
	 vhtfF484Otv9Pp8GhthbDzasYLcsGV0fz8e5edkQa0wkHHm6ZMD4IjkMxBpDjSK2RZ
	 I4ToS/Tej9+royjA9hF/WHuuRGOO5tH8Te5e7IG9dx11HVEWuISgAI7Hc0u4KFVPFT
	 ZEZnDXsl0IZaHseAOpxGVslb1Add4QOk+qDSwHdYUiG/lMYS+vKMxtMKK1S9cw46wF
	 xIm1C87RXrDiF7RTbghP+ejl/fx48r1qO8yNKirjHjBSH4iGnQ026aMoWXUtybzqzi
	 U+oelv535Ilqg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mike Marshall <hubcap@omnibond.com>,
	Stanislav Fort of Aisle Research <stanislav.fort@aisle.com>,
	Sasha Levin <sashal@kernel.org>,
	devel@lists.orangefs.org
Subject: [PATCH AUTOSEL 6.17-5.4] orangefs: fix xattr related buffer overflow...
Date: Sat, 25 Oct 2025 11:55:24 -0400
Message-ID: <20251025160905.3857885-93-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mike Marshall <hubcap@omnibond.com>

[ Upstream commit 025e880759c279ec64d0f754fe65bf45961da864 ]

Willy Tarreau <w@1wt.eu> forwarded me a message from
Disclosure <disclosure@aisle.com> with the following
warning:

> The helper `xattr_key()` uses the pointer variable in the loop condition
> rather than dereferencing it. As `key` is incremented, it remains non-NULL
> (until it runs into unmapped memory), so the loop does not terminate on
> valid C strings and will walk memory indefinitely, consuming CPU or hanging
> the thread.

I easily reproduced this with setfattr and getfattr, causing a kernel
oops, hung user processes and corrupted orangefs files. Disclosure
sent along a diff (not a patch) with a suggested fix, which I based
this patch on.

After xattr_key started working right, xfstest generic/069 exposed an
xattr related memory leak that lead to OOM. xattr_key returns
a hashed key.  When adding xattrs to the orangefs xattr cache, orangefs
used hash_add, a kernel hashing macro. hash_add also hashes the key using
hash_log which resulted in additions to the xattr cache going to the wrong
hash bucket. generic/069 tortures a single file and orangefs does a
getattr for the xattr "security.capability" every time. Orangefs
negative caches on xattrs which includes a kmalloc. Since adds to the
xattr cache were going to the wrong bucket, every getattr for
"security.capability" resulted in another kmalloc, none of which were
ever freed.

I changed the two uses of hash_add to hlist_add_head instead
and the memory leak ceased and generic/069 quit throwing furniture.

Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Reported-by: Stanislav Fort of Aisle Research <stanislav.fort@aisle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- Fix makes `xattr_key()` terminate on the terminating NUL
  (`fs/orangefs/xattr.c:54-61`); the old `while (key)` loop never ended,
  so any user who ran `setfattr`/`getfattr` hit an infinite scan,
  leading to faults, hangs, and reported OrangeFS corruption. That is a
  serious, user-triggerable bug worth fixing in stable.
- Added NULL guard in the same helper (`fs/orangefs/xattr.c:57-58`)
  keeps the cache code from hashing bogus pointers; this is defensive,
  tightly scoped, and carries no observable side effects for valid
  callers.
- Entries now go straight into the bucket chosen by `xattr_key()` via
  `hlist_add_head()` (`fs/orangefs/xattr.c:180-181` and
  `fs/orangefs/xattr.c:234-235`). Previously `hash_add()` rehashed the
  already-reduced key, so `find_cached_xattr()`’s bucket walk
  (`fs/orangefs/xattr.c:71-82`) never located cached/negative entries,
  leaking a `kmalloc()` on every lookup until OOM (seen in xfstest
  generic/069). The new storage method matches the existing
  lookup/removal logic and the cleanup walk in `hash_for_each_safe()`
  (`fs/orangefs/super.c:115-131`), so it simply restores the intended
  caching behaviour.
- Change set stays within `fs/orangefs/xattr.c`, doesn’t alter
  interfaces, and directly resolves the regression; without it OrangeFS
  remains trivially DoS-able and leaky. With it, functionality is
  restored and risk is low, making this a strong stable backport
  candidate.

Suggested next step: rerun xfstest generic/069 on the target stable
branch to confirm the leak is gone.

 fs/orangefs/xattr.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/orangefs/xattr.c b/fs/orangefs/xattr.c
index 74ef75586f384..eee3c5ed1bbbb 100644
--- a/fs/orangefs/xattr.c
+++ b/fs/orangefs/xattr.c
@@ -54,7 +54,9 @@ static inline int convert_to_internal_xattr_flags(int setxattr_flags)
 static unsigned int xattr_key(const char *key)
 {
 	unsigned int i = 0;
-	while (key)
+	if (!key)
+		return 0;
+	while (*key)
 		i += *key++;
 	return i % 16;
 }
@@ -175,8 +177,8 @@ ssize_t orangefs_inode_getxattr(struct inode *inode, const char *name,
 				cx->length = -1;
 				cx->timeout = jiffies +
 				    orangefs_getattr_timeout_msecs*HZ/1000;
-				hash_add(orangefs_inode->xattr_cache, &cx->node,
-				    xattr_key(cx->key));
+				hlist_add_head( &cx->node,
+                                   &orangefs_inode->xattr_cache[xattr_key(cx->key)]);
 			}
 		}
 		goto out_release_op;
@@ -229,8 +231,8 @@ ssize_t orangefs_inode_getxattr(struct inode *inode, const char *name,
 			memcpy(cx->val, buffer, length);
 			cx->length = length;
 			cx->timeout = jiffies + HZ;
-			hash_add(orangefs_inode->xattr_cache, &cx->node,
-			    xattr_key(cx->key));
+			hlist_add_head(&cx->node,
+				&orangefs_inode->xattr_cache[xattr_key(cx->key)]);
 		}
 	}
 
-- 
2.51.0

