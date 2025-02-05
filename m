Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4057F142E86;
	Wed,  5 Feb 2025 13:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763698; cv=none; b=NjdYTtNIMPiXbKEp6k8LPjHVRsYkqgx9OzavTaq9AIMJThV3wbpVnZYbkHo5lam8A0rQF1n/nf3BDTQhPDsTgEwlJTnci+Lz26v/FtKH9R3fR1MR+z2N7b/4pagMw+JJDy2PxZVuUeQ59cBDEPh9Ezz9eoPqS2BPUaekfP7WI8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763698; c=relaxed/simple;
	bh=UG2vyZwI2YroaGwwp5GNzpT1R8V9kZ1MPV3umKRAzGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GU62CaQiHvtPOhsMlHkJIEB65/gJTYvygDTSpKSKlM5R8mY4r8bvauMPF6HWtVU/mlbiG8BbGqtOSy4IWPpVTpsCSIxyPeAVN9FuVLQhzA3g0dHE5E2V2Tl4vuqy7zlbg5R8m7uyvtvTxPTRijPGkqtmXMGm/uLoNHDw2+ma3GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hoBoiQyf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hoBoiQyf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5680EC4CED1;
	Wed,  5 Feb 2025 13:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763697;
	bh=UG2vyZwI2YroaGwwp5GNzpT1R8V9kZ1MPV3umKRAzGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hoBoiQyfb0J6Wb5qHtUQ5bsAMBXSJFRSF3WwYlBCjbkt1Lc1LgGNVZITz4t4/929D
	 MwsbQrGdts4p/77IIT6vKHPo6HcTsuzNGzSsJKXkpqg35UJXnE9LDol/WZvvm8ugkB
	 HWWCyDNu14BXEpwWb0peCsE80g1N0BP2O0PRUteg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 010/623] io_uring: prevent reg-wait speculations
Date: Wed,  5 Feb 2025 14:35:52 +0100
Message-ID: <20250205134456.623977036@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 29b95ac917927ce9f95bf38797e16333ecb489b1 ]

With *ENTER_EXT_ARG_REG instead of passing a user pointer with arguments
for the waiting loop the user can specify an offset into a pre-mapped
region of memory, in which case the
[offset, offset + sizeof(io_uring_reg_wait)) will be intepreted as the
argument.

As we address a kernel array using a user given index, it'd be a subject
to speculation type of exploits. Use array_index_nospec() to prevent
that. Make sure to pass not the full region size but truncate by the
maximum offset allowed considering the structure size.

Fixes: d617b3147d54c ("io_uring: restore back registered wait arguments")
Fixes: aa00f67adc2c0 ("io_uring: add support for fixed wait regions")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/1e3d9da7c43d619de7bcf41d1cd277ab2688c443.1733694126.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4758f1ba902b9..d062c5c69211b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3233,6 +3233,7 @@ static struct io_uring_reg_wait *io_get_ext_arg_reg(struct io_ring_ctx *ctx,
 		     end > ctx->cq_wait_size))
 		return ERR_PTR(-EFAULT);
 
+	offset = array_index_nospec(offset, ctx->cq_wait_size - size);
 	return ctx->cq_wait_arg + offset;
 }
 
-- 
2.39.5



