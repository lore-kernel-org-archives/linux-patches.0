Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9964A3402
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300995; cv=none; b=u5zF/Wt43Bt7ZY2kmsb1U/TogbLoiHINYF2Lo5m2OxwINfITdkWHtAB1F5KVqLHTUhlLvGfJ+ntvAyFY29x+fz7nXDsWBrWCwjfLzQo+ekhncgk6/nzds6De7CkSMwgSVrJ74QqSTTgU05xsahlVVMkhb0bizUFFrEh4OXUPGi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300995; c=relaxed/simple;
	bh=IdhmLKuWOidnkaxRzWz3RCEfg4U/Ju35W0NcPka7ons=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/3+ogx+DZDHNMSSP92G/VjgelFdjQaKoGZxX+CK4sbfjyg43Fqf/dagDW/U4QF4PEAEcBsvYBIpANM7mLSmDtGH5McuFkybhrkCEU8wDnAbPuROh3iRG0O7CYFRQ1MB6SWmtsQz7SDhHxc4iviQ9nkQ6bob+15f7dacOy1dEJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qnloNGlm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qnloNGlm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D68FC19424;
	Sat, 28 Feb 2026 17:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300995;
	bh=IdhmLKuWOidnkaxRzWz3RCEfg4U/Ju35W0NcPka7ons=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qnloNGlm9EyNKufyiI/BnU9K0ufEUCi6n3KHoYmmZR5HBGYTsuZgWmnfrVPSytC0r
	 OJkPNmndZzbOfOFEMEo0V7SLkm8Euon9Nfr+NtGKxgXHqM1wpc6HNF6krJ9DliGKF1
	 CcgBhqE/kamBkSnpTYGOs/TYGwyYmVDRZSKZUNeVHRW6lcTIxccexZWRLnOxhstQCN
	 hRevNAYGzdbhzpaGqktqCc9dpuU2SSqrKfRdisg3nZNoYt2y73dpQtj3AHlRj98OFw
	 vwZDDlB54TCYKm1P1MCayq1ik8GF9jc1aviREdyqC4d+x+H2OfRprK4WK8HDlJAGgU
	 Bv16EH1pZWIzg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 126/752] media: dvb-core: dmxdevfilter must always flush bufs
Date: Sat, 28 Feb 2026 12:37:17 -0500
Message-ID: <20260228174750.1542406-126-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Hans Verkuil <hverkuil@xs4all.nl>

[ Upstream commit c4e620eccbef76aa5564ebb295e23d6540e27215 ]

Currently the buffers are being filled until full, which works fine
for the transport stream, but not when reading sections, those have
to be returned to userspace immediately, otherwise dvbv5-scan will
just wait forever.

Add a 'flush' argument to dvb_vb2_fill_buffer to indicate whether
the buffer must be flushed or wait until it is full.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-core/dmxdev.c  | 8 ++++----
 drivers/media/dvb-core/dvb_vb2.c | 5 +++--
 include/media/dvb_vb2.h          | 6 ++++--
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index 151177e5a06d8..8a9cca6da3e0e 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -397,11 +397,11 @@ static int dvb_dmxdev_section_callback(const u8 *buffer1, size_t buffer1_len,
 	if (dvb_vb2_is_streaming(&dmxdevfilter->vb2_ctx)) {
 		ret = dvb_vb2_fill_buffer(&dmxdevfilter->vb2_ctx,
 					  buffer1, buffer1_len,
-					  buffer_flags);
+					  buffer_flags, true);
 		if (ret == buffer1_len)
 			ret = dvb_vb2_fill_buffer(&dmxdevfilter->vb2_ctx,
 						  buffer2, buffer2_len,
-						  buffer_flags);
+						  buffer_flags, true);
 	} else {
 		ret = dvb_dmxdev_buffer_write(&dmxdevfilter->buffer,
 					      buffer1, buffer1_len);
@@ -452,10 +452,10 @@ static int dvb_dmxdev_ts_callback(const u8 *buffer1, size_t buffer1_len,
 
 	if (dvb_vb2_is_streaming(ctx)) {
 		ret = dvb_vb2_fill_buffer(ctx, buffer1, buffer1_len,
-					  buffer_flags);
+					  buffer_flags, false);
 		if (ret == buffer1_len)
 			ret = dvb_vb2_fill_buffer(ctx, buffer2, buffer2_len,
-						  buffer_flags);
+						  buffer_flags, false);
 	} else {
 		if (buffer->error) {
 			spin_unlock(&dmxdevfilter->dev->lock);
diff --git a/drivers/media/dvb-core/dvb_vb2.c b/drivers/media/dvb-core/dvb_vb2.c
index 29edaaff7a5c9..7444bbc2f24d9 100644
--- a/drivers/media/dvb-core/dvb_vb2.c
+++ b/drivers/media/dvb-core/dvb_vb2.c
@@ -249,7 +249,8 @@ int dvb_vb2_is_streaming(struct dvb_vb2_ctx *ctx)
 
 int dvb_vb2_fill_buffer(struct dvb_vb2_ctx *ctx,
 			const unsigned char *src, int len,
-			enum dmx_buffer_flags *buffer_flags)
+			enum dmx_buffer_flags *buffer_flags,
+			bool flush)
 {
 	unsigned long flags = 0;
 	void *vbuf = NULL;
@@ -306,7 +307,7 @@ int dvb_vb2_fill_buffer(struct dvb_vb2_ctx *ctx,
 		}
 	}
 
-	if (ctx->nonblocking && ctx->buf) {
+	if (flush && ctx->buf) {
 		vb2_set_plane_payload(&ctx->buf->vb, 0, ll);
 		vb2_buffer_done(&ctx->buf->vb, VB2_BUF_STATE_DONE);
 		list_del(&ctx->buf->list);
diff --git a/include/media/dvb_vb2.h b/include/media/dvb_vb2.h
index 8cb88452cd6c2..0fbbfc65157e6 100644
--- a/include/media/dvb_vb2.h
+++ b/include/media/dvb_vb2.h
@@ -124,7 +124,7 @@ static inline int dvb_vb2_release(struct dvb_vb2_ctx *ctx)
 	return 0;
 };
 #define dvb_vb2_is_streaming(ctx) (0)
-#define dvb_vb2_fill_buffer(ctx, file, wait, flags) (0)
+#define dvb_vb2_fill_buffer(ctx, file, wait, flags, flush) (0)
 
 static inline __poll_t dvb_vb2_poll(struct dvb_vb2_ctx *ctx,
 				    struct file *file,
@@ -166,10 +166,12 @@ int dvb_vb2_is_streaming(struct dvb_vb2_ctx *ctx);
  * @buffer_flags:
  *		pointer to buffer flags as defined by &enum dmx_buffer_flags.
  *		can be NULL.
+ * @flush:	flush the buffer, even if it isn't full.
  */
 int dvb_vb2_fill_buffer(struct dvb_vb2_ctx *ctx,
 			const unsigned char *src, int len,
-			enum dmx_buffer_flags *buffer_flags);
+			enum dmx_buffer_flags *buffer_flags,
+			bool flush);
 
 /**
  * dvb_vb2_poll - Wrapper to vb2_core_streamon() for Digital TV
-- 
2.51.0

