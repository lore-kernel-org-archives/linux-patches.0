Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702E7394783;
	Thu, 17 Sep 2026 17:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666457; cv=none; b=jLzqstiNo0l6l/VcRuNKvN9MnGVKIRQ4l6p5j70/2EPcvXkllNYXDgQVf+V8Ee6kdgpi74vZvO4+HQGgFK13/sAK9EkvBOOp7bmIs1uGEEbCk+1WKemPLIMmPOHU4zTPWgLG9LV6dp/AJsflMWNrFtUbkgGQwShlReDxyVmR2HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666457; c=relaxed/simple;
	bh=+bfHyJVdW6vOEVlxvLB4RX9b1O/IG8Uh0s+leJMplSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DSITTnU+IjZytxkYY1Ekx+0fIxH/FmLXBaJi815FdOlQey1aQTuSbULyhmNLyUZkA77Wtgj5JypWjTjhFzin1zYPZ+7THmBH06UEmU9bQr71rfD6pu/S+roCqR38SfLrJyuV8z49q11cnCWZtZ6LsY1fq6DW7CRhrhmrJEagoXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LpiG6xd/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LpiG6xd/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B20F1F000FF;
	Thu, 17 Sep 2026 17:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666455;
	bh=fToX1genwaDMBq+NhYgj3sal2FOMoLoC8PRsD1vRZ6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LpiG6xd/v8jbO5GfTXpsyyBRtPaOXqizKwn2Meyl2KOH/d3Ix0gu5sC6HTOXee5SM
	 5E/ZZ9283JUoiBja0er0M6R4ShTPj+G1aags39SGpu8I6okodDS4+xr44u0OSD+P9L
	 WWVhzoR886OoKxWX4b/tV4mxjcXVNFAKRVBIWgt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.18 1043/1250] s390/crypto: Fix use of mutex in atomic context
Date: Thu, 17 Sep 2026 16:13:58 +0100
Message-ID: <20260917151620.347374105@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Harald Freudenberger <freude@linux.ibm.com>

commit d1c44a7d085473173bb360b7218a43699c3f56c7 upstream.

The AES CTR implementation used a mutex to lock one page of exclusive
memory for fast CTR processing. Unfortunately a mutex is not save to
use in atomic or interrupt context. So use a binary semaphore instead
which is save to use in such environments.

Furthermore rework the code to get rid of conditional locking. So
restructure the AES CRT code by extracting the main loop into a
separate function and just give in information about the (locked) page
can be used or not (is not locked).

Fixes: 7988fb2c03c8 ("crypto: s390/aes - convert to skcipher API")
Suggested-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Cc: stable@vger.kernel.org # 5.5+
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/crypto/aes_s390.c |   63 +++++++++++++++++++++++++++-----------------
 1 file changed, 39 insertions(+), 24 deletions(-)

--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -28,14 +28,14 @@
 #include <linux/module.h>
 #include <linux/cpufeature.h>
 #include <linux/init.h>
-#include <linux/mutex.h>
 #include <linux/fips.h>
+#include <linux/semaphore.h>
 #include <linux/string.h>
 #include <crypto/xts.h>
 #include <asm/cpacf.h>
 
 static u8 *ctrblk;
-static DEFINE_MUTEX(ctrblk_lock);
+static DEFINE_SEMAPHORE(ctrblk_sem, 1);
 
 static cpacf_mask_t km_functions, kmc_functions, kmctr_functions,
 		    kma_functions;
@@ -668,46 +668,61 @@ static unsigned int __ctrblk_init(u8 *ct
 	return n;
 }
 
+static int __ctr_aes_crypt(struct s390_aes_ctx *sctx,
+			   struct skcipher_walk *walk, bool locked)
+{
+	unsigned int n, nbytes;
+	int ret = 0;
+	u8 *ctrptr;
+
+	while (!ret && ((nbytes = walk->nbytes) >= AES_BLOCK_SIZE)) {
+		n = AES_BLOCK_SIZE;
+		if (nbytes >= 2 * AES_BLOCK_SIZE && locked)
+			n = __ctrblk_init(ctrblk, walk->iv, nbytes);
+		ctrptr = (n > AES_BLOCK_SIZE) ? ctrblk : walk->iv;
+		cpacf_kmctr(sctx->fc, sctx->key, walk->dst.virt.addr,
+			    walk->src.virt.addr, n, ctrptr);
+		if (ctrptr == ctrblk)
+			memcpy(walk->iv, ctrptr + n - AES_BLOCK_SIZE,
+			       AES_BLOCK_SIZE);
+		crypto_inc(walk->iv, AES_BLOCK_SIZE);
+		ret = skcipher_walk_done(walk, nbytes - n);
+	}
+
+	return ret;
+}
+
 static int ctr_aes_crypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct s390_aes_ctx *sctx = crypto_skcipher_ctx(tfm);
-	u8 buf[AES_BLOCK_SIZE], *ctrptr;
 	struct skcipher_walk walk;
-	unsigned int n, nbytes;
-	int ret, locked;
+	u8 buf[AES_BLOCK_SIZE];
+	int ret;
 
 	if (unlikely(!sctx->fc))
 		return fallback_skcipher_crypt(sctx, req, 0);
 
-	locked = mutex_trylock(&ctrblk_lock);
-
 	ret = skcipher_walk_virt(&walk, req, false);
-	while (!ret && ((nbytes = walk.nbytes) >= AES_BLOCK_SIZE)) {
-		n = AES_BLOCK_SIZE;
+	if (ret)
+		return ret;
 
-		if (nbytes >= 2*AES_BLOCK_SIZE && locked)
-			n = __ctrblk_init(ctrblk, walk.iv, nbytes);
-		ctrptr = (n > AES_BLOCK_SIZE) ? ctrblk : walk.iv;
-		cpacf_kmctr(sctx->fc, sctx->key, walk.dst.virt.addr,
-			    walk.src.virt.addr, n, ctrptr);
-		if (ctrptr == ctrblk)
-			memcpy(walk.iv, ctrptr + n - AES_BLOCK_SIZE,
-			       AES_BLOCK_SIZE);
-		crypto_inc(walk.iv, AES_BLOCK_SIZE);
-		ret = skcipher_walk_done(&walk, nbytes - n);
+	if (down_trylock(&ctrblk_sem) == 0) {
+		ret = __ctr_aes_crypt(sctx, &walk, true);
+		up(&ctrblk_sem);
+	} else {
+		ret = __ctr_aes_crypt(sctx, &walk, false);
 	}
-	if (locked)
-		mutex_unlock(&ctrblk_lock);
+
 	/*
 	 * final block may be < AES_BLOCK_SIZE, copy only nbytes
 	 */
-	if (!ret && nbytes) {
+	if (!ret && walk.nbytes > 0) {
 		memset(buf, 0, AES_BLOCK_SIZE);
-		memcpy(buf, walk.src.virt.addr, nbytes);
+		memcpy(buf, walk.src.virt.addr, walk.nbytes);
 		cpacf_kmctr(sctx->fc, sctx->key, buf, buf,
 			    AES_BLOCK_SIZE, walk.iv);
-		memcpy(walk.dst.virt.addr, buf, nbytes);
+		memcpy(walk.dst.virt.addr, buf, walk.nbytes);
 		crypto_inc(walk.iv, AES_BLOCK_SIZE);
 		ret = skcipher_walk_done(&walk, 0);
 	}


