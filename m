Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E6F5FF10;
	Tue, 13 Feb 2024 17:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845161; cv=none; b=bas0i7PT6gRYmMgD+grbpBZUsu1BDo8wvbNapDYWiuRonanaegkurWJOE674zT7yxWw8sr76x9q7sQ8CPFIr1+KDyIsXs6+cQGurqKpXoaWE7w5hFdUiVDTHchxf9BG8BOk8BW/EOguffEto3bigQxfvwmWv2js5CSV2nQD41eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845161; c=relaxed/simple;
	bh=nXGqAOJ3vYFZsqaWHAq2v+8VaoWf53fnX0LuHdeD5Hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y6rW05mLedf5TFh2wIb4AL1b+qVyu1+DdRYvB+mS8D/M1NxW5gBWKt9Aku3VrJcbjyzf4mSYWNY6YlHG2TP3agZ2SrvbuGAF4BkS5acCRPV+8Qgh0I8HUXoqfe88LsaCwxe0GyUN1/76Glyd66beBL0wpsrEcqAHh9aHJdnpr3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ds8Wi1tT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ds8Wi1tT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9706C43390;
	Tue, 13 Feb 2024 17:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845161;
	bh=nXGqAOJ3vYFZsqaWHAq2v+8VaoWf53fnX0LuHdeD5Hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ds8Wi1tT1/H1EuN+Xx1KpNKfea9ZFXuqPDQNSJBDemNOGDOOZRT+qjUUpU5pGu5Pa
	 5khYqgVSB157i5z324Yx+V1/eaxDCKqJ3Owes659TElaO/ZkivAvNod0Z73HcFY+fT
	 1CmXWQXTmNRm9X1d7EZ777lu95Y92x8LaYn0WZTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 58/64] io_uring/net: fix sr->len for IORING_OP_RECV with MSG_WAITALL and buffers
Date: Tue, 13 Feb 2024 18:21:44 +0100
Message-ID: <20240213171846.562845992@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171844.702064831@linuxfoundation.org>
References: <20240213171844.702064831@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -875,6 +875,7 @@ retry_multishot:
 		if (!buf)
 			return -ENOBUFS;
 		sr->buf = buf;
+		sr->len = len;
 	}
 
 	ret = import_single_range(ITER_DEST, sr->buf, len, &iov, &msg.msg_iter);


