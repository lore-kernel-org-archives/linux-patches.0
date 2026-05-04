Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB3B3DEAC4;
	Mon,  4 May 2026 13:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903110; cv=none; b=SEttq2C7zoUa7ooQuus/jyvD/AhZZXmuuJzIs0mU1qdospmg8vgQe8FiwWmoJvE9jVHJUUyRIfvkJp/kuL4Ymjkr+dezBEdkzCEm1OMQkJH0c+Regpga4uxaYQjTtwVP5xhTBT4BXLeejcBfPFAntdszJBSxVqd6U4c/EHrTbHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903110; c=relaxed/simple;
	bh=A33vXjm09Gh4UwbU0raWqdYSE9Y8TriLzlRhLzaoJFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jba54AFiZloNHEbNObHlXbGNp1TJ5tsfzh+3bYw5db8sJ41nKCkpx9E4t1neKXZen5bEfvxZtJ3hbYOsfa1rz2EQMAhS3ZYt268qLVVJ0VQw0xOc7tdFuNh2PoCj95jNRO++L8vuGI9ZB15WfZ3YK7v0TFcib4i3ggaMJa6mzik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r6zclTh8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r6zclTh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D11C2BCB8;
	Mon,  4 May 2026 13:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903110;
	bh=A33vXjm09Gh4UwbU0raWqdYSE9Y8TriLzlRhLzaoJFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r6zclTh8//YUTKekCPMrgYrbxLLTCcu3m1lN+W8run3T0auUWvMVZKhDaWeQ94N/T
	 Wo6GTiPqTbAm7IyDhJEk6U9HC6LkWOAI73FsN0ZWlr3T2oZ7Qa0UOThO2Npd8NWM81
	 wgsK7l2OFPZ8iYmvTc2duNWsp0GLspgyJtIZk9Xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.0 108/307] io_uring/timeout: check unused sqe fields
Date: Mon,  4 May 2026 15:49:53 +0200
Message-ID: <20260504135146.874658653@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -449,6 +449,8 @@ int io_timeout_remove_prep(struct io_kio
 
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
+	if (sqe->addr3 || sqe->__pad2[0])
+		return -EINVAL;
 	if (sqe->buf_index || sqe->len || sqe->splice_fd_in)
 		return -EINVAL;
 
@@ -521,6 +523,8 @@ static int __io_timeout_prep(struct io_k
 	unsigned flags;
 	u32 off = READ_ONCE(sqe->off);
 
+	if (sqe->addr3 || sqe->__pad2[0])
+		return -EINVAL;
 	if (sqe->buf_index || sqe->len != 1 || sqe->splice_fd_in)
 		return -EINVAL;
 	if (off && is_timeout_link)


