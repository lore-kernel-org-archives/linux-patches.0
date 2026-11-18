Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045297;
	b=hi40XcJxM4BrlX8yXsZneAYiRT+1J3UpU2XEIfYrVWrlL7FLRHxfFJDui+TX3VXe8QOK
	 XkUMotILz5WUt+OxApWeMOhaweLl0gLqY+5I6Ov9RqVmNI/R0sW1vmTm4ex0ANL3RLfel
	 D0KxWdrQiwITdOGmGkvVJmD7moJjvLvQ9IlcZDnV27QErkpts/aogmEVhUITRHM1r6XuF
	 WszYLlOmA64yO+AMmwa9fKdntG/bzUR8kDpy7jFeSHqhB7Zrqr3kLa8mD7VROALstPDN2
	 eK2dCsoZ4klvmeAj+MeTtrwLOwOG+EdTWUh4IHhRzFwc8zqUIJuqo57LJxFFDn0OabQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2IVUq3344DA5JHqpYTCvj4c6TTIhaoPiKx+RrMiSeOI=;
	b=yitdkKygfjvs2jy2q3De6gdL8vO5m04yi8jlpj9KfUA5Q35L3bsbeQMl2KaRisoXFm53
	 ObvKTEWIxxT9H2FCwAAVeJAzmyvpRLwLEghdRf4Jcw9LB/Ra87eTN5hrsQMqStsJzQr9U
	 5GVYU4dvz7fS+nfRGBrrann2Z9vMEVJVxp1EkGVHiNmUSAE1Rl+ra4l3hqNbzFbELENrD
	 IMokhxG9n3h70Q61eVMORrGlYtLsDrzon6PLUNju80Im0Kwouo8ujw640icgsYzCrUVV1
	 g8ESYOrebY5uh6CV8ovaRjPY0QrFvRLrfWICbzLkyvwG3ZQwXdDtDlBb8tkMPayBsGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=okHnXdOX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C45606A339;
	Wed, 18 Nov 2026 23:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=okHnXdOX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250B41F000CC;
	Wed, 18 Nov 2026 23:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045297;
	bh=2IVUq3344DA5JHqpYTCvj4c6TTIhaoPiKx+RrMiSeOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=okHnXdOX5V3A8Y8vC+V3qhUJN3/Oi71xJCVR0qcS7bBkinGx1JyclQpiYzKoMbBOI
	 QWBacIYCkhQ5PAU1hqvKZX1FSp4nS1XKNNFcT2buwGDXQEpKbEEJMs6JpvK5HlIrbR
	 eQpU0sWRMwqS2PEqNQnMPAV104b+DoGqBsEYAOm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0872/2857] media: vicodec: fix NULL deref on oversized frame
Date: Wed, 18 Nov 2026 15:31:46 +0100
Message-ID: <20261118150232.959998589@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index fb55908d9ee96..31e13ea6a7e91 100644
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



