Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4606735CB60;
	Fri,  7 Aug 2026 15:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117368; cv=none; b=L1/rAWwwuSflfPnFWc9OyVyNqStyh3YXjFSYWxwAodrR20JDvefTGl/wZFFCsBE3GBb4KFUlil5mj7qovoc5PXE/7mdecv9j4n+/0NznmmNJLqzGZYaDw0EY0E9qMOiC58cv0vycD4ChaT+ZFKW4XylVy+L8gxZKBnOkAW92m6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117368; c=relaxed/simple;
	bh=Kq02ZdRH65DHCdKYcG6BoasWDZjFSdsct24gLy4WfrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YExouKWxnBqO5a22pUtAvWw2iV4Kk7m5+qoC/Ikh1tAavQs4VDJgryQEeJ2atGR1XqiBqP06lDI7HktS8jqFn8SfJmfEhStk18MZgVHehamk3sHfFfR+iJbF5rJSkv+xYlui5UJjNpxIl4wTCjHJyfngluAU+r/ANycxcbRzst8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h1x8dU1I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h1x8dU1I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17F51F000E9;
	Fri,  7 Aug 2026 15:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117367;
	bh=HQzG7V6bhQiSqZYON741bmry3yB2orcDIavv2QK3qVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h1x8dU1IU54n9Izp4qxT4lkxIasOMOzYfsTVE1PWG8HGBXn4I42C7JnGhCvIHbFvD
	 nSg9BSK5k9t9iXWXr6Bcy3L0A1ClU3IiqnFMQ4CIQ5q35K8UY5xeSm+Y/8oS+aEjNR
	 IQhafINAYBGljx1qWZcuRpOxvYCtalEGEGHmcOuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sung Keum <kambodi127@gmail.com>,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.1 293/438] io_uring/net: initialize mshot_len for send
Date: Fri,  7 Aug 2026 16:38:09 +0200
Message-ID: <20260807143434.221513254@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit c77ffbc980efb337fd750c337d8157d532ea14e5 upstream.

Commit:

6a8afb9fff64 ("io_uring/net: allow multishot receive per-invocation cap")

changed how io_mshot_prep_retry() set sr->len, and added the same
initialization in io_mshot_prep_retry(). But it neglected to touch the
send path, which may also uses the mshot retry path. Ensure that
sr->mshot_len always gets initialized correctly.

Fixes: 6a8afb9fff64 ("io_uring/net: allow multishot receive per-invocation cap")
Cc: stable@vger.kernel.org
Reported-by: Sung Keum <kambodi127@gmail.com>
Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    1 +
 1 file changed, 1 insertion(+)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -436,6 +436,7 @@ int io_sendmsg_prep(struct io_kiocb *req
 		req->flags |= REQ_F_NOWAIT;
 	if (req->flags & REQ_F_BUFFER_SELECT)
 		sr->buf_group = req->buf_index;
+	sr->mshot_total_len = sr->mshot_len = 0;
 	if (sr->flags & IORING_RECVSEND_BUNDLE) {
 		if (req->opcode == IORING_OP_SENDMSG)
 			return -EINVAL;


