Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DC419FA88;
	Thu,  6 Jun 2024 14:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683136; cv=none; b=QnPLDSltS4cO3p7f3lGNopC8ZznP5AqqxbI4b75FIMyMmT+6Xs/xhy0X4hpdIRKXjLxYQs1PIrYctDY9M/I5WCa6l1CBQjZn9tQIJwwGO4mJkPCWI9nHdYCyakUlgCRmHPjf+gHLRWTyNifnQ1q3fcK84s7faDbQsGoh1o9HqwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683136; c=relaxed/simple;
	bh=X2LUCwWcrWczqVgKNU/e4l7ca8w/YtJspmS0h7Vyprw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DWG2gzQUS+fwcvGDmExGUT61iOn/pMEIcPBEqr/MgNISXV/TXdOGK/Bu1K9i3XdxjeFVap1TS8p0/48eMaMRA2yaveWErszeD9FXCyOPcSEJYk2BYfmyEzNc3vrWWDC5qf0Al4qY5qENYtZGr8jBRO9WsKBKOnyJhEdVFkDJpjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tBekq1Ek; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tBekq1Ek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16719C2BD10;
	Thu,  6 Jun 2024 14:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683136;
	bh=X2LUCwWcrWczqVgKNU/e4l7ca8w/YtJspmS0h7Vyprw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tBekq1Ek+iM3N/3chGyLfYuQn057ZWf66Wi/jUMBisVkPWwhNkvlzByyRf/uuL+ko
	 G9yRGrORAjk//N60KfI4DQD/AUwyw2WLjAmt3F7Z5bgyCGqw1NHGFlWzFyxAS0BwBg
	 SJwzv/JiPM4tbMSvk7D3FD+sojOJtZnCxstfgrMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 6.1 008/473] io_uring: fail NOP if non-zero op flags is passed in
Date: Thu,  6 Jun 2024 15:58:57 +0200
Message-ID: <20240606131700.090781205@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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
 io_uring/nop.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/io_uring/nop.c
+++ b/io_uring/nop.c
@@ -12,6 +12,8 @@
 
 int io_nop_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
+	if (READ_ONCE(sqe->rw_flags))
+		return -EINVAL;
 	return 0;
 }
 


