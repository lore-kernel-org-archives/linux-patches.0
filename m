Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6121A00CE;
	Tue, 21 Oct 2025 20:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077148; cv=none; b=svoIfJqAWMoBb/O2aj0RgKTQRRq4GWfj6JyBLrq84bSrdL7F/gw5r/ZQce4a+u59ybnzOXUAJL4bCDQpP/obAnWW9+i40p03qWkV0NOQpGTYeNVI3WfQyNbuWZ9V+0q/ltycelm2mz1d7neDU9HikBVmVJeNqQ740Fe4xBmAIuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077148; c=relaxed/simple;
	bh=6QjOArCs436xuEFPcFxhmg9mpa+jJKScKDLXnHeE+ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EU6Dbql6ecZMtiAp+dV1ZF2hp4aLyBqlPfFS3bq+AjUIyjxKNN7OobFhFxH1hZCKEL80hbTXg1y67ahUd85g6NmEdSRHb42OXFB5TSoj7ZhLBi3e+cP4WLDCa8zeMZA+GFPfMUXZ6/dGu/kwXZTSaQgf7DoV91UUIn+6KbG+c8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UKzbTDxg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UKzbTDxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6623C4CEF1;
	Tue, 21 Oct 2025 20:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077148;
	bh=6QjOArCs436xuEFPcFxhmg9mpa+jJKScKDLXnHeE+ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UKzbTDxgAQwvA13WvLx++wY1qi/XGlDPW9gI4MzVPZtMJMoTwmhisQi4E5jsJskvY
	 dhSxpkWlQH5BYuRg+9dqzVZDDQnN9qINcsXQG0G1LpCPI7uPDAwlzz6Lx9kmoOkGal
	 R8jTFDJVYl1c3TTLNBYoSfWIQ/phn8uyztkxPD5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.17 015/159] io_uring: protect mem region deregistration
Date: Tue, 21 Oct 2025 21:49:52 +0200
Message-ID: <20251021195043.550950943@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

commit be7cab44ed099566c605a8dac686c3254db01b35 upstream.

io_create_region_mmap_safe() protects publishing of a region against
concurrent mmap calls, however we should also protect against it when
removing a region. There is a gap io_register_mem_region() where it
safely publishes a region, but then copy_to_user goes wrong and it
unsafely frees the region.

Cc: stable@vger.kernel.org
Fixes: 087f997870a94 ("io_uring/memmap: implement mmap for regions")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/register.c |    1 +
 1 file changed, 1 insertion(+)

--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -618,6 +618,7 @@ static int io_register_mem_region(struct
 	if (ret)
 		return ret;
 	if (copy_to_user(rd_uptr, &rd, sizeof(rd))) {
+		guard(mutex)(&ctx->mmap_lock);
 		io_free_region(ctx, &ctx->param_region);
 		return -EFAULT;
 	}


