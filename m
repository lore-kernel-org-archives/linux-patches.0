Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025295;
	b=K/n111gPA1Vp/X/xK51aKk+363rRS4wjmX2aObNB00zdgWgrnC3aNn2TeLk0ee+Gm2ps
	 z3EJiaKN6u/M5JqAueSFRa53TK7Enhjp4bKBlOpPskXr76kszwb1+weqhFfsfasLl8XXO
	 j8VrO3JhVDzcKgN7K7LDOZSolbiJSho9b6er068PmRAlW28D0jYiV/HLDKaAQf8N6ivnu
	 H/npE0VPqes+qPQrvSas/TnL0B2fz7RyTAuei2a7A1SvVyborH1KQdZ4Phtk+dnFIeca7
	 9R4YcnvPUT+PqpK+W4P1HDFSXGO21XtssIKZeSvbCwINby7NOCKIeI5GDKZcIDX7ulw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025295;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HIFEaThH5M7cM41ffWjEv4Ywpf6r2iKvQu+EsKIBDUY=;
	b=aoofgY19A0WLYb9EzOzAWKu6UWUj66TkY3LvT4I2BPXhet2OC/9LthUXLAlhjAp2KXOk
	 fTbRb9lK4iuh06ls/vUgbomXakh3dBOqaemQHqzVR/3un+uBnRUJ5cyihSUYkLeZq7qB2
	 tUYd/lH9/vZOzdt02HVWYm8Ry96M+S9V8jvmRuvJ7hw5OdRjf/eUFmlSVHtHcM47bJlwk
	 x52rfZsmWLbd9LJUh6GOB1c8VrwYdffTSl57mbXLcbnb9dr9VSCffw5WtmjQQxWkXD7ah
	 nGct0XMC3Chxv9Hogb/nPTaEmxGpvNNGpllnkQ8HlDlrY/YnXM0221awnl41PS263vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AhPz7zl9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C307A60A262B;
	Wed, 18 Nov 2026 18:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AhPz7zl9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4311F000C7;
	Wed, 18 Nov 2026 18:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025295;
	bh=HIFEaThH5M7cM41ffWjEv4Ywpf6r2iKvQu+EsKIBDUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AhPz7zl9b5kHdJ/L+0FYC1CdL7dw1QxZbyU0l9ba5J23khC4BoGaB4UeRcZqDa0oD
	 2iP+a9tuu6WBz9vcMMD3e1UmysGkTkrkcn0wDzInO2u/BHAcidFCb3M88BxLAoQ6Hi
	 N273RWuPZ9o31k2YuPi9jM2CiDh4YIH/FoQ/Rf08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sang-Hoon Choi <csh0052@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1030/2151] md/raid5: protect big_stripe_tree lookup with RCU
Date: Wed, 18 Nov 2026 15:46:05 +0100
Message-ID: <20261118150159.895249456@linuxfoundation.org>
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

From: Sang-Hoon Choi <csh0052@gmail.com>

[ Upstream commit 73b0df929494522acf9ccc8dafea4f721166965b ]

big_stripe_tree is updated under tree_lock, and deleted radix-tree
nodes are freed after an RCU grace period.  r5c_big_stripe_cached()
used to run under an RCU read-side critical section, but that protection
was removed together with unrelated rdev lookup protection.

The lookup can now be preempted while walking the tree, allowing a
concurrent deletion and grace period to complete before the walk
resumes.  Protect the lookup locally with rcu_read_lock().  Only the
presence of the entry is used after unlocking.

Fixes: ad8606702f26 ("md/raid5: remove rcu protection to access rdev from conf")
Assisted-by: LLM
Signed-off-by: Sang-Hoon Choi <csh0052@gmail.com>
Link: https://patch.msgid.link/179070265341.12871.12495446593114993799.idr-bug-88@gmail.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5-cache.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index b3e2582a39d03..3b51e8b4425af 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2970,7 +2970,9 @@ bool r5c_big_stripe_cached(struct r5conf *conf, sector_t sect)
 		return false;
 
 	tree_index = r5c_tree_index(conf, sect);
+	rcu_read_lock();
 	slot = radix_tree_lookup(&log->big_stripe_tree, tree_index);
+	rcu_read_unlock();
 	return slot != NULL;
 }
 
-- 
2.53.0



