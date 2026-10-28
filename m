Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214148;
	b=RNRouC93I0xCAIrJWrsmv6nTHOy5C5KEF4U0SBppAvH3/wo2zlGcq+jAy99y4tifFXcD
	 0wlLCgwcr7LsEghKRD/I3VlUTGTODVbvfGv0q08f3MVe2iblwAEf4rP8d4N/LzSno5FgA
	 WuqYXw3VpyGvFEcV6R8RVy+8w0fG8iaPGjtPkFB95VhtKA00qHBpDfJ2VtluQFiBM2fcY
	 G1OkezTZPeay+3HvP0bGHI5UdsMztlT58SsXk0AFHilmZhC9pmNeWkBKG93PcjWTow2W9
	 xAZqpW5W6gCAH1pKkPbwl6ioNgtrK6rlKdHmDyYEXCB2fIad30pyMC/oq/QtdtIWxjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214148;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QijXEXiG9lBI4YyFAEeVnmI2UK7XyY7DI9E+xdyuAxE=;
	b=iDFmVaWZg/bkRJ30jdplLSAfoan0qQ1OQb3sHnSm8zfL89v2l3k6M7k8w7WagW/aekW3
	 mypFV6/VwhOa/P3rk+2Zd9KA8IwL19IROvgFLezGbKEQnXwyl8NXn69gr+aPGP+gzvHZG
	 PF+YOp5KKFxIRXNuEbDiIs165fSCWvMBdbEr9BqyeJlhIguRjOwtjJcG5KQNRb9ygjkyg
	 hQfTC8/SeUM97BgU6Ds6dfGvRBJBpHbGjnHbPeU+Rh/olKkp4WRw3OPBCLY57klKIaHXP
	 RoKzQg04UU2+xKt6DciJK16/4odmkltLJdz6HEYO6cdGnFtvbvXMe9mZau4syN4pIcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eTy6WJIU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D3E606A31F;
	Wed, 28 Oct 2026 19:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eTy6WJIU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC82C1F01825;
	Wed, 28 Oct 2026 19:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214147;
	bh=QijXEXiG9lBI4YyFAEeVnmI2UK7XyY7DI9E+xdyuAxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eTy6WJIUSAxt4MwKq9TGbbbTeWLxSLG+m+L7nWlXztxGS73z+CJvTP7eaAG/F4gx4
	 b3A7i8f/10XF8IVJXSF7EQ92KmO02ppFkF5gBcZMbkiLof32Jof+GyGlOdoskEeSUQ
	 biWMLokMzWBp1GfDDptpxmgHQKYyhE1hMGEpk3nA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Jann Horn <jannh@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0719/1887] udmabuf: fix memory leak on last export_udmabuf() error path
Date: Wed, 28 Oct 2026 17:46:55 +0100
Message-ID: <20261028170515.799465179@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

[ Upstream commit f49856f525acd5bef52ae28b7da2e001bbe7439e ]

In export_udmabuf(), if dma_buf_fd() fails because the FD table is full, a
dma_buf owning the udmabuf has already been created; but the error handling
in udmabuf_create() will tear down the udmabuf without doing anything about
the containing dma_buf.

This leaves a dma_buf in memory that contains a dangling pointer; though
that doesn't seem to lead to anything bad except a memory leak.

Fix it by moving the dma_buf_fd() call out of export_udmabuf() so that we
can give it different error handling.

Note that the shape of this code changed a lot in commit 5e72b2b41a21
("udmabuf: convert udmabuf driver to use folios"); but the memory leak
seems to have existed since the introduction of udmabuf.

Fixes: fbb0de795078 ("Add udmabuf misc device")
Acked-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241204-udmabuf-fixes-v2-3-23887289de1c@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/udmabuf.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index 6277c5b8d1251..3ba3574510743 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -289,7 +289,16 @@ static long udmabuf_create(struct miscdevice *device,
 	flags = 0;
 	if (head->flags & UDMABUF_FLAGS_CLOEXEC)
 		flags |= O_CLOEXEC;
-	return dma_buf_fd(buf, flags);
+
+	/*
+	 * Ownership of ubuf is held by the dmabuf from here.
+	 * If the following dma_buf_fd() fails, dma_buf_put() cleans up both the
+	 * dmabuf and the ubuf (through udmabuf_ops.release).
+	 */
+	ret = dma_buf_fd(buf, flags);
+	if (ret < 0)
+		dma_buf_put(buf);
+	return ret;
 
 err:
 	while (pgbuf > 0)
-- 
2.53.0



