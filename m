Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1424844B675;
	Tue, 16 Jun 2026 15:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623702; cv=none; b=hMFQjHaxF8y9vxRt1MsVwWfkznZ4m1nksOe/im0AM7cTlvO6bEgSiFcHmKrFfGCZNIq4FB34dr29kBvWzuYdyr2UPNtCFFaqPrRWe5xSZo8wUdfDHGjomzPTFMnrTPoaK8lwNva3iDOIa54OY9nKjoUqeux5GtKuWpaJ4NwOsTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623702; c=relaxed/simple;
	bh=s2mrYXkcv+RRkEhr2O2XADdTVNQnLMQ9Hk/7RBcePTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBabhqx8l4saYcHwiX+ymHVWEbP0lb9Iu+nRFObM7p2dMdRkclVAz+VOg0/jZUuruIMt3QnaQ3pnNME+BtN3F5QuP0dZKOU25HEww8/DRMboDhy9aokuLisWZRGwxxE2uWJ1e4odCwY0fswOvcZOq0lpwgyF3ayo7rFBtU+f7Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QBCo41pT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QBCo41pT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D386D1F000E9;
	Tue, 16 Jun 2026 15:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623700;
	bh=eg5ESlBtWKSd+Cy/LGRdYCGgwvkXCTmZSp5iywzlpbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QBCo41pTebKk/NgLtSTLDdOFgdY97XInX/Vr/lX8q/PBVGIm4vvn30Yd5m/jzkM3D
	 SzgkYSvCMHs7AY7bBPB+lRmOZm3p/3A42AQJk7jiWPo3uMuj7pZeSlBuTjDYkfZqtr
	 Hdhbkrc4+D0pkID374XNwXGwN+QDzBElBnv1qte8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anders Hedlund <anders.hedlund@windriver.com>,
	Mahesh Rao <mahesh.rao@altera.com>,
	Muhammad Amirul Asyraf Mohamad Jamian <muhammad.amirul.asyraf.mohamad.jamian@altera.com>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 7.0 180/378] firmware: stratix10-svc: Return -EOPNOTSUPP when ATF async unsupported
Date: Tue, 16 Jun 2026 20:26:51 +0530
Message-ID: <20260616145119.852113941@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Amirul Asyraf Mohamad Jamian <muhammad.amirul.asyraf.mohamad.jamian@altera.com>

commit 3e529f57931417120fab700afeef6e49553250d5 upstream.

Add a 'supported' flag to struct stratix10_async_ctrl to indicate
whether the secure firmware supports SIP SVC v3 asynchronous
communication. When the ATF version check in stratix10_svc_async_init()
fails, set supported=false and return -EOPNOTSUPP instead of -EINVAL.

This allows callers to distinguish between "async not supported by this
ATF version" (-EOPNOTSUPP) and "programming error / bad argument"
(-EINVAL), and take appropriate action (e.g. fall back to synchronous
V1 SMC path) rather than treating both as fatal.

Also update stratix10_svc_add_async_client() to return -EOPNOTSUPP
immediately when async is not supported, rather than -EINVAL from the
!actrl->initialized check, so client drivers receive a consistent and
meaningful error code.

This patch is a prerequisite for the following fix and must be applied
together with it to correctly restore functionality on old ATF versions.

Fixes: bcb9f4f07061 ("firmware: stratix10-svc: Add support for async communication")
Cc: stable@vger.kernel.org
Suggested-by: Anders Hedlund <anders.hedlund@windriver.com>
Signed-off-by: Mahesh Rao <mahesh.rao@altera.com>
Signed-off-by: Muhammad Amirul Asyraf Mohamad Jamian <muhammad.amirul.asyraf.mohamad.jamian@altera.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/stratix10-svc.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/stratix10-svc.c b/drivers/firmware/stratix10-svc.c
index e9e35d67ef96..8a4f18602f36 100644
--- a/drivers/firmware/stratix10-svc.c
+++ b/drivers/firmware/stratix10-svc.c
@@ -212,6 +212,7 @@ struct stratix10_async_chan {
 /**
  * struct stratix10_async_ctrl - Control structure for Stratix10
  *                               asynchronous operations
+ * @supported: Flag indicating whether the system supports async operations
  * @initialized: Flag indicating whether the control structure has
  *               been initialized
  * @invoke_fn: Function pointer for invoking Stratix10 service calls
@@ -228,6 +229,7 @@ struct stratix10_async_chan {
  */
 
 struct stratix10_async_ctrl {
+	bool supported;
 	bool initialized;
 	void (*invoke_fn)(struct stratix10_async_ctrl *actrl,
 			  const struct arm_smccc_1_2_regs *args,
@@ -1103,6 +1105,7 @@ EXPORT_SYMBOL_GPL(stratix10_svc_request_channel_byname);
  * Return: 0 on success, or a negative error code on failure:
  *         -EINVAL if the channel is NULL or the async controller is
  *         not initialized.
+ *         -EOPNOTSUPP if async operations are not supported.
  *         -EALREADY if the async channel is already allocated.
  *         -ENOMEM if memory allocation fails.
  *         Other negative values if ID allocation fails.
@@ -1121,6 +1124,9 @@ int stratix10_svc_add_async_client(struct stratix10_svc_chan *chan,
 	ctrl = chan->ctrl;
 	actrl = &ctrl->actrl;
 
+	if (!actrl->supported)
+		return -EOPNOTSUPP;
+
 	if (!actrl->initialized) {
 		dev_err(ctrl->dev, "Async controller not initialized\n");
 		return -EINVAL;
@@ -1562,6 +1568,7 @@ static inline void stratix10_smc_1_2(struct stratix10_async_ctrl *actrl,
  *         initialized, -ENOMEM if memory allocation fails,
  *         -EADDRINUSE if the client ID is already reserved, or other
  *         negative error codes on failure.
+ *         -EOPNOTSUPP if system doesn't support async operations.
  */
 static int stratix10_svc_async_init(struct stratix10_svc_controller *controller)
 {
@@ -1585,10 +1592,12 @@ static int stratix10_svc_async_init(struct stratix10_svc_controller *controller)
 	    !(res.a1 > ASYNC_ATF_MINIMUM_MAJOR_VERSION ||
 	      (res.a1 == ASYNC_ATF_MINIMUM_MAJOR_VERSION &&
 	       res.a2 >= ASYNC_ATF_MINIMUM_MINOR_VERSION))) {
-		dev_err(dev,
-			"Intel Service Layer Driver: ATF version is not compatible for async operation\n");
-		return -EINVAL;
+		dev_info(dev,
+			 "Intel Service Layer Driver: ATF version is not compatible for async operation\n");
+		actrl->supported = false;
+		return -EOPNOTSUPP;
 	}
+	actrl->supported = true;
 
 	actrl->invoke_fn = stratix10_smc_1_2;
 
-- 
2.54.0



