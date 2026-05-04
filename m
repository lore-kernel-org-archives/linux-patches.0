Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D088A3D8129;
	Mon,  4 May 2026 14:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904601; cv=none; b=RfqtYgo+iBTnKc9cDWiaHqWCXSzpQnm8WYvmtrSGoTip/v+8xkfDe3u2HbTyFm5uXzQaOZY83LlyaS6YqGn3zL47aCvjzb+yELAQARKS2Kj+qM6qIU/F2TektpvmPQI22C+jtxUnr8ar7WGg26/BidHxk5SiLLEJyLeuietf+qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904601; c=relaxed/simple;
	bh=kSbwmID0A9W1F88hPAgxEDtLG6cSISQ9lCjYiVK945k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D5523WgmU1goIDcncVfoLOi+B9fdP9yEnfK6AUEdgM+a8ii1qs01zakHqk7HCuPzFu+fc6dJUL+qLJ/yFG0viJNXhtscmq6sPR1EN9fBnoyVoG8NcQP+TAq83Sa5kBPIiqR7AyOTfaO3oyLtbrFVTDdlxhQ0B2opqTTA9Z+DJd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n0YC/PjE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n0YC/PjE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6633DC2BCB8;
	Mon,  4 May 2026 14:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904601;
	bh=kSbwmID0A9W1F88hPAgxEDtLG6cSISQ9lCjYiVK945k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n0YC/PjExgJdY6UIU+ao2ISQOhqa1BvW2bVChsYetVO70YkrY4ZSqKOdfjRyzKUiU
	 GAvCUelAfR6KTpFC1qrZzB0TwSy4geTWAmue3qnYoprFlOgfo2CEJHTfDQNfnT6O5n
	 ET/3zzfSLMMRNkvEsudegdSyQu7Q+ECUhRvUT1q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 070/215] io_uring/timeout: check unused sqe fields
Date: Mon,  4 May 2026 15:51:29 +0200
Message-ID: <20260504135132.726420698@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -424,6 +424,8 @@ int io_timeout_remove_prep(struct io_kio
 
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
+	if (sqe->addr3 || sqe->__pad2[0])
+		return -EINVAL;
 	if (sqe->buf_index || sqe->len || sqe->splice_fd_in)
 		return -EINVAL;
 
@@ -496,6 +498,8 @@ static int __io_timeout_prep(struct io_k
 	unsigned flags;
 	u32 off = READ_ONCE(sqe->off);
 
+	if (sqe->addr3 || sqe->__pad2[0])
+		return -EINVAL;
 	if (sqe->buf_index || sqe->len != 1 || sqe->splice_fd_in)
 		return -EINVAL;
 	if (off && is_timeout_link)


