Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0061DF722;
	Tue,  8 Oct 2024 12:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391264; cv=none; b=sRl6h8Q9K58kTjPF8EWlBSa4d51D4TMG/tyToLJx33dsSUAYbmxvjaySr0aseVfyWeX7ssuYCWNakpfRh4qVmUsXec1F/ws9WAGe9NT61bbidfWmQIXhe5dijjRJ6dRPQoUQDX4CBsGx4/ZnSIiScPcUPxmkDaQtfX6IELH47mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391264; c=relaxed/simple;
	bh=2vES4HwBAf0smykimYpD0QS5kmjJol9d4E/dETpsnvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zuzy3RT4tA6Kqooyxi0RbVjbmd5uFghtxX9NsjUJBPzjlJxOWkEwTnXnjFoSW3mCI4OL+3RzVRyspm75HYVpQ9suzizndg12+2+PGcjoviZh9hNM1fjOckL6jY8k4FqwETbvmVkoZoFqHshCmcWBIirBUSBZdc7R2ZlSThyJarA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ejaBfKsB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ejaBfKsB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89289C4CECD;
	Tue,  8 Oct 2024 12:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391263;
	bh=2vES4HwBAf0smykimYpD0QS5kmjJol9d4E/dETpsnvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ejaBfKsBClxb4LUZ8kcTY4K8ni5kOqqaggjAk0ZE64bEtXzNLva48RZjBBBMcJ2ik
	 FSjz/sPp7xWo+3xmPtaJGnpRw6vuFh2d1xDLH1dfOG441UWwZwWtd5O6zkShVu5A0x
	 wlZvVHdPCcSVensqTgKeNVcOiht2DBJmCD83bb0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 059/558] io_uring: fix memory leak when cache init fail
Date: Tue,  8 Oct 2024 14:01:29 +0200
Message-ID: <20241008115704.541660130@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 3a87e264290d71ec86a210ab3e8d23b715ad266d ]

Exit the percpu ref when cache init fails to free the data memory with
in struct percpu_ref.

Fixes: 206aefde4f88 ("io_uring: reduce/pack size of io_ring_ctx")
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
Link: https://lore.kernel.org/r/20240923100512.64638-1-kanie@linux.alibaba.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 25112cf78e2b3..7a166120a45c3 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -321,7 +321,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 			    sizeof(struct io_kiocb));
 	ret |= io_futex_cache_init(ctx);
 	if (ret)
-		goto err;
+		goto free_ref;
 	init_completion(&ctx->ref_comp);
 	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
 	mutex_init(&ctx->uring_lock);
@@ -349,6 +349,9 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	io_napi_init(ctx);
 
 	return ctx;
+
+free_ref:
+	percpu_ref_exit(&ctx->refs);
 err:
 	io_alloc_cache_free(&ctx->rsrc_node_cache, kfree);
 	io_alloc_cache_free(&ctx->apoll_cache, kfree);
-- 
2.43.0



