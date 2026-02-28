Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C5F3446B0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302051; cv=none; b=ig4FVUy2kvAx8sPzjM3EMfshAB+73ppf+uskIBRj0KEc9w4p7gvOuIeoNsJkD1SwLK7y59UfRtA5lDTyCX0TdMwn6JtHR2CJSoN6NwauzrI7IZwU3sCBLayOXvqk5qmj66zFc7p+Z4f2DxWi1V530T0bisiwrtSC+KRwIZsQP1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302051; c=relaxed/simple;
	bh=B79EG2LYC+euL18wqK1Lt2nJryyy92rN+TCFpVK74Gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIrHDqfGpju8GAM21P2QNw0rxTqZI5n119f8elbER5h3YCO0Q4L0mTtX93NaoelLEn79Y226O889Zd+ZVh5WfOXEuB0MpYuyD2/xp2enV7ch1d0u2N17KKzEyOvXFSuRSJ/hlcj4GzHRKScfmzMbVPx/6gXhGtlVOsIbd+w/eqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jbbf5sB6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jbbf5sB6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764DBC19424;
	Sat, 28 Feb 2026 18:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302050;
	bh=B79EG2LYC+euL18wqK1Lt2nJryyy92rN+TCFpVK74Gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jbbf5sB62maYUmBE54L7reBYUKRfwFZSrA+MQDkPf+UHSxC2fjP3a9irf+Vu9VpnW
	 YqMZ5R3sgQgWLO6w6zy001Sp2MYFx+9Bg0jadLzKPqqV36r9tV8BJeJVZ50RTawZmB
	 ucbpB5sSB3yxOP5jBs8xouN26XJW1CYckDUq8DNODCrk2QkUvenhFR9BtHC1axKDfg
	 AUKSwdLw3FgCnzzACOeY68umj21+qYCzbTZhxm8cazCpYtQT4uPddGMpefBuf72E6c
	 KD+Fz4w4MIV48poxgPs6Gmp0R0rvq9dCynQtw5ZgUpvEAtkNov8jYNjfie6ywCJouh
	 kABNrz29PaKZQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/283] io_uring/sync: validate passed in offset
Date: Sat, 28 Feb 2026 13:02:47 -0500
Message-ID: <20260228180709.1583486-25-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 649dd18f559891bdafc5532d737c7dfb56060a6d ]

Check if the passed in offset is negative once cast to sync->off. This
ensures that -EINVAL is returned for that case, like it would be for
sync_file_range(2).

Fixes: c992fe2925d7 ("io_uring: add fsync support")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/sync.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/sync.c b/io_uring/sync.c
index 255f68c37e55c..27bd0a26500bc 100644
--- a/io_uring/sync.c
+++ b/io_uring/sync.c
@@ -62,6 +62,8 @@ int io_fsync_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EINVAL;
 
 	sync->off = READ_ONCE(sqe->off);
+	if (sync->off < 0)
+		return -EINVAL;
 	sync->len = READ_ONCE(sqe->len);
 	req->flags |= REQ_F_FORCE_ASYNC;
 	return 0;
-- 
2.51.0

