Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774110;
	b=c3kDrbIUiWY6DaY6H7J3Ajxfq0mqZl6I/j+OLya7UnBc8MSpRBjIA8ktwW48+xUudml6
	 6yGYuSlEhTHqC6nCy29d4GiJIH7L5lAzwdfXecP8h5dydsXslrgjQ/Uy60zo4VrrQGnNF
	 ekJZa0ttJMbZXS+OdU2bTj7cQjSDLNB4ZUnR+NIBniUGL2N5tcDuckCU4Z2d07Og5lPvB
	 fJVISJ99L1O8nT/5JwCqDW3CmUjE0vnl2rltK+/AEL1aN6HaXBh5LyYJUa83mHnOrDumi
	 9TKLydwxKkQ+gJw9lkLu4XSdmeKQJ5oMZ5lpTE/P5sPJJoNUXSReQCgRgYxmRNOAWyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774110;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E3BttM9PEG/sZJP5fCWssHZIGwwxYHaJmOQqOCWdxPU=;
	b=S4bm0ECrACpGgeDAf3xToD8shigm99ZezTFE4tSU/dM2cchssLT/Cgy4L6RjsgLLtjRH
	 8z7dXDx8VLv1O46fXOXKFbLSTt6HmJfzNiAwSJCYfemni/Mr3CcZ6S5WSl/dApFNvHB+D
	 ttF0cyI9IbkSLnoIxub+OrcR4exylohNzX8dimusTJKbDrH/mBEBJYNgy5xa0Qq+pkwDA
	 oFZzPapoL/UFJdNTp9MCbTPRzh6OzzOiske2p1yi8AadAOrSXiLJS2mrxayQnparSsjOA
	 cUJ1ujA26RIOMJh1FRFntOb5Hpeg/zlA0kB3kbTFhl0FWJ2ZxMwhUpV08ISZpDFdeJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="v/6zNPPg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C99606A31A;
	Fri, 23 Oct 2026 16:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v/6zNPPg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229931F01825;
	Fri, 23 Oct 2026 16:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774109;
	bh=E3BttM9PEG/sZJP5fCWssHZIGwwxYHaJmOQqOCWdxPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v/6zNPPgVqA4g4qLiT5mrs4oQhz7z20ziqM0KR4Y1ElTmEFmzyDO0KGWxt2ZckwFY
	 cbLLHGLL98jmwGYgrQIXkTwJKdDsYHtzJ7g1KgqlbVlZEEHnWRpWH23oZZK8BI99ct
	 mISBLJqYvdFCFn0IMiZSH1+ngphQhlxS7OeQnHZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>,
	Ben Cressey <ben@cressey.dev>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 123/193] dm-crypt: fix a tiny race condition in crypt_dec_pending
Date: Fri, 23 Oct 2026 18:36:40 +0200
Message-ID: <20261023163717.113451139@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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
@@ -1820,7 +1820,6 @@ static void crypt_dec_pending(struct dm_
 {
 	struct crypt_config *cc = io->cc;
 	struct bio *base_bio = io->base_bio;
-	blk_status_t error = io->error;
 
 	if (!atomic_dec_and_test(&io->io_pending))
 		return;
@@ -1842,7 +1841,7 @@ static void crypt_dec_pending(struct dm_
 	else
 		kfree(io->integrity_metadata);
 
-	base_bio->bi_status = error;
+	base_bio->bi_status = io->error;
 
 	bio_endio(base_bio);
 }


