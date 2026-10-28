Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210082;
	b=T7RvHl/YdlWdZedwx7ONo2k+GQXTt9Z/X2hIFzFeP6V0aNJJ6b1Paccb3nkysVHRPBDU
	 ggTpVXqD8phsWcR2eZ8PIKKFNC1bgmJpzqbkQlb2LCJotfY79g5vwoHbBKu7dYU+crqXA
	 5CoHTUbuLPv6jn8xWWnXRurSV5eMAGkkiWVjZyeHEie7rzxdPoXxpcb77kMaFQp2r2aX5
	 JdXAiXv4LFPKVyo9Rg54BwRxnRFgT4BP9IeHyyWiUB2zVsUFCvr5uvFwmF4y76B6AhueH
	 fyUFNQ84Az9VH3qSkusaJT5zQLqYD4U1XJPEbVW/tCLsXBOdUxIXEFv64p5ny9RC4Og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210082;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=geFngZMVb7IM+J7ZROYFsQjmco4GYWCxhxjKSYm7E4k=;
	b=ihh+6X8FlHHHwmtzv1/LPlXnaI1TyTVJL+66AwxHMn17oLU6rmisryTmnBKGM164L6YA
	 R1IbYXPJVmeeTjtCKzT1OQwZJANni6/sLh0V/pXlUUnQIWE2A085ETBOmRbQojyvWKvDm
	 P+TkS6pvncqecURYRxiKNzfU2hWckZzSizzubovBceYfK7sIRcDnHODMe5hFfxzj7jfAF
	 REkivNGppOXpm8qPffpj81fkOK2KZKtG3iO3AoP6MWUC85OW2TK16WCKNkt8NWocqsMoQ
	 JcUMwQ9CC2OeaU39mv4sRSUqZYL/WyeHks/eVMCbsoAphouhNFiD/T3Ea+4HRgP/C/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K6q4hS5r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E084606A31E;
	Wed, 28 Oct 2026 17:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K6q4hS5r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC501F01825;
	Wed, 28 Oct 2026 17:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210082;
	bh=geFngZMVb7IM+J7ZROYFsQjmco4GYWCxhxjKSYm7E4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K6q4hS5rMPiD8CuWwoJDW3mi/1VAm6RwBPWwcw8bhWE/oMbMCz1mbTg6hAwB+FYwq
	 yzRffVGD1KBFs7Sj19CYUETSMdxxYba4HzDEKkFNagCusAOMfQ9uLPP30WNkS0yIQa
	 VOz8uk6IsuFi4GDAEGf9wVxwsD1nmQNJTOGQ9NgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>,
	Ben Cressey <ben@cressey.dev>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.6 070/168] dm-crypt: fix a tiny race condition in crypt_dec_pending
Date: Wed, 28 Oct 2026 18:00:06 +0100
Message-ID: <20261028165944.742907841@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1794,7 +1794,6 @@ static void crypt_dec_pending(struct dm_
 {
 	struct crypt_config *cc = io->cc;
 	struct bio *base_bio = io->base_bio;
-	blk_status_t error = io->error;
 
 	if (!atomic_dec_and_test(&io->io_pending))
 		return;
@@ -1816,7 +1815,7 @@ static void crypt_dec_pending(struct dm_
 	else
 		kfree(io->integrity_metadata);
 
-	base_bio->bi_status = error;
+	base_bio->bi_status = io->error;
 
 	bio_endio(base_bio);
 }


