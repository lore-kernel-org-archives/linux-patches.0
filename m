Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58BA2196C7D;
	Thu,  6 Jun 2024 14:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683096; cv=none; b=pWZwByGaN+62XYIa6QQQDuOl7uFCwIlqdzvEG1Q+vde67Aii0awL+hJDnD0NboOSPpUItExzG8/+/fDELh+eMFf4BQZbDALQ9lJrnHWyd3rHy5mHjHnoqj5mc1LMyq4cCwZCr3jdSrFIiv3Kxbrd8Lv6tD3/yhgKlE9YNm8uxt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683096; c=relaxed/simple;
	bh=invqL0T1VoX0RC5bHpt4ltghRCy+FwaMXcujrYQbkS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdsHa3YS+YE7AWFi4ofdJTklSap/dN/wM/QziM8h0YA1eDJWsYX0f7t28wz4LnaHeIRzIkIDyepi5XZPsnIeOKENBXNvYc4iK3OG2rlCUvVQKuicm+Y1R6f/sVU3E/IZVYw37Dt5pAZaYiDvu74/y8uRRY8oqVzTkKLA/s0fdnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SDVToGZr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SDVToGZr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D05C2BD10;
	Thu,  6 Jun 2024 14:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683096;
	bh=invqL0T1VoX0RC5bHpt4ltghRCy+FwaMXcujrYQbkS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SDVToGZrUYFeaC6vSIpNBKReP8KUERw7jBxYFFHkmh8SrVYztBeFsE4BRBETeKNhY
	 QlkTRWthsPWu1hEpP6cyvMZjB68k0RCtRF2iV6kruKOfea7wedBeJ4goJwZAG8qCGH
	 Z/bFJDoQNWm/rIVFV1e1AkOAS25/0U3mjcmpHu74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 6.6 010/744] io_uring: fail NOP if non-zero op flags is passed in
Date: Thu,  6 Jun 2024 15:54:42 +0200
Message-ID: <20240606131732.779586137@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


