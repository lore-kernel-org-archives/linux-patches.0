Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016724;
	b=awifIvqG9J0ewpUWowT7Shmw9N39tB2HnxttpdcHsy5dT90qKyA6SsZgAZ+VPM4xDJ9G
	 CFR9wikwNPISKr2AgOu5JBXOlX6zaS/8nkaBoX64lH/rz/SVgxAT/+54O2YpXWTXqgIMX
	 8jtu4m8kf/FjR84b/+fBJhLlPpz8Sz3qfJWjV0lVpYeFwSNNCjH74Is9iG0wAupG9HTus
	 j+ZbefjL3x8r2z7vPS7qNL49PBc30CHo8X44Ov3jHxKL9skOrsCcuha+9VS2hh9wdpNvF
	 qllyxD3Spp8TlJncBjV7s6v3I9uWe1fa1SjSFHmr+Ve9lODuQ+PDqbYjTgS24ZHaIeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016724;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5/G/1K4TGmgOOu0aaOjAoDV1kO+CmnB3cJpWyn/C8NU=;
	b=OY0R8p3378LhKeufAHLsQIbjrlRfvUb6XgLvFuPJiWMZIHg05xH4DEpgo8NhOzmEusYn
	 saDLacAvxhaEU3cYpUqSC4y9vCALco2u1XZ/XHlVyLLU2tj8KBkeNfXDAg5RsBNRDLZP+
	 emJE4qnuvNOyP6XIhBiDRx7S+IHrpL9M/qcAd0dySsGs6i5ufF3ATt7GE7O8L4IVNiK35
	 5hsqLcruWZen0q/I4F3frsQWSmFqWfzB6o3dCb6bfrmVRqnXetuzW3ziVfqlbl9AECLcn
	 MasvNDf1fU0yxqQ9A+aRyrqduX/JNyb4a4Ntxkt982NWogp+iq2RRX0jcnDPuhkO8kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s7xzoPEP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255DC60A2602;
	Wed, 18 Nov 2026 15:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s7xzoPEP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 665B61F000C4;
	Wed, 18 Nov 2026 15:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016723;
	bh=5/G/1K4TGmgOOu0aaOjAoDV1kO+CmnB3cJpWyn/C8NU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s7xzoPEPcbXwqbqT0+p6Luc7ZEQ3Qh+/FhjHDaOebDHPZwLxPGhtQAtQyClKtC8b4
	 wrrcs+cM6ufLwFziy+XYBZbLDDVz5wOOa/Iaov91UyOwDcnL7n753B2BovfSWpMFYj
	 +8BFOgLXU+/biGbstL/S6d9TqN3I2lH3AqjZilH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0630/2651] md: fix mddev_unlock() called without holding lock in lbs_store()
Date: Wed, 18 Nov 2026 15:31:10 +0100
Message-ID: <20261118150310.368043252@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Wang <jinpu.wang@cloud.ionos.com>

[ Upstream commit 68dab5c14aaff17686df22ba1f1eea3b3433797a ]

lbs_store() jumped to the unlock label on mddev_lock() failure,
calling mddev_unlock() on a mutex that was never acquired. Return
directly instead.

Fixes: 62ed1b582246 ("md: allow configuring logical block size")
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Link: https://patch.msgid.link/20260920103705.23191-1-jinpu.wang@ionos.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ef46a7ffeddd2..8c56c521a8f8a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6051,11 +6051,10 @@ lbs_store(struct mddev *mddev, const char *buf, size_t len)
 
 	err = mddev_lock(mddev);
 	if (err)
-		goto unlock;
+		return err;
 
 	err = mddev_set_logical_block_size(mddev, lbs);
 
-unlock:
 	mddev_unlock(mddev);
 	return err ?: len;
 }
-- 
2.53.0



