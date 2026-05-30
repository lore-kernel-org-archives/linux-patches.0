Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D827D3A0E97;
	Sat, 30 May 2026 16:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159948; cv=none; b=dYaflZEfoQHS1O/3wiHsMWv5uol91br+kt1SI+/R9Qir+MLnsuhTyx0jrsiwA0ccibDa11a91or3H9E2t0KId3y5TE8ge01WGH5JJECX7BLDa8NUJSMg86XiJORLbxBLUmLUSPHd+OQ8ywffZxN8kLHGnsykIbEIltBC08TQCzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159948; c=relaxed/simple;
	bh=XoNYS8kruxBu63AD9GJPDN6OEdvjRYUFT5sMS3vvqMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UWug2coFaFu0NYh0BrRDJ6ihsddp0KVzmlBSTY8yGpUjIVc9eP9KKPnzbxoffULPdW3lSnGm2ilKJAPzjyFg2YPzjXuj294kkWzqYeaM8YjvPXOHXCJ9AQbUKEdYyXRl5x33Rmw3DRqBiXChsPk/VbJXD7+TMbFxwib6gp9Q0DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nT2QhszC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nT2QhszC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCDEB1F00898;
	Sat, 30 May 2026 16:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159946;
	bh=OiGfotliX04Qhco/rsR72mVBi7mViJom2m72FNMLYOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nT2QhszCVW7rhB6wB7r9slHSHvep6oVhvauPQ80QUCJ8nJ0b3oC/WNasHePhksEPA
	 HKZzeUlE2M+VIr/rxK+4mOpatiT+Ubkhx+2hwmkI8TPF3pPtDMSqMVPhx3CzQoLhAL
	 3No7JtoKEKlEPtIcVP3WgmoOKSg56oByu5Heh4KI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 204/969] io_uring/timeout: check unused sqe fields
Date: Sat, 30 May 2026 17:55:28 +0200
Message-ID: <20260530160306.111744203@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit 484ae637a3e3d909718de7c07afd3bb34b6b8504 upstream.

Zero check unused SQE fields addr3 and pad2 for timeout and timeout
update requests. They're not needed now, but could be used sometime
in the future.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/timeout.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -394,6 +394,8 @@ int io_timeout_remove_prep(struct io_kio
 
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
+	if (sqe->addr3 || sqe->__pad2[0])
+		return -EINVAL;
 	if (sqe->buf_index || sqe->len || sqe->splice_fd_in)
 		return -EINVAL;
 
@@ -466,6 +468,8 @@ static int __io_timeout_prep(struct io_k
 	unsigned flags;
 	u32 off = READ_ONCE(sqe->off);
 
+	if (sqe->addr3 || sqe->__pad2[0])
+		return -EINVAL;
 	if (sqe->buf_index || sqe->len != 1 || sqe->splice_fd_in)
 		return -EINVAL;
 	if (off && is_timeout_link)


