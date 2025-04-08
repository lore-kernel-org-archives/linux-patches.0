Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2077D207E14;
	Tue,  8 Apr 2025 11:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111304; cv=none; b=o8o7RujZs2KZs/XKrT5J+YuJR/6S7ZQ4mlzuQFpdtlQk3VndYqQacb+TeaFjmNTVk7hlpky/AVyvfwB6ZuhMLC0AjXJ9Cq/k7JZp6O4iHR0GDnn1RazW22EknXOik09nZzlwroWosQ3hb1pd3zE4kYUDQvqsONgdVI+mKdVr2d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111304; c=relaxed/simple;
	bh=UC4Mhx7eJOSmQQCuLiC/6d/5fkQ53VWRCECHE5J8Bog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QkSy0mHXTaRCLhx1OXIEUUsnCdK2DixTe4DpdWRYi4dxrTczCfaOdDi91hmnPIC8/b5f8aa1rrajx+ev4cbE1xeFtlPuj7DP4smisgp4w6+6ygDyUrJq3BnJu/UEU6gh9ewnAjAUtoBrOhRFrugIxgKqt1vgm3fs2ZLiAssRFKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o+ExtvAe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o+ExtvAe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C54C4CEE5;
	Tue,  8 Apr 2025 11:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111304;
	bh=UC4Mhx7eJOSmQQCuLiC/6d/5fkQ53VWRCECHE5J8Bog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o+ExtvAeTokjmgn0rG83pqjRK71bexo8M4o0q9rTpVag0CHgqBoDAZAcAaIwj5dRM
	 MR42G233ypWSKRb97giu/GJyL3re6jt1N8Fnpdri5/dyJwIOP4wiWAXAE/GfDlDCEg
	 UZOwm7uo6OIT7F0g2vOOXwEwxbERza8iYWnmbG6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 343/731] io_uring/net: only import send_zc buffer once
Date: Tue,  8 Apr 2025 12:44:00 +0200
Message-ID: <20250408104922.253858937@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit 8e3100fcc5cbba03518b8b5c059624aba5c29d50 ]

io_send_zc() guards its call to io_send_zc_import() with if (!done_io)
in an attempt to avoid calling it redundantly on the same req. However,
if the initial non-blocking issue returns -EAGAIN, done_io will stay 0.
This causes the subsequent issue to unnecessarily re-import the buffer.

Add an explicit flag "imported" to io_sr_msg to track if its buffer has
already been imported. Clear the flag in io_send_zc_prep(). Call
io_send_zc_import() and set the flag in io_send_zc() if it is unset.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Fixes: 54cdcca05abd ("io_uring/net: switch io_send() and io_send_zc() to using io_async_msghdr")
Link: https://lore.kernel.org/r/20250321184819.3847386-2-csander@purestorage.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/net.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index e9bea0235c130..16d54cd4d53f3 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -77,6 +77,7 @@ struct io_sr_msg {
 	u16				buf_group;
 	u16				buf_index;
 	bool				retry;
+	bool				imported; /* only for io_send_zc */
 	void __user			*msg_control;
 	/* used only for send zerocopy */
 	struct io_kiocb 		*notif;
@@ -1252,6 +1253,7 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	zc->done_io = 0;
 	zc->retry = false;
+	zc->imported = false;
 	req->flags |= REQ_F_POLL_NO_LAZY;
 
 	if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
@@ -1414,7 +1416,8 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 	    (zc->flags & IORING_RECVSEND_POLL_FIRST))
 		return -EAGAIN;
 
-	if (!zc->done_io) {
+	if (!zc->imported) {
+		zc->imported = true;
 		ret = io_send_zc_import(req, issue_flags);
 		if (unlikely(ret))
 			return ret;
-- 
2.39.5



