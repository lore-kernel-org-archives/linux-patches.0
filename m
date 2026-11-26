Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705570;
	b=krgPk2R0AH2UEaWG5hLq+3ZiCZ8yKBCSaizHElVW7Fk0STcDTdU92qGVNHnkTyh//qNQ
	 qMthozF8BPnZTDkIdMjG+NrwVw3XhCDPMAVOh2x3K0D5WWW+5GRnrDrhsHZPBIUa3rwyV
	 /3Jn6GtJKiNPluKBr2v5WwY6Xa7qd8EsR5r9mmLIBQKOe9+0pG0D1E+JnL8He0OEdmyy5
	 mP97sjV4UN8vAjNG++nKXlgieyuzvJ3wEavIny2+3sQVCaLz8RvFuKYDC0LKnRrhU9+3n
	 hx4CM8ZbYn801p6yHXhtFHwwUDIB0YSsrg/eW+iHt0owyUc6ZV9fwzodV9jdXyjhPXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705570;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hu+tjbuv0QGO8EHb6eoLn5puKE63QgXJr7Fk9FiP2VU=;
	b=G5c46C+hd4SxFyVuAPpjoGnq38OKp5sGZB/nE2TtDmXU0/AKacD2VLq7UqF76N3TlOa2
	 0ri4zFq57RmYl4hGmhi1MFal3gk0O0mdch8878xAUp2RsiBglI2lktHAyGfXRDm2r7qTz
	 h7tUlA1iQPbH96yd/9b6urQJ7SoPBSXHZrCDJ1U4XVojnixqh+Csmw2H/rNOgK9uNxhAu
	 zBl55NjMKeIQprGiz7ePH19vqNVw2zCc1Giks4ukj8VbJR9LsWIE8y2KD6d4R7jzgzUNF
	 3MxeA++Cu7hWLZQXk6ygC2103zuEbgHoYY2FjKuH+A/WJ7uclTx+9AghXIw4z/vVo3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q1m+sC3n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7082D606A326;
	Thu, 26 Nov 2026 15:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q1m+sC3n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65DA61F000C4;
	Thu, 26 Nov 2026 15:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705569;
	bh=Hu+tjbuv0QGO8EHb6eoLn5puKE63QgXJr7Fk9FiP2VU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q1m+sC3nKE+8OWWWaRuuvYPouXug8o45fUpX/P2fPVHGyfVXVuaTSSpCFD0dSbWrk
	 6/WfipVk8SK2HC21ygSmDboroB9NEM04c48OFtf9U+rc4IaEXoje6sCwxkwbd/W7Wl
	 t/SaXwkSm1HLklD6NfSWS/6QycC3KvC00pWeS3vE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4b232570d625662eaab4@syzkaller.appspotmail.com,
	Zhao Feng <zhaofeng2@cmss.chinamobile.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 242/319] dm crypt: fix use of uninitialized percpu_counter in ctr error path
Date: Thu, 26 Nov 2026 15:40:10 +0100
Message-ID: <20261126144012.207487059@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Zhao Feng <zhaofeng2@cmss.chinamobile.com>

commit 8ba1ade3e6b595b9091040feaa3341d7e45ba95d upstream.

If percpu_counter_init() fails in crypt_ctr() (e.g. when the
underlying percpu allocation fails under memory pressure or fault
injection), the error path jumps to "bad", which calls
crypt_dtr().  crypt_dtr() then evaluates
WARN_ON(percpu_counter_sum(&cc->n_allocated_pages) != 0) and calls
percpu_counter_destroy() on a counter that was never initialized,
because __percpu_counter_init_many() returns -ENOMEM before
calling raw_spin_lock_init() on fbc->lock.

With lockdep enabled this triggers "INFO: trying to register
non-static key" in __percpu_counter_sum(), as reported by syzbot.
The console additionally shows "crypt: Unknown error (-ENOMEM)"
because this failure path sets no ti->error.

Move percpu_counter_init() to right after the allocation of cc,
before ti->private is set and before any "goto bad" can happen.
On failure, set ti->error and free cc directly, so that
crypt_dtr() is only ever called with an initialized counter.

Reported-by: syzbot+4b232570d625662eaab4@syzkaller.appspotmail.com
Closes: https://syzbot.org/bug?extid=4b232570d625662eaab4
Fixes: 5059353df86e ("dm crypt: limit the number of allocated pages")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Feng <zhaofeng2@cmss.chinamobile.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-crypt.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -3157,6 +3157,14 @@ static int crypt_ctr(struct dm_target *t
 		ti->error = "Cannot allocate encryption context";
 		return -ENOMEM;
 	}
+
+	ret = percpu_counter_init(&cc->n_allocated_pages, 0, GFP_KERNEL);
+	if (ret < 0) {
+		ti->error = "Cannot initialize page counter";
+		kfree_sensitive(cc);
+		return ret;
+	}
+
 	cc->key_size = key_size;
 	cc->sector_size = (1 << SECTOR_SHIFT);
 	cc->sector_shift = 0;
@@ -3168,10 +3176,6 @@ static int crypt_ctr(struct dm_target *t
 	crypt_calculate_pages_per_client();
 	spin_unlock(&dm_crypt_clients_lock);
 
-	ret = percpu_counter_init(&cc->n_allocated_pages, 0, GFP_KERNEL);
-	if (ret < 0)
-		goto bad;
-
 	/* Optional parameters need to be read before cipher constructor */
 	if (argc > 5) {
 		ret = crypt_ctr_optional(ti, argc - 5, &argv[5]);


