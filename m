Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216674;
	b=2aT8SB7vgzQimKfEY7UUU+/0hlDkkNKTNHdA4jL5+EZXVstwDCvbeM8UDY/pm2cGo/mf
	 050qQWTw9ijnh15EVUdJ11qO9JgRqJ4m6vMkNUUolWfGsfEgFDNkXqDHXSVimp8LzwSS+
	 obu+hNQdx8Z73ZiNVs9mRpevfrI+ImMra4F/o50HHdYfE18FGZi5UYzLTsBbvgh5iIp83
	 KTgPKZwccHKpxI+Uoz+bo8rQ3KPrFHXEhEuWHyphVy0uZlcLJjdZMrUydjEeFBVkEhzoY
	 VkGx1s2EyqbCVxnEDM9KGys6WSHWGBz9HyKb2XKVeaPsYrrVJYhcQHxnu0Hh9IekuiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216674;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qlO24b4j8kJFc5baYT2AXukTl7XJ0x5DM7hSNZcG9II=;
	b=LBGibgLFzu4qzpWtMwQWlKc5dowdT2QoEP16WZwBqIpf9xLM4XhZxosj+PPbO3JWIvpN
	 4IdE8Y6N8jQbq5Y3bCjobGzdgl8UyaUaon+IAFsM+HMjdza/+ZOAbx7KToJ18Nx4OSOkY
	 VkfSTHqxdRTTRXuWLDEmFMEcpTox8DwU0Q1dH5wwzsTzSVDggMl0LqmOUj71KAa1fqlc8
	 V74GgzTDck9q0AMEINjd/aY85gqgn2tyXBWxJZE/2Un/alAiuJA8cClPYdPwOzMepZ+kR
	 971lr7FKOHneE5zG3gqCVcFRXxuyJRUKMZazW/8CcLzf9I1wxZIYfSEFyGYZk+tkQgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ez7SYyM4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517F2606A31A;
	Wed, 28 Oct 2026 19:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ez7SYyM4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60DAC1F01828;
	Wed, 28 Oct 2026 19:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216673;
	bh=qlO24b4j8kJFc5baYT2AXukTl7XJ0x5DM7hSNZcG9II=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ez7SYyM4e7U5Co3D7ZysNUqze2PoWwk3InxP8V0GoFwHAlbKJHZzDJyHBaaVjJ+vL
	 0SHpOQf6Zn229kGVNTDp+gc/l5HATWgDTCU49X6e6QBFKDMa1Ry7e8axlcmPmxBoYZ
	 9pQ3LsK1DX1YyDJZ0Qp/2H89nQQmNDEUtM48AcpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manos Pitsidianakis <manos@pitsidianak.is>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1637/1887] hwrng: core - fix rng list on registration error
Date: Wed, 28 Oct 2026 18:02:13 +0100
Message-ID: <20261028170536.717123868@linuxfoundation.org>
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

From: Manos Pitsidianakis <manos@pitsidianak.is>

[ Upstream commit 3a5834db2b1ce25649f330e78efe1ccde78967fd ]

hwrng_register(rng) does the following:

1. Checks if rng has name and read methods set
2. Checks if the name already exists
3. Adds rng to global rng_list
4. May try to set rng to current_rng

If step 4 fails, it returns an error. However, it does not remove the
rng from rng_list, causing a dangling reference which can result in
use-after-free if the caller frees rng, since registration failed.

Add a list_del_init() cleanup step.

Fixes: 2bbb6983887f ("hwrng: use rng source with best quality")
Signed-off-by: Manos Pitsidianakis <manos@pitsidianak.is>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 1f72ffc2017ed..4b1a0fed48ab6 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -622,7 +622,7 @@ int hwrng_register(struct hwrng *rng)
 		 */
 		err = set_current_rng(rng);
 		if (err)
-			goto out_unlock;
+			goto out_list_del;
 		/* to use current_rng in add_early_randomness() we need
 		 * to take a ref
 		 */
@@ -643,6 +643,8 @@ int hwrng_register(struct hwrng *rng)
 	if (is_new_current)
 		put_rng(rng);
 	return 0;
+out_list_del:
+	list_del_init(&rng->list);
 out_unlock:
 	mutex_unlock(&rng_mutex);
 out:
-- 
2.53.0



