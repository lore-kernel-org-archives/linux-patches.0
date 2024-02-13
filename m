Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9E65FDDF;
	Tue, 13 Feb 2024 17:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845567; cv=none; b=FNjrlzp5PojUlnJgy3zVBIbxOuA4IQGiln2nhIjh8SwIkNnoS9noxQUZj4E4UcLwb63kglyAq63YjNXJXEOgk5wus3TfxUL0k5/f7IXo6AdN4l5V37FbcWwMfd+x6uRREhgT1FoiC3aPZ31W3Mt+YNAzFP5eaGkroiL2V/e7Fo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845567; c=relaxed/simple;
	bh=6DvIEJQ7cQNB0HrkYxHzhU07II9VkVbEYYxRZhIY1Rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jYz6BlSV6gqzWgGo4You1A0WEsQvFjVhtLsTGKLNZJ4R7gWV6uvg5Jaz3B6+uu+g5O9b/FR3KdtRhOWESGhsQxdqS8o+npiynzg5yEwWKJg5m6opZ1mDX4XqYHYDmJTjU2WaPLBYt1n6xFc/KYwkodAemh/gMUN6rrqs4US/REM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PVIgzi4N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PVIgzi4N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D86AC433F1;
	Tue, 13 Feb 2024 17:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845567;
	bh=6DvIEJQ7cQNB0HrkYxHzhU07II9VkVbEYYxRZhIY1Rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PVIgzi4N02E/trMsRLZb/Wi2O3CgFfVOYKifdhKopCcBsJvl0fkgCXHpgCcJ1tNBj
	 3Bm5o4A0Dicu571hPXdvMu/cp+nyh29A+X9n/WQYMVNGUb8pKKpt8oZP9tw7DFJvqc
	 1WDIyBuknH6lKmw8mFgBB+Q+Je8xim7jHluCIBhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 117/121] io_uring/net: fix sr->len for IORING_OP_RECV with MSG_WAITALL and buffers
Date: Tue, 13 Feb 2024 18:22:06 +0100
Message-ID: <20240213171856.403075045@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 72bd80252feeb3bef8724230ee15d9f7ab541c6e upstream.

If we use IORING_OP_RECV with provided buffers and pass in '0' as the
length of the request, the length is retrieved from the selected buffer.
If MSG_WAITALL is also set and we get a short receive, then we may hit
the retry path which decrements sr->len and increments the buffer for
a retry. However, the length is still zero at this point, which means
that sr->len now becomes huge and import_ubuf() will cap it to
MAX_RW_COUNT and subsequently return -EFAULT for the range as a whole.

Fix this by always assigning sr->len once the buffer has been selected.

Cc: stable@vger.kernel.org
Fixes: 7ba89d2af17a ("io_uring: ensure recv and recvmsg handle MSG_WAITALL correctly")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    1 +
 1 file changed, 1 insertion(+)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -902,6 +902,7 @@ retry_multishot:
 		if (!buf)
 			return -ENOBUFS;
 		sr->buf = buf;
+		sr->len = len;
 	}
 
 	ret = import_ubuf(ITER_DEST, sr->buf, len, &msg.msg_iter);


