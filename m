Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D4725B673;
	Tue, 25 Mar 2025 12:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905968; cv=none; b=JAT5cIaGOSDeuYCmOi9e51SDH6Sm9a+wv6bPZ7mhueEgJNsDxlLPQC+nU2ooZofJ6B2zUXMW+vSL4BdvkauFwLB1f4d9Lm6w+PD5euKDe3Y/c67B3VEedTq4oOzKbfm8igLL7eueEOiPuUNh6/AHd70SDWBA+Y1UuG9D42XXu70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905968; c=relaxed/simple;
	bh=dsJNuxyLla/juUz8IwkRkSd9aCasxOcZZSsTjdu/Ie8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/DDgujnFAYTpnDTBI9F3PGxhdYbuO8oMBYf59QJHjR+t63APzHr7qjahJOQOjnPY7AmFZFNluNOum3ysXsIvrBBT0TmdtpUJLLDmDbqjrWsAkyDJ9jmwPq/g4nO0gmQ9jyRzCZbZ9ynHVZpMCRELcJZ9oVf/m1ErLAfHSiyfU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HWPwc3Nb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HWPwc3Nb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C320CC4CEE4;
	Tue, 25 Mar 2025 12:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905968;
	bh=dsJNuxyLla/juUz8IwkRkSd9aCasxOcZZSsTjdu/Ie8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HWPwc3NbAps6qEKPUEvt4fRkZnKT5E+8xlXk0chsh/HGl1BKGoa1GDdsbYfJ430Cg
	 25ulOIoBNrLzpchcR7EzSLxlXUUgcJSmpBJfvbyxxt2hCldGPWimNyN8yJNyHJVu2U
	 KUPkBjPpfUB/M7dyV87a1Lk1qNnDT/ZbljjuRCIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wei <dw@davidwei.uk>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.13 063/119] io_uring/net: dont clear REQ_F_NEED_CLEANUP unconditionally
Date: Tue, 25 Mar 2025 08:22:01 -0400
Message-ID: <20250325122150.667626965@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

commit cc34d8330e036b6bffa88db9ea537bae6b03948f upstream.

io_req_msg_cleanup() relies on the fact that io_netmsg_recycle() will
always fully recycle, but that may not be the case if the msg cache
was already full. To ensure that normal cleanup always gets run,
let io_netmsg_recycle() deal with clearing the relevant cleanup flags,
as it knows exactly when that should be done.

Cc: stable@vger.kernel.org
Reported-by: David Wei <dw@davidwei.uk>
Fixes: 75191341785e ("io_uring/net: add iovec recycling")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -151,7 +151,7 @@ static void io_netmsg_recycle(struct io_
 		if (iov)
 			kasan_mempool_poison_object(iov);
 		req->async_data = NULL;
-		req->flags &= ~REQ_F_ASYNC_DATA;
+		req->flags &= ~(REQ_F_ASYNC_DATA|REQ_F_NEED_CLEANUP);
 	}
 }
 
@@ -453,7 +453,6 @@ int io_sendmsg_prep(struct io_kiocb *req
 static void io_req_msg_cleanup(struct io_kiocb *req,
 			       unsigned int issue_flags)
 {
-	req->flags &= ~REQ_F_NEED_CLEANUP;
 	io_netmsg_recycle(req, issue_flags);
 }
 


