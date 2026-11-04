Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831254;
	b=ZJRSv7OWq91rftRQluCuCDwNh5njkuCYCROmH4bQKEuq9NuOksBKV+Ev3txcPIJ6qcHS
	 7sJiksW93DUlN6h5ZPZBeDjRTxzKohoaoj3ekYsIUL69iCHdjZPJkXo+uhzgcv2E1IhP7
	 W93/c41CJx7m4OXOr5CSN/v2Dfaeqn4c7QvVeeXOWIKgUWe+3pEt1+KYMB9KWJp/n8Hcy
	 1qaDdu7x8YZK1DxJCeKy8MDmdP1VGvEEpXM9//7DR/+CP7FvRsTvVR6g+3ma8+BDJom4L
	 JxwGvPlWqVHkbeD7hyU9A49sKwugYJDUimtWvY75YLbtfSjAlw5b0Zh6UZd3Igt9pFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831254;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C4iN2i7whsB2R52uuhoXaN+c1J/Zwt70UjYeZqAzFwY=;
	b=OFG3BZOykfn2YhTE5c+NJIBtlnuZU4Hg0M+LOkT8qLoIEyoDgSm7Bo7sqLAHo7n0z67M
	 8QAwxgViyFCwFfbrz/Hh7A4OqcOwXMi4imEED4VHJeXUftc+dpFYNZhQb1zWXjAtPk8KD
	 bUcpeAqQ9nvkjOgNkowWnzUWwzk4oKHgOnpkMXtHMMdqDJpyD6YrXICDY04eFo0giYj24
	 0pLYV1DHMFjlNoXFC+6V5If01Ug4AdVuKP0t6CG6Hs9iimSeD9nABomKm2GepJPoUHHrp
	 kcW8lxlmTKjY1G5RMLNjgEBjAuDOkKL9liih+5KeZeLH+gvsf94Gw2vRZMf74YQ6Glw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WdyFSAhd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0E2606A33E;
	Wed,  4 Nov 2026 22:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WdyFSAhd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B76081F0093A;
	Wed,  4 Nov 2026 22:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831254;
	bh=C4iN2i7whsB2R52uuhoXaN+c1J/Zwt70UjYeZqAzFwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WdyFSAhdM6nnyDu80F1lnRrbYjqBh1sLeq5BwECZQsKPpcWYItql3LMgw3EJaYgOZ
	 8VQCayEkUNHos+JZgveUkYJVT6DMGcFybeaKCzNQzN82avKq9IkafYvETh7pGbB7my
	 6NgzKD/vl7J6oeNTKzANqlP8kuC4OtwswKvsYRfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0554/1005] nfsd: use test_and_clear_bit for somebody_reclaimed to prevent lost update
Date: Wed,  4 Nov 2026 16:04:47 -0500
Message-ID: <20261104211059.412643986@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index f5671861ef7e7..e56f072d2e5de 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6856,9 +6856,8 @@ static bool clients_still_reclaiming(struct nfsd_net *nn)
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



