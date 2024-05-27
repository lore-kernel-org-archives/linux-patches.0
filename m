Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2D9168C4;
	Mon, 27 May 2024 19:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837441; cv=none; b=Ek6t1/j4ZDsWg93M1i77sGr2PVzJxTuJyvyBtQlrlXsJiBAwmvEWTEH60xMlSphSilUwEZz3LRLxuTprTcARoS5inLRQ41t4SyAIKYExsH/O5pmWVUyvrR6Ky5z2wgpstL4QJ520Pz3eESHbF0uAEmVm3BsCYAnrmnE9eiy+SFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837441; c=relaxed/simple;
	bh=YxB2uof3gcoaiRWbuaJR4AkTQDOEoFCyz01yUchT7Xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GvA7c+p+E0g8mXWsoL1RvQdBhNrcJ7TKs7Y7GTnvdffPehENlV5PdFI2NQUromMerc9oHqCWXRFr95IRWitttYtT0MbvaZ22z/qEHi05qhp0EP33kftjfhJtrOkyxZYAiqaj1ZVepMxAkJYTB7kglPg9rUwLpj0CNvRkYicDS7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YLJRP8Ei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YLJRP8Ei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45E8C2BBFC;
	Mon, 27 May 2024 19:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837441;
	bh=YxB2uof3gcoaiRWbuaJR4AkTQDOEoFCyz01yUchT7Xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YLJRP8EineMTeZ8hBJ+IWyYZUORnCPmV3Ck7qfcz6kNcA7ICEHZHcok3MoTxETEYs
	 TPXJcEibcSpDnF+68mBfuHWkBRP22jf/yCfq9VybMX/WfwA3CrpxpUethe7QmGbhqW
	 68fVSfuFcJFcHTf5vbasWkLyG+Ia9PKDzIjnGvY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 6.8 015/493] io_uring: fail NOP if non-zero op flags is passed in
Date: Mon, 27 May 2024 20:50:17 +0200
Message-ID: <20240527185627.992355247@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
 


