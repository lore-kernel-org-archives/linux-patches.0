Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061356;
	b=U7WAu0adiH0E2b0fm6GS+0ZUUz+VXxgIQcs54u5GsKwsYwKveLvd/7rge8PXYHSVXM1A
	 Z7y9FLmYGxzje8oa+xW3vqkKfyToMomoE+o1gpAHGj7EjT02Jb1VdwBPScYBIm/oLYPum
	 FGJ4g+VlwwUaxK5chZB/6FcKM02a8dapk+A3aqYl4sFrP3Irq0EHQ4mc96JCHtllcNgoF
	 SvQi1ZOfra3sQsxPQAxVZG8VxouoK/9jTDK+jkAAaOX9l/lXwmP0eiIAOELHVH4/zi9Pn
	 qrYJE3xEM5KgS6a7pb3U1TPYxDdT+qUyIaaPXwVZtrjsAq6jm2JOiKBzlKtkQaB09hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061356;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5W3azvDLnHzuOoyS7gfkPSurxlIFsaLwbTwuLXcZ0v8=;
	b=EVTHDwalR8Z2NYGy4IPngM41FkU5Q5GgJxk8E4pC9Ux07Bs7VT1EYBpTiEqEFLV9rfba
	 zXSTdbmi/W4KCpzYsA7U/zKm0tXo22A6JkXOpziWgjPocRnHcoWbVBBdZTjaDT30on9hN
	 6K1FvqXAOS36nNYpK+0a4fAU+EaZHA75uuPj1al8yc7reA6prKGMSlXIYN/xeFn/OJuQ6
	 2ecadNIfzizbUS7c4EzULKAF0qiD9V2b603EDas9nYhy1anXwZfqYyRS8dr6XuK7hWdD3
	 05Z2tXTE0r9Y2YJbQNyUuutdvoBr4t2XNnP5qg0UVANH1YGdUg6v83Ey8bKJ9+nQQzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rWMjssFl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12B4606A326;
	Sat,  7 Nov 2026 14:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rWMjssFl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5531F0089F;
	Sat,  7 Nov 2026 14:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061355;
	bh=5W3azvDLnHzuOoyS7gfkPSurxlIFsaLwbTwuLXcZ0v8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rWMjssFlITNHiaARUaugqqQOeRKllBODVF1JtcQJ0WUsakRNP8qS3ZKA+EN19mK4C
	 Rwz6bx1tc02+I9lWv7EIzgfdz1nVj9Lu/4npQ541Ql/rdQmXmasyvuHG9Mezq55+XM
	 IgkRY8vzrKYTjZe+/h1HJso3VpGrxXkGOIjQIuUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0482/1536] nfsd: use test_and_clear_bit for somebody_reclaimed to prevent lost update
Date: Sat,  7 Nov 2026 08:41:38 -0500
Message-ID: <20261107135011.028079873@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 0a5a548861ab09e79a6b3062ac17e410323af3cd ]

clients_still_reclaiming() uses separate test_bit() and clear_bit()
calls on NFSD_NET_SOMEBODY_RECLAIMED. A concurrent set_bit() from
the OPEN or LOCK reclaim path arriving between the test and clear
is silently lost, causing the next laundromat tick to end grace
prematurely.

Replace with test_and_clear_bit() to make the read-and-clear atomic.

Fixes: 8c67a210c90c ("nfsd: convert nfsd_net boolean flags to unsigned long flags word")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260611-nfsd-testing-v2-13-5b90e276f2d9@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index c9a55105fa8e7..ecde340ae4945 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6552,9 +6552,8 @@ static bool clients_still_reclaiming(struct nfsd_net *nn)
 		if (atomic_read(&nn->nr_reclaim_complete) == size)
 			return false;
 	}
-	if (!test_bit(NFSD_NET_SOMEBODY_RECLAIMED, &nn->flags))
+	if (!test_and_clear_bit(NFSD_NET_SOMEBODY_RECLAIMED, &nn->flags))
 		return false;
-	clear_bit(NFSD_NET_SOMEBODY_RECLAIMED, &nn->flags);
 	/*
 	 * If we've given them *two* lease times to reclaim, and they're
 	 * still not done, give up:
-- 
2.53.0



