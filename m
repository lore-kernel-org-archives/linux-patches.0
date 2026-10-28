Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217006;
	b=f4g1geUyAAc1I4sZsU0kADPhVnl/hlJ8TzMRRzxKIKhgg/iIs3Z+XUiyEQ5yDdCKLxU7
	 4MLk6Brthoibl4VTStyFXoK/AcKfJH3qB68BW1Ck7jwDu0/WFK9jLFx5iOG6MR6isMD4N
	 cuFsr/wB3azD9GfyNseXI9A5J+0dFe7J7BUvQVhSFkUOMjRbF8dNeDs7WNFExCIjnx5wO
	 28VEBLCWOgUThLKGikoHnccvvkYgm/Az6c2jki7Q7zfyyko4PtMkdpg6kNZRyfQZknZiD
	 wb5n50ronyQsDIaIQ8P07EjFLPPU9IRfZ5vWkeoOzPtwWlN0bWaIbNYxVmqiIrpvukA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217006;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A0ETxy+AkpgVWzfQkKQfPwWzlN++WZgGlmiyZoYLPJY=;
	b=NwTRDcqmQfDXBOlQFPfW1TNB0huV3+Q80j+sw91hYA5iXN3B6sc9Bm/XsAEUDS4aSUoV
	 TCbAxLqW7SLgzO7JskCNKVVNNwrSu5QjWs7J9BE1px2HEZ8VMirC8WaldQXYq6xgZkfhr
	 CSWfpA+JRvauxppkhidLQt71Iy9uwQTrVgOH37bCz/h6drszxm3lix8gmqZ/ubzJzLBoE
	 VHpILYtOJ1lWPvLE8QmDA0j7ZvIAQ1xkKnVmrRN8J9hU4x74EvYhDzW2aaby5pedOsBuJ
	 ru1yKMcF4X1P8Hn4bpmMPlr7kRkdSTbjceLQeSsvA1y4vrDUauHICMQuuu2z/t6nz8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PFORJ4FB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B3B606A33B;
	Wed, 28 Oct 2026 19:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PFORJ4FB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C321F031E0;
	Wed, 28 Oct 2026 19:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217005;
	bh=A0ETxy+AkpgVWzfQkKQfPwWzlN++WZgGlmiyZoYLPJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PFORJ4FBMnL0M7765rUrh2MrsxZ6XsfvgT2kD5tt9qg4LJuWGp5UrnOZoVyYJWBD/
	 nHRO2HIhMHonZE62vwdL9FNT7PhZxZg6i6sTB8+C6KzKDOPIJ+mgcqWr3JwWzUWe/B
	 Uw313sugdKZ/C9q/sEEc3HHC8AVJD/ymlD6W58bQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>,
	Ben Cressey <ben@cressey.dev>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 1756/1887] dm-crypt: fix a tiny race condition in crypt_dec_pending
Date: Wed, 28 Oct 2026 18:04:12 +0100
Message-ID: <20261028170539.419115328@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1758,7 +1758,6 @@ static void crypt_dec_pending(struct dm_
 {
 	struct crypt_config *cc = io->cc;
 	struct bio *base_bio = io->base_bio;
-	blk_status_t error = io->error;
 
 	if (!atomic_dec_and_test(&io->io_pending))
 		return;
@@ -1780,7 +1779,7 @@ static void crypt_dec_pending(struct dm_
 	else
 		kfree(io->integrity_metadata);
 
-	base_bio->bi_status = error;
+	base_bio->bi_status = io->error;
 
 	bio_endio(base_bio);
 }


