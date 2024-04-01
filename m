Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F423F8F4;
	Mon,  1 Apr 2024 16:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988336; cv=none; b=tKXF0cdxD7IuRLNSs6XRc480zpPrcrOS/Z6inw/E9YOKjlonf989xI3IytSJXtoPu5WygClaH66wBqhglVt0Zvu5vY5zujnoTJfUYbusvpBy+w4oPPZkaVg4NNRsZyE6SFKl6+R4s39kTU152uvSloO7VM4qjigFAWLXdrMUmC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988336; c=relaxed/simple;
	bh=+azZDFIhrn86m6JuD94M9RmNzmsaahLgYPX097l00G0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nT6L9SyH/3Q/o3AqSkXdZhgx8lTdv/C9bhaFG1C7It671xlMWDa5HkomJFzWRrhiGCVlIZ0DQxQALREKWvofZLy/QnwlyJFxz/O8NRVHqoWGJgwIlV6VQyciq5nQE2j8C/zaYABtJID/P7e+85MC9HiqJGLhcPXRs92KUrjymzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GN3vZ6GA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GN3vZ6GA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F75C433C7;
	Mon,  1 Apr 2024 16:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988336;
	bh=+azZDFIhrn86m6JuD94M9RmNzmsaahLgYPX097l00G0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GN3vZ6GAK80mHBHLjGwGXwhQC/K3SGi6Rfjdr8XiIsmp0c2nk3QboG8+fhpgJ4+O+
	 BjQSrfIZV6U/w+DJdUt2lc3/LEj9RCuemfYBxeXcil5CM2NV69IrtLA1FwQKIWCuQq
	 H6K6nQ5LDwm+t+xdaJ0my8qEF0aqMu/7uztXCFMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sargun Dhillon <sargun@meta.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 154/432] io_uring/rw: return IOU_ISSUE_SKIP_COMPLETE for multishot retry
Date: Mon,  1 Apr 2024 17:42:21 +0200
Message-ID: <20240401152557.737419500@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 0a3737db8479b77f95f4bfda8e71b03c697eb56a ]

If read multishot is being invoked from the poll retry handler, then we
should return IOU_ISSUE_SKIP_COMPLETE rather than -EAGAIN. If not, then
a CQE will be posted with -EAGAIN rather than triggering the retry when
the file is flagged as readable again.

Cc: stable@vger.kernel.org
Reported-by: Sargun Dhillon <sargun@meta.com>
Fixes: fc68fcda04910 ("io_uring/rw: add support for IORING_OP_READ_MULTISHOT")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/rw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index f66ace04403f7..70c5beb05d4e9 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -942,6 +942,8 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 		 */
 		if (io_kbuf_recycle(req, issue_flags))
 			rw->len = 0;
+		if (issue_flags & IO_URING_F_MULTISHOT)
+			return IOU_ISSUE_SKIP_COMPLETE;
 		return -EAGAIN;
 	}
 
-- 
2.43.0



