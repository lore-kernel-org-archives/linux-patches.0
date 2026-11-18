Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056202;
	b=bB2DfF50ph8gdW0K4r+aMf2Hc4ispf+4v8/NwKessfZJH+TQcegTFrc9O6AyRBgAP2Ag
	 bt6UktvH5DtBAv6XLaBhREkenv9iZxDFs92DO6oNgWriaTZqcPffg5/y90V1di9D2couA
	 nvt1pi15uz5q2UF+DBOnVY69aVIcax9YhnpwZQfFUOGOaCqnK22exzemfrS3QG46FW5Ya
	 ojjt9jyG2DOqTeftavBdgrflOY4fnGcDHXGk81aWle3Sxue+IPW3uv3276H0/WL0a4my1
	 78zEiw38Kmob/2XSjl1arEuZKbZg7Tl7WlWfOY8HMk2BH1qVBYKC+IpylmXdn9vmmqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056202;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O7VxQL/gdVogJ0P3c26S27uOZWKLHXpdVg9KmIFWux4=;
	b=LSn54np1LKFIVhoNxCUtd0Stk7QC0OdYLpzfVBtnp09TH3em0Ps569D0+IWyxWPwuBpQ
	 sISZmjWRyFjhiO8NvM7mzhN/3atB073n8RYOAmpi1VkVKPhhoYtZD9YDZUcXZX/hrrQWo
	 yZRMM0GJ/uR/LYDwK4iiXVWm+AGP5oWsh+FmR9V2vMjYsDSkVYBAn4+N4qZgoLj2hphkn
	 +jUFQKs7XRZGlFRp+kr1NeEC4RsNp9jIHS7077SLYrcF1tGKty/b2OSbIhD7Sv3vZNTvx
	 JbRNp2U+OxzbQH2mBkHILt9mN6X/tsghryG2ngac//gbG84G0NHvIVRNOnPLxneBJjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2i1IyLC6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D6A606A320;
	Thu, 19 Nov 2026 02:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2i1IyLC6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4361F000C5;
	Thu, 19 Nov 2026 02:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056201;
	bh=O7VxQL/gdVogJ0P3c26S27uOZWKLHXpdVg9KmIFWux4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2i1IyLC6U0GXNncpeWrCdyl1fx0383Ar36FAk3F+uAr2TQcQ5RqTo0RSmiAino5xf
	 t20pzmvr1Jwqcfo+durLO9zCBEOupjj6yEMNf219p86VVkGO3Zxc/WyQ2BPBNTPX1V
	 jAmpDi0CLkk/OgXofQet+LFx/ryjenDKvRBDhgws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1863/2214] calipso: hash the cache key, not the option start, in calipso_cache_add()
Date: Wed, 18 Nov 2026 15:58:59 +0100
Message-ID: <20261118150125.854361914@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joas Antonio dos Santos <joasantonio108@gmail.com>

[ Upstream commit d538cc3ec0bc4cb7b40981b3213a6c6671959ed5 ]

calipso_cache_add() stores calipso_ptr + 2 as the cache key, but
computes entry->hash over calipso_ptr, i.e. starting two bytes earlier
at the option type and length.  calipso_opt_getattr() looks entries up
with calipso_cache_check(calipso + 2, calipso[1], ...), which hashes the
key itself.

The two hashes only match on a jhash collision, so the CALIPSO label
cache never hits and every labelled packet takes the full DOI lookup and
category conversion path.  The memcmp() on the key keeps lookups
correct, so this is a performance bug only.

Hash the stored key, as cipso_v4_cache_add() does for CIPSO.

Fixes: 4fee5242bf41 ("calipso: Add a label cache.")
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
Assisted-by: Claude:claude-opus-5-5
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/179138670045.80227.16155454353416856947@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/calipso.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/calipso.c b/net/ipv6/calipso.c
index 72079ef2959b9..e4e2ee5059c3d 100644
--- a/net/ipv6/calipso.c
+++ b/net/ipv6/calipso.c
@@ -284,7 +284,7 @@ static int calipso_cache_add(const unsigned char *calipso_ptr,
 		goto cache_add_failure;
 	}
 	entry->key_len = calipso_ptr_len;
-	entry->hash = calipso_map_cache_hash(calipso_ptr, calipso_ptr_len);
+	entry->hash = calipso_map_cache_hash(entry->key, calipso_ptr_len);
 	refcount_inc(&secattr->cache->refcount);
 	entry->lsm_data = secattr->cache;
 
-- 
2.53.0



