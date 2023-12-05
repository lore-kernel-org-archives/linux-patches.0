Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5920A6AA0;
	Tue,  5 Dec 2023 03:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KT3KqO3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6D6C433C8;
	Tue,  5 Dec 2023 03:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746476;
	bh=Bb7TZIarwP7GL3snKNUejHBfIPik4RWV2JJy6QaqZqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KT3KqO3KV6guYWUDcMeKNJH3fjyTNo5j7YLSC4hMpoAvzKqBioFXoCpzTQFgFULxC
	 U5+hn2mqxnQOMgqdKJ7rMjJv1ufCQtbwDJcP5chfYwiyA1xmNbkfYUlHdcev+nIKEI
	 myi51PXRJ8adkr+AZVjE3buxcnN1nYepMqSlhZ7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wu Bo <bo.wu@vivo.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.6 037/134] dm verity: initialize fec io before freeing it
Date: Tue,  5 Dec 2023 12:15:09 +0900
Message-ID: <20231205031537.850673938@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

From: Wu Bo <bo.wu@vivo.com>

commit 7be05bdfb4efc1396f7692562c7161e2b9f595f1 upstream.

If BIO error, verity_end_io() can call verity_finish_io() before
verity_fec_init_io(). Therefore, fec_io->rs is not initialized and
may crash when doing memory freeing in verity_fec_finish_io().

Crash call stack:
 die+0x90/0x2b8
 __do_kernel_fault+0x260/0x298
 do_bad_area+0x2c/0xdc
 do_translation_fault+0x3c/0x54
 do_mem_abort+0x54/0x118
 el1_abort+0x38/0x5c
 el1h_64_sync_handler+0x50/0x90
 el1h_64_sync+0x64/0x6c
 free_rs+0x18/0xac
 fec_rs_free+0x10/0x24
 mempool_free+0x58/0x148
 verity_fec_finish_io+0x4c/0xb0
 verity_end_io+0xb8/0x150

Cc: stable@vger.kernel.org      # v6.0+
Fixes: 5721d4e5a9cd ("dm verity: Add optional "try_verify_in_tasklet" feature")
Signed-off-by: Wu Bo <bo.wu@vivo.com>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-target.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -642,7 +642,6 @@ static void verity_work(struct work_stru
 
 	io->in_tasklet = false;
 
-	verity_fec_init_io(io);
 	verity_finish_io(io, errno_to_blk_status(verity_verify_io(io)));
 }
 
@@ -792,6 +791,8 @@ static int verity_map(struct dm_target *
 	bio->bi_private = io;
 	io->iter = bio->bi_iter;
 
+	verity_fec_init_io(io);
+
 	verity_submit_prefetch(v, io);
 
 	submit_bio_noacct(bio);


