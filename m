Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00132853ED;
	Wed, 23 Apr 2025 15:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422544; cv=none; b=UzOQsQ6tkW8yt4z1V2Xlpea+BpXP8eNQ/suM7rUXE72B2RlCdAL8kxhXZnMyYeZnbQh61Ymw+T4xEpdu/hAa2o+dtXc1RmA/Bd15g+f2HsYVOzeOF95iA1pshZ8sDbqbyPy0n59xtkCb1lVmmKvmFsWeOTvFZhunOK0/9jNrTDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422544; c=relaxed/simple;
	bh=9jPSKLSs7AKzoEYvn0j/AaHPorMKCX5mn2kIZo3hYH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=anAjf17UfL3HXV8H0kBHe0i7XfLvljgfMnJwf3U8HFVYYMOb/XjAmmuiiRTLR/6djLTRNbBnZOTuTpQFiLD4iG6dIh0JfrmBGUb9c/y9WPTdxqppCGdfjqdzQlKgrPvPau7OyyJEDt6Nff+jxoFfUnUad7sZvV+zoqs3z+JFznY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xp+A8yqe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xp+A8yqe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07A5C4CEE3;
	Wed, 23 Apr 2025 15:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422543;
	bh=9jPSKLSs7AKzoEYvn0j/AaHPorMKCX5mn2kIZo3hYH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xp+A8yqeTHXR9B7MT8fnxZ0CZ5l36vuNLuK2DutdTtUYTDH3wZ9WXJYXIZt505zzn
	 p8qfZ3VDC3pKST8Ec1gVFAx8ijJNaz9dt5uvIquhVCSW/Sy6LDmhlMCVVmjULuo63a
	 FhE2g90ne7O4owjIgpvlpBZ2dEA6OJMUYPRAgwEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 359/393] io_uring/net: fix accept multishot handling
Date: Wed, 23 Apr 2025 16:44:15 +0200
Message-ID: <20250423142658.170389982@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Pavel Begunkov <asml.silence@gmail.com>

Commit f6a89bf5278d6e15016a736db67043560d1b50d5 upstream.

REQ_F_APOLL_MULTISHOT doesn't guarantee it's executed from the multishot
context, so a multishot accept may get executed inline, fail
io_req_post_cqe(), and ask the core code to kill the request with
-ECANCELED by returning IOU_STOP_MULTISHOT even when a socket has been
accepted and installed.

Cc: stable@vger.kernel.org
Fixes: 390ed29b5e425 ("io_uring: add IORING_ACCEPT_MULTISHOT for accept")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/51c6deb01feaa78b08565ca8f24843c017f5bc80.1740331076.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1438,6 +1438,8 @@ retry:
 		goto retry;
 
 	io_req_set_res(req, ret, 0);
+	if (!(issue_flags & IO_URING_F_MULTISHOT))
+		return IOU_OK;
 	return IOU_STOP_MULTISHOT;
 }
 


