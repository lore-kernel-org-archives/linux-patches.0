Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055698;
	b=ngPoEGIVI7ZFSS6gl2iBgWhzCUDlawtqbDwEzEogT5dBJ5iZi0mhwCsCAPjFk5QaDv47
	 U65fNSB6/95EsVKmsMO0TMe0cU0lLP8uGrbOxFBTkDvatr2fPD7zFKr9qOd4ufp5mtmEP
	 MyhKz7l++FO0v2ydyKVgyX6XtiIowYJqeM2nx/LHjZ8oRHKYxLFYo3liIh2m/f4GYztR7
	 d1WSEHBgV78GADMMlPDLrZe3inZCAnkb/EOf/xckPYHPSIj3ZpsN0fUHEG/f3cN8z9gbG
	 FOGFQyu4VHMIvcLE8MD2pijW3t3E5VtVkvRl/TuNZpIkWLRNVX7OCjjPrb3JzYvoy7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055698;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hWQsns8oUoY2JtF7dKrEJBu+gzeRfSWhpL9lufBQzKA=;
	b=sEPwnob1wfmIuth/Co5dF80OqRl53ixqDAhXD2YugWNTOw3kvqJpWyRmfXhe+2lNUBV4
	 /t4LJjMRKFFQ3w0C2cuvdB3PYTUczR0eo+ofudUgN7mL8apS5LzNBFubiphygslOl7/r8
	 ojHybncJX+zDgrsNtjcbxGRaFa1btUTCyPfr5+9hGNXpZ1OfPbSyTuffrAaMoaNgnq82f
	 nVjISFNYDnNP6E3z6Yzmq5hmOV5z2hFQ3EHcHjgllxiZCrEHxzsBH60UlukUR/knq+4s6
	 J6c2/T94mBPkjThTeTmYdfTShOcjO/M1UQqyG2bSZxj3vBloROwmHampxWQJD97AXrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J1pchUyu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1A5606A32C;
	Thu, 19 Nov 2026 02:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J1pchUyu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53DE21F000C5;
	Thu, 19 Nov 2026 02:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055697;
	bh=hWQsns8oUoY2JtF7dKrEJBu+gzeRfSWhpL9lufBQzKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J1pchUyuOxW0uV6Nb7le5kAf5oGz6tVyuf9ND5QEKOkpXP55OMTSTGmZQWOqmwPc8
	 00rX+g8Vkbn2vWWil0AA/GyiEd2c69SuD8AwRn9Er3E2LEBsPHr3H57BZ4OgmvYviY
	 G58LtqgL3Nspz3VCSqkiYYlFQgn1Rasbfm5pe5xA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6a132745caefcf42cb0d@syzkaller.appspotmail.com,
	Li Youhong <liyouhong@kylinos.cn>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1722/2214] md/raid5: drain released_stripes before destroying the cache
Date: Wed, 18 Nov 2026 15:56:38 +0100
Message-ID: <20261118150120.606800174@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Li Youhong <liyouhong@kylinos.cn>

[ Upstream commit af560e357a81964544be40c549e241b032ef7565 ]

grow_one_stripe() calls raid5_release_stripe() for each new stripe.
When mddev->thread is already set, that queues the stripe on
conf->released_stripes and wakes the thread. Only raid5d moves that
list onto inactive_list.

Takeover calls setup_conf() while mddev->thread still belongs to the
previous personality, so those stripes stay on released_stripes. If
setup_conf() then fails, shrink_stripes() only frees inactive_list and
kmem_cache_destroy() warns that objects remain.

Move stripes still queued on released_stripes onto inactive_list
before shrink_stripes() frees them.

Fixes: 773ca82fa1ee ("raid5: make release_stripe lockless")
Reported-by: syzbot+6a132745caefcf42cb0d@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-raid/6ab6b743.7eec07f4.c25c.0006.GAE@google.com/T/#t
Signed-off-by: Li Youhong <liyouhong@kylinos.cn>
Link: https://patch.msgid.link/20260929083916.50620-1-dayou5941@163.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d5e5e3b4691f8..e5f58853bb468 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2653,6 +2653,37 @@ static int drop_one_stripe(struct r5conf *conf)
 
 static void shrink_stripes(struct r5conf *conf)
 {
+	struct list_head temp[NR_STRIPE_HASH_LOCKS];
+	int i;
+
+	/*
+	 * grow_one_stripe() parks new stripes on released_stripes when
+	 * mddev->thread is already set. Takeover leaves the previous
+	 * personality's thread there, so raid5d never moves them to
+	 * inactive_list. Drain them before the cache is destroyed.
+	 * slab_cache is assigned only after device_lock and the hash
+	 * lists exist; earlier abort paths have nothing to drain.
+	 */
+	if (conf->slab_cache) {
+		for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
+			INIT_LIST_HEAD(&temp[i]);
+
+		spin_lock_irq(&conf->device_lock);
+		release_stripe_list(conf, temp);
+		spin_unlock_irq(&conf->device_lock);
+
+		for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++) {
+			if (list_empty(&temp[i]))
+				continue;
+			spin_lock_irq(conf->hash_locks + i);
+			if (list_empty(conf->inactive_list + i))
+				atomic_dec(&conf->empty_inactive_list_nr);
+			list_splice_tail_init(&temp[i],
+					      conf->inactive_list + i);
+			spin_unlock_irq(conf->hash_locks + i);
+		}
+	}
+
 	while (conf->max_nr_stripes &&
 	       drop_one_stripe(conf))
 		;
-- 
2.53.0



