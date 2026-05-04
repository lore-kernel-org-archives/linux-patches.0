Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA2440DFD4;
	Mon,  4 May 2026 13:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903123; cv=none; b=CZtGLStLZUp78zfngBOHj7JrGAyuuHaFsimBBKRwBmRt9tZ4wyrcCCprYPaGRnBjs2Rvz/wGh3JIh8TA2uNh6uFfqKO2zsZwSV+AT/oDNShj+Xuab4f5pL/8FkhTN6Ov3DwaSuzQt74gL2oO0C/m1ZvvXAIj7PGyylKsZqHYrTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903123; c=relaxed/simple;
	bh=eNC64pxZf2uyBGoiwikcbfSaAFYsqrvTeEdD6vKv034=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SkwwXP/7JHAO4sTQ0T6TNoLrmxh0KX99kLzs+4r3zqilObR+G9wr+MblotXG2/iq0VLOJ02OTyf7tJn/55o0xR5d9U1U8zvRI9pfkBWEQV2J+KauOyhCq9OtMuuYOsRebciGOtHqv/wQ9Kp8TJECM6+VRSzgMHXviLBhnZAK94M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qpahb8Ch; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qpahb8Ch"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CD9C2BCB8;
	Mon,  4 May 2026 13:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903123;
	bh=eNC64pxZf2uyBGoiwikcbfSaAFYsqrvTeEdD6vKv034=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qpahb8ChYx86teEc7NCR1alPPLlMtbQ2os44saX93CfPTZ64UsNFm8DH+QNug1r0P
	 6t37zI4d0EZhtA+nGLvePeXL7U4C4uny3urgNplOsH6IO+9W7w2v75hyzkTstEd5Q9
	 s4Fp8X0LJyGuakN1MZJi1zqdJEGc+gisGqn7ZVus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Longxuan Yu <ylong030@ucr.edu>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.0 113/307] io_uring/poll: fix signed comparison in io_poll_get_ownership()
Date: Mon,  4 May 2026 15:49:58 +0200
Message-ID: <20260504135147.058223051@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Longxuan Yu <ylong030@ucr.edu>

commit 326941b22806cbf2df1fbfe902b7908b368cce42 upstream.

io_poll_get_ownership() uses a signed comparison to check whether
poll_refs has reached the threshold for the slowpath:

    if (unlikely(atomic_read(&req->poll_refs) >= IO_POLL_REF_BIAS))

atomic_read() returns int (signed). When IO_POLL_CANCEL_FLAG
(BIT(31)) is set in poll_refs, the value becomes negative in
signed arithmetic, so the >= 128 comparison always evaluates to
false and the slowpath is never taken.

Fix this by casting the atomic_read() result to unsigned int
before the comparison, so that the cancel flag is treated as a
large positive value and correctly triggers the slowpath.

Fixes: a26a35e9019f ("io_uring: make poll refs more robust")
Cc: stable@vger.kernel.org
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Tested-by: Zhengchuan Liang <zcliangcn@gmail.com>
Signed-off-by: Longxuan Yu <ylong030@ucr.edu>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://patch.msgid.link/3a3508b08bcd7f1bc3beff848ae6e1d73d355043.1775965597.git.ylong030@ucr.edu
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -93,7 +93,7 @@ static bool io_poll_get_ownership_slowpa
  */
 static inline bool io_poll_get_ownership(struct io_kiocb *req)
 {
-	if (unlikely(atomic_read(&req->poll_refs) >= IO_POLL_REF_BIAS))
+	if (unlikely((unsigned int)atomic_read(&req->poll_refs) >= IO_POLL_REF_BIAS))
 		return io_poll_get_ownership_slowpath(req);
 	return !(atomic_fetch_inc(&req->poll_refs) & IO_POLL_REF_MASK);
 }


