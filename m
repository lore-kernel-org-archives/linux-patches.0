Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A1321D00A;
	Mon, 23 Mar 2026 13:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273936; cv=none; b=DMkq17oS+zkQ0S9CnZvTj7ZhGSBwpi1s+5T9Y+AGj5tOSNOcXDDFia7Y+PuzXth9EYQy5AHzhvDYt1hhco6iubYzcziSczNzGmCrsViSKzau8SI4HUY27buRMhYL+FlM/NpMCdxLfEK2lYprMYQFvY0VNnv7yw4e8AZPxi/KMe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273936; c=relaxed/simple;
	bh=PxiVlIaRW2KicaxEN33twZvgwUDOQ4OwYP36vxwc75s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDWdkBBNUqa1d+qBFcuUo9xr0tuc5rQ3x7Qk2RBUyZyJ5wnbdX0wX/A0Xn5q2bPm+YSXV1+1S9nADPzFRPUHixYU8LP54HXZvfRW41+cJjUv9HvZxsdGyxbwBTyusBPL+jz00jJcTI1+p+2WphAicbATJNdGQTkB/6mIWRbeBBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lzu41ByE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lzu41ByE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56164C4CEF7;
	Mon, 23 Mar 2026 13:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774273936;
	bh=PxiVlIaRW2KicaxEN33twZvgwUDOQ4OwYP36vxwc75s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lzu41ByEdSHjVst7MsFPNSYLEP/0X5AEunjgKa0HoK+Mi3ryPF5DL/wUM05zx9FVY
	 yhfKJjxaGWSGQ++iZpmG6AKqGn6xakhdhfGTej/6owHXrG5ihG2L2ftEKbgEz7aplv
	 WySwzlLeq/64fwnylagUU375vFbQXoydzJ2wvLCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Michaelis <code@mgjm.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.19 056/220] io_uring/kbuf: fix missing BUF_MORE for incremental buffers at EOF
Date: Mon, 23 Mar 2026 14:43:53 +0100
Message-ID: <20260323134506.355298959@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 3ecd3e03144b38a21a3b70254f1b9d2e16629b09 upstream.

For a zero length transfer, io_kbuf_inc_commit() is called with !len.
Since we never enter the while loop to consume the buffers,
io_kbuf_inc_commit() ends up returning true, consuming the buffer. But
if no data was consumed, by definition it cannot have consumed the
buffer. Return false for that case.

Reported-by: Martin Michaelis <code@mgjm.de>
Cc: stable@vger.kernel.org
Fixes: ae98dbf43d75 ("io_uring/kbuf: add support for incremental buffer consumption")
Link: https://github.com/axboe/liburing/issues/1553
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -34,6 +34,10 @@ struct io_provide_buf {
 
 static bool io_kbuf_inc_commit(struct io_buffer_list *bl, int len)
 {
+	/* No data consumed, return false early to avoid consuming the buffer */
+	if (!len)
+		return false;
+
 	while (len) {
 		struct io_uring_buf *buf;
 		u32 buf_len, this_len;


