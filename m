Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB593ED5C7;
	Tue, 17 Mar 2026 16:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765818; cv=none; b=U3q3foJcVraAWJGKnx4SxKsDdldYjvFuVitB6/KClHj41UcU2fmX2bQkEb7AFJ+wpvWhtazVG3kBvVdrPeSrsHltbMRhA8tk8D7yFkI1FqXUilwwbApnVoFQNth4F+NebF3GP8Kslskxsq1XE6reK3ZUFOsnGdXjXNIBD2lG/wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765818; c=relaxed/simple;
	bh=ceuyEPbLMBkWfBemHn3foMK/OLUdV7av6lTmKJiQxl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mpGsT7UGR3xrIU7ZU8GnDbHunCF89iL81PQwWJ3/SjhtMbfquMuY/Mhv9utDBOzV1CCn3LTnFail2EiOpHw4H/b0JXcyM4sz6fQ1ejJSVxFUNiFdRo0hPMNERNcehRRTBbXa7Qg0XjmY/2Q+SZ2DyeTkK0QYtyCd0ksM2vhnGjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T6a8SnY1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T6a8SnY1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFD1C4CEF7;
	Tue, 17 Mar 2026 16:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765818;
	bh=ceuyEPbLMBkWfBemHn3foMK/OLUdV7av6lTmKJiQxl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T6a8SnY1yIs4F8F063DCah9RtVgkpbWnRaUBzQJZ6ZdSvYuxvPpdlz5/a/nNmtiKE
	 2TMhmj4lKRgzEZ+auaXDDJAO1sAY+eLK2B7/A/34TSJCdh8MvhQ/f2PuCcJrppMgl/
	 9q4np9gtlEZP2zNDLViL5PwfmQxbdpzRt+9dWmjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Ryan <ryan36005@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 102/378] io_uring: fix physical SQE bounds check for SQE_MIXED 128-byte ops
Date: Tue, 17 Mar 2026 17:30:59 +0100
Message-ID: <20260317163010.769802393@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Ryan <ryan36005@gmail.com>

[ Upstream commit 6f02c6b196036dbb6defb4647d8707d29b7fe95b ]

When IORING_SETUP_SQE_MIXED is used without IORING_SETUP_NO_SQARRAY,
the boundary check for 128-byte SQE operations in io_init_req()
validated the logical SQ head position rather than the physical SQE
index.

The existing check:

  !(ctx->cached_sq_head & (ctx->sq_entries - 1))

ensures the logical position isn't at the end of the ring, which is
correct for NO_SQARRAY rings where physical == logical. However, when
sq_array is present, an unprivileged user can remap any logical
position to an arbitrary physical index via sq_array. Setting
sq_array[N] = sq_entries - 1 places a 128-byte operation at the last
physical SQE slot, causing the 128-byte memcpy in
io_uring_cmd_sqe_copy() to read 64 bytes past the end of the SQE
array.

Replace the cached_sq_head alignment check with a direct validation
of the physical SQE index, which correctly handles both sq_array and
NO_SQARRAY cases.

Fixes: 1cba30bf9fdd ("io_uring: add support for IORING_SETUP_SQE_MIXED")
Signed-off-by: Tom Ryan <ryan36005@gmail.com>
Link: https://patch.msgid.link/20260310052003.72871-1-ryan36005@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 63efd60829f37..b10f33eef19da 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2152,7 +2152,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		 * well as 2 contiguous entries.
 		 */
 		if (!(ctx->flags & IORING_SETUP_SQE_MIXED) || *left < 2 ||
-		    !(ctx->cached_sq_head & (ctx->sq_entries - 1)))
+		    (unsigned)(sqe - ctx->sq_sqes) >= ctx->sq_entries - 1)
 			return io_init_fail_req(req, -EINVAL);
 		/*
 		 * A 128b operation on a mixed SQ uses two entries, so we have
-- 
2.51.0



