Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6106314AA1
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:32:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11C3C433C0;
	Mon, 26 Jun 2023 18:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804336;
	bh=R3xLn3LrKMnRyXEZ+DITys4ZK78OIrcJCLL2O/Ho3b0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VTIt2PmDeHu6mOr3pIu0sf1qbfgqtBMel4gwHR0+8vHrwS2C8vN+Q+1r/q8JhVsRS
	 G9NdOCi5I+JbI5c+KFtECv4dAOlzVg0EoLDi7Cv1XaUEb57WUjl5kqAaWmQkDmsyN8
	 g0uu8cDayMsOnvhq2qU3Vgw5xKIHe9X8jRGLCEaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 122/170] io_uring/net: use the correct msghdr union member in io_sendmsg_copy_hdr
Date: Mon, 26 Jun 2023 20:11:31 +0200
Message-ID: <20230626180806.031333298@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
References: <20230626180800.476539630@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 26fed83653d0154704cadb7afc418f315c7ac1f0 ]

Rather than assign the user pointer to msghdr->msg_control, assign it
to msghdr->msg_control_user to make sparse happy. They are in a union
so the end result is the same, but let's avoid new sparse warnings and
squash this one.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202306210654.mDMcyMuB-lkp@intel.com/
Fixes: cac9e4418f4c ("io_uring/net: save msghdr->msg_control for retries")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/net.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 41f828d93c899..2b44126a876ef 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -190,7 +190,7 @@ static int io_sendmsg_copy_hdr(struct io_kiocb *req,
 	ret = sendmsg_copy_msghdr(&iomsg->msg, sr->umsg, sr->msg_flags,
 					&iomsg->free_iov);
 	/* save msg_control as sys_sendmsg() overwrites it */
-	sr->msg_control = iomsg->msg.msg_control;
+	sr->msg_control = iomsg->msg.msg_control_user;
 	return ret;
 }
 
@@ -289,7 +289,7 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (req_has_async_data(req)) {
 		kmsg = req->async_data;
-		kmsg->msg.msg_control = sr->msg_control;
+		kmsg->msg.msg_control_user = sr->msg_control;
 	} else {
 		ret = io_sendmsg_copy_hdr(req, &iomsg);
 		if (ret)
-- 
2.39.2



