Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF42359F8C;
	Fri,  9 Jan 2026 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960007; cv=none; b=lNX2TeXgofElw0d+ifKfiBl8j9KuskQXGt9i7zBhrtuDE8xdf8xczhIoEN3ic8ezLer78lpdR+E4LwJfYWqUjck5P3nlWt2dbWB2yuXovNjzRr++5foYvcAjsUJqNcJHF1du7YIJWJCipA1TB+Hh4QzYK1D9Ws9/yHqpKv3BZmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960007; c=relaxed/simple;
	bh=oEP/v6SGCAy/mm/ow16XCr52Ro60sGHwSBicenpQ2Dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fB+r9hwcUo1Y19UmAjhrpzkd9SJ5AQaJG07oJQOyvdpebkF6BPHaSl/wGbdOjZNvjgGmBmKplrnrk182RowmMiT74dyIr7BSCW4Pk+i3Z/HqGQalSB1e8OsgnovJHfaC+wJLDCOxlsRdOqQycXnJTsU/OzhjTqRP1LXkJkGTkPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZilf+vH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZilf+vH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C365C4CEF1;
	Fri,  9 Jan 2026 12:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960007;
	bh=oEP/v6SGCAy/mm/ow16XCr52Ro60sGHwSBicenpQ2Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZilf+vHvJEGjro0jBh7aGmz8jOYB0eDVfQb7T3UWU9l4j/6jwmnfBcMBTLUMkXpO
	 1Dvw5QL/HJshdPaqv4vhVM3EG/DKJKuuGCaUVuK8oOFbOFs6JLpImFAKMNEbpNzP+6
	 LIjOxzSYVCgkLnEllRtBOzOOzmlIA92lYVe+7E5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 220/737] ublk: make sure io cmd handled in submitter task context
Date: Fri,  9 Jan 2026 12:35:59 +0100
Message-ID: <20260109112142.279320572@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 3421c7f68bba52281bbb38bc76c18dc03cb689e4 ]

In well-done ublk server implementation, ublk io command won't be
linked into any link chain. Meantime they are always handled in no-wait
style, so basically io cmd is always handled in submitter task context.

However, the server may set IOSQE_ASYNC, or io command is linked to one
chain mistakenly, then we may still run into io-wq context and
ctx->uring_lock isn't held.

So in case of IO_URING_F_UNLOCKED, schedule this command by
io_uring_cmd_complete_in_task to force running it in submitter task. Then
ublk_ch_uring_cmd_local() is guaranteed to run with context uring_lock held,
and we needn't to worry about sync among submission code path any more.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20231009093324.957829-3-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: c6a45ee7607d ("ublk: prevent invalid access with DEBUG")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index ec6d7a08104d9..6419f304fa5e2 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1857,7 +1857,8 @@ static inline struct request *__ublk_check_and_get_req(struct ublk_device *ub,
 	return NULL;
 }
 
-static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
+static inline int ublk_ch_uring_cmd_local(struct io_uring_cmd *cmd,
+		unsigned int issue_flags)
 {
 	/*
 	 * Not necessary for async retry, but let's keep it simple and always
@@ -1871,9 +1872,28 @@ static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 		.addr = READ_ONCE(ub_src->addr)
 	};
 
+	WARN_ON_ONCE(issue_flags & IO_URING_F_UNLOCKED);
+
 	return __ublk_ch_uring_cmd(cmd, issue_flags, &ub_cmd);
 }
 
+static void ublk_ch_uring_cmd_cb(struct io_uring_cmd *cmd,
+		unsigned int issue_flags)
+{
+	ublk_ch_uring_cmd_local(cmd, issue_flags);
+}
+
+static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
+{
+	/* well-implemented server won't run into unlocked */
+	if (unlikely(issue_flags & IO_URING_F_UNLOCKED)) {
+		io_uring_cmd_complete_in_task(cmd, ublk_ch_uring_cmd_cb);
+		return -EIOCBQUEUED;
+	}
+
+	return ublk_ch_uring_cmd_local(cmd, issue_flags);
+}
+
 static inline bool ublk_check_ubuf_dir(const struct request *req,
 		int ubuf_dir)
 {
-- 
2.51.0



