Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704656;
	b=AWMu/C8DmDH3CeXR1KpnE0bCnVQrW7MClVN/86o2CChMuhJkNT6UYbotmhXI0Wnw131n
	 NvcNPiUIZL5G2F978/i2t5ij8DNgF+EH9lZ6nHCYGuesvJQzztu+H+9kWoYoC36XdHnQI
	 gXDCit2mgShextiYsmDl2A5gSmnVSNdQon0E6WMJVZC1+bUA9Sj40gcDqX9ZoeChZC7QV
	 fDlf/XUvf4yt+908oHaKoR2sYpL6FNc/bqD9H5Ad40r8ySLadxQAnXj9tL1YYhx1dfDrY
	 dLu1BQVl+USST+45bzVRcqXGc/zLI7uikl7VMX5Q6y8QsQK9N3Z5102T3XdqA9rQyYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704656;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PL1TI+FJnslSG5fSsYkbtuijbarSvh1huw0Yfl+Omk4=;
	b=fjF1UtnKodWMlZfItUCf3K49AmioDTe+uEv+kZKKbMTQPpS9Y9htUBRB3y0XEH4yauG0
	 MvCQpYBagd0feoX2nVb8UYSdLHE8JsRevwv6gFXAPqFgjmK6AUJbtvl+7u2rFNKLsMTWz
	 8WL3uUNfzs4sAYbahWM+zS/Hxc01uypZM7tbRoYu4VhOXaRqHaJ8ARUqT552AqNJFrfw+
	 uYjBznJw6WmFgRsrxzBY7li7iGK4Bc8YUm7Fy63ajSZMnOV2eNnViAd4DU4eOGviXm9Gm
	 JXLv0nxiXuZEtf3f5U1aau6xF2uQKvRFqhajGGBJ1IzDhJeFerBplN6RFDPPmDBhyog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gimZf1dN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C31A606A323;
	Thu, 26 Nov 2026 14:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gimZf1dN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076B61F000C0;
	Thu, 26 Nov 2026 14:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704655;
	bh=PL1TI+FJnslSG5fSsYkbtuijbarSvh1huw0Yfl+Omk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gimZf1dNWME1MDlZJKlWnSzHEYEQQUAyBQEm1UayP5iTVd50Gt85E6yGLo3/CE2av
	 he0Eskq+KRNJEywx/y/HJrAqvc2g6JWP1j95A1zGpsMSGvDMY1iAN4c/MiNo5i5/Vc
	 jaMGeQk3sGwheb+i76OJ1qIkOj17W6ywAQJhAgZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4b232570d625662eaab4@syzkaller.appspotmail.com,
	Zhao Feng <zhaofeng2@cmss.chinamobile.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 200/265] dm crypt: fix use of uninitialized percpu_counter in ctr error path
Date: Thu, 26 Nov 2026 15:38:50 +0100
Message-ID: <20261126143619.195757811@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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
@@ -3173,6 +3173,14 @@ static int crypt_ctr(struct dm_target *t
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
@@ -3184,10 +3192,6 @@ static int crypt_ctr(struct dm_target *t
 	crypt_calculate_pages_per_client();
 	spin_unlock(&dm_crypt_clients_lock);
 
-	ret = percpu_counter_init(&cc->n_allocated_pages, 0, GFP_KERNEL);
-	if (ret < 0)
-		goto bad;
-
 	/* Optional parameters need to be read before cipher constructor */
 	if (argc > 5) {
 		ret = crypt_ctr_optional(ti, argc - 5, &argv[5]);


