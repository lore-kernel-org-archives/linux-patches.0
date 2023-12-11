Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094771D696;
	Mon, 11 Dec 2023 18:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uMPAkOKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32969C433C7;
	Mon, 11 Dec 2023 18:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319463;
	bh=j4sCLRIBk+F0+LQqGtsnw6W5j9aOLehuA5QHwcsC338=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uMPAkOKGsgwC3b6J++NgqWbTE8VvndXLpEcwmRnXPmCBA8uWhx/ZloWgmVMxX4nRr
	 fNqRS65JcLZolyA49zMr1GxIDrOdG1V6n+826xmpAMPOmfoWOxuyxe00fozotDqI3M
	 lQGCo2Y3DWoWbPWFrCZivn5UnHq/kb+lIDbHhtLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 115/244] io_uring/kbuf: Fix an NULL vs IS_ERR() bug in io_alloc_pbuf_ring()
Date: Mon, 11 Dec 2023 19:20:08 +0100
Message-ID: <20231211182050.968292262@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit e53f7b54b1fdecae897f25002ff0cff04faab228 ]

The io_mem_alloc() function returns error pointers, not NULL.  Update
the check accordingly.

Fixes: b10b73c102a2 ("io_uring/kbuf: recycle freed mapped buffer ring entries")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/5ed268d3-a997-4f64-bd71-47faa92101ab@moroto.mountain
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/kbuf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 012f622036049..12eec4778c5b1 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -623,8 +623,8 @@ static int io_alloc_pbuf_ring(struct io_ring_ctx *ctx,
 	ibf = io_lookup_buf_free_entry(ctx, ring_size);
 	if (!ibf) {
 		ptr = io_mem_alloc(ring_size);
-		if (!ptr)
-			return -ENOMEM;
+		if (IS_ERR(ptr))
+			return PTR_ERR(ptr);
 
 		/* Allocate and store deferred free entry */
 		ibf = kmalloc(sizeof(*ibf), GFP_KERNEL_ACCOUNT);
-- 
2.42.0



