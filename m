Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1372C1A5;
	Mon, 12 Aug 2024 16:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480395; cv=none; b=MqyoaOJLQ5ttMDimEZ4Ekj0gtJliO40MRbDbfxkMzuAKQ74Ci/txuYFyCIMyzvfpLbOxiZ8YAeN8Fgkw184/IEqa9rwXy1lGPXlOMWJFlH5NkDYS862FRoQ3Wn70Zy20xL/hOqio8rmKLe61CxSp9AiUnCXR2jNhkV2PfXw0j80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480395; c=relaxed/simple;
	bh=f25LoB5zDNaHMAeOJPwWrErTrnODdy6dKRjfmtzPGI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1Yd1+/EbYIHOta1d3jVYkJ8ep0gCl9ZIqW0wIJkkQWtwUEcZZxL7M3+jbl+Mq5eLgpsm5oN3ZRaKDgaf81zrZAjVyk2rS4+qWBhuC8L7VA6oRr2jMkuvaJh0DITbNLcV304Y3ndafZzvKvAkExAdiQmQHuQMqpgprlPk23T/HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vI0YK7lt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vI0YK7lt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A715C32782;
	Mon, 12 Aug 2024 16:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480394;
	bh=f25LoB5zDNaHMAeOJPwWrErTrnODdy6dKRjfmtzPGI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vI0YK7lt6ZsoduWCpP+596qmdcGBWQu3v9pRJN7CwDILWetC6vqlmv2mzVx2O5VvL
	 Z8JECAwsmj0olHA9o6fdve/Ce/8rywM/JVBVX1wiXgOlZZOr27bRuBhRZ2CEjrUQ0g
	 MWwIEsxY+gWBeB2R2KUQeYZm1HPfwkryUZ+gGgsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.10 181/263] io_uring/net: dont pick multiple buffers for non-bundle send
Date: Mon, 12 Aug 2024 18:03:02 +0200
Message-ID: <20240812160153.476746305@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 8fe8ac24adcd76b12edbfdefa078567bfff117d4 upstream.

If a send is issued marked with IOSQE_BUFFER_SELECT for selecting a
buffer, unless it's a bundle, it should not select multiple buffers.

Cc: stable@vger.kernel.org
Fixes: a05d1f625c7a ("io_uring/net: support bundles for send")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -591,17 +591,18 @@ retry_bundle:
 			.iovs = &kmsg->fast_iov,
 			.max_len = INT_MAX,
 			.nr_iovs = 1,
-			.mode = KBUF_MODE_EXPAND,
 		};
 
 		if (kmsg->free_iov) {
 			arg.nr_iovs = kmsg->free_iov_nr;
 			arg.iovs = kmsg->free_iov;
-			arg.mode |= KBUF_MODE_FREE;
+			arg.mode = KBUF_MODE_FREE;
 		}
 
 		if (!(sr->flags & IORING_RECVSEND_BUNDLE))
 			arg.nr_iovs = 1;
+		else
+			arg.mode |= KBUF_MODE_EXPAND;
 
 		ret = io_buffers_select(req, &arg, issue_flags);
 		if (unlikely(ret < 0))


