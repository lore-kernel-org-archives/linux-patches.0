Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC45726561A;
	Tue, 17 Mar 2026 17:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768103; cv=none; b=astr8biCSkHIAujJr4mhxzOUCPh+Utgj485cb46bgfT4LM36bf6Bk4EPKmKtmqcNmBk9SNAV8ByBpFjecDRhCgIWMoAtz9BnXqHqItZmsfAVh6fZcpmuEyTGAZKDW1gJbSbfjxn1aQimgPYxuRxN8+P3y5QVErQXAxU54JnrWNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768103; c=relaxed/simple;
	bh=pLtlu/KmACZDZr8D6pK0P1fe1rZl51OoAcV99GoNBgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P1tkowSBowQgBAIlE5RRoGYP4I6OI4gV+W7ne/JTVpyqOj/YwEfk8PuXfiGRsIs/QxATpE9qK+lqOBQI8vW3o6y88/47W95rguRK73yr5OX1RfUHKS+KiOcco+FA+9WrZ3h99X7r/TiJ9e69LOe3fZdvjkKupc/3cmny/sfd21k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sYde+Pkw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sYde+Pkw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC9DC19424;
	Tue, 17 Mar 2026 17:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768103;
	bh=pLtlu/KmACZDZr8D6pK0P1fe1rZl51OoAcV99GoNBgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sYde+PkwFmmpt5pERfIzReZKkEXlcdDheePC1tHz0kjBFOA0aPcDXAoLYgeC/1nAU
	 9hVW4IOUcOnVf9Gc2UPvtde12sH2QWdecYZNJhnUMe6D/GtTTR4OUmCpc2JQr6O2PY
	 CilsZ8T9q/wUMlkxCUHn1wVX51VquSdkBoH9R53I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 231/333] io_uring/net: reject SEND_VECTORIZED when unsupported
Date: Tue, 17 Mar 2026 17:34:20 +0100
Message-ID: <20260317163007.932156534@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

commit c36e28becd0586ac98318fd335e5e91d19cd2623 upstream.

IORING_SEND_VECTORIZED with registered buffers is not implemented but
could be. Don't silently ignore the flag in this case but reject it with
an error. It only affects sendzc as normal sends don't support
registered buffers.

Fixes: 6f02527729bd3 ("io_uring/net: Allow to do vectorized send")
Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -376,6 +376,8 @@ static int io_send_setup(struct io_kiocb
 		kmsg->msg.msg_namelen = addr_len;
 	}
 	if (sr->flags & IORING_RECVSEND_FIXED_BUF) {
+		if (sr->flags & IORING_SEND_VECTORIZED)
+			return -EINVAL;
 		req->flags |= REQ_F_IMPORT_BUFFER;
 		return 0;
 	}


