Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F58343893;
	Sat, 12 Sep 2026 09:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206274; cv=none; b=BdSnCdfoy1e8RN+mlmtgI/79TVTHWZABgZssdhdXv45E9/U8NYFlVs62+qCN+WJw0NfsIsOTZV3rRgVfFXh9Pye8u5aJilQoo63QhxSZCKbiraVQlI5TV6fP9M0bMWE8ZKgIR2Xntn7aC1Y0rjxbzTVvTuBJbCJBLJEol1I9NtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206274; c=relaxed/simple;
	bh=76BnmaT4An9fpZzngA60P6zvc3lHTo4fUrZzXwIACJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ah4G93qRbWvtLcz48ozYkF1VDPwaGQEBxgE4xiJoH/cEpDDoOHwmk/7g7yyceD2/Hp1+Gtzkh/eYJhK+8Htt0wFAZkS9Y1PTMAHBpYnMTG0EUp9+J+owDhg9mM1ZBr1S4hNPBS9z3QxcEN9rmFRWr/GcGIpYnPz5nXj2dhwm3RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B1hyH5uv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B1hyH5uv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048DA1F000FF;
	Sat, 12 Sep 2026 09:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206273;
	bh=etc8suvqqdxAzj2Pht+jJWoSoeilx05TAZgKdcLJ6LQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B1hyH5uvMUkV6cyIz4ViMFg1sCGAYxfTaVatCqhVXF7G2OlT/RR9I5WTwPAim9jlW
	 FWoN/YGMpSsQ3DtYw4aEno9Etm2srLyfsUndc3KdhHHSOCJl2cIT4ozOt8LBonvM2Q
	 PM2iqqMp3vCcbVmNj1wpj/6WuCRi36pPIfh7b7Zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Hwang <leon.hwang@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0172/1518] bpf: Copy per-CPU map value padding in copy_map_value_long()
Date: Sat, 12 Sep 2026 08:39:01 +0200
Message-ID: <20260912065627.387420824@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e264c695f31ce..84a8afc6e6df3 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -536,7 +536,7 @@ static inline void bpf_obj_memcpy(struct btf_record *rec,
 
 	if (IS_ERR_OR_NULL(rec)) {
 		if (long_memcpy)
-			bpf_long_memcpy(dst, src, round_up(size, 8));
+			bpf_long_memcpy(dst, src, size);
 		else
 			memcpy(dst, src, size);
 		return;
@@ -559,7 +559,7 @@ static inline void copy_map_value(struct bpf_map *map, void *dst, void *src)
 
 static inline void copy_map_value_long(struct bpf_map *map, void *dst, void *src)
 {
-	bpf_obj_memcpy(map->record, dst, src, map->value_size, true);
+	bpf_obj_memcpy(map->record, dst, src, round_up(map->value_size, 8), true);
 }
 
 static inline void bpf_obj_swap_uptrs(const struct btf_record *rec, void *dst, void *src)
-- 
2.53.0



