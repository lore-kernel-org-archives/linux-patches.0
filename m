Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B17C38330E;
	Sat, 17 Oct 2026 15:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252651; cv=none; b=tSaRMqijA4MXJzD/5/+y7ZpA0Z/Avzb97mYHOnGYa6bzJ1iLmaFl+b3PI/ESDWrPqDIkgZYwTGeigLWJcKuyzD8NoB0ULNsERwQEdkdpC4Vm+Jo+N5dDX+EtdRIr7IiucDEnpe+Ig+tFjX3/DsExV5u1gX8HWh1WsoiSixIDIRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252651; c=relaxed/simple;
	bh=nukX4Dm+eqXYdC/NZmN292hR4X3Rw/iQGsPhWvTAE+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ydy46wEFBVc8+seAhHpy+6UltXoRH4yPm7Hm9GKY6rgQGLsej7RUMtJglZA03IlUs3sExB2m7FsvWNDDup9PYhVvAmKmpLYY7kkt3RExRnsOhrDj9bafu0m49K6bN1PShdereUyGIuBSGY3UaoIL6aLerREbIQkV9NaW9K2GXMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xC+Gbd6b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xC+Gbd6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0DB81F000C4;
	Sat, 17 Oct 2026 15:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792252650;
	bh=rzebn8F1edr7Ph+61vLM5hNB8RJ8cjzr+9tiIZPJ5cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xC+Gbd6bQ9J8Bv0QSckcbjmjP5fN6YgLBK/XwsU6NfZSuiCCAhyw7kigQtC0ax2gb
	 D3wuQLHFuIHhFlvZbEefxkX7dXZgQfqz2vLLSvY4Nj7UeGGuVIsNoQ58Crr2LRd7ds
	 QBHEPnzXySGRfiwB6sLnlNFEOfxetOBhXSlr2ijg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hengyu Liang <hengyul@cs.unc.edu>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 49/52] io_uring/kbuf: dont charge provided buffer rings to RLIMIT_MEMLOCK
Date: Sat, 17 Oct 2026 17:54:50 +0200
Message-ID: <20261017155106.420415119@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017155104.830766652@linuxfoundation.org>
References: <20261017155104.830766652@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit cde56daf4b93f474dc256dbcc5205035223ae6f5 upstream.

Just like with the SQ and CQ rings, the provided buffer rings were also
not charged against the memlock limit prior to the below mentioned
commit. Restore that behavior.

Fixes: ef62de3c4ad5 ("io_uring/kbuf: use region api for pbuf rings")
Reported-by: Hengyu Liang <hengyul@cs.unc.edu>
Cc: stable@vger.kernel.org
Tested-by: Hengyu Liang <hengyul@cs.unc.edu>
[axboe: 6.18 uses io_create_region_mmap_safe() for the pbuf ring]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/kbuf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 48e599996ab3f..9b9f0d369847c 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -444,7 +444,7 @@ static int io_remove_buffers_legacy(struct io_ring_ctx *ctx,
 static void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl)
 {
 	if (bl->flags & IOBL_BUF_RING)
-		io_free_region(ctx->user, &bl->region);
+		io_free_region(NULL, &bl->region);
 	else
 		io_remove_buffers_legacy(ctx, bl, -1U);
 
@@ -661,7 +661,7 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 		rd.user_addr = reg.ring_addr;
 		rd.flags |= IORING_MEM_REGION_TYPE_USER;
 	}
-	ret = io_create_region_mmap_safe(ctx, ctx->user, &bl->region, &rd, mmap_offset);
+	ret = io_create_region_mmap_safe(ctx, NULL, &bl->region, &rd, mmap_offset);
 	if (ret)
 		goto fail;
 	br = io_region_get_ptr(&bl->region);
@@ -695,7 +695,7 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	if (!ret)
 		return 0;
 fail:
-	io_free_region(ctx->user, &bl->region);
+	io_free_region(NULL, &bl->region);
 	kfree(bl);
 	return ret;
 }
-- 
2.53.0



