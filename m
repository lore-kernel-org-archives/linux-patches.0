Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3533737170
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W8/WQMdO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6FFDC433C9;
	Wed, 15 Nov 2023 19:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076353;
	bh=IHqNd75rQhIzgU/4Gq7TpH0gI5o0TuveAAvWQZI8uq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W8/WQMdOkBVaeUyyZQEPaY5En5mhzjHT+VxonhSfdbMen0yfmsMBAzVlCsx57ya2G
	 DVhSydDvFa15vs8p11c/fvEpkUVzULq3xaGLsfpOkaiUAOmg1BhfiD5EcmGFaa4xwH
	 0YkEBlDxTPUP3AOSd5UeGlySGDsNviuujaJnD9Ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 238/550] io_uring/kbuf: Fix check of BID wrapping in provided buffers
Date: Wed, 15 Nov 2023 14:13:42 -0500
Message-ID: <20231115191617.210005451@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Krisman Bertazi <krisman@suse.de>

[ Upstream commit ab69838e7c75b0edb699c1a8f42752b30333c46f ]

Commit 3851d25c75ed0 ("io_uring: check for rollover of buffer ID when
providing buffers") introduced a check to prevent wrapping the BID
counter when sqe->off is provided, but it's off-by-one too
restrictive, rejecting the last possible BID (65534).

i.e., the following fails with -EINVAL.

     io_uring_prep_provide_buffers(sqe, addr, size, 0xFFFF, 0, 0);

Fixes: 3851d25c75ed ("io_uring: check for rollover of buffer ID when providing buffers")
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
Link: https://lore.kernel.org/r/20231005000531.30800-2-krisman@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/kbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 7ca6f4f7819ce..427a995d26300 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -356,7 +356,7 @@ int io_provide_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	tmp = READ_ONCE(sqe->off);
 	if (tmp > USHRT_MAX)
 		return -E2BIG;
-	if (tmp + p->nbufs >= USHRT_MAX)
+	if (tmp + p->nbufs > USHRT_MAX)
 		return -EINVAL;
 	p->bid = tmp;
 	return 0;
-- 
2.42.0



