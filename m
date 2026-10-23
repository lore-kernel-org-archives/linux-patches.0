Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774862;
	b=BecDTVuGArgDgRU8MxJWKTs1dgG3hdH5oMe2Gy/DxU9+0TjAMOnJ4gCFESRoF3fduRC1
	 E/8CvaIvlLgsd1aUohLxn0iZOwfE9D1xhdLnrmPsFvBSx1zLMGkqXHkdomGxiUs3fTyaO
	 3m/NxLjspt020PMU08v4bG2Tpxm5rtnVx65SePByrenuX7A3GY2Ex/yH4NqHj9O3eYPg4
	 T84+N+XnNQIAgpj5MSPldwxn51hitGFbA4wHI+jTIaPXeM9gvus0pQct68wO9vizipw0e
	 g0MJFl2SOezQqlDXORxpI2dWM3y2V5weryosVD6yAXe4CmXky94GlOYFc7C8SVzxtwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774862;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hkHOLTjzxEgnuIGSx7CTq2tn5huXdX6HZDy3c7PA0Ls=;
	b=N7ntr+KPwUn2gmgB5RxAeEKVJRKU6tNbtZPppKajgeGIt/ljVhMbOKmkVXXjizmbuxPb
	 vyh2vX4tIskDkhAuX7ShU70XuDuV38P1rs8d3/tRKQOvjIGMPcTpb2NzwowevJMTdUzvI
	 6YMA0p8XQQX3Vb997OsGzGgnxWMViK1TsNEW9/tiar568co1U/Wbbuva1pXAOwzPG6slg
	 BA3S8VxelOBuz/g9APeXzoWpk0SwoN9QbnplpdBd2R6i3Xe4fsO6NmMBgAu6kIsEx5CQS
	 YPZpOobBNd+yyXZkk50ZQ0/mQJ2oicFTL5ltvgDheElwGb9tuZqlQ4M+naVBPf5XShA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="yy/DEyj8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCD1606A31B;
	Fri, 23 Oct 2026 17:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yy/DEyj8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEAB91F01825;
	Fri, 23 Oct 2026 17:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774861;
	bh=hkHOLTjzxEgnuIGSx7CTq2tn5huXdX6HZDy3c7PA0Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yy/DEyj8kYt8F0SaZ4+dS8SlBlmEK9XdAP54vRc/zD/qUAOZl0noX8PoE1MQXWfQT
	 Pb5z6MGgbMXp6pvtumlZxcx46SpGScM0G3Xu426Bw5gR3hhZSEz0xUy30ilGd+BKkw
	 PK85PHJykEBVePv+XF8Tn/YhHDzD0ohXqbuTuzHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>,
	Ben Cressey <ben@cressey.dev>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.2 184/242] dm-crypt: fix a tiny race condition in crypt_dec_pending
Date: Fri, 23 Oct 2026 18:40:26 +0200
Message-ID: <20261023163718.138493518@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Cressey <ben@cressey.dev>

commit 148845aa1921d95ef5dc851c76e6a284f6657df6 upstream.

crypt_dec_pending reads io->error before calling atomic_dec_and_test.
Another context, for example crypt_endio called from an interrupt, may
set io->error and drop its reference between the read and the
decrement. crypt_dec_pending then drops the last reference and completes
the bio with the stale status - so a read that failed and was never
decrypted, or a write that failed, is reported as successful.

The read was placed before the decrement by commit b35f8caa0890 ("dm
crypt: wait for endio to complete before destruction"), because that
commit freed dm_crypt_io before calling bio_endio. This is no longer the
case, dm_crypt_io lives in the per-bio data now.

Read io->error after atomic_dec_and_test instead. atomic_dec_and_test is
fully ordered, so no additional barrier is needed.

Fixes: b35f8caa0890 ("dm crypt: wait for endio to complete before destruction")
Cc: stable@vger.kernel.org
Reviewed-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
Signed-off-by: Ben Cressey <ben@cressey.dev>
Assisted-by: Claude:unspecified
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-crypt.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1745,7 +1745,6 @@ static void crypt_dec_pending(struct dm_
 {
 	struct crypt_config *cc = io->cc;
 	struct bio *base_bio = io->base_bio;
-	blk_status_t error = io->error;
 
 	if (!atomic_dec_and_test(&io->io_pending))
 		return;
@@ -1767,7 +1766,7 @@ static void crypt_dec_pending(struct dm_
 	else
 		kfree(io->integrity_metadata);
 
-	base_bio->bi_status = error;
+	base_bio->bi_status = io->error;
 
 	bio_endio(base_bio);
 }


