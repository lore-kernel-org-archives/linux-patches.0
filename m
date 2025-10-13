Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B115265CAD;
	Mon, 13 Oct 2025 14:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367121; cv=none; b=M5awfP9Mf5HWoAmizUAc2gnHjZrVhpKsXMExsx6TKbw2yVE/EjHQyemIPod2R3Y8R3xnHCSFjFgA5BJJlIa02/4aba7Vd0Pe4g1fe9saEEPNAKnGBX0t2xpwsw2xYfrLm0yuW82cVoxma36pmwE/c+cjxswTPJWtIxVieFva7XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367121; c=relaxed/simple;
	bh=p4WRCroPxbLYC+PBn0efKicAz54qcBzsH6QimDlXj5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwwVwjdn+5o5CQN20v041rYvfhBInDk8seeh6E1UfBa4WkFa/Q7s7b+uMyy5gKwh7N8oftB1j7GhII6giwuzteTSFmNMmrujzTejL6NhdWhby/IKyDrr95tautJFwagIOeUVC42PHVu/GebVrFexqS/mpPm19yi40gKHY4yatGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VGtijXNR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VGtijXNR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5D1C4CEFE;
	Mon, 13 Oct 2025 14:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367121;
	bh=p4WRCroPxbLYC+PBn0efKicAz54qcBzsH6QimDlXj5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VGtijXNRLZjrPsU5j8qe72mlUl90k1GK/omb58E8kkn05PzpG5EtjZi22pAVml2FN
	 d3dxm8OD3kXbg0wjAzVP9AFjUZ2qxjealeF8n9SrWVGWxEUYQ4rQOC1UnKDp9dvfK9
	 wovZffFXoXrpZhcV6KVmp/nddpgSpcfzpcCvFQLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 100/196] media: st-delta: avoid excessive stack usage
Date: Mon, 13 Oct 2025 16:44:33 +0200
Message-ID: <20251013144318.317464279@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



