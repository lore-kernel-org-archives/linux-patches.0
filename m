Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217338;
	b=nwfX0Lwt1fDkVQr1frulhhxSGl2qhup65bdvRrcGMEKWIl2Smz2hxA6qcM9iYaMK8DP/
	 VpfPnKoqTRXYYnmzfaI2Y0hUP5jv9XwibJAfU17dUH2xGE0SkTY+fpBH65qpHfvG8Kpfr
	 tAJ6aYYRCbJTh386K+srQZHRB/zjgjSSSlvxnUBhHMMPMcEfZNZDAJkq9M6rLtnAdTutG
	 oA7FTJ7o3oEqL5XpSRcn/a7klMGa/S9k+9yFcMr0C+jRmmrM8NHaqNlOGQNHz7sGcmPmO
	 6tU3JZvhuVhhXNqX1nabwR0fONtxiRrkPU16MAboTjoVtZ7YlcOJt6L38NAgWe75Osw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217338;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nBmMtqO/YRJbRu/22IBZ+9N0e7DnBLA36zKRsVNsbXQ=;
	b=o9tti4pAqzvbaNsSeiNUthjg+sEp/usmuKpEKFSf6Dcn4rMaKmUmoRs6M54L7JWkhElI
	 ZP9Y9Z/hQ1wILWvPfG0hfvsFzn6HaOeyfrwq0Ocldr0eQnRHFjjOV0ZxhymslPfWoOhcE
	 CaCfMX3Q6P24137sKr+GGcK4D7Rgcl6sXCMjntg+tIf4f1MoAvRiTnIPbZgYMmnh3Pdo7
	 gkk87mhYVY983A0JomEyR87MqZ8qaCnyi31C/DaxiXJ5EnGy1EzQEXlTTNcKOip4wf6KY
	 nUcXaYrOeljHFZlUeIiANrbSp/qjgObLdA8BlkJGYtANoIH/1R4Ck7G/X8LoO+NR14g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pk+6IMJv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACEC5606A31C;
	Wed, 28 Oct 2026 19:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pk+6IMJv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081991F01825;
	Wed, 28 Oct 2026 19:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217337;
	bh=nBmMtqO/YRJbRu/22IBZ+9N0e7DnBLA36zKRsVNsbXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pk+6IMJvkuA6Wd/ljER3J+sEci+3Pdxv/QLeq3GkBW75M0F0Ir0ITThZVh18VieAz
	 OSboKGu17lJTMrFKFfCE7HFxkB0xaAe7lBioQ9H++oBxUUHi7Xg+uahpSHIvWtzQjj
	 kbniVY8eqkUSMWXnV2Xvu6Joy1/CcJctmmt+wrI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1868/1887] ext4: fix error pointer dereference in ext4_mb_load_buddy_gfp()
Date: Wed, 28 Oct 2026 18:06:04 +0100
Message-ID: <20261028170541.963922066@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit c6a6c9694aadc4c3ab8d89bdd44aed3eab1e43c6 ]

This code calls folio_put() on an error pointer which will lead to a
crash.  Check for both error pointers and NULL pointers before calling
folio_put().

Fixes: 5eea586b47f0 ("ext4: convert bd_buddy_page to bd_buddy_folio")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/eaafa1d9-a61c-4af4-9f97-d3ad72c60200@moroto.mountain
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 2f7809db4432d..e77d56c533c0b 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1625,7 +1625,7 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
 	return 0;
 
 err:
-	if (folio)
+	if (!IS_ERR_OR_NULL(folio))
 		folio_put(folio);
 	if (e4b->bd_bitmap_folio)
 		folio_put(e4b->bd_bitmap_folio);
-- 
2.53.0



