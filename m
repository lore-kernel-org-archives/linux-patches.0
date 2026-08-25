Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63D6481233;
	Tue, 25 Aug 2026 13:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664830; cv=none; b=r3jCjXM1ohFkpVX0aiKRC7ps/kd3v38jjzyX/5q7B+3jhy3cE9WOSQ4gNXlYyajEgTQWMjylKkLiO978FdAUufdOc0/lkMONIaAQbDzT2Q/OwgGxIoLTczRIlWqkpl5up21Tp1dOKKDSbXBdodWK/37I8BSKoXxsEMMDhDnW8fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664830; c=relaxed/simple;
	bh=ThpP861DD4jpmuFWNzT6RmdeW5N7kuBeCTs+Hwwg0oU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LUmfsz69eEKGcS6V6llphupx7nJQqLwrVzk7ili4aYRLNaLxpIgBL6b0ghCbiGlhXUdffSLmJa8bK4oUszW3Y6bhMP3QbxNvirNx5OXtKc2DEt8qAOSHez5E+Z00JRzTbQYSLXUt98VaP2mk8zxNd7rXyt1LQaV2vcY1bSPOOho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AV6HCBre; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AV6HCBre"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1CBD1F000E9;
	Tue, 25 Aug 2026 13:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664828;
	bh=zKR48cdiKeOZZdwhtMDHW+6AQcdmGDTBuIB1VX+QQVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AV6HCBreBRvwUeM90fD9Mz6DKjws+RlFytvaGhMhUQGbzDyxej8wdfJyahx9p+o11
	 jdYgYzaTgbW5s98liYIz3Cn+pHCeXBe7L+UFPfp/VUTeJMiGppA+OTbRgIApZ+WbYM
	 c4CWLdxkZzqJShpgf3OOn3lZqMDQz2sMTzZhxOSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a4ccdd7ebf452e4d4701@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.1 019/101] io_uring/uring_cmd: dont skip completion for a synchronous multishot cmd
Date: Tue, 25 Aug 2026 15:24:57 +0200
Message-ID: <20260825132542.755948068@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
References: <20260825132541.986300899@linuxfoundation.org>
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

commit 360941242f09437a1e07cbed9b5a96663ffeabb6 upstream.

If IORING_URING_CMD_MULTISHOT is set, io_uring_cmd() treats any
non-negative return from ->uring_cmd() as the driver having taken
ownership of the request and returns IOU_ISSUE_SKIP_COMPLETE. But
nothing guarantees that the driver did so, and any handler that just
completes the command inline and returns 0 or a positive result then
leaves the request orphaned, leaking the io_kiocb, the async data,
and the file reference.

The special case isn't needed. ublk returns -EIOCBQUEUED for the
multishot fetch command, which is passed through as-is, and the poll
driven socket timestamp command returns -EAGAIN. Kill it, a multishot
handler that wants to hang on to the request must return -EIOCBQUEUED
or -EAGAIN like any other command.

Fixes: 620a50c92700 ("io_uring: uring_cmd: add multishot support")
Cc: stable@vger.kernel.org
Reported-by: syzbot+a4ccdd7ebf452e4d4701@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6a7a0194.b50370da.49fe0.0056.GAE@google.com/
Link: https://lore.kernel.org/all/20260811115125.1831170-1-vasilisalmpanis@gmail.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/uring_cmd.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -273,10 +273,6 @@ int io_uring_cmd(struct io_kiocb *req, u
 	}
 
 	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
-	if (ioucmd->flags & IORING_URING_CMD_MULTISHOT) {
-		if (ret >= 0)
-			return IOU_ISSUE_SKIP_COMPLETE;
-	}
 	if (ret == -EAGAIN) {
 		ioucmd->flags |= IORING_URING_CMD_REISSUE;
 		return ret;


