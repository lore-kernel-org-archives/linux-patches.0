Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215122;
	b=YjD/9kHvtan0D0kdJgdg3BfTrbrGVihamM54Ray1ETgU2k9VtUZHU39sWZ9n5Bux7nfD
	 2Pvxwd9EErByj3I8me9g25CXJDP0FZvMZI/4UAmpzmzq24dFZpkZtmOmfa4JWgDihuk4t
	 tHlLMmBTBOEEny+IKp1ofGksh5RHpQzbrdpVjnZjkrB1i6GK0q6+B3STrR8ZOjRhqgBLA
	 dECCqEIfJ5ct5WCRPCejtUirHLbvKoCWqEiKcf6WrZdIZ2WFmKsPZ1imsAwYnIYT9/pc4
	 eZCIJ5k0ZqN+Ijvij+jm6rFYoPvlTztsYg0R5SJZP8HN4dpzIIhi/s8VyGOM7UIYA3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215122;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sEm2VTbDhLQR3RV83ih8Ug8nb0TWU5LHhLnKdG9ezjI=;
	b=zNtcy2SgO8KOMJ62AQMeX6nrlmkJydQvJsRkEUFY7ez7nM6AJ01WxsxnyyN9VuhbcmsQ
	 5g6mRArILNpK9M0DpaWEcXWQDbnnt9whW1f7xn/n+6sKtWzdb+LT9ipp27srmvBzTw7m2
	 XdXipiDGXiE2XArkx5kn0dZ5RIn5O9sVEKtkih5oUyJe0FrQpt9u+OWNFRWc19jq3IGZi
	 VVKbwe5GSuwwokFh1OVEBMzAckHo4tRu9GinsjEbJYSnJsHfbCzwcDRZmOOtgpga/3sQY
	 J+uFN7LPi3yIRJgodBb/yi2VnHyt9QoMvo4TEC0hT0+qhgTmm51bjAFRcvnJlk6RRoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NubRsKZS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521A5606A31C;
	Wed, 28 Oct 2026 19:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NubRsKZS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04EA1F01825;
	Wed, 28 Oct 2026 19:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215122;
	bh=sEm2VTbDhLQR3RV83ih8Ug8nb0TWU5LHhLnKdG9ezjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NubRsKZSf78QQKCr2lNQQAqFT6HTzr2e4hzkJNZeuJbC0kVVh7B1Zd02OGhCQ95yS
	 chTDzIxZ3Qk8IOWXgR7FNy+V4EhuRD5lk8DB0ZI7UjuO/c1RI0fVafkYKORZJagDMm
	 ZZq01pQK4nTj8PvsEOftkJmwoRxpqKAs+QaMIEZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+52bae5c495dbe261a0bc@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Jianan Huang <jnhuang95@gmail.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1101/1887] erofs: fix use-after-free on sbi->sync_decompress
Date: Wed, 28 Oct 2026 17:53:17 +0100
Message-ID: <20261028170524.459935139@linuxfoundation.org>
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

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 1aee05e814d292064bf5fa15733741040cdc48ba ]

z_erofs_decompress_kickoff() can race with filesystem unmount, causing
a use-after-free on sbi->sync_decompress.

When I/O completes, z_erofs_endio() calls z_erofs_decompress_kickoff()
to queue z_erofs_decompressqueue_work() asynchronously. Then, after all
folios are unlocked, unmount workflow can proceed and sbi will be freed
before accessing to sbi->sync_decompress.

Thread (unmount)        I/O completion        kworker
                        queue_work
                                              z_erofs_decompressqueue_work
                                               (all folios are unlocked)
cleanup_mnt
 ..
 erofs_kill_sb
  erofs_sb_free
   kfree(sbi)
                        access sbi->sync_decompress  // UAF!!

Fixes: 40452ffca3c1 ("erofs: add sysfs node to control sync decompression strategy")
Reported-by: syzbot+52bae5c495dbe261a0bc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=52bae5c495dbe261a0bc
Reviewed-by: Chao Yu <chao@kernel.org>
Reviewed-by: Jianan Huang <jnhuang95@gmail.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zdata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 27cfc9aa30722..f3d859e6ffbcc 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1281,10 +1281,10 @@ static void z_erofs_decompress_kickoff(struct z_erofs_decompressqueue *io,
 	if (atomic_add_return(bios, &io->pending_bios))
 		return;
 	if (z_erofs_in_atomic()) {
-		queue_work(z_erofs_workqueue, &io->u.work);
 		/* enable sync decompression for readahead */
 		if (sbi->opt.sync_decompress == EROFS_SYNC_DECOMPRESS_AUTO)
 			sbi->opt.sync_decompress = EROFS_SYNC_DECOMPRESS_FORCE_ON;
+		queue_work(z_erofs_workqueue, &io->u.work);
 		return;
 	}
 	gfp_flag = memalloc_noio_save();
-- 
2.53.0



