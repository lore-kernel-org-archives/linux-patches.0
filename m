Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211841;
	b=NJ5uqO4Pn77mcekb8iKvt5vGAhG+cw1HH3zhELt0b2yPGFOESzbCBibgjSVn7WDVYmDa
	 aoS6+liDSLGnXKBiVtnq514HdLSVnJTQ6czWvEf3sePz+ApeGkd3U3JL2/Vl8sl5+hcJF
	 wXsGVoRXdZPIx/2qm3qb2cXfAJ4L/KLSVJBnYXZ4oT9ZVnNhGI+du4nzIv03rnXVayyO8
	 wcgfqicP20IXlHbbwMI5lbqdvtvTP748iiEJdKlW/QsdUCoAiKjxcx65mgZSrvUl8ui9h
	 u7x6iPyptEr2yh3OuHB4PRkwu7lW0PTx+fvP9fRRT5QvPhSp43qIWBNqST12VOA/gDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211841;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t9pNGdW6TjfHMTFVMNNSGeHkcxDYQ79vXnt9mex71Ik=;
	b=gL3XIa7YtK+Z6sc8BmmrBDogSQ8DEYbqlRAgvjQcr7yJjturT4MwkiZR2OouzUiKqo38
	 O80Fhd2DZoRi/C2rUTq91CZeyfgq5Wza+QdDWCRPaAIA0qVAf6VwG5QhCQJYo6Bd5Amxe
	 PEiPP2AHdXQfIEw6baczTuh6Q9htAmYgty/xobi4ixVJaY4f6lgCJxOcFKXjgrD7SlPB1
	 x6bw6ZZVd1LXDkg5KaVbSaVcWrx32dqrKPejuiPVRuXPb4ngTDarxHOrxRM5W8RNs4G2X
	 fjxCyf4TLJWC2jlqy2ZftQ3g/zU2gWSrAUWvAIaULXjvWd+VvMztNP1O0vFtnv+aR6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YVc3UuLT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B253606A329;
	Wed, 28 Oct 2026 18:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YVc3UuLT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 975861F01828;
	Wed, 28 Oct 2026 18:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211841;
	bh=t9pNGdW6TjfHMTFVMNNSGeHkcxDYQ79vXnt9mex71Ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YVc3UuLTBMrEII0uGicV/SmADI7INtElRdX8Aybe4/8dXuofnpjAB8NVGdOvn9MOR
	 pOQqokMgUSNYHJIn+EqVEBvPaatK8+mnf/2RawxVaZqsbh/io3xDeMDhyO8IhtaNuK
	 sE+GiiLOTsjgQKvPaXZSH5muY+sNqXfX06wQw4uE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>,
	Ben Cressey <ben@cressey.dev>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 512/571] dm-crypt: fix a tiny race condition in crypt_dec_pending
Date: Wed, 28 Oct 2026 18:00:59 +0100
Message-ID: <20261028170020.178951174@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1740,7 +1740,6 @@ static void crypt_dec_pending(struct dm_
 {
 	struct crypt_config *cc = io->cc;
 	struct bio *base_bio = io->base_bio;
-	blk_status_t error = io->error;
 
 	if (!atomic_dec_and_test(&io->io_pending))
 		return;
@@ -1753,7 +1752,7 @@ static void crypt_dec_pending(struct dm_
 	else
 		kfree(io->integrity_metadata);
 
-	base_bio->bi_status = error;
+	base_bio->bi_status = io->error;
 
 	bio_endio(base_bio);
 }


