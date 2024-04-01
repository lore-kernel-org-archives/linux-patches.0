Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B23F1C0DE7;
	Mon,  1 Apr 2024 17:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990962; cv=none; b=HZm4jZFnsyodYJhZJ7trnBV3whPzESvkjxPdV7LIpgCm4eITdqkF7glbXa18NvkphATLLZ9+DHFeTQGGpAbEQV8zgZga7/Ej0+zaYNopWi15aRcRByZSNs8sBiiCbQewUBy9ThJebohLiPibx8m5SVkBMKeJa29QSIFnko4Hcac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990962; c=relaxed/simple;
	bh=q8iHN/HzVjHL0CPSLRYlrke3elk0GE3T85ZhUfSWWb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ft+yL6kkbANlNBQzEaNfuVxRxMbgGvT9FmSVST/3CLmGaZiFnk5E0gtcOUzWmSga24rQKGWYYug4YU5uriJUY5qJLqoyLyi83Qf+3glbzw9M3kzndPDN4cLnEgdbd4u34duXWfD/aqVOLF4Gbu5GHbGF33n95TTA13MrYiLdKg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LikL4vlC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LikL4vlC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD135C433C7;
	Mon,  1 Apr 2024 17:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990962;
	bh=q8iHN/HzVjHL0CPSLRYlrke3elk0GE3T85ZhUfSWWb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LikL4vlCsp5pe6rBsqkqwpH2Fd7N+cTchG26/FFSgVvh7UBGdiqg5cW9ty+V3xAeR
	 qv/9qnKQWsIoSWAoX5xbvvR/EkFpIkwY0xQuAhSWVU7BC1rGdR5Z3nNaq6tb28ujJ2
	 TcOVxZvbpL9YHcDPNZXrgV9kluxWi3RmdA2GYtRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 092/272] io_uring/net: correctly handle multishot recvmsg retry setup
Date: Mon,  1 Apr 2024 17:44:42 +0200
Message-ID: <20240401152533.509468759@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit deaef31bc1ec7966698a427da8c161930830e1cf ]

If we loop for multishot receive on the initial attempt, and then abort
later on to wait for more, we miss a case where we should be copying the
io_async_msghdr from the stack to stable storage. This leads to the next
retry potentially failing, if the application had the msghdr on the
stack.

Cc: stable@vger.kernel.org
Fixes: 9bb66906f23e ("io_uring: support multishot in recvmsg")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/net.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 0d4ee3d738fbf..b1b564c04d1e7 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -876,7 +876,8 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 			kfree(kmsg->free_iov);
 		io_netmsg_recycle(req, issue_flags);
 		req->flags &= ~REQ_F_NEED_CLEANUP;
-	}
+	} else if (ret == -EAGAIN)
+		return io_setup_async_msg(req, kmsg, issue_flags);
 
 	return ret;
 }
-- 
2.43.0



