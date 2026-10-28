Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209475;
	b=wzvHKf+fJgnFW1qFCt1R/slh3LRytXLauuV2UpB9Ja5UknEsgv4RQX6VLVNcIzvQ8zFC
	 t9wiRfrw+QoOGBrJkLwLAlk2TUCfYuvy5QUmJHEVbBkmLeI8nDrccvAA9WYS4ifNTolkv
	 r0Yqn7TlolSksfX6jh5WoQt3UjZeUAYvvqQHjCgv5rEUG6cAtNhCvZT9siak5M4teF2aa
	 JJ4PykzxZvZC1s2syvUztfi7uDyJfDPqWfek3HXvN2KBsWMmmfrs6JjpzFk9q64/6P8Kq
	 gqx63MxORZFNvNnOSehRUelGOSsWm3cMO4hX8+n17ZtO1ecvFieTD/dWHTtKCYcFu9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209475;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wE4prY3kpwys9K7mS5BdKW47Hp9XaTaUjtComn7Z9F0=;
	b=TuT7Dt+xA2g8uVED/T66Pe1XL3XMWPpPH1DfivOID+i/779oGE6NCq+3Jt+1XuYQ1E1H
	 hsAHsmaniTiq08v8vViXyzTLSa6phwKZWLMw4vXUiCjjCDTuCxRtbZUuFUJbywMhCukVX
	 Emj1TJMyyqcdXh9RwyVhlbby7/F5yi+CvrOl3oTijlIXZo1RkF9gi8Par5VHP8/9BQJkq
	 Gi6OxhJPicMvJcm6kYDX41lTMZwFt7+t6e8WOZy6qHweWBRYWBEAghczCcO08NHeIB92t
	 4UywMpDPkqpT727FJvzs4OQm9MVT8zdK7udbVaqoDd0jqup+CqkC4lml3KsdJvzfp0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sqB4NQrG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160BD606A31A;
	Wed, 28 Oct 2026 17:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sqB4NQrG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699D51F01825;
	Wed, 28 Oct 2026 17:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209474;
	bh=wE4prY3kpwys9K7mS5BdKW47Hp9XaTaUjtComn7Z9F0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sqB4NQrG14wqycAT8n0DFnULy5YT5mXI49cW8ErAdTxPuRABkx4TDp56Gkjxt6a5K
	 KcqCbAnQtskHIrGg4LtIpMrkFZ8D3JzqJ6OFOkMxoi46oWibDZsC4DwD9jihyKvpPe
	 6cFRSTKHRATuIyyXZczTzzYZ005w+rTwsbbleSvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>,
	Ben Cressey <ben@cressey.dev>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 467/516] dm-crypt: fix a tiny race condition in crypt_dec_pending
Date: Wed, 28 Oct 2026 18:00:19 +0100
Message-ID: <20261028170014.544351171@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1748,7 +1748,6 @@ static void crypt_dec_pending(struct dm_
 {
 	struct crypt_config *cc = io->cc;
 	struct bio *base_bio = io->base_bio;
-	blk_status_t error = io->error;
 
 	if (!atomic_dec_and_test(&io->io_pending))
 		return;
@@ -1761,7 +1760,7 @@ static void crypt_dec_pending(struct dm_
 	else
 		kfree(io->integrity_metadata);
 
-	base_bio->bi_status = error;
+	base_bio->bi_status = io->error;
 
 	/*
 	 * If we are running this function from our tasklet,


