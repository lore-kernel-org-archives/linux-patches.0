Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031615;
	b=uXi6eazr4DwcjvXO7nbmakNCn2LPIhJNb+KGwBVcO+62eoWB5bnS6nKEckMscsKGvMp/
	 WHdphgnq4FV0WsOnJaTZ38R4WFzjUx8JuvKVgdW56+QlCvRSAePTqDiuFZsJXJTbYvw2Y
	 oEWLj8tzIPtQsKLrwvNuiEfJaNAedE4SJt85hSybJriXm5v80ygb0XzmkfENGOy+2/1cw
	 zQlB+UmdYSzUsJMxhR1wRkfPO6GdUhmSpwpVoPwOSya7aiITB8sSZ+5u5UeA6K9eCSad8
	 v8IWoUsKSEyN+lU1pxcw7FsD0j+vVwPk2b2c/2ZeCyRDyU4INmpQty0KRr8UsaIRJog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031615;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ICE575WrY0oYn5aKUtwCXsvU5alGaB419EALovBTfDM=;
	b=1UAH1C0NfUGhoxBpFOop54UzTbC3532KlZWRqlK2w7+7VJJv1YXfINO8r70NicRVMGFS
	 4g2fQWJsf4juUjwAq9GVnxJOwtg78EUGAwMsKLafyFdUvxwVMQkY9IFjMeRZaXfc61tfE
	 NJkZSNCN5IjZeKSKVLcK9YNR4S5jGZmLedXXQbffdxyj3YpzNNzOSjMcgBTRLDd8UoTSu
	 zLL0gp3z7rv6fdYFLx0vmzyx4nmyf5SRQvurGKF1jU7TElg1AEkFIW2KdS5tuAQH+WTfX
	 4nRuAdZzhJ85eqGjZQGURjRlVLZnAoRWkMGisVfQBTQnrIHngJbLa8oYE+VU7y8EG1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nsKW15+S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1AC3606A330;
	Wed, 18 Nov 2026 19:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nsKW15+S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241171F000CF;
	Wed, 18 Nov 2026 19:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031615;
	bh=ICE575WrY0oYn5aKUtwCXsvU5alGaB419EALovBTfDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nsKW15+Shq/ZQOSCKEzF0OWftSXL0n6nW4FXRE+HBHh66IXFMCvLBRnaEktymLC5V
	 EkFTnTF8qXOfoK/K4vHDfSQiG6AhQo+Vt0WXC9a7UJYiPGFC/047Y6R/tmrjJaoQkB
	 LINtkd/Mu0YCrzlVgzZZkG0Rk+fD7xzuvJN+or64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1103/1756] calipso: hash the cache key, not the option start, in calipso_cache_add()
Date: Wed, 18 Nov 2026 15:53:50 +0100
Message-ID: <20261118150054.094091468@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3ab22f9b416ec..f3a983aa07036 100644
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



