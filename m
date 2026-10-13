Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBBE4EDCB2;
	Tue, 13 Oct 2026 11:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892196; cv=none; b=c4jRL+UfaX7EZevOpCiuk5qXz1ZRqaKFreTnhJR2tfFq+7fs9SfE9ZyN/yKLu+dc1gqv3c19mvnh22Zj78kJYEpCT0sJp/31fETolk1cnwhtlFZ/QqoVY+PNSRwypmAUAX6Q46oe9oc14WZdhHNrSwDZE7e3GQbXJGDbCRqOwxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892196; c=relaxed/simple;
	bh=xiso+3FCjiszQXpqkNJPJSrF5vsqkbIHyvZIWw4r9/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oegTTCypNNZWOZ8FSGucCEZ3JhKX7f9lb5CwDhMd6jqoGh94co2VjnUDQkPN/x4z4nfzVPs+JR/nHuJfMCmJjfAVg4mp6XtiaWSfI9UcTqjHlWk5uVirUMB4ID4vqowU9Og0vL0niPkTd1/CUgeP8zrOqM3/RQp/iVZRpKZUQaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=02S4+Rf+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="02S4+Rf+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B59B1F00893;
	Tue, 13 Oct 2026 11:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892194;
	bh=l5sVkQYnIU5HPHYjYpFNXGFwYTz4B8tQuSKgEOsCLOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=02S4+Rf+WOpWuvGWXaTf9NN7CLqpxYY7LU6C5DEfS3Cf4grjian2vZFQJHipy0z7J
	 eyAGc9Da3eMolJSzd+itES8XVIEx54XTNB9n1DHtrpVyrwCOlIATjfeEILtpm+H8Kw
	 XItMaNbIYQX+W9qY0bjnF8J5g4dO7hTr+1TOpQMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao-Fu Chen <shf.chen@mediatek.com>,
	Jens Wiklander <jens.wiklander@oss.qualcomm.com>
Subject: [PATCH 7.2 093/281] optee: register TEE devices only once fully initialized
Date: Tue, 13 Oct 2026 13:36:49 +0200
Message-ID: <20261013112857.393104805@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shao-Fu Chen <shf.chen@mediatek.com>

commit c108feca0a096f8db25d1b69130035025e9e936d upstream.

optee_probe() called tee_device_register() on both the client and the
supplicant device before the rest of struct optee had been initialized.

tee_device_register() calls cdev_device_add(), which does two things at
once: it creates /dev/tee0 and /dev/teepriv0, and it links the device
into the tee class so that class_find_device() can find it. From that
moment on the device is reachable both from user space via tee_open()
and from kernel space via tee_client_open_context(). The only gate in
teedev_open() is tee_device_get(), which merely checks that
teedev->desc is non-NULL, which was already set by tee_device_alloc().
Therefore, there is effectively no gate at all.

A context opened in that window can run against a struct optee where

  - optee->call_queue.mutex is not initialized by optee_cq_init()
  - optee->supp mutex and completions is not initialized by
    optee_supp_init()
  - optee->rpmb_dev_mutex is not initialized yet,
  - the message argument cache is not initialized by
    optee_shm_arg_cache_init()
  - optee->ctx is still NULL

Any open session or invoke during this window takes uninitialized
mutexes and dereferences a NULL pointer.

Fix it by moving both tee_device_register() calls down to the point
where all of struct optee is set up.

Fixes: 4fb0a5eb364d ("tee: add OP-TEE driver")
Cc: stable@vger.kernel.org
Signed-off-by: Shao-Fu Chen <shf.chen@mediatek.com>
[JW: adding fixes and cc]
Signed-off-by: Jens Wiklander <jens.wiklander@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tee/optee/ffa_abi.c |   16 ++++++++--------
 drivers/tee/optee/smc_abi.c |   17 ++++++++---------
 2 files changed, 16 insertions(+), 17 deletions(-)

--- a/drivers/tee/optee/ffa_abi.c
+++ b/drivers/tee/optee/ffa_abi.c
@@ -1123,14 +1123,6 @@ static int optee_ffa_probe(struct ffa_de
 
 	optee_set_dev_group(optee);
 
-	rc = tee_device_register(optee->teedev);
-	if (rc)
-		goto err_unreg_supp_teedev;
-
-	rc = tee_device_register(optee->supp_teedev);
-	if (rc)
-		goto err_unreg_supp_teedev;
-
 	rc = rhashtable_init(&optee->ffa.global_ids, &shm_rhash_params);
 	if (rc)
 		goto err_unreg_supp_teedev;
@@ -1159,6 +1151,14 @@ static int optee_ffa_probe(struct ffa_de
 	if (optee_ffa_protmem_pool_init(optee, sec_caps))
 		pr_info("Protected memory service not available\n");
 
+	rc = tee_device_register(optee->teedev);
+	if (rc)
+		goto err_unregister_devices;
+
+	rc = tee_device_register(optee->supp_teedev);
+	if (rc)
+		goto err_unregister_devices;
+
 	rc = optee_enumerate_devices(PTA_CMD_GET_DEVICES);
 	if (rc)
 		goto err_unregister_devices;
--- a/drivers/tee/optee/smc_abi.c
+++ b/drivers/tee/optee/smc_abi.c
@@ -1849,14 +1849,6 @@ static int optee_probe(struct platform_d
 
 	optee_set_dev_group(optee);
 
-	rc = tee_device_register(optee->teedev);
-	if (rc)
-		goto err_unreg_supp_teedev;
-
-	rc = tee_device_register(optee->supp_teedev);
-	if (rc)
-		goto err_unreg_supp_teedev;
-
 	optee_cq_init(&optee->call_queue, thread_count);
 	optee_supp_init(&optee->supp);
 	optee->smc.memremaped_shm = memremaped_shm;
@@ -1916,6 +1908,14 @@ static int optee_probe(struct platform_d
 	if (optee->smc.sec_caps & OPTEE_SMC_SEC_CAP_DYNAMIC_SHM)
 		pr_info("dynamic shared memory is enabled\n");
 
+	rc = tee_device_register(optee->teedev);
+	if (rc)
+		goto err_disable_shm_cache;
+
+	rc = tee_device_register(optee->supp_teedev);
+	if (rc)
+		goto err_disable_shm_cache;
+
 	rc = optee_enumerate_devices(PTA_CMD_GET_DEVICES);
 	if (rc)
 		goto err_disable_shm_cache;
@@ -1942,7 +1942,6 @@ err_supp_uninit:
 	optee_shm_arg_cache_uninit(optee);
 	optee_supp_uninit(&optee->supp);
 	mutex_destroy(&optee->call_queue.mutex);
-err_unreg_supp_teedev:
 	tee_device_unregister(optee->supp_teedev);
 err_unreg_teedev:
 	tee_device_unregister(optee->teedev);


