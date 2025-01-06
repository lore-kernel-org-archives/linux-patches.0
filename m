Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD453148316;
	Mon,  6 Jan 2025 15:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178009; cv=none; b=vC3We2iezyNT6lJWAe9a8qUDWeydU6JkeUNlyiROZfpYHlbV63yFWa/7LK3F6TaHIXNi2hlAzJdgAyK6bsSh5O3EQGlKaZDva4jywXR7gF/LAncfzRnSQtLhluY9VU+GyoCJ3tFlSj/mQNm6QoM8INHKbbh6SGe7UQly/JPK7H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178009; c=relaxed/simple;
	bh=N/erQIczHCHmasM8XDKSEs+u2OHslM/q7K+n9k83xHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HtJczSHXpx5poB9MQR9DFMa2vYJp66+ViB4hpjEbsNnfN50sow1XsRXBGmDmKZM2TM/t+XGW2NpX7U575JlIKV6k6XnOzB5SQYK4Q3Nj3AS+7OP0Ko47pSPZvmJb4Fa3rJwNrluZZmn+08I2k7Blyle/kL6BA6oCMuqXolu7XPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mjwslzv6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mjwslzv6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F51C4CED2;
	Mon,  6 Jan 2025 15:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178007;
	bh=N/erQIczHCHmasM8XDKSEs+u2OHslM/q7K+n9k83xHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mjwslzv6n4frmYAYBahmessl++pp78rvNngHVv9NTnGA3KonfJz6Mu1LerWHtZ/xH
	 BlUv+eNeFwHShiH4cARM7SjYIRruCa9JtAgeEh/ZRGEDnRPrxfyJYwjzbqG06dCipe
	 Jy9Ar+PTfGRJ0NLQMbmbnKlX6jOI49WGCVcE6h6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	chase xd <sl1589472800@gmail.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 131/156] io_uring/rw: fix downgraded mshot read
Date: Mon,  6 Jan 2025 16:16:57 +0100
Message-ID: <20250106151146.666840477@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

commit 38fc96a58ce40257aec79b32e9b310c86907c63c upstream.

The io-wq path can downgrade a multishot request to oneshot mode,
however io_read_mshot() doesn't handle that and would still post
multiple CQEs. That's not allowed, because io_req_post_cqe() requires
stricter context requirements.

The described can only happen with pollable files that don't support
FMODE_NOWAIT, which is an odd combination, so if even allowed it should
be fairly rare.

Cc: stable@vger.kernel.org
Reported-by: chase xd <sl1589472800@gmail.com>
Fixes: bee1d5becdf5b ("io_uring: disable io-wq execution of multishot NOWAIT requests")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/c5c8c4a50a882fd581257b81bf52eee260ac29fd.1735407848.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rw.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -979,6 +979,8 @@ int io_read_mshot(struct io_kiocb *req,
 		io_kbuf_recycle(req, issue_flags);
 		if (ret < 0)
 			req_set_fail(req);
+	} else if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
+		cflags = io_put_kbuf(req, ret, issue_flags);
 	} else {
 		/*
 		 * Any successful return value will keep the multishot read


