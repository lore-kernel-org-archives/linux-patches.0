Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF1D256C88;
	Thu, 17 Apr 2025 18:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914583; cv=none; b=XXZB+RxPGP0DbuVBUc7Uo8FywvoqMYUQESVt24KEktlKGMb5AEJloZgHCqUbsxPZ1bODSjVvjx68wwnW0rwlZzwOluPbRVmIzqBtPeY1b8Jja7zMbZLXqyG3gkymiJOybofY/zpyK66tNTlGm3FPz/+YeVXuDZMyPdywFZmi0b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914583; c=relaxed/simple;
	bh=/kF7Y1Fi3OrhvAqWq+S4Fced+/HFIW0DLPUJI34pOqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNTrkkkm/I9twDeWnH/sjZjItihJXxoOm3QVF1sRW5mFQK3x0kuQCBb4AK0rgOfdWeiveebuel4cE7AvOsmrk4U3sw7VbpF9DNQc8WTf6Nx4MBxm0vNXTsenyJn2AUd2GKgcQhffgx1MEqykvjIaPf9MF/9WJ3Ig0PyAEL3tEMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xx3nHaTJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xx3nHaTJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092E8C4CEEE;
	Thu, 17 Apr 2025 18:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914583;
	bh=/kF7Y1Fi3OrhvAqWq+S4Fced+/HFIW0DLPUJI34pOqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xx3nHaTJ1gDyfnZvK23aP+phFqosnQVXLFPLvR3HbY0S6krDu7tjXmVG2xKhEtI55
	 IZTYPFrn04bLJH1SIMcbQmbnPEsqsmKWhHZyVZRP3suaXFZR2Q6Hj0b2jrJu28WJk/
	 3ifsPKKpS6rrYWXKEbJH6gdwnOSnHs9NXtxJf7kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.13 263/414] io_uring/net: fix accept multishot handling
Date: Thu, 17 Apr 2025 19:50:21 +0200
Message-ID: <20250417175122.009453902@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit f6a89bf5278d6e15016a736db67043560d1b50d5 upstream.

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
@@ -1649,6 +1649,8 @@ retry:
 	}
 
 	io_req_set_res(req, ret, cflags);
+	if (!(issue_flags & IO_URING_F_MULTISHOT))
+		return IOU_OK;
 	return IOU_STOP_MULTISHOT;
 }
 


