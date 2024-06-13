Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0325C144D28;
	Thu, 13 Jun 2024 12:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281566; cv=none; b=ZaWdM0rafKJQzu624/IhdpQd5JYjrj6ARwd3VNgfdgapJZ/msEz+lBWyurW7vKIE91oXJ4b4EtBA1TDpxz2BDppMwd6gSSaO+Q1QqqFiOaHKxRYlNdAM7uV5QOJJd/cmj5GmxtEZPdqWZa04aisVgTzfnRCRgPbt79aNwfnukMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281566; c=relaxed/simple;
	bh=dEgkLC9R/zecjOYUtFzehZ5SNLCmlLR1LZYXt/7KITQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJXLDwlZnwIltTTFwzARZg7M8g/E+8lz89MV0tcnEQ06o03vIsvXWCGK9653m6O5952V+xFeKdm5g4jyQxUzI7c4SvqQbE/PnYxHvXhgRkey0cWgTseFOp9zxqyclHEBoFz/45ScvUn8TLv/n9X+6uWqVHr6y+cjoMsRy1nqPVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ajj5TKFL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ajj5TKFL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D29DC2BBFC;
	Thu, 13 Jun 2024 12:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281565;
	bh=dEgkLC9R/zecjOYUtFzehZ5SNLCmlLR1LZYXt/7KITQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ajj5TKFLr0TMyGtEujLq4dJLa3VnrWN5Ar3SYC+P2QRBFTJZsbk6vvbIGteNDYM87
	 n3NY+aiOFbPe5ZAwqFy5RBNwEACX4Ee6YMnaeJbH2j6rBxUlz4+ROR5gojGhqqqKnt
	 L9iXDWE3OcPeCA1RDbzzv3PGDz2xAG5xM2j1oaOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 5.10 268/317] io_uring: fail NOP if non-zero op flags is passed in
Date: Thu, 13 Jun 2024 13:34:46 +0200
Message-ID: <20240613113257.919652625@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6474,6 +6474,8 @@ static int io_req_prep(struct io_kiocb *
 {
 	switch (req->opcode) {
 	case IORING_OP_NOP:
+		if (READ_ONCE(sqe->rw_flags))
+			return -EINVAL;
 		return 0;
 	case IORING_OP_READV:
 	case IORING_OP_READ_FIXED:


