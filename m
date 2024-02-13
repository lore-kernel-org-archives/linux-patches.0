Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2E95F56B;
	Tue, 13 Feb 2024 17:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845574; cv=none; b=HEg+LrbTEdhtCT3yhy/KFDRkkQ1u+6leIxSy7D5BqMm9ugA/uT9WLvxD58yeOsL1i9/nbQtjPuP2P/q3enesi2d7A1ioZt38313gnUMDaGif49s6aBo9xHgw4yCmBpqUoUl4bSPdUUbbHe/D+a8uo0FC/KMlWB0PeMLtl3QluxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845574; c=relaxed/simple;
	bh=vt1Ata/LlLg0iy821nVek4DspNuXtGFPo0vDlkFLTxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nNcBhQ1tvwVJu7O6wdyGZk29QoREkV3oJRX8RHxXCaXWRUYeEieJYQtEyn2Rfqwj0kM6Yr0huPr55nktJzRyVaEEi4PwyCRH40wgc90WnwFNVNFeSr39ATZyDWLjKHnUOvhpoWFEgfsAEZB4yX7QMCZnBpYuhDYS7Z2R93e8W/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hwrN+mBu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hwrN+mBu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC82C433F1;
	Tue, 13 Feb 2024 17:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845574;
	bh=vt1Ata/LlLg0iy821nVek4DspNuXtGFPo0vDlkFLTxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hwrN+mBu4xswy1Ncm2g+L5elAg3T1q7+tzs2lMn5kI3LGJMhYD1YC2r6j8FxclD6f
	 HZys7vbbOhdVA7g/rn6Zto8wEnxCHsuuV9d/1GuFf6hT42y/TT/dM2aXln+iiSQDy0
	 Eo34dxF1F5n435ynwmtO/jivTJSkQYFKyZf+xDRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 119/121] io_uring/net: un-indent mshot retry path in io_recv_finish()
Date: Tue, 13 Feb 2024 18:22:08 +0100
Message-ID: <20240213171856.459895981@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

Commit 91e5d765a82fb2c9d0b7ad930d8953208081ddf1 upstream.

In preparation for putting some retry logic in there, have the done
path just skip straight to the end rather than have too much nesting
in here.

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |   36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -645,23 +645,27 @@ static inline bool io_recv_finish(struct
 		return true;
 	}
 
-	if (!mshot_finished) {
-		if (io_fill_cqe_req_aux(req, issue_flags & IO_URING_F_COMPLETE_DEFER,
-					*ret, cflags | IORING_CQE_F_MORE)) {
-			io_recv_prep_retry(req);
-			/* Known not-empty or unknown state, retry */
-			if (cflags & IORING_CQE_F_SOCK_NONEMPTY ||
-			    msg->msg_inq == -1)
-				return false;
-			if (issue_flags & IO_URING_F_MULTISHOT)
-				*ret = IOU_ISSUE_SKIP_COMPLETE;
-			else
-				*ret = -EAGAIN;
-			return true;
-		}
-		/* Otherwise stop multishot but use the current result. */
-	}
+	if (mshot_finished)
+		goto finish;
 
+	/*
+	 * Fill CQE for this receive and see if we should keep trying to
+	 * receive from this socket.
+	 */
+	if (io_fill_cqe_req_aux(req, issue_flags & IO_URING_F_COMPLETE_DEFER,
+				*ret, cflags | IORING_CQE_F_MORE)) {
+		io_recv_prep_retry(req);
+		/* Known not-empty or unknown state, retry */
+		if (cflags & IORING_CQE_F_SOCK_NONEMPTY || msg->msg_inq == -1)
+			return false;
+		if (issue_flags & IO_URING_F_MULTISHOT)
+			*ret = IOU_ISSUE_SKIP_COMPLETE;
+		else
+			*ret = -EAGAIN;
+		return true;
+	}
+	/* Otherwise stop multishot but use the current result. */
+finish:
 	io_req_set_res(req, *ret, cflags);
 
 	if (issue_flags & IO_URING_F_MULTISHOT)


