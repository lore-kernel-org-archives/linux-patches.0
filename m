Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025290;
	b=LqLJtOS3ms73p+xQQHxfxOtlHIi82O58pn/B7B5XkVW2eduiiVBDULhc0T54guXnVSXO
	 4NpKZgM/+Wag7IgdlExqYJx54ZP6IYNAq+nLW9+NGqw154oneDUguHNuHCdZVVg7fxb6O
	 pVPOaJe6PNarecePsT7UOlkfwiblyaEC5A1PhzgZZPLsYPd//taulZneFPfbsV1U5EMyu
	 s0S3jx4X6wEeP7cTpPDDhasgb9E7uGxn+Q681SjnU+8IRK/f+U84ZXln1p0N1yugvNDHj
	 wLfeTS7mYUlVEgUFnPz+s64LQsLrHprz1KqLxYYgmx9Hc+lV1kN44hUwEd9tW67oaAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025290;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jnAMvmEESSAqSISIrkiGuW/0BwpFjfDlBqnU7oC/uJI=;
	b=HkRAjW1ABGMv1C8rbBFwpWoeKri7VmJblIGbzZJYXGPygjjSZ7zAKdvcf9dQnHtqSabD
	 kfBJIB4Vcm3I7qXGx9HCq6aXLw5WHiiD3up4bXmr0ParQbZLyuetnOW+tw0+u/q2ET1kG
	 TafK1zq5ZSLLFTDc1Gb2OaYfglvWjLDww7V8wp1NXP4qEQssVV9g9MvYHkQBbpDkTf+mK
	 9C+6NV92Y6/lw5ZPUlwrFetRGY/3Gp5IQSsD0LrqZbemkrU5gZR7Ra4a3/MBnUrEURWt7
	 LKyMKc0zYCKbPyv1/7+f4SBUbaSWyBnJqkYk7f3Nj1CJhkeq1L6XTTgSUbT9lnsl2aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yPTVWFQp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189DA606A330;
	Wed, 18 Nov 2026 18:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yPTVWFQp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 638C71F000CA;
	Wed, 18 Nov 2026 18:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025289;
	bh=jnAMvmEESSAqSISIrkiGuW/0BwpFjfDlBqnU7oC/uJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yPTVWFQpL+5LetmdE0BYicQNHl+64r0C+Ul5EpTyQLTPNLIo8ds17wPV21bmNvU30
	 SCbrb9ed4993yabHR0qUIwT+alecrnSgruPc9OMRGrMInS9YqPVjr0CqweCe3MYiNl
	 HUYZZo2MfE8kVnEsX3Lx/nc2aMgfEohLzZMvWbo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6a132745caefcf42cb0d@syzkaller.appspotmail.com,
	Li Youhong <liyouhong@kylinos.cn>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1028/2151] md/raid5: drain released_stripes before destroying the cache
Date: Wed, 18 Nov 2026 15:46:03 +0100
Message-ID: <20261118150159.828997510@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index d427b24314c91..06ae7a3ec49a1 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2698,6 +2698,37 @@ static int drop_one_stripe(struct r5conf *conf)
 
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



