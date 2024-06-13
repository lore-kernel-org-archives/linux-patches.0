Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBB9A59;
	Thu, 13 Jun 2024 12:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282634; cv=none; b=H9yob07bYxiSxkSaP5zljTweSD1hsbiSC1J0bgzGKS6k92DtOg++cK6p74fZAAzI4YV/U41Y0K+YYI5zCXa8VGVFb88V10JUnxZgqmE9Xjz+wEhMhhnYofe3eccR7lIcdMx0fhUY5Ur37N+xjMlj9sQj8+ZVeV/8bYunj/yFqGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282634; c=relaxed/simple;
	bh=I/nZeepu/Ver9jU8BoIlau4mnGydNnpb6Bg5uBT702o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AF3lcHLfB0j2W+UEn0OpvWycXLghccd5kA2rcxhUqqV2qYnkZz8+dNLyGLJhj0dkI2pY1X+//miUlD9k4ybx3AvA56hgu2yLnotnmKHnBxiSCvjkqyOCzzYwznpNhBLaH+BOZCrRrQdHmNjillysTB0uY11ANwl5Epv7ft5BYIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lGcqPmyg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lGcqPmyg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3DBC32786;
	Thu, 13 Jun 2024 12:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282634;
	bh=I/nZeepu/Ver9jU8BoIlau4mnGydNnpb6Bg5uBT702o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lGcqPmygh+QUN0Q2oaHJ1urEmP9a8msPMhcPy5yRk6A8BjXCa16LZRuVFu5LEeWG8
	 f8VSe6yv8a3oZ3bK7G9iQayY2HCOGJ2VJWPfA6GogTH1YsMvKIG7nFIzSOTXOf2J9W
	 2ZGwGOTml74/UK58r14+q5CjSn2EBzp93HKpgQBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 5.15 343/402] io_uring: fail NOP if non-zero op flags is passed in
Date: Thu, 13 Jun 2024 13:35:00 +0200
Message-ID: <20240613113315.510727831@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

commit 3d8f874bd620ce03f75a5512847586828ab86544 upstream.

The NOP op flags should have been checked from beginning like any other
opcode, otherwise NOP may not be extended with the op flags.

Given both liburing and Rust io-uring crate always zeros SQE op flags, just
ignore users which play raw NOP uring interface without zeroing SQE, because
NOP is just for test purpose. Then we can save one NOP2 opcode.

Suggested-by: Jens Axboe <axboe@kernel.dk>
Fixes: 2b188cc1bb85 ("Add io_uring IO interface")
Cc: stable@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20240510035031.78874-2-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -6621,6 +6621,8 @@ static int io_req_prep(struct io_kiocb *
 {
 	switch (req->opcode) {
 	case IORING_OP_NOP:
+		if (READ_ONCE(sqe->rw_flags))
+			return -EINVAL;
 		return 0;
 	case IORING_OP_READV:
 	case IORING_OP_READ_FIXED:


