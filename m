Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207679;
	b=G9QMZ+nW4rqxeWMQS0rN+c0ASRL20d+Wp7aMdeMqsZ2QsqGD4LvH9E5zUi9sCAfiHwxT
	 8cb9ju0yaj2PsIqZF39aSPjJChiI1MTJC3U0qy2TmpgZZ39mtdHUhayiMyxQSFlZsKQoy
	 edES4JoR/n+xocuIXhVeQt3lgT5NpuPMGWdG+IuV5aI4DtS2lt94qHWS2tY40jR6iPVXc
	 g3NVuoQfH44djqqrQYuo6AICjv4KrpVsL9A5CLGASzbovbYI1VgEXDu6tPmm9S6IHwcFd
	 BeiakLeivJFVGT7w+zPwIRPKV/5UfEVFxZFWLA7HCpbYRVkKrb5EPFyoetpfcaAdOPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207679;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TsC5KhooFVHQ9FJoXOZM+BlJxuiy+9aGbwXrA5ucU6c=;
	b=g7VgW50gRaykwdAFFAvmtgo1sAPhoFyIYlddvEvGWChu3X3XCvhQPQGrsg6UPs+DZn5Y
	 7RkbK5ob+/Eey7PmZOw6SjChnBOd+8BrtkIFoW51hsuTdANpOvM/CcUlfCq3ifuQ94EL3
	 R+HtFMqxiF6IrcCOPrS9Orn+nC9HecpH2mkjNLRSXgqBV/anvIH0al1MlosdN4vFf/OBU
	 4WvAkqxKXIHfFayk45CKHvuTfooygOCI25rJSSrcX1I6Rc6ekAs1epeCz7AaJktt+NOcA
	 Emg/XFimJ+44BajuWA/tJScSytVK5U61S8XuOWLqZXMy8otdWX3YyvrZFwi8m3FpmLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sH+4xe5f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E7D606A31C;
	Wed, 28 Oct 2026 17:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sH+4xe5f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50AF51F01825;
	Wed, 28 Oct 2026 17:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207678;
	bh=TsC5KhooFVHQ9FJoXOZM+BlJxuiy+9aGbwXrA5ucU6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sH+4xe5fo833Y9KKskig56IzQ+Z2AeQMQ/ggQDYAYeI6d+9c/0rdMzUNQTsqZHLoH
	 NCpr/oUjSWa0hSILL+Tt9tBaM0kxV9shGl4zw7h5llmrWr0T0ghJ28QC3TaWehUsOJ
	 SIPv98n4EvefkVuTlsShMMoOrR6bDxYek5BqqL64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>,
	Ben Cressey <ben@cressey.dev>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 101/247] dm-crypt: fix a tiny race condition in crypt_dec_pending
Date: Wed, 28 Oct 2026 17:58:24 +0100
Message-ID: <20261028165949.787417188@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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
@@ -1837,7 +1837,6 @@ static void crypt_dec_pending(struct dm_
 {
 	struct crypt_config *cc = io->cc;
 	struct bio *base_bio = io->base_bio;
-	blk_status_t error = io->error;
 
 	if (!atomic_dec_and_test(&io->io_pending))
 		return;
@@ -1859,7 +1858,7 @@ static void crypt_dec_pending(struct dm_
 	else
 		kfree(io->integrity_metadata);
 
-	base_bio->bi_status = error;
+	base_bio->bi_status = io->error;
 
 	bio_endio(base_bio);
 }


