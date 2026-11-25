Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623424;
	b=Oq0T5xxm0CVSUyPU/4x+j3vyECq63O8AMRAVfdQ8h6f2K5liHD5klc8FhOvIlzwwMUTV
	 5hl4qHtMe3brsBGNRe698pjXdf0OkoqoKGhKI8olTSQ0ej6296UtINAOOjRRsN7i8idl4
	 Q8eGV/SSmRC1A05fyNmsC4Y43xAVfHVWXRLDjhqKgvJRKjGlIRd5xmqZ4mP061hlNYttC
	 Lexg6Fy1kEzQqbp2Sr+0mxeA+A+jkFoTozE0K2hMCfNtKTXYiLpb8N1FLtQxVu1+EtxNS
	 Nt97lPaEOXb4Hhav1NPv0LqGxPv2WvWRmt9MCoLMZGrSbzdNb6LwnuAU/ZtIRWHBQyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623424;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SHBNDZud0AEwrCi54p2SPcbDGH+F1ANAXyc6CkGtcGk=;
	b=0ndY7ntX+j9UBGCgAbGt5BMAShBQauGzKId3cfX1NH/c0+8MrV3l0/ccfjjwfGhpEayS
	 OU1i1VO2MHBGrXLJEbyzbhyU1bf+dqHP48AO6RuMAva+1aQa8VAVY6xRmSc+34RYCwLHL
	 fXMdXajzRee5s+UDlvnIgOVpQqNxdSF8zvcE0OtL0zIBzLko0+g8JT1rATITk2c+6n2gz
	 Oap7iK0jJhNzjoLhJyp6MImUougR8TOP35//VWYzJdd7IZugeE5r6PLBh574vKnL1RGxr
	 zbg6U1oa4/9swyIjHQ0J7Th2YPqH6oiFeRX590cDZxN26h30HFZQTNS56BZXhX86jZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZjK6SBFn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFF4606A323;
	Wed, 25 Nov 2026 16:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZjK6SBFn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A091F000C6;
	Wed, 25 Nov 2026 16:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623424;
	bh=SHBNDZud0AEwrCi54p2SPcbDGH+F1ANAXyc6CkGtcGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZjK6SBFnm6lvrCGD//kxHY4vGAil/7X6RhO7npL/QH2+C+vgzH6Jvbo86mzB9NwL+
	 u+edfBL+tODhBy/ty/FDD2QItGsTw6bslkRy/J5WHXu79b3JwsQQLc9Pj/YwhBvoka
	 KryaVsR1W0PAqVibJfu3mA4cr9S2LHbaeSlPjMQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4b232570d625662eaab4@syzkaller.appspotmail.com,
	Zhao Feng <zhaofeng2@cmss.chinamobile.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 855/990] dm crypt: fix use of uninitialized percpu_counter in ctr error path
Date: Wed, 25 Nov 2026 15:37:02 +0100
Message-ID: <20261125143842.055376413@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
@@ -3287,6 +3287,14 @@ static int crypt_ctr(struct dm_target *t
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
@@ -3298,10 +3306,6 @@ static int crypt_ctr(struct dm_target *t
 	crypt_calculate_pages_per_client();
 	spin_unlock(&dm_crypt_clients_lock);
 
-	ret = percpu_counter_init(&cc->n_allocated_pages, 0, GFP_KERNEL);
-	if (ret < 0)
-		goto bad;
-
 	/* Optional parameters need to be read before cipher constructor */
 	if (argc > 5) {
 		ret = crypt_ctr_optional(ti, argc - 5, &argv[5]);


