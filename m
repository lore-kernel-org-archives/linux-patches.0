Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D6D547071;
	Thu, 17 Sep 2026 18:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671088; cv=none; b=Vdnfuu//styFuTLzZ2Bzw0FwxP184osouHjzEEsa/4uT82X4xQ5vsF4wbh+XlZKkhh0HGS2pYB2/IsvajYQcCB2eKCIwTfKrGAlQeNRCZCGVrZmVGk1+Gk3AsYjZ/ReYcHfTRvETJt1s/n7OsuktNekEhgkP4DlLL1IlrPJNux4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671088; c=relaxed/simple;
	bh=R8qKcs/oLGacqAKC1L827wVjQ3U/qYfyUFQ/tWOpGR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ccdWj3klfoR2qI0yIsgvyjydGYRfCdRAgEn2SA0gcY5+HxlkQVyece4ir7q9cL1Iz/BWwgepfEpwB0N48VMmUSwtoDJCyDsICqPJvkMAcVwFZu+CP6I1c4Fu2tYk6F7iOUxLC9pS7e7qjU2FSyOya3sPuFCE2YMmIACzz3uXDuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MSeJkicJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MSeJkicJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B90AD1F00893;
	Thu, 17 Sep 2026 18:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671087;
	bh=tet/BD0qsT0yIYFJqeCMS0FxEIWWMSQLqOjxDcfFWnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MSeJkicJ5KUeKKOaEfbSNGSoHgbkW+rz5MmCXkfRZvsXiuvBUzXxlJqVacP/Nqxa8
	 bfhC54QUfGvcnyZX7nz6qekZoS0LuGIx7Z2hEoEQYF0Btu3CMr2uIiSwY7p0JJ+kGY
	 aZeqVYEuz4xOK5hCsZiTTqHiKHa64ur2TBDdtcC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.12 0863/1102] s390/crypto: Fix skcipher_walk return code handling in aes_s390
Date: Thu, 17 Sep 2026 16:13:26 +0100
Message-ID: <20260917151602.218881173@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harald Freudenberger <freude@linux.ibm.com>

commit 15fa028589c3a2545f0bff355eff06d5844196bf upstream.

The return codes from skcipher_walk_virt() were not properly checked
before entering the processing loops in ecb_aes_crypt() and ctr_aes_crypt().
If skcipher_walk_virt() fails, the walk structure may be in an undefined
state, and attempting to process data could lead to incorrect behavior
or accessing uninitialized memory.

Add proper return code checking to ensure correct handling of the walk
initialization and walk advance and eventually return to the caller
with that return code.

Fixes: 7988fb2c03c8 ("crypto: s390/aes - convert to skcipher API")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Cc: stable@vger.kernel.org # 5.5+
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/crypto/aes_s390.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -236,7 +236,7 @@ static int ecb_aes_crypt(struct skcipher
 		return fallback_skcipher_crypt(sctx, req, modifier);
 
 	ret = skcipher_walk_virt(&walk, req, false);
-	while ((nbytes = walk.nbytes) != 0) {
+	while (!ret && ((nbytes = walk.nbytes) != 0)) {
 		/* only use complete blocks */
 		n = nbytes & ~(AES_BLOCK_SIZE - 1);
 		cpacf_km(sctx->fc | modifier, sctx->key,
@@ -340,7 +340,7 @@ static int cbc_aes_crypt(struct skcipher
 		return ret;
 	memcpy(param.iv, walk.iv, AES_BLOCK_SIZE);
 	memcpy(param.key, sctx->key, sctx->key_len);
-	while ((nbytes = walk.nbytes) != 0) {
+	while (!ret && ((nbytes = walk.nbytes) != 0)) {
 		/* only use complete blocks */
 		n = nbytes & ~(AES_BLOCK_SIZE - 1);
 		cpacf_kmc(sctx->fc | modifier, &param,
@@ -466,7 +466,7 @@ static int xts_aes_crypt(struct skcipher
 	memcpy(xts_param.key + offset, xts_ctx->key, xts_ctx->key_len);
 	memcpy(xts_param.init, pcc_param.xts, 16);
 
-	while ((nbytes = walk.nbytes) != 0) {
+	while (!ret && ((nbytes = walk.nbytes) != 0)) {
 		/* only use complete blocks */
 		n = nbytes & ~(AES_BLOCK_SIZE - 1);
 		cpacf_km(xts_ctx->fc | modifier, xts_param.key + offset,
@@ -594,7 +594,7 @@ static int fullxts_aes_crypt(struct skci
 	memcpy(fxts_param.tweak, req->iv, AES_BLOCK_SIZE);
 	fxts_param.nap[0] = 0x01; /* initial alpha power (1, little-endian) */
 
-	while ((nbytes = walk.nbytes) != 0) {
+	while (!ret && ((nbytes = walk.nbytes) != 0)) {
 		/* only use complete blocks */
 		n = nbytes & ~(AES_BLOCK_SIZE - 1);
 		cpacf_km(xts_ctx->fc | modifier, fxts_param.key + offset,
@@ -684,7 +684,7 @@ static int ctr_aes_crypt(struct skcipher
 	locked = mutex_trylock(&ctrblk_lock);
 
 	ret = skcipher_walk_virt(&walk, req, false);
-	while ((nbytes = walk.nbytes) >= AES_BLOCK_SIZE) {
+	while (!ret && ((nbytes = walk.nbytes) >= AES_BLOCK_SIZE)) {
 		n = AES_BLOCK_SIZE;
 
 		if (nbytes >= 2*AES_BLOCK_SIZE && locked)
@@ -703,7 +703,7 @@ static int ctr_aes_crypt(struct skcipher
 	/*
 	 * final block may be < AES_BLOCK_SIZE, copy only nbytes
 	 */
-	if (nbytes) {
+	if (!ret && nbytes) {
 		memset(buf, 0, AES_BLOCK_SIZE);
 		memcpy(buf, walk.src.virt.addr, nbytes);
 		cpacf_kmctr(sctx->fc, sctx->key, buf, buf,


