Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624082;
	b=RoSkY4mZPJ0pZyNYrqDd5EkCPPY675hQMyGIAIaoKVEJZBSR6vXDQz6OR7mwXVssUiMw
	 lWstN+CCXYFFpiSrZfZfLYHzx9YJc9xTy/TjeZSdkc8CQzQj5Ur7qm4ODBWNz/OaluvUG
	 UJx40lnbl045TAoZRj/QsyEnlgrlvhKIw/N1897tBKhiHn0tLub56zYMJBbaQbDHwfyg6
	 Qpka0yBJ+kOltBFCwhIUbYNf9DHyBY65ahAlgMFEysctFwn3meYZI0/57xESRgHaJF6Xu
	 PM+jyK/sAxGW8ve0KQBxigOejRgdz5qt+dw5JENTvsbT2DNorFjkcGHn78/Q1seNOdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624082;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xAw3gwoKJ4COdzCxmvjrCNqwBnuU0fdxCoSY5gE+Xy8=;
	b=J9Yp+apDl9g8cNpGUPUxRyqcO02OeU8IZalKQicewxk7zRcU4DQbXE+b1bvBLFW86MPw
	 1ZNGH2mauuutplY18rptK2NNd1nBBQMufRUmh1rpuLq8cQEDN1kZhpk49kXGmyVlBpc/H
	 xv6LE1vIg8ixUemImRweXXaPEZZO23PPzcBY3XwV8ThhWFu/TAsmrfysiGm7PfxJrRVh1
	 lzLgFr9dPYnIH8mwGcdvxmZzq0PxYKdZc/ony/ZjCibgSvBTqt8HlQVlpxBzXpB2IEOta
	 y1UqjSAWu+h8HL3YYzPUQUR7QWeIjne/MkRH5H4Wd0dVqDvS81w7RfWUMre2xVR3+VQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DnCNZIlB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4051606A323;
	Wed, 25 Nov 2026 16:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DnCNZIlB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E111F000C6;
	Wed, 25 Nov 2026 16:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624082;
	bh=xAw3gwoKJ4COdzCxmvjrCNqwBnuU0fdxCoSY5gE+Xy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DnCNZIlBU0rCD21TPyWEyJ6iJkr+jc31NS99VzjCYuB1RUS51JLlNfZg3Y7bwOKEi
	 KdonRdl+8TzkTy6Pt81PMimYFdPc13fRI5pu2fBDscLKNxXeiNz52ep7NRLCkcYhlo
	 nP9OY+lRUJ84MLPdEEAOoN31v9TTKSiDs/a5cDds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 035/816] io_uring/rw: fail soft links on IOPOLL short or error IO
Date: Wed, 25 Nov 2026 15:26:23 +0100
Message-ID: <20261125143850.032311242@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Xiuwei <yangxiuwei@kylinos.cn>

Commit 4d3db66c5363dcf42c3d43ebaea330ac2d1888bb upstream.

io_complete_rw_iopoll() updates cqe.res when the transfer does not
match the requested length, but it does not call req_set_fail().
Soft linked requests then still run after a short or failed IOPOLL
read or write.

Fixes: b66ceaf324b3 ("io_uring: move iopoll reissue into regular IO path")
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Link: https://patch.msgid.link/20261114072246.741950-3-yangxiuwei@kylinos.cn
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/rw.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index b18b10cdbb524..688ce923f6a3c 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -553,8 +553,10 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res)
 
 	if (res == -EAGAIN && io_rw_should_reissue(req))
 		req->flags |= REQ_F_REISSUE | REQ_F_BL_NO_RECYCLE;
-	else if (unlikely(final_res != req->cqe.res))
+	else if (unlikely(final_res != req->cqe.res)) {
+		req_set_fail(req);
 		req->cqe.res = final_res;
+	}
 
 	/* order with io_iopoll_complete() checking ->iopoll_completed */
 	smp_store_release(&req->iopoll_completed, 1);
-- 
2.53.0



