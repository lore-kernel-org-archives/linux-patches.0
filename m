Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459A34369A;
	Wed, 25 Feb 2026 01:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982913; cv=none; b=H9HwwbzJcZ3gn/NzjnGOeRejG9cX1eGqyR/SlccsvDA2dhuhFO1HI8rBMn/9G20Ry9HTyClfA3QNuIbo1Z5OXQ0vZZkY1JL4Qgj1UCObbzW4YLZayy7zB36fs9R4TlqCVpPRUc4BLjmogpEQt1cRSE1hwV3ZYqbMVmvPu/lYOCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982913; c=relaxed/simple;
	bh=2dMskO09mWJqMZP9IwXVO8kMXTnTCM3V8sbd0wb/qI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pnhUlQu02IxmBWv+SGzxRC7B2br4YNS0E1fCA4cy6aZK/PqUt1a/Fzg1XyyS2F2PuO2breHSkZVxYPzvXIcIEL0SMKTp/2l/WbSOJScxCQq2ttWrpm1yoCbnhHuyPDSNnTNYClKRwc0JQ286tAp4yHWC9zPE/wLlXNfShuhdCzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Np8di75S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Np8di75S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8862C116D0;
	Wed, 25 Feb 2026 01:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982913;
	bh=2dMskO09mWJqMZP9IwXVO8kMXTnTCM3V8sbd0wb/qI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Np8di75SHy4BGb85ILFpawoLpPihJuRSlqxGD/ITk1XoAfzDb9FFoFsMzeQnPjWR6
	 JupMkhr5eV2FEGsm6mLiqkwDZM5R0KVe+k4Zd98rHmi56ObsPn4WMziwEGq9YXo+QL
	 LCfDXSrQmimh0HL1/hK3x9T0VWDrxLJxpSUm7t4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 067/781] io_uring/kbuf: fix memory leak if io_buffer_add_list fails
Date: Tue, 24 Feb 2026 17:12:56 -0800
Message-ID: <20260225012401.347584957@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 442ae406603a94f1a263654494f425302ceb0445 ]

io_register_pbuf_ring() ignores the return value of io_buffer_add_list(),
which can fail if xa_store() returns an error (e.g., -ENOMEM). When this
happens, the function returns 0 (success) to the caller, but the
io_buffer_list structure is neither added to the xarray nor freed.

In practice this requires failure injection to hit, hence not a real
issue. But it should get fixed up none the less.

Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/kbuf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 796d131107ddb..67d4fe576473a 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -669,8 +669,9 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	bl->buf_ring = br;
 	if (reg.flags & IOU_PBUF_RING_INC)
 		bl->flags |= IOBL_INC;
-	io_buffer_add_list(ctx, bl, reg.bgid);
-	return 0;
+	ret = io_buffer_add_list(ctx, bl, reg.bgid);
+	if (!ret)
+		return 0;
 fail:
 	io_free_region(ctx->user, &bl->region);
 	kfree(bl);
-- 
2.51.0



