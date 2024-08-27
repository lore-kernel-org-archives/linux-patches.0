Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCA51BC9E3;
	Tue, 27 Aug 2024 15:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771512; cv=none; b=XMtkgeFxtiWc8VKZ0/2Sfmribmd7mSay0d6aP5CD2wlMIDq/uWeQ/6QjuDjKpdj2wPXhIMNi+La0hw4Lbkihn2v88PV5TIIiCdLb9mwpYpfzgOOYxP9vz6EN+Unr0sXH0NlFWGuUj+pYYOK+tHHrx2516uz9OzL9mEsyL+fZuHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771512; c=relaxed/simple;
	bh=MnxJ7H2fZOcLTdXbYnJjytAhLg1IfqNI/GJDW15gDeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amQvk1JjAbdMRsQDGRmP+aUVpITt3usTI8rbvFvobtUT1QqWRR46P2lW76/qmgRpIsAmFD57/0TEWqo710qFb7WqjbHcbjMxrItOQdN466PaKqzq/gvwz+ACSOQNONHMO6Io6mBdEXF51+BAP6Lpx9vSt1LuUAZHcCatuy4BeFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TSAZHyKB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TSAZHyKB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0573C4DDEE;
	Tue, 27 Aug 2024 15:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771512;
	bh=MnxJ7H2fZOcLTdXbYnJjytAhLg1IfqNI/GJDW15gDeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TSAZHyKBthyJVliNrh1LuC4eBIt2V6Mfxfh0/QwJBuD/3bHLdtXXhF4p4KTuH1wlS
	 /BhSuHgtGSEO4GCynJ0SLMG0mYs4jIe9a2JzEIUnRQ6l5bgfhTOJo/VojMc20dUWUw
	 3ESTOk4KgxjW2jPWU9zq5Rk+N2vjVLmPRcpev2V0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 211/273] io_uring/kbuf: sanitize peek buffer setup
Date: Tue, 27 Aug 2024 16:38:55 +0200
Message-ID: <20240827143841.440223688@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit e0ee967630c8ee67bb47a5b38d235cd5a8789c48 ]

Harden the buffer peeking a bit, by adding a sanity check for it having
a valid size. Outside of that, arg->max_len is a size_t, though it's
only ever set to a 32-bit value (as it's governed by MAX_RW_COUNT).
Bump our needed check to a size_t so we know it fits. Finally, cap the
calculated needed iov value to the PEEK_MAX_IMPORT, which is the
maximum number of segments that should be peeked.

Fixes: 35c8711c8fc4 ("io_uring/kbuf: add helpers for getting/peeking multiple buffers")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/kbuf.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index c95dc1736dd93..1af2bd56af44a 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -218,10 +218,13 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 
 	buf = io_ring_head_to_buf(br, head, bl->mask);
 	if (arg->max_len) {
-		int needed;
+		u32 len = READ_ONCE(buf->len);
+		size_t needed;
 
-		needed = (arg->max_len + buf->len - 1) / buf->len;
-		needed = min(needed, PEEK_MAX_IMPORT);
+		if (unlikely(!len))
+			return -ENOBUFS;
+		needed = (arg->max_len + len - 1) / len;
+		needed = min_not_zero(needed, (size_t) PEEK_MAX_IMPORT);
 		if (nr_avail > needed)
 			nr_avail = needed;
 	}
-- 
2.43.0



