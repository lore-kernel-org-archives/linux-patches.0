Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216682;
	b=rtUcyu/tktj2D77XAhcNMAfpz/6ed46c6llkg71iIh2BLzA5DAH0lM+7HbOfRQce9kpK
	 EONM5IorTs8sVAhwURLUnTkRZgO130iBbexNCwpck0s0sgJ3SJTvXE6UJhEZsbGQob/JN
	 dpYO7noC3HXmadiBQo+zrUZ0jHZvxYbJ3fVWgkLa/qK/fVFwOVjNkgw+tupzg9xskz0gZ
	 xWt4X97wVv8QWULH+LZhUbntbYzUhNj5wL2+9CYbphPMAM+FgndYthXyU33nxfLT4M5LL
	 w2MWm6GpNPQho0p3LYg/uGrsFoA7+D/YgRpiFdP42LueMUjAsQ856xEZT8FAD5e7hiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216682;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fFsscvfWCFUULIbxs3lWhpiD2j4UR0Ja6bIYKFjVVps=;
	b=L7VoOSRKPRdkyKdC8uWPH0YIqZuJSJZfYWGwinMSwFIBdEGpjBE1ya93N6mmDhWH0qeU
	 nYQ0WkGqg9JkuLv06mNyN9e6y90+RSDGx9O/Jc8muoIV2fdm64tslFhjpO80Pk51+3iWz
	 xynmGDj02tpSnz1KjPxF6z5FMmariMWO1+Eu3FhD63wgT2Dwc4P1+exygjTCSa30q1UCp
	 Fy46NPBRpexfa3rIvVEJF+VfW8SMtM6IIMJfXAQzFGG3SqQtryTG1NPXHJsnyI4AwwJzt
	 csPomhxOJgi6p+E2nSkDTyc9wydm7ts2ryLUZAoOpN1+cslBQye+urW6lmP/pKzSJUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gRV5WMdR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9B4606A31D;
	Wed, 28 Oct 2026 19:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gRV5WMdR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B911F01825;
	Wed, 28 Oct 2026 19:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216682;
	bh=fFsscvfWCFUULIbxs3lWhpiD2j4UR0Ja6bIYKFjVVps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gRV5WMdRlhWtrQEEj8FnodvZwMO2Bi714ZXerqle6xHOaKHNBw5bP8uPG8Afl/TLP
	 ieHYfCk7O9Q4oo6Fi2qqdskuaH8Kk0Pyv/mPWi9UwJ3AAPWGpRUwY+h6wdXjhFIJgK
	 zVeC4TWsBfVyWb0iU/YvEbVQAdibeH46kncM+81k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Hwang <leon.hwang@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1640/1887] bpf: Copy per-CPU map value padding in copy_map_value_long()
Date: Wed, 28 Oct 2026 18:02:16 +0100
Message-ID: <20261028170536.783762879@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 include/linux/bpf.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 7af010d1830d0..0ce4f1eb92d10 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -354,7 +354,10 @@ static inline void __copy_map_value(struct bpf_map *map, void *dst, void *src, b
 		memcpy(dst + curr_off, src + curr_off, next_off - curr_off);
 		curr_off = next_off + map->off_arr->field_sz[i];
 	}
-	memcpy(dst + curr_off, src + curr_off, map->value_size - curr_off);
+	if (long_memcpy)
+		memcpy(dst + curr_off, src + curr_off, round_up(map->value_size, 8) - curr_off);
+	else
+		memcpy(dst + curr_off, src + curr_off, map->value_size - curr_off);
 }
 
 static inline void copy_map_value(struct bpf_map *map, void *dst, void *src)
-- 
2.53.0



