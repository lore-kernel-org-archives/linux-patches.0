Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBD230C617;
	Sat, 12 Sep 2026 14:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222615; cv=none; b=tOghGllSRrhn9XJkDw9ZrGXMEDFaY6XutC6Ur3ngbQxG6JErN+Qd5U+lXNeRPBn0O4dt7EoiyF5r1v5xFujGkNaCGMUsG7Wt+0S7Ga5sG3a4K1S3/JGfImpoGDJ6e+ojqsHHBDfOapH8zKvuXjSKgXfSmy4dfEvzveCcBLuFiEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222615; c=relaxed/simple;
	bh=7mPhxUSExDHfzdGimI8uzaVNBQqLCxfwZk3oUJidKuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbFylELt9goViFwHh1FjGmIeaezb0nCMo8JakNRX/j8ekhze0UOgo/YOaOrgWKbcVjWaEMgZdNEGQep0Zmx0ZJWhItiz/2AFkXXFnqJwhFKf7WySPOnw8kCZ2N2E7AFoUGJv3WCtKyzxJASLuKriPJdYsNXz/1v1znNrdsNwkM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rzKypBL9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rzKypBL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E7A1F000FF;
	Sat, 12 Sep 2026 14:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222613;
	bh=AauSe+6kQHRlYwJCmuPKUsKcLU3p3QvNagQsZUiZ+dA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rzKypBL9p8R3CC0glbqK5pyS/saRmA+Ny1q8qRUoZaPmZTXuC9tBJDcht2HpPT1a4
	 n/JmjPScrGP0QvtfDkgLi//F6t5TzMrxaIxEylNNwofPGMwAsKU4YYy5NTRj77sTLj
	 aHNIAukNfH9a0b4JM7H/Et18QzyroAC4S64gizhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Hwang <leon.hwang@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0621/1424] bpf: Copy per-CPU map value padding in copy_map_value_long()
Date: Sat, 12 Sep 2026 08:50:53 +0200
Message-ID: <20260912065621.198650716@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Hwang <leon.hwang@linux.dev>

[ Upstream commit 7cf9cd98cf6f0df3befc167ca6b54c07014d71de ]

In kernel, per-CPU map elements are stored with
round_up(map->value_size, 8) bytes. On UAPI lookup paths, it copies the
rounded size for each CPU into a temporary buffer.

However, copy_map_value_long() passes 'map->value_size' to
bpf_obj_memcpy(). When the map has special fields, bpf_obj_memcpy() copies
around those fields with memcpy(), and does not copy the tail padding
between 'map->value_size' and round_up(map->value_size, 8).

The temporary UAPI lookup buffers are allocated without __GFP_ZERO. As a
result, when the per-CPU map's value size is not equal to
round_up(map->value_size, 8), UAPI LOOKUP_ELEM and its variants can return
stale heap contents from that padding to user space. The same issue
applies to bpf_iter for per-CPU maps.

Pass round_up(map->value_size, 8) to bpf_obj_memcpy() from
copy_map_value_long(), so per-CPU maps both with and without special
fields copy the entire per-CPU slot. Remove the now redundant round_up()
from bpf_obj_memcpy()'s long_memcpy path.

Fixes: 448325199f57 ("bpf: Add copy_map_value_long to copy to remote percpu memory")
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260624155115.85196-2-leon.hwang@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 398fa28c388d9..fd20812cbcc33 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -482,7 +482,7 @@ static inline void bpf_obj_memcpy(struct btf_record *rec,
 
 	if (IS_ERR_OR_NULL(rec)) {
 		if (long_memcpy)
-			bpf_long_memcpy(dst, src, round_up(size, 8));
+			bpf_long_memcpy(dst, src, size);
 		else
 			memcpy(dst, src, size);
 		return;
@@ -505,7 +505,7 @@ static inline void copy_map_value(struct bpf_map *map, void *dst, void *src)
 
 static inline void copy_map_value_long(struct bpf_map *map, void *dst, void *src)
 {
-	bpf_obj_memcpy(map->record, dst, src, map->value_size, true);
+	bpf_obj_memcpy(map->record, dst, src, round_up(map->value_size, 8), true);
 }
 
 static inline void bpf_obj_memzero(struct btf_record *rec, void *dst, u32 size)
-- 
2.53.0



