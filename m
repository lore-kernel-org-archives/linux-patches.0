Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC7A3C6612;
	Tue, 17 Mar 2026 16:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766585; cv=none; b=clU2Dgyu0cZFAvIKpewvuO4l+m6OJT94+Y/91ZIwkohxmVdZ4Sr1NW0RiE+NO2tp3hUmycv+81R3ESA8op9KFyN+6t9HRC0nHwg2bB2+ae39La4JgAk5iT8Z6WU0xfkjbVACm3ZpoIW1L1SvGvVvXKRsiO9kpV33aLvNriw2eio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766585; c=relaxed/simple;
	bh=p1KCMXP9S0EhXwXDOMH8mTjReu3JCKsx2zOD7gdYiWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pbOEOLG+Ci1zMo0u+fUWUXjmUI/Modzp0L0xMlzm7R2iAjvLWf7bKWcrioxCiuv4/6pdi/msDmDo8hcj4QWFeyH5ZqR5fa2bsQx01KgYTNCx28cPYf/yD0K27Kn2VRDBPLDn7BO0c7+9O/nzqmtwA3BGTWv3+UZn5W75MQFsTHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ykFYtFJy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ykFYtFJy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B149C4CEF7;
	Tue, 17 Mar 2026 16:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766584;
	bh=p1KCMXP9S0EhXwXDOMH8mTjReu3JCKsx2zOD7gdYiWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ykFYtFJyrXNpyaw/CsL3hrYx0/g9djouNsvFs2nYYnB3xYPzXBUdCMtc03x/vhEAT
	 BXpCsdM1aVhD8UEYnwT91EDLAfy9JPiqfAnqVAVBZhcbY9UOw4TN8LWQy5yWxlKI8m
	 MxlPGAtsUW+cNys4yHMWPxu/Na1JXQB3SBbqrzCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.19 278/378] io_uring/net: reject SEND_VECTORIZED when unsupported
Date: Tue, 17 Mar 2026 17:33:55 +0100
Message-ID: <20260317163017.233975173@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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
@@ -375,6 +375,8 @@ static int io_send_setup(struct io_kiocb
 		kmsg->msg.msg_namelen = addr_len;
 	}
 	if (sr->flags & IORING_RECVSEND_FIXED_BUF) {
+		if (sr->flags & IORING_SEND_VECTORIZED)
+			return -EINVAL;
 		req->flags |= REQ_F_IMPORT_BUFFER;
 		return 0;
 	}


