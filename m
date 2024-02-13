Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7C15FF04;
	Tue, 13 Feb 2024 17:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845956; cv=none; b=QFBY39hFcMvLKZRU4Sj8CK0inSDusjuDUhXmbI2yZlv66SuDVwd4J8SsqmqBImfkCwVpeLQBUZzv3G9/xlqQUulo/udzCKGJsZVPFd/NyCQaiMaTlNWgI2jPOHxASSP3tkAiS25vUU/mPwCixGTzyKs5gZsR489MBFMGVNOoBk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845956; c=relaxed/simple;
	bh=os8518AXoW3S8LaFW0pXcbcrz/aGJpdj9oZZix/XmLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dnPDDDEMieYsTTcptjpVgRa+T7p7YlpsGC77CVALmb2rf+X4JoPLEr7kRqX/2EUkhq2fS/lLX8da74XDzL8vtxWoYQZOz2CDndBKK0nVv4euS61ISzm28u8o6TLKXGcfGGgMEMEQSVhP2j22HG3XhHpQEhWjdMuHJpTsaisJNSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=esWZkfpx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="esWZkfpx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64DC2C433C7;
	Tue, 13 Feb 2024 17:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845955;
	bh=os8518AXoW3S8LaFW0pXcbcrz/aGJpdj9oZZix/XmLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=esWZkfpx5DyWCopu5yxXtIT3m+C3vs1Hq5UR+tFu2pkRpUlGSwxfCUjZ4ArnfReEj
	 RhHAk9xxyML5uSFYcW9zAayaC04mBoRLGkwtJp3XUBg27hfGTHd+RmwrNalO326LkE
	 8ocoxfWXfmDRIXooRRNwU7vn1J91FSdN0Vwi/I9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.7 105/124] io_uring/net: fix sr->len for IORING_OP_RECV with MSG_WAITALL and buffers
Date: Tue, 13 Feb 2024 18:22:07 +0100
Message-ID: <20240213171856.795785052@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


