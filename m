Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2A425D91C;
	Tue, 25 Mar 2025 12:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906335; cv=none; b=jXOvYzh3WNdh+7lYZhnyQQ/diDYFCB1lJGod6xUgnZ1s+yKSLwNp0cL2tR2A92pHJXTOKPmLLpOit8aUyqx5FEzbveMbbLS/88dQuvHD5mVHaowKgaXIzxDlicAu9uPWP4VEE9wgJAT6998hBAFRm/5y9z/kywYQOqFzIvCdDuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906335; c=relaxed/simple;
	bh=aoJqRYXzjpVpCMq8RVpoVimP7dvcV29MT0VVFxDXAHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTGnthHGPS/3FQ9T4UYPBynRMKdqGlXqAFjKlX1KTMYVy01TDt3SpHKcQ1oNPWyZOYAuc8UBTdVLePExCj2MT7cznkiirUMxql8XwQUaDcm0h6gZaotrrmgCpMBmvp4Z7podVxfhvJFXIdC0JyPrEhw1hw+4rp45ETqMAuiud/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iDltou9P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iDltou9P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9802CC4CEE4;
	Tue, 25 Mar 2025 12:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906334;
	bh=aoJqRYXzjpVpCMq8RVpoVimP7dvcV29MT0VVFxDXAHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iDltou9PozOmEXHF2ypZUxGKpxLrnpBGAdfbaqj3ufFVxQszCnuJomOY7iFJMVg01
	 TvxMoFshaDF9DO0AaKyIMPYxN54FlxSRzB7he4JrYzMoNJ8oMYnlMD+3pKxkZbHqIR
	 4i0d9xmz3RryW5tbZhCLxqyT0110jKwywM4je64o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wei <dw@davidwei.uk>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 061/116] io_uring/net: dont clear REQ_F_NEED_CLEANUP unconditionally
Date: Tue, 25 Mar 2025 08:22:28 -0400
Message-ID: <20250325122150.769281825@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -152,7 +152,7 @@ static void io_netmsg_recycle(struct io_
 		if (iov)
 			kasan_mempool_poison_object(iov);
 		req->async_data = NULL;
-		req->flags &= ~REQ_F_ASYNC_DATA;
+		req->flags &= ~(REQ_F_ASYNC_DATA|REQ_F_NEED_CLEANUP);
 	}
 }
 
@@ -447,7 +447,6 @@ int io_sendmsg_prep(struct io_kiocb *req
 static void io_req_msg_cleanup(struct io_kiocb *req,
 			       unsigned int issue_flags)
 {
-	req->flags &= ~REQ_F_NEED_CLEANUP;
 	io_netmsg_recycle(req, issue_flags);
 }
 


