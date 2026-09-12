Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24FA0431A5C;
	Sat, 12 Sep 2026 12:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214771; cv=none; b=SJa3fjtFmMC+VzuVvEfB1hsAclLZhSTisAiwHtXduniw8QztGmetiCwsqqVvFZIiHA1FZdvM9WqQjS5Elg+wrJcu1UPD+edfs3b8YzN7t2vNkMcbJZvczTEEHoJEa8G/KVRHM5ew7Xuyr4Ma2tzj5FgAGZVsWCBhFgFnaW1RS1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214771; c=relaxed/simple;
	bh=HzqYqX+5pysMiNAFEsGfFE9SfX6uWEKMzCXQ3ECLpAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QwdYUxMrFdkaJdt4/rGkD7GYV1YJcZjaTN43a+0qaXrI0SSSUPUUmRkwkB9K/Af0hNWaJ8DDae76+gWmSehESUGd7RJ5l6AzaqCh827QM3AeRIs1ljUzrXF4h3Jitv3EVd23iywKDNKiJj01We1lClNJoQR51BQYS1oKaQ0ClW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zgkq90AY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zgkq90AY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945631F000FF;
	Sat, 12 Sep 2026 12:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214769;
	bh=STfv+/VrtpZHWOjdCOOccsx3LpHw9za+BEHg3hnQsqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zgkq90AYif4H2dTT7JQ/c2TLqOh7zjPghE3VLd90YFUTkAcBmbv6YYF4XfF9k2wnX
	 sTG/RPpRwiIkjEycwqf7wcqkqLvRdNJm2bR65cGtSPiVcXQ8V1tsWPTPtDGTQwgLwZ
	 RGYGfHee2dJkzAt+Rvx+/Z+S3FaaxRG2DLUSK8eM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Hwang <leon.hwang@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0377/1376] bpf: Copy per-CPU map value padding in copy_map_value_long()
Date: Sat, 12 Sep 2026 08:46:43 +0200
Message-ID: <20260912065615.950877346@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 9e1731db76d86..47fdbf13abe16 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -500,7 +500,7 @@ static inline void bpf_obj_memcpy(struct btf_record *rec,
 
 	if (IS_ERR_OR_NULL(rec)) {
 		if (long_memcpy)
-			bpf_long_memcpy(dst, src, round_up(size, 8));
+			bpf_long_memcpy(dst, src, size);
 		else
 			memcpy(dst, src, size);
 		return;
@@ -523,7 +523,7 @@ static inline void copy_map_value(struct bpf_map *map, void *dst, void *src)
 
 static inline void copy_map_value_long(struct bpf_map *map, void *dst, void *src)
 {
-	bpf_obj_memcpy(map->record, dst, src, map->value_size, true);
+	bpf_obj_memcpy(map->record, dst, src, round_up(map->value_size, 8), true);
 }
 
 static inline void bpf_obj_memzero(struct btf_record *rec, void *dst, u32 size)
-- 
2.53.0



