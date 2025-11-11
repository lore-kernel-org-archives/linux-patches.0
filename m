Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEE324BBEB;
	Tue, 11 Nov 2025 00:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822753; cv=none; b=gjw3UE9dSuGFDd6WxDsNya5iotB+xv8sNIGnk4DatFo5YRFxCUPGofPS/BVLLLlw2I+kUQXCEcxGw1dGBtBZBRvaPIH4okjEVCSBCyBKf8IAeu1fUVGPfWABM5DbLkYIV3IHpnLCCxFRv116pUC9Kph6f7n5KsYpugnp1k2pOvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822753; c=relaxed/simple;
	bh=i+qqejGiLxe5Bq8fiLuJGzbUP6RRQjOT+yI7EbV3TfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHBF9IaVTEQAhr3k1WsCc/SrAAUOrPC9i+EBMaDo0AEk/Z9TW9V6WuYQWf8K3G9NXWkJp+tbEoMLhJC2rQmUYBGslFBVFiLNYKJKZ7r1QGKOskFGF4BwF8OKDMEwXU2Z2NrdDidj/yI5eKXRqxSxcQYUlhWuKwtreSTw5sbElHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hbl/SD8P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hbl/SD8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CCADC16AAE;
	Tue, 11 Nov 2025 00:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822752;
	bh=i+qqejGiLxe5Bq8fiLuJGzbUP6RRQjOT+yI7EbV3TfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hbl/SD8P8j8OsCI4LeVXqM/wTh9CAAmZv2IRGSruvJ64vCSoewplrXvryA6WMeiVz
	 xvkb8y6AZ+1kRJJ4unLnDC4EgKJCgwoEem+6wvq+54EjXtorexggx5I+x+qR8QHsyX
	 vPBvUnhLOWlf7KKz8k/TC4e4gtHq9Jl91psXR4og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 161/849] io_uring/rsrc: respect submitter_task in io_register_clone_buffers()
Date: Tue, 11 Nov 2025 09:35:31 +0900
Message-ID: <20251111004540.324284278@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit 2f076a453f75de691a081c89bce31b530153d53b ]

io_ring_ctx's enabled with IORING_SETUP_SINGLE_ISSUER are only allowed
a single task submitting to the ctx. Although the documentation only
mentions this restriction applying to io_uring_enter() syscalls,
commit d7cce96c449e ("io_uring: limit registration w/ SINGLE_ISSUER")
extends it to io_uring_register(). Ensuring only one task interacts
with the io_ring_ctx will be important to allow this task to avoid
taking the uring_lock.
There is, however, one gap in these checks: io_register_clone_buffers()
may take the uring_lock on a second (source) io_ring_ctx, but
__io_uring_register() only checks the current thread against the
*destination* io_ring_ctx's submitter_task. Fail the
IORING_REGISTER_CLONE_BUFFERS with -EEXIST if the source io_ring_ctx has
a registered submitter_task other than the current task.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/rsrc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index f75f5e43fa4aa..e1e5f0fb0f56d 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1299,10 +1299,17 @@ int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
 	if (src_ctx != ctx) {
 		mutex_unlock(&ctx->uring_lock);
 		lock_two_rings(ctx, src_ctx);
+
+		if (src_ctx->submitter_task &&
+		    src_ctx->submitter_task != current) {
+			ret = -EEXIST;
+			goto out;
+		}
 	}
 
 	ret = io_clone_buffers(ctx, src_ctx, &buf);
 
+out:
 	if (src_ctx != ctx)
 		mutex_unlock(&src_ctx->uring_lock);
 
-- 
2.51.0



