Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062825;
	b=v26hSU85OqBjWo0vki+v6533Bd8tOODQVvgXwbdFXygT/JV5zfGRPoCefZW57IfHzyOx
	 eMy3cXmlbY+GK0ggNaQCZYIUAmTqZL6DSCfT/YonISN7GJQ9rthpe8V8MmGryrokZ+vLi
	 gqgeH1/pqtUM4IWIYXxuu1P94rw0ipwj8HXplt1A97/GOQaYlGq/NYVtuhA76FUswtnSG
	 9in92TDkxYMDkhPhyTsAYb1tjdHzcZacw+vYwx/hmPXgUQhtwyWBt8pOVFpZ7Ra0byohj
	 al9b7YeF6dHEcyPHbl2jbc6c4n1UinKcEPFsFBmTL4XnPqgpdNhUYQwTsWrNRqrYNBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062825;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gMqoG3UtVZyMriuAkD63xclXSz32f/amUyRgKKNaBAk=;
	b=gSzGF+pdcNqktA4ApNxzTPokXYGjeNZlQ/GxeRFChUFyxnTtX1kKfmlAbw01jjdT4gtO
	 uK4wS6OnKU80VIOjRXTXmOzNQDER+kIMbmd1FOLF6YKtyoVTE6aIlyEDNoNHCTlgli34K
	 yw9y9Vaiy5YIkvBo2ay/btlhB/St9fFzmeOad36p4JM9f3nOyzkXPzqsXwgxon7VNubkq
	 o+5+xvcgNiiE/O6SBqsQXpQiHXQMO4S2bAIYomG1ryVq+6mcNoA8xrD0oiL1+roQIybnf
	 weyZdR+ZefGRF7DMPqkVWQicH4yyG+Oqf+6ZHnFKqfJX3AA8r1SR83VvaTVD3hmWfmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qLFW6g18;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BB3606A334;
	Sat,  7 Nov 2026 14:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qLFW6g18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EBB11F0089F;
	Sat,  7 Nov 2026 14:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062824;
	bh=gMqoG3UtVZyMriuAkD63xclXSz32f/amUyRgKKNaBAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qLFW6g189JQYEXlECN85FhGWckCww8PLKIF8egZBxR3G0BEQs2o/n8OjuFWRXDrXT
	 1T443pBFRnKAZd09o7KNDeZseEf0WYUyYgh41bQwstg07Ho7rqX9V2zMKVkzEpjLXO
	 cUd2mNUz47I2FSNdTOe7akD9rt3khvL7cGLmpG0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 085/869] media: vicodec: fix out-of-bounds write on under-rounded coded dimensions
Date: Sat,  7 Nov 2026 08:46:07 -0500
Message-ID: <20261107134855.581540486@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit 0183746ebca4c478027e2261b904f844f1443b19 ]

A capture format whose width or height is one more than a multiple of 16
makes the FWHT codec write one 8x8 block row, or column, past the end of
the capture plane, and read the same block out of the reference frame for
P-coded frames.

vic_round_dim() is documented to round a frame dimension up so that both
the luma and the chroma plane end up a multiple of 8, but it only rounds
the chroma plane:

	round_up((dim) / (div), 8) * (div)

For div == 2 the result is a multiple of 16 in every case but one: when
dim % 16 == 1, dim / div is already a multiple of 8 and the macro returns
dim - 1. encode_plane() and decode_plane() round the same dimension with
round_up(dim, 8), which yields dim + 7 -- one block more than the coded
dimension that sized the buffer.

On a KASAN-enabled kernel, a 641x360 YUYV P-frame triggers:

  BUG: KASAN: slab-out-of-bounds in add_deltas+0x450/0xcc0
  Read of size 1 at addr ffff888009070800 by task trigger_bin/70

  Call Trace:
   add_deltas+0x450/0xcc0
   decode_plane+0x1916/0x3390
   fwht_decode_frame+0x173/0x620
   v4l2_fwht_decode+0x751/0x1120
   device_run+0x6bb/0x1850

Round the dimension itself up to a multiple of 8 * div. The rounding
changes only for div == 2 and dim % 16 == 1, and MAX_WIDTH and MAX_HEIGHT
are both multiples of 16, so the rounded value still fits the advertised
limits.

Fixes: 3b15f68e19c2 ("media: vicodec: Add support for resolution change event.")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/vicodec/codec-fwht.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/test-drivers/vicodec/codec-fwht.h b/drivers/media/test-drivers/vicodec/codec-fwht.h
index 0eab24020e9e6..4b4d390310899 100644
--- a/drivers/media/test-drivers/vicodec/codec-fwht.h
+++ b/drivers/media/test-drivers/vicodec/codec-fwht.h
@@ -61,7 +61,7 @@
  * both luma and chroma components resolutions are rounded up to
  * a multiple of 8
  */
-#define vic_round_dim(dim, div) (round_up((dim) / (div), 8) * (div))
+#define vic_round_dim(dim, div) round_up(dim, 8 * (div))
 
 struct fwht_cframe_hdr {
 	u32 magic1;
-- 
2.53.0



