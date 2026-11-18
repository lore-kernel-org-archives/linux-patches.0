Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026311;
	b=yUvVuZIeFI3bbfubAfDcRkc76vKaX+5NPWYVMdakkmejUMdo0Uy8F/fygZqtMhq4VYRC
	 /R0kAb19HhS1BzHowR+edaA1trYT3mWW6S+no7zjvvYSlJLrBQMSgIjS4OGcrY86IMvT1
	 fsLAcq4xfRLwZ5cPQbkUf/e4b3yK5gvHgx3034mydnuhhFfyUkkKujB1OgG+fmNyOmPSw
	 u+4wu4GX2JQ6nKOnXrljGtOanj6IkyX47QvPZrzdViuiv6gYvAvV6JU9bwuLxbx/9kaFB
	 kXWkzGwRprBNqY/NyBvjm1e0cK6EQTKKvPzuh3a3EFOXbkC5Qke6asuNyjU+BVQO10Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026311;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gAnEPye0xk2zGIMGqbZYODM1RuVn0yPNI/KzlzBCGew=;
	b=tVHHMRBPM/xllCLvb0Vzmrn66uJE+Q2euD7W1B+GPBCFgiPyxZDoggK3ecryx8Ty+Bdt
	 q6WJpi8XU7Xr2tWbDH4jCpwVWQoZJg1i04N7q2F9NEm/Zjd+6V/rfhcBzekk8obYfcECn
	 rbzuvmuh6Dnf48iowVIh2a27932d59ttkbVPQlZ/EK9odGNQBprmQM/KeRYRI7Czvp8F9
	 2gYH+UzWXc3uItmjNZERDum4w/Xd+lk26RSe9Xmjns1x6RFhiqLv3FXqCIk95f/94EhWf
	 F/9bcdez1eDiysJ6ViBD0OOz2ukD1EHqa7UCy2MJ+nyTi5dBuVihjOwXs7ZfHd3Ib6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n2Et1awt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C97606A332;
	Wed, 18 Nov 2026 18:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n2Et1awt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A651F000C5;
	Wed, 18 Nov 2026 18:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026310;
	bh=gAnEPye0xk2zGIMGqbZYODM1RuVn0yPNI/KzlzBCGew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n2Et1awtSnFJ8eiXCyFuKyy/tkbkcz81S63oRHyU9gosCwpmxbRNKqe/WEOV/cr15
	 xFB+y5EYqmaBequodebu1oynwNLLNdwHQ4A/ri3x2i74/fZ3i1LTwGPCYDGPbaLyjR
	 EsIeKGV6ob+T9VfJqnT0LeGI9aKmdyPI2NgNpEvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1391/2151] calipso: hash the cache key, not the option start, in calipso_cache_add()
Date: Wed, 18 Nov 2026 15:52:06 +0100
Message-ID: <20261118150212.671444631@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 22008f5a2973d..2bc3a8fac86bf 100644
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



