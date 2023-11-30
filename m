Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CF255770;
	Thu, 30 Nov 2023 16:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHhjURrT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E06BC433C7;
	Thu, 30 Nov 2023 16:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701362074;
	bh=5OSlxkJo/rX5o+WKOP6ai9tLLuk4nxauDi/92X5LWbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oHhjURrTcauqX45iMXzUlzPhasLvgWCM38vwB1/VLHvlFFZs2ko2BdWTlicqwyiHy
	 R3A6f+Bvw/i4q7NsYkYP8q5z54hnYsd0L2uyk3Kylb7RuyUV4284zuRjqsrQnz0il9
	 Vz7+NRBuMQd1wlXqO1GnHs9s4+/xDCuw4IhkfUC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingzhe Zou <mingzhe.zou@easystack.cn>,
	Coly Li <colyli@suse.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 57/69] bcache: fixup init dirty data errors
Date: Thu, 30 Nov 2023 16:22:54 +0000
Message-ID: <20231130162134.935005781@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162133.035359406@linuxfoundation.org>
References: <20231130162133.035359406@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -981,8 +981,11 @@ void bch_sectors_dirty_init(struct bcach
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


