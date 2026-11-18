Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022332;
	b=Hpntz2qlcZhA0nwW5PP7K+DXcld9bDQXYbXSdKXJ0c1oVM5fld3WrXlLmcdn8rUhwWH3
	 8Qq/HkBMaUTVyaF+rPGsZW1CSsLyKqMP97nZzo9udP0kznTvw+LusaCq/TjOq9a5a+zWx
	 JCai9WogVkh1XOpQ0JavL+BIk+gu+xPccVe2hroWj0QEN2JoKUvCi1ss0MAenUzkfK6Q/
	 GdyCBtCvtcdxgRQFydLKzOCHzkk2L8NeeEK2FbBS4QQfxPBZ7zo2TY+jJAFQZRkvuoUok
	 kOy2agu/x9zygTKo+bPXlnVcm00BdnaI33JWzB9rZ0glbb0S9kcPGfIqqitnygCSrEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022332;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NoVB/M1O5xEip6EG2qu7lcbFz9KLMPjikUJIYtg9/7Q=;
	b=GsheHyKMRhO91NxRTsr0g2jmW5mZdponYE1eeaxr0BeZPfaOwkvbxHl+p46JbP8Fz3ow
	 p7sthwmX04JMYOmKN2wnkIlsBFaUKIViy65X5BPTWcBNoDXgyEKGQVC6toYriQW/ufKJj
	 12xSWO23tWAdNJU6MBp7BkxKQRWtlVswfxBXmQP5LOANwJAHNHWHG5XblQXv9XGWVIgWO
	 fdcVgpo2lJ5vcKFXTSJlt2nR1ag4gAPj98OZ481wAT4YqzFQ8whSXNDrx0tY9y7CPo22g
	 JPFbMVRcsWNgfrMY9SrnSkC1JMhEdO9UYepRRdmZKkJv3Aw/XzhNn/OWYMCVslNXFiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZHvjuquU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F33B606A31C;
	Wed, 18 Nov 2026 17:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZHvjuquU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7727A1F000C4;
	Wed, 18 Nov 2026 17:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022332;
	bh=NoVB/M1O5xEip6EG2qu7lcbFz9KLMPjikUJIYtg9/7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZHvjuquUpTmSkTP+gd3tq74L3CdltDnnQ7ZMrY3NTRLGCFG1Y96TvjB4J3qhrxGiV
	 pKofkP9SDPeNyVD0vOvpowv97JdoVKES9VtwGtZphh3SvkmLW5SHxCfzNmopPe0m19
	 1M+91cQwAGbwbD5omujVHeHM/CpbIROv4hOB2720=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2584/2651] blk-mq: dont forget a timer the driver has restarted
Date: Wed, 18 Nov 2026 16:03:44 +0100
Message-ID: <20261118150417.338719772@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 0db9f8968a8941d4fc9fddf220d4983d9b68deaf ]

If ->timeout() returns BLK_EH_RESET_TIMER, blk_add_timer() gives the
request a new deadline that blk_mq_timeout_work() doesn't know about
when it picks the next expiry. A 2s nbd read next to a 60s one expires
once and then not again for a minute. Let the new deadline take part.

Fixes: 320ae51feed5 ("blk-mq: new multi-queue block IO queueing mechanism")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261028164415.1262013-32-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 3440e6906f5a4..bff51cb759fce 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1710,8 +1710,11 @@ static bool blk_mq_handle_expired(struct request *rq, void *priv)
 {
 	struct blk_expired_data *expired = priv;
 
-	if (blk_mq_req_expired(rq, expired))
+	if (blk_mq_req_expired(rq, expired)) {
 		blk_mq_rq_timed_out(rq);
+		/* If its timer has been started again, count the new deadline */
+		blk_mq_req_expired(rq, expired);
+	}
 	return true;
 }
 
-- 
2.53.0



