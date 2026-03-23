Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81A823BCFD;
	Mon, 23 Mar 2026 14:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274651; cv=none; b=euGXTPhX+PwmXPwgQoC/hOGHku1WgCjfc1veT+eFVfrY2v00kdNPBIcEv3ZG93i+n8s2L/QMdNzI6/uiyrgc0i6e0so1/9elymlVcH1ot2mkG+9Pkx06M5iKhW2o/dabb9tNkvKkAE9ULV0T/zDa5/97ojrbgo1NMxhfFTNW9MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274651; c=relaxed/simple;
	bh=Lx2mbXY7dhAwlsosoarQgKrzvgONZyGeJRW9GOHjHr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILmuHuntmSCpVxoFzhMBAoyKncgu8vY2FMPiAMDFGdwOWjgD/0fA+JifBK4YWTY5SAN90w2S2Vzvb0wF0hWpN4h7KZIcor0ljZ0m2qW+sCvzGqwFiVNd/13yUlGU0Pvw9iHpXrXShNCmfVAVzOAFjDWAewOsXD9S8WPnAM+bJlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fef1YVlK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fef1YVlK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9DFC4CEF7;
	Mon, 23 Mar 2026 14:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274651;
	bh=Lx2mbXY7dhAwlsosoarQgKrzvgONZyGeJRW9GOHjHr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fef1YVlKeY1+ZVlyG6oygCO7scwKF5GM9JFE8xzSnYeOUokr9T907TRqFI93775xG
	 qEM+sBZDw0xRTSch/Aq36M7+jIqVYeNO4ywzszTPtC0cWM39/2V1f6/WIUWF+z6NL2
	 TdHEIIJiT54nVGi9vfeoO+fIM7QJ49VNO37Z03xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Michaelis <code@mgjm.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 064/212] io_uring/kbuf: fix missing BUF_MORE for incremental buffers at EOF
Date: Mon, 23 Mar 2026 14:44:45 +0100
Message-ID: <20260323134505.801464198@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


