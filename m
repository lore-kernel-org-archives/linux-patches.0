Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651DE305669;
	Fri, 15 May 2026 15:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860725; cv=none; b=Rc0GNqiM54WEh94eEx74RqG9P9FCHQHV7+9XhtnK3L9BKcmU+vSG8qHbXBWgRTd+/wz0hT+d5VUaka819YfPOQY+Pvub84WKQl9hAhV7tT3LO5mYDMwR/NDnPssIF/vpn4JXDqIQdPOxNOl8XAPwZ9ZbuDpBCKH30K/140AQ/Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860725; c=relaxed/simple;
	bh=/zaCmqzVF5+fDFSQwmDjDthToPcLLKQmb7G4Bc9uWMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/b5xWE8FJDEnEOn0VyJ8GTCoJe6E+FW3FybSdP/R786wsnBIpMF/QoiFspx67zrM9h3clKzMqjXNEQVEubyDn0gzPWtbSIHyW1jzAdUyTKhV4FNyeTsNdXsT4ZiZnmOD+qZCLW4QK1+ySQDcu3u032bYFYJiP+AtCb3yw6evfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HEUbcz+a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HEUbcz+a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE364C2BCB0;
	Fri, 15 May 2026 15:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860725;
	bh=/zaCmqzVF5+fDFSQwmDjDthToPcLLKQmb7G4Bc9uWMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HEUbcz+atefNFCvkhexGtfgbLWrC2lsn+MtCxHWAP0Y7AjfjuQ7QsNu3ODKLOEe4h
	 uxtorNGm4Rh3q0E8tk3HA0YKMWqzze4TypeyP0WC933SoQa69sF1ffsTkTbglN/DUY
	 SPEvbmSzzFuKqhfmK1Kl8NbPdnmsiPTin6UQ9Et4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 054/474] io_uring/timeout: check unused sqe fields
Date: Fri, 15 May 2026 17:42:43 +0200
Message-ID: <20260515154716.215667918@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -428,6 +428,8 @@ int io_timeout_remove_prep(struct io_kio
 
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
+	if (sqe->addr3 || sqe->__pad2[0])
+		return -EINVAL;
 	if (sqe->buf_index || sqe->len || sqe->splice_fd_in)
 		return -EINVAL;
 
@@ -500,6 +502,8 @@ static int __io_timeout_prep(struct io_k
 	unsigned flags;
 	u32 off = READ_ONCE(sqe->off);
 
+	if (sqe->addr3 || sqe->__pad2[0])
+		return -EINVAL;
 	if (sqe->buf_index || sqe->len != 1 || sqe->splice_fd_in)
 		return -EINVAL;
 	if (off && is_timeout_link)


