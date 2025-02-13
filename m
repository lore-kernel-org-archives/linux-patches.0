Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D687C70805;
	Thu, 13 Feb 2025 15:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460842; cv=none; b=QeagFVbIyoAj2ZrNdexYdtevmy+0zF22R/+CKvcUTcTBYqrD8mc5e63a2mX2uBHBs8OpEVZa1BdFn9rOLFTteCNIjSUXVfoV7dnltQTIjvLntgDZfBkONQP5XGEDOTLN6jAQb+b1YOd3Fp754MjihY19lvoZtupXqK8YUF8LQwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460842; c=relaxed/simple;
	bh=oQvTLn5xl6+vuoTViIrr5+nvhZCArB2XC3V7cQOcXGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9UJeAeCOCTXvFTHw/uFQ1eb8QvNPuDYGr/SekaTA1o6oRt7+sg+hVHAW4I3eapDjIYoB7Sq1BBGRI81S7e967sxVuzl5ztupPgkYUz8hPnLiF2v3OvHDmCgHArzGMstpj1hjBRie3EfyI/OBKSWq7h86ajbftmjwkSCzK9/OdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hHp3cK0h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hHp3cK0h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25BE2C4CED1;
	Thu, 13 Feb 2025 15:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460842;
	bh=oQvTLn5xl6+vuoTViIrr5+nvhZCArB2XC3V7cQOcXGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hHp3cK0hfkNzEiidcYK9msHkA9jFYmR4+ixaGqKPD4dDdNV09ClqUzxkoeZnE7o6F
	 UQTTX+Ik14HHQnksujb6vL6uTcxA9jD50nBwaR3I5u8eX/3krovEGDWM/1JcEoOR/t
	 r8HwYqUpW9CBD5giZ3Q444J5EBXg1jMIxthCObRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Ramdhan <ramdhan@starlabs.sg>,
	Bing-Jhong Billy Jheng <billy@starlabs.sg>,
	Jacob Soo <jacob.soo@starlabs.sg>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 6.6 228/273] io_uring: fix io_req_prep_async with provided buffers
Date: Thu, 13 Feb 2025 15:30:00 +0100
Message-ID: <20250213142416.442489926@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

io_req_prep_async() can import provided buffers, commit the ring state
by giving up on that before, it'll be reimported later if needed.

Reported-by: Muhammad Ramdhan <ramdhan@starlabs.sg>
Reported-by: Bing-Jhong Billy Jheng <billy@starlabs.sg>
Reported-by: Jacob Soo <jacob.soo@starlabs.sg>
Fixes: c7fb19428d67d ("io_uring: add support for ring mapped supplied buffers")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1779,6 +1779,7 @@ int io_req_prep_async(struct io_kiocb *r
 {
 	const struct io_cold_def *cdef = &io_cold_defs[req->opcode];
 	const struct io_issue_def *def = &io_issue_defs[req->opcode];
+	int ret;
 
 	/* assign early for deferred execution for non-fixed file */
 	if (def->needs_file && !(req->flags & REQ_F_FIXED_FILE) && !req->file)
@@ -1791,7 +1792,9 @@ int io_req_prep_async(struct io_kiocb *r
 		if (io_alloc_async_data(req))
 			return -EAGAIN;
 	}
-	return cdef->prep_async(req);
+	ret = cdef->prep_async(req);
+	io_kbuf_recycle(req, 0);
+	return ret;
 }
 
 static u32 io_get_sequence(struct io_kiocb *req)


