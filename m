Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB16F34AAE3;
	Tue, 26 Aug 2025 14:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217570; cv=none; b=Dj7Ui3Ez/u/Vz09PkKUqtMvj17xvpUmNW3aYD4wNcv/niSJReSHb94RMKYYDmYspftGhs/rOAmufi0jmNQaAcS/scKbk/Dn3bmsqQkjyE88QTJyaSt0WRhlH9taJxs7AuOJolBanmuGvLQWnFyeXu4cGwYWXlJGN85R4TN/44EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217570; c=relaxed/simple;
	bh=2/smWpJTC7oaqyO8nDnlOw/gaY2yLur7Hs+EcMTYV7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SsvMj0W84qjh/+EdBIBzlbX6sS5KX36GDCgW9vP9TnkM6WCStAfnSTZlvR9q3g1BDGRCXsOsxWDEev7EK90osc+i9Jk/F0egGrhp0VoF7UUbCOWP1hbFGDWmCW64sN+y/X6i245gQYzV9xeClTi9jeXkkhYNo0ukxIOkDcK6Qhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I4VeknCB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I4VeknCB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B90DC113D0;
	Tue, 26 Aug 2025 14:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217569;
	bh=2/smWpJTC7oaqyO8nDnlOw/gaY2yLur7Hs+EcMTYV7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I4VeknCBEMbBb6C9KPcBhHASBxIhTw6qrrdtR4h+pOxl8fJOsHgYnOvCTKvfgJR07
	 GFtVK18RXoXY60WnxcWFdPhjTIRepZFfr7EBdSlmbk9mKbrkpTjfP+biUm5OcY4JRj
	 i9GkNWLx6dBQMnKlctpIsArIZ5OUUgDjpVirJLi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 192/523] io_uring: dont use int for ABI
Date: Tue, 26 Aug 2025 13:06:42 +0200
Message-ID: <20250826110929.185846695@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit cf73d9970ea4f8cace5d8f02d2565a2723003112 upstream.

__kernel_rwf_t is defined as int, the actual size of which is
implementation defined. It won't go well if some compiler / archs
ever defines it as i64, so replace it with __u32, hoping that
there is no one using i16 for it.

Cc: stable@vger.kernel.org
Fixes: 2b188cc1bb857 ("Add io_uring IO interface")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/47c666c4ee1df2018863af3a2028af18feef11ed.1751412511.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/io_uring.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -29,7 +29,7 @@ struct io_uring_sqe {
 	};
 	__u32	len;		/* buffer size or number of iovecs */
 	union {
-		__kernel_rwf_t	rw_flags;
+		__u32		rw_flags;
 		__u32		fsync_flags;
 		__u16		poll_events;	/* compatibility */
 		__u32		poll32_events;	/* word-reversed for BE */


