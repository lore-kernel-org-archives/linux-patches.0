Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083E915C14B;
	Mon, 23 Dec 2024 16:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970532; cv=none; b=dF2yGQAEO/UD6HduniZlnrUQ9GGaGvWK0noXKRV5E5LPgn048IbwMb1/lLZI116s3Ib4b0LNvnV3+8+lmPt/lwlYZyW2QIFcPpZe1GmvvNjtiICURYXWl+J059yOBAkF8+VpDL/TRBV9mi+GAwxLhChhIvhbanQchBMO4//zxAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970532; c=relaxed/simple;
	bh=nFpcnq3YdSfzLRTRM4YVuo28lluM9Ob5RzT2N9tADng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7kIbGfOTIU0s7L3TUyq/DdKsvaYIMzJU+66zdvxCqqIr241E3Zu3HHmZ/OaXKCP7uXNQRsUFLlxIi9/18s+393LFQd+yfW9iyxlj3cN8Xx5DM3KBRhPBgr3qZvMmhuDoko3nqf9Vo1uFgevwKeKPvRpj7z7g16kkVq2UeAy9f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W0Ibaex/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W0Ibaex/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F766C4CED3;
	Mon, 23 Dec 2024 16:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970531;
	bh=nFpcnq3YdSfzLRTRM4YVuo28lluM9Ob5RzT2N9tADng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W0Ibaex/gAo+BegWrjGIcd4Fu+wUnLiSjYlDTGm20kOerkrQXaOLi4J7sYfnLitJP
	 HAYyznWy9VCwhSEW0CfPf9R8wd99OlHmw7lfunwPv9WoEGSUhH3KHTZAF6tJNjj4DS
	 z/1ioDasqo/Lc3vnSgGYt4HrN4TuGa1xffTuvalg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 111/116] io_uring/rw: split io_read() into a helper
Date: Mon, 23 Dec 2024 16:59:41 +0100
Message-ID: <20241223155403.862155889@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

Commit a08d195b586a217d76b42062f88f375a3eedda4d upstream.

Add __io_read() which does the grunt of the work, leaving the completion
side to the new io_read(). No functional changes in this patch.

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
(cherry picked from commit a08d195b586a217d76b42062f88f375a3eedda4d)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rw.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -712,7 +712,7 @@ static int io_rw_init_file(struct io_kio
 	return 0;
 }
 
-int io_read(struct io_kiocb *req, unsigned int issue_flags)
+static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	struct io_rw_state __s, *s = &__s;
@@ -857,7 +857,18 @@ done:
 	/* it's faster to check here then delegate to kfree */
 	if (iovec)
 		kfree(iovec);
-	return kiocb_done(req, ret, issue_flags);
+	return ret;
+}
+
+int io_read(struct io_kiocb *req, unsigned int issue_flags)
+{
+	int ret;
+
+	ret = __io_read(req, issue_flags);
+	if (ret >= 0)
+		return kiocb_done(req, ret, issue_flags);
+
+	return ret;
 }
 
 static bool io_kiocb_start_write(struct io_kiocb *req, struct kiocb *kiocb)


