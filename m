Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0084D12E4D;
	Tue, 27 Aug 2024 15:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771379; cv=none; b=f6QIu3IewSgQ6hJ3W4iv8cEx3g5zAvT8cxBsBO8PEobKd0RLY57J9GxTc1pSyUMOl607YDwQOWnI4AI/848NfTSqPRWmMEmf8xyI97G7QTLRdHPN0NqoooUYLinY8/tOVDi9zV/aS70+eMKf5fLPdfdV004Zwrhdjx9r3Upfnkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771379; c=relaxed/simple;
	bh=4z4/k55Dw6hxoXeWJ/eXnvnSQhsZW5zDAnKeqrqSA3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s1MZA9/8xNSiUJfDhytJ/zUA7CwWEyAxFpprPxV4RncINrF9Rg/AECLiDsjiu3kT5pDL1yB3ppidB0yZ9ksBuEJaL22gy/kspWdG1T5YgTIj9dWXfEXIJl5uFqUnY1EmdXIBffU0a2YtHx7GHHG7+Vq3nDbfRMvJXa/YbKThUUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mp1bkcTa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mp1bkcTa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AEA3C4AF1A;
	Tue, 27 Aug 2024 15:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771378;
	bh=4z4/k55Dw6hxoXeWJ/eXnvnSQhsZW5zDAnKeqrqSA3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mp1bkcTavK89gDI+8YRXEic8CikD7QQ89/wCsDzOX8uZEngxSlFdsnm+4xUMtMsg/
	 74cSR6rtJVXA0jvBHejLUoQhqq76hBs/wXG9BW2vfQ9QnKvYuZ+c+p/4VOI6y0tq86
	 LKNljA9JhXtVnvGUwXvXNFWsIQi6utt5S2TTbJbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@toblux.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 129/273] io_uring/napi: Remove unnecessary s64 cast
Date: Tue, 27 Aug 2024 16:37:33 +0200
Message-ID: <20240827143838.313763698@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@toblux.com>

[ Upstream commit f7c696a56cc7d70515774a24057b473757ec6089 ]

Since the do_div() macro casts the divisor to u32 anyway, remove the
unnecessary s64 cast and fix the following Coccinelle/coccicheck
warning reported by do_div.cocci:

  WARNING: do_div() does a 64-by-32 division, please consider using div64_s64 instead

Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
Link: https://lore.kernel.org/r/20240710010520.384009-2-thorsten.blum@toblux.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 84f2eecf9501 ("io_uring/napi: check napi_enabled in io_napi_add() before proceeding")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/napi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/napi.c b/io_uring/napi.c
index 080d10e0e0afd..327e5f3a8abe0 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -285,7 +285,7 @@ void __io_napi_adjust_timeout(struct io_ring_ctx *ctx, struct io_wait_queue *iow
 			s64 poll_to_ns = timespec64_to_ns(ts);
 			if (poll_to_ns > 0) {
 				u64 val = poll_to_ns + 999;
-				do_div(val, (s64) 1000);
+				do_div(val, 1000);
 				poll_to = val;
 			}
 		}
-- 
2.43.0



