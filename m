Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633B826A082;
	Wed, 23 Apr 2025 15:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422141; cv=none; b=dZ6hQ/cMaaNLP/xJ2JbpY2nCQcY2POsmy4l+aurrom36Q2421/+bPZ9FzSKSSD9bmOlnmbIpsRYgPE7n4ZXbi6+EVTElQmxyoXfJQoGDnkGdZRpVtAiOiUKDttXIJ0TNPO/ioIK1h1meMqB11iPAeCfrMy3U1xD4LbIToRq83ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422141; c=relaxed/simple;
	bh=MAEQMdbfXZPUT5GkwWJV9FT/sLE4VtS9qtox+0vk7Lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOuOCoC7XyuG5So+pfy7Y8AMi2+kHrIrb+Q2zbTUhK5+un/2D+sPYkkPFxy+vRB8jiKw5zMt9YQ4dxtoCDB61JtJ8WXpM+hEjtyBqmjAcLxSZmdl8Bfh7UiTiGjo8EejOBjqsNknWxkQckf1VvSd7Vb6FS+ovhlxOjWFaf9neeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uk0T/cV5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uk0T/cV5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA13AC4CEE2;
	Wed, 23 Apr 2025 15:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422141;
	bh=MAEQMdbfXZPUT5GkwWJV9FT/sLE4VtS9qtox+0vk7Lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uk0T/cV5BlxQnF3RA+bQEhyCWz55m0cyeMhPpd0L5ZSVohJIOIXFvSRB4crGEbdiJ
	 uZNdiT2n2V7OyQZnPVYZBZQEdN1K/Mzk2X30dFCCTM3sS1pKeHh+wiO03Q1QE+D626
	 RJTdr0BnLttVMvx9wOpJhv/j4DsqNOlYukCP6VtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 244/291] io_uring/net: fix accept multishot handling
Date: Wed, 23 Apr 2025 16:43:53 +0200
Message-ID: <20250423142634.390435123@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
User-Agent: quilt/0.68
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

Commit f6a89bf5278d6e15016a736db67043560d1b50d5 upstream.

REQ_F_APOLL_MULTISHOT doesn't guarantee it's executed from the multishot
context, so a multishot accept may get executed inline, fail
io_req_post_cqe(), and ask the core code to kill the request with
-ECANCELED by returning IOU_STOP_MULTISHOT even when a socket has been
accepted and installed.

Cc: stable@vger.kernel.org
Fixes: 390ed29b5e425 ("io_uring: add IORING_ACCEPT_MULTISHOT for accept")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/51c6deb01feaa78b08565ca8f24843c017f5bc80.1740331076.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1391,6 +1391,8 @@ retry:
 		goto retry;
 
 	io_req_set_res(req, ret, 0);
+	if (!(issue_flags & IO_URING_F_MULTISHOT))
+		return IOU_OK;
 	return IOU_STOP_MULTISHOT;
 }
 


