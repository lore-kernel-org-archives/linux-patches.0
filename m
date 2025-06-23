Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9CF4409;
	Mon, 23 Jun 2025 22:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716088; cv=none; b=ePf1t2/49D+YbQe18svDtKDcqcUx5mPhvece+VnhGaqDONM8Zw/olpMYjDh6SM4cnoFmFLMKR6QreIXtcZ/qaLOi7NM94iI8Kf63hQ+PqH1gp0j1nMI4ygcRJD3ewBujAU4NmgMxCnFkFdDbGarub5tnfRiK5ZfqYOijCXgMG8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716088; c=relaxed/simple;
	bh=WiW5Ufm8pSUYAMsAPpGhqIfg8R/konNei49QuoRPKNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JEatzWLKO7IqGk7Z/6kgNemwUGgS93Zx3F+Xl4yLm/k48JdLm2lP6cgyx+1O0dYJAXaMdDwu5Wi0roPB4MKIsjPlNf6AKL6m/IXmu/9FVgp296wT6jO2Jm6WA1/qwbB3lkNjqILXdHXX08MjV6vFmW3UXkAlafeeSIp1HVGcLBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vXJrHvZf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vXJrHvZf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5AAAC4CEEA;
	Mon, 23 Jun 2025 22:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716088;
	bh=WiW5Ufm8pSUYAMsAPpGhqIfg8R/konNei49QuoRPKNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vXJrHvZfQ8BOLqLkyMQz/ryK2BEKyNPfueZT4qGzA/1blopLkmgsVbnoXd5JpZTT2
	 Yjl6kKdRkkjlZfs6yC96GdLl3ztJ3xz7OkJOG3kJdysiJGqe6QgMtKkBfoxeVTLA4y
	 gUQG7LP5eqqiH0nxSlO8ZaU7UIGWvT0iHshPYcUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Roy Tang (ErgoniaTrading)" <royonia@ergonia.io>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.15 501/592] io_uring/net: always use current transfer count for buffer put
Date: Mon, 23 Jun 2025 15:07:39 +0200
Message-ID: <20250623130712.348932906@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 51a4598ad5d9eb6be4ec9ba65bbfdf0ac302eb2e upstream.

A previous fix corrected the retry condition for when to continue a
current bundle, but it missed that the current (not the total) transfer
count also applies to the buffer put. If not, then for incrementally
consumed buffer rings repeated completions on the same request may end
up over consuming.

Reported-by: Roy Tang (ErgoniaTrading) <royonia@ergonia.io>
Cc: stable@vger.kernel.org
Fixes: 3a08988123c8 ("io_uring/net: only retry recv bundle for a full transfer")
Link: https://github.com/axboe/liburing/issues/1423
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -829,7 +829,7 @@ static inline bool io_recv_finish(struct
 	if (sr->flags & IORING_RECVSEND_BUNDLE) {
 		size_t this_ret = *ret - sr->done_io;
 
-		cflags |= io_put_kbufs(req, *ret, io_bundle_nbufs(kmsg, this_ret),
+		cflags |= io_put_kbufs(req, this_ret, io_bundle_nbufs(kmsg, this_ret),
 				      issue_flags);
 		if (sr->retry)
 			cflags = req->cqe.flags | (cflags & CQE_F_MASK);


