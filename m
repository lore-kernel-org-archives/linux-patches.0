Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062258;
	b=cBDUDzCdAy4IA4ZIqHCnX3OSLJKD7pQCQ3LxC7Tk4bD9tlF3VSa/RTr1uoV/iY1ygHT1
	 k51SYvOBW3nEzbBOO1vbrS0vA9bVSvLqmzK6FTI0stKHpkUStxMyiyMWziE/NEaIJxdIi
	 aJu6SxHcxHMYDzCKPq4mT1fHXUFtEu1XXiKzWH/nc2TJF//vAYwBdtryZNMhiZlu2b0Zh
	 acUwV/orNSpG4Co0meBWxhJ+74/d4zg56rY4SZymTpIi2+Vj4PkZI2gSXTCa3RwwhIyZb
	 hYVwehWroQy/SEQTguOsOS7B42mIjIuUAJcMHeghjePxkY/DZFCguY/Tup7EhgUqP/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062258;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2ZsoiUO3pv7sZ9zcWAWmwM5WFkG7xzFddSmhgJrLCUY=;
	b=5pbW4u2P9DgGk4tUmzeydhUe7YBLkl+kY+Pgg0yTGLwYnrlDR9KLueUAWz8MLw2wXWd3
	 i43D+zwhdhMmhwpvJWNz338RTV5WZKONt8Zu50hJK9fJvnsAfkZ/+ChWi7/Xx0tQsGQYe
	 7HUE/ppr7n4qv+fb86CyYl57hYLaI1CdFsHn3zSdI+HXAjRF8fXFMy6YWDD1+tpSOkQIK
	 btNuTHNLaArKCSn3jczbiBo3GSzqP+A9VcPWhINivR2ULol1seehZwT64Xu3bmxI/RVZq
	 f3MtC86sYfc96wwY6geoeDIC5kQgHe2acRdqqyMrExNxE80qjShKvq/wrGPhG2Lng/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ewO56Kiv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22B4606EE82;
	Sat,  7 Nov 2026 14:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ewO56Kiv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 718891F008A2;
	Sat,  7 Nov 2026 14:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062257;
	bh=2ZsoiUO3pv7sZ9zcWAWmwM5WFkG7xzFddSmhgJrLCUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ewO56Kivdx8kS4hbpfBtR9TPYJ7JFH4k1XNgi8ScZoxaXV2sMxGuZvQLg3eUGTGni
	 d9lWQscFk98ovPCWXohzd8yrwSyelGSZd+E8FUDjDScq9Nnnbv/cuYxtC1vUzs/Dtz
	 xjrBiTEb527A3UfsFu/YM34Te3Uwq55WptGHKZYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1152/1536] media: vicodec: fix NULL deref on oversized frame
Date: Sat,  7 Nov 2026 08:52:48 -0500
Message-ID: <20261107135030.082188840@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit c657eb609197e289b054bc2c4e86a0fc32dd7ebe ]

job_ready() only honours the is_header_valid() verdict when
ctx->comp_has_frame is set, and comp_has_frame is only set once
comp_size reaches the full frame size. Since the copy is clamped to
ctx->comp_max_size, a header advertising a larger size leaves comp_size
stuck at comp_max_size, so comp_has_frame stays false and the failed
validation is discarded.

Control then falls into the resolution change branch, which calls
update_capture_data_from_header(). That function re-derives info via
info_from_header(), assigns it to q_dst->info and dereferences it as
q_dst->info->sizeimage_mult, with no NULL check of its own.
is_header_valid() does check that same info_from_header() result --
if (!info) return false which is precisely the false verdict
job_ready() discarded above. info_from_header() returns NULL whenever the
header flags resolve to no supported pixel format.

Drop the comp_has_frame conjunct so an invalid header always bails out.
The resolution change path is unaffected, as it is entered with a valid
header. Oversized frames are then rejected by device_process(), which
already returns -EINVAL when comp_frame_size exceeds comp_max_size.

Fixes: 3b15f68e19c2 ("media: vicodec: Add support for resolution change event.")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/vicodec/vicodec-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/test-drivers/vicodec/vicodec-core.c b/drivers/media/test-drivers/vicodec/vicodec-core.c
index 29e9f8db664a4..34bbaca077662 100644
--- a/drivers/media/test-drivers/vicodec/vicodec-core.c
+++ b/drivers/media/test-drivers/vicodec/vicodec-core.c
@@ -650,7 +650,7 @@ static int job_ready(void *priv)
 	 * if the header is invalid the device_run will just drop the frame
 	 * with an error
 	 */
-	if (!is_header_valid(&ctx->state.header) && ctx->comp_has_frame)
+	if (!is_header_valid(&ctx->state.header))
 		return 1;
 	flags = ntohl(ctx->state.header.flags);
 	hdr_width_div = (flags & V4L2_FWHT_FL_CHROMA_FULL_WIDTH) ? 1 : 2;
-- 
2.53.0



