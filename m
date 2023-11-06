Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D81420316
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qoKyA68E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EB0C433C7;
	Mon,  6 Nov 2023 13:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276477;
	bh=dFry83SkEhp6Z9oFwt3lD5bTUXluOSTi6xNO9iHJemU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qoKyA68Ed084FkqWAphnEKBc+dFFJmXYCwmuWfdOx5/zhDZssE9NDk6EUsJeOZ3HK
	 gl7KHO9IN8vBKH8OMh8LiE3knVFvMBHtormFtBHytI9Wo5Qw1fBu3r8Xydcm1XzTtP
	 LwsUyy/aUSYiUHvudTXf7HTGFUj0l1hVrzpw4Vno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 38/62] io_uring: kiocb_done() should *not* trust ->ki_pos if ->{read,write}_iter() failed
Date: Mon,  6 Nov 2023 14:03:44 +0100
Message-ID: <20231106130303.199541332@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130301.807965064@linuxfoundation.org>
References: <20231106130301.807965064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 1939316bf988f3e49a07d9c4dd6f660bf4daa53d ]

->ki_pos value is unreliable in such cases.  For an obvious example,
consider O_DSYNC write - we feed the data to page cache and start IO,
then we make sure it's completed.  Update of ->ki_pos is dealt with
by the first part; failure in the second ends up with negative value
returned _and_ ->ki_pos left advanced as if sync had been successful.
In the same situation write(2) does not advance the file position
at all.

Reviewed-by: Christian Brauner <brauner@kernel.org>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/rw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 0218fae12eddc..0133db648d8e9 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -326,7 +326,7 @@ static int kiocb_done(struct io_kiocb *req, ssize_t ret,
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	unsigned final_ret = io_fixup_rw_res(req, ret);
 
-	if (req->flags & REQ_F_CUR_POS)
+	if (ret >= 0 && req->flags & REQ_F_CUR_POS)
 		req->file->f_pos = rw->kiocb.ki_pos;
 	if (ret >= 0 && (rw->kiocb.ki_complete == io_complete_rw)) {
 		if (!__io_complete_rw_common(req, ret)) {
-- 
2.42.0



