Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BC8524AF;
	Mon,  8 Apr 2024 13:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583693; cv=none; b=aPafFCi6sk5I3S+Jw7Yk6bmQfdNoPQr3WdcnCCF5yiNu2JmEK3CNTqmpKgobWRBCkrVDVl2NXw+pEkpwfw3UhM6NR7QjbQfgMALJVNs/Dax0Qh6iNWiwOfVPTH3SsAyr4/vKoVPYTJAOWr/YoYvyswm22NuDyk4YiQ2QOf1hREM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583693; c=relaxed/simple;
	bh=X6FuGkPkTuGQ0fbnQUvOUW+aaJyS2cLgtVkTLR80b3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZAfgQOI0ipemcjtoVS3gzLEN979znp5cKRCqZG351zWHQIzyM6sQEiGqzkZfNbYB8JR48dY+wAdWQaEqBs/QxpCC415FdB7GM8YR4/a9Htb8qVv7z04N7IJBDKbe/qSTmSTy06NX5HAEWVhICdoh8ysZY8vmCfiIIYaURTcnnmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LYrrSETa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LYrrSETa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D0AFC433C7;
	Mon,  8 Apr 2024 13:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583692;
	bh=X6FuGkPkTuGQ0fbnQUvOUW+aaJyS2cLgtVkTLR80b3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LYrrSETahRWvKXyxWiD6f7XRRtU1Ezt+YIuiSOjcabzncoXlAACvZwuF3bgd44P6+
	 9cZOAsaZDBY+zzXwi+n2Y5xR1pc0nHNw2AxbDJNdNm7OHsGf4aRyZZEwawejE7ioIP
	 EktqRzvfWzFQm0/Gm96J6wZQSuG/xlJVtBfZ4jGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.8 209/273] io_uring/rw: dont allow multishot reads without NOWAIT support
Date: Mon,  8 Apr 2024 14:58:04 +0200
Message-ID: <20240408125315.848752367@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

commit 2a975d426c82ff05ec1f0b773798d909fe4a3105 upstream.

Supporting multishot reads requires support for NOWAIT, as the
alternative would be always having io-wq execute the work item whenever
the poll readiness triggered. Any fast file type will have NOWAIT
support (eg it understands both O_NONBLOCK and IOCB_NOWAIT). If the
given file type does not, then simply resort to single shot execution.

Cc: stable@vger.kernel.org
Fixes: fc68fcda04910 ("io_uring/rw: add support for IORING_OP_READ_MULTISHOT")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rw.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -938,6 +938,13 @@ int io_read_mshot(struct io_kiocb *req,
 	ret = __io_read(req, issue_flags);
 
 	/*
+	 * If the file doesn't support proper NOWAIT, then disable multishot
+	 * and stay in single shot mode.
+	 */
+	if (!io_file_supports_nowait(req))
+		req->flags &= ~REQ_F_APOLL_MULTISHOT;
+
+	/*
 	 * If we get -EAGAIN, recycle our buffer and just let normal poll
 	 * handling arm it.
 	 */
@@ -956,7 +963,7 @@ int io_read_mshot(struct io_kiocb *req,
 	/*
 	 * Any successful return value will keep the multishot read armed.
 	 */
-	if (ret > 0) {
+	if (ret > 0 && req->flags & REQ_F_APOLL_MULTISHOT) {
 		/*
 		 * Put our buffer and post a CQE. If we fail to post a CQE, then
 		 * jump to the termination path. This request is then done.


