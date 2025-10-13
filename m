Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A626530AD0A;
	Mon, 13 Oct 2025 15:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369526; cv=none; b=bhE3BUcFQwdfrFUL+S8Q65MyZRXmid/OFUjlmvqvgO0WGaiccTdoWfr6bsV+u+JnAoD+aaYxe69TD54ZBufgAlqtxNVCeMGgKi7v3ehgx2+e/KRBvzb7Bmyx1kYc9cg0wd49FlzZbWTPK1r1Qy83OdT1rOB39ozYrHHf8rH2TNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369526; c=relaxed/simple;
	bh=H+jHcfjguSScUxMImuQcwgth0HfB5HRgR3Oe/pVJJm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/un3T3Tjwnjdna7ovN4CUOZRhV5S+07mlDxHQBy16unR5IBDZ00yPEIenQded+PCUbbgaz5lWtK7PmUvhM1u3XKOdmAMPkk3+UNkQZzelhZYXKzOToKAxvK/mw6tC4QamE5Uv7akUjJY+KShUmT5FNJoQLO8eWSh1/WAvhN1Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qDJc0Ezo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qDJc0Ezo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30DC2C4CEE7;
	Mon, 13 Oct 2025 15:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369526;
	bh=H+jHcfjguSScUxMImuQcwgth0HfB5HRgR3Oe/pVJJm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qDJc0EzoSniCPwIOCfkH3fONH3MSit0QQiUY3ZfCD9YZlRnpp/RfCJKMjTXvHi1og
	 Buj60AN2PYKE/jXubuqEjF7fmsJZEQ7Ve7q7nW4L0fRM9W09wYt6tXEg7R7fcQD9mI
	 vRs6KKA9bhsx16EmFHyn2scPSFHbOPPMUf7ao2Ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 278/563] media: st-delta: avoid excessive stack usage
Date: Mon, 13 Oct 2025 16:42:19 +0200
Message-ID: <20251013144421.343069931@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 5954ad7d1af92cb6244c5f31216e43af55febbb7 ]

Building with a reduced stack warning limit shows that delta_mjpeg_decode()
copies a giant structure to the stack each time but only uses three of
its members:

drivers/media/platform/st/sti/delta/delta-mjpeg-dec.c: In function 'delta_mjpeg_decode':
drivers/media/platform/st/sti/delta/delta-mjpeg-dec.c:427:1: error: the frame size of 1296 bytes is larger than 1280 bytes [-Werror=frame-larger-than=]

Open-code the passing of the structure members that are actually used here.

Fixes: 433ff5b4a29b ("[media] st-delta: add mjpeg support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platform/st/sti/delta/delta-mjpeg-dec.c   | 20 ++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/st/sti/delta/delta-mjpeg-dec.c b/drivers/media/platform/st/sti/delta/delta-mjpeg-dec.c
index 0533d4a083d24..a078f1107300e 100644
--- a/drivers/media/platform/st/sti/delta/delta-mjpeg-dec.c
+++ b/drivers/media/platform/st/sti/delta/delta-mjpeg-dec.c
@@ -239,7 +239,7 @@ static int delta_mjpeg_ipc_open(struct delta_ctx *pctx)
 	return 0;
 }
 
-static int delta_mjpeg_ipc_decode(struct delta_ctx *pctx, struct delta_au *au)
+static int delta_mjpeg_ipc_decode(struct delta_ctx *pctx, dma_addr_t pstart, dma_addr_t pend)
 {
 	struct delta_dev *delta = pctx->dev;
 	struct delta_mjpeg_ctx *ctx = to_ctx(pctx);
@@ -256,8 +256,8 @@ static int delta_mjpeg_ipc_decode(struct delta_ctx *pctx, struct delta_au *au)
 
 	memset(params, 0, sizeof(*params));
 
-	params->picture_start_addr_p = (u32)(au->paddr);
-	params->picture_end_addr_p = (u32)(au->paddr + au->size - 1);
+	params->picture_start_addr_p = pstart;
+	params->picture_end_addr_p = pend;
 
 	/*
 	 * !WARNING!
@@ -374,12 +374,14 @@ static int delta_mjpeg_decode(struct delta_ctx *pctx, struct delta_au *pau)
 	struct delta_dev *delta = pctx->dev;
 	struct delta_mjpeg_ctx *ctx = to_ctx(pctx);
 	int ret;
-	struct delta_au au = *pau;
+	void *au_vaddr = pau->vaddr;
+	dma_addr_t au_dma = pau->paddr;
+	size_t au_size = pau->size;
 	unsigned int data_offset = 0;
 	struct mjpeg_header *header = &ctx->header_struct;
 
 	if (!ctx->header) {
-		ret = delta_mjpeg_read_header(pctx, au.vaddr, au.size,
+		ret = delta_mjpeg_read_header(pctx, au_vaddr, au_size,
 					      header, &data_offset);
 		if (ret) {
 			pctx->stream_errors++;
@@ -405,17 +407,17 @@ static int delta_mjpeg_decode(struct delta_ctx *pctx, struct delta_au *pau)
 			goto err;
 	}
 
-	ret = delta_mjpeg_read_header(pctx, au.vaddr, au.size,
+	ret = delta_mjpeg_read_header(pctx, au_vaddr, au_size,
 				      ctx->header, &data_offset);
 	if (ret) {
 		pctx->stream_errors++;
 		goto err;
 	}
 
-	au.paddr += data_offset;
-	au.vaddr += data_offset;
+	au_dma += data_offset;
+	au_vaddr += data_offset;
 
-	ret = delta_mjpeg_ipc_decode(pctx, &au);
+	ret = delta_mjpeg_ipc_decode(pctx, au_dma, au_dma + au_size - 1);
 	if (ret)
 		goto err;
 
-- 
2.51.0



