Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756E015FCFB;
	Mon, 27 May 2024 19:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838715; cv=none; b=lRqqo0ztFpnmOOORixIDqqqAB7bHSZyZARbH+HpCj2liwmDWvaWTc1I+Zv45r0/lh+SkmuBqRfFX9I3+atqx2VxOOfKU027R8cwXGBfa0U1Gt8TCp70APPLeXBFf/ArbENcbYSe3vLhyZ9m1HLPQmvqS7gVo47levLnH0tNa1Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838715; c=relaxed/simple;
	bh=YSGIcTkXKZGsQfdEXxKaII7Fk7y/IPdczVrBrCJXxmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khRBqGhiZyHVCxDH1KGlly/QcDoR1u3TKflFyELE3bvk3AQb8ufZBGSE6A2Rm0jX/b3uJbA4RQ5j3/3xRILEctpTiNYZjwvqqMBi1d0YGHs9K1sWT/m5DfYyKK6fJeG+gICVB6fEOz5Rel5YBwu6JwihjBHvKC1alGgAOGM5Zrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dCp0fvjr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dCp0fvjr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF2CC2BBFC;
	Mon, 27 May 2024 19:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838715;
	bh=YSGIcTkXKZGsQfdEXxKaII7Fk7y/IPdczVrBrCJXxmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dCp0fvjrlJeERu52K5kWYAwlAiDV6N6qd7jy2SLUE7d/QRRW719XaWei8zes92tko
	 d1uLt2KU3F+b5oxO5tD1awwLYUH0j4pNl7PeESiVl3HavHcOYL9CdmZE6LqoOgywd4
	 /kX60khNh3Eww9JRSJXk3MYTn7Y/OrC+e1kec73A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 490/493] io_uring/net: ensure async prep handlers always initialize ->done_io
Date: Mon, 27 May 2024 20:58:12 +0200
Message-ID: <20240527185646.158703929@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit f3a640cca951ef9715597e68f5363afc0f452a88 ]

If we get a request with IOSQE_ASYNC set, then we first run the prep
async handlers. But if we then fail setting it up and want to post
a CQE with -EINVAL, we use ->done_io. This was previously guarded with
REQ_F_PARTIAL_IO, and the normal setup handlers do set it up before any
potential errors, but we need to cover the async setup too.

Fixes: 9817ad85899f ("io_uring/net: remove dependency on REQ_F_PARTIAL_IO for sr->done_io")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/net.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 099ab92cca0b7..dbabe0058f1cb 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -311,7 +311,10 @@ int io_send_prep_async(struct io_kiocb *req)
 	struct io_async_msghdr *io;
 	int ret;
 
-	if (!zc->addr || req_has_async_data(req))
+	if (req_has_async_data(req))
+		return 0;
+	zc->done_io = 0;
+	if (!zc->addr)
 		return 0;
 	io = io_msg_alloc_async_prep(req);
 	if (!io)
@@ -338,8 +341,10 @@ static int io_setup_async_addr(struct io_kiocb *req,
 
 int io_sendmsg_prep_async(struct io_kiocb *req)
 {
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	int ret;
 
+	sr->done_io = 0;
 	if (!io_msg_alloc_async_prep(req))
 		return -ENOMEM;
 	ret = io_sendmsg_copy_hdr(req, req->async_data);
@@ -586,9 +591,11 @@ static int io_recvmsg_copy_hdr(struct io_kiocb *req,
 
 int io_recvmsg_prep_async(struct io_kiocb *req)
 {
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *iomsg;
 	int ret;
 
+	sr->done_io = 0;
 	if (!io_msg_alloc_async_prep(req))
 		return -ENOMEM;
 	iomsg = req->async_data;
-- 
2.43.0



