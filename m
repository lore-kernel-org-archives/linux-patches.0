Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A652954FB6;
	Thu, 30 Nov 2023 16:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fCypT3KH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359FDC433C7;
	Thu, 30 Nov 2023 16:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361632;
	bh=PjV9I5NdzFFpmqsHge/TuGd29NqukEti0pNJHpMyDp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fCypT3KHCjEEZ87Bld8UCKCQPetQVOeT0QeZD8iRhUGxVteEQiaPftp3Ne4IRHixj
	 hXe9gtRopuFTE+7X6RMMi/OssOgQSG6V0ylpD6wHeL+p5WvG9fKfGB+ZrykmOrVnaD
	 Bc9ifHVk53xmIX0gKhXMEw10TNvHCJDHuDmahirA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingzhe Zou <mingzhe.zou@easystack.cn>,
	Coly Li <colyli@suse.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 098/112] bcache: fixup init dirty data errors
Date: Thu, 30 Nov 2023 16:22:25 +0000
Message-ID: <20231130162143.416493163@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mingzhe Zou <mingzhe.zou@easystack.cn>

commit 7cc47e64d3d69786a2711a4767e26b26ba63d7ed upstream.

We found that after long run, the dirty_data of the bcache device
will have errors. This error cannot be eliminated unless re-register.

We also found that reattach after detach, this error can accumulate.

In bch_sectors_dirty_init(), all inode <= d->id keys will be recounted
again. This is wrong, we only need to count the keys of the current
device.

Fixes: b144e45fc576 ("bcache: make bch_sectors_dirty_init() to be multithreaded")
Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
Cc:  <stable@vger.kernel.org>
Signed-off-by: Coly Li <colyli@suse.de>
Link: https://lore.kernel.org/r/20231120052503.6122-6-colyli@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/bcache/writeback.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -991,8 +991,11 @@ void bch_sectors_dirty_init(struct bcach
 		op.count = 0;
 
 		for_each_key_filter(&c->root->keys,
-				    k, &iter, bch_ptr_invalid)
+				    k, &iter, bch_ptr_invalid) {
+			if (KEY_INODE(k) != op.inode)
+				continue;
 			sectors_dirty_init_fn(&op.op, c->root, k);
+		}
 
 		rw_unlock(0, c->root);
 		return;


