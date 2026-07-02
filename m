Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F46E348C4C;
	Thu,  2 Jul 2026 16:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010678; cv=none; b=VEDF8leQDZS6iUO/5w1Y5AFxl1NQCt8GcjgrPEbDFoy81FF4LsCCsmoSx/jKXPzXIrYYjk/O6jomyn10Knm0GrsQAscWVeOnPYP8qOGVfjby7m2uanFc+SNq3T8n3Wu7zzVOzObeB6VIO+qXlFhg3tvjwa4xJWESsloqRl3c/yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010678; c=relaxed/simple;
	bh=rhkq13umY3BesztJZ5QPnhUnGIfBiwcFnSp/ddI6GvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q8GAgGA0pQANuRU+HQPC2dcJWZXeUMJ3+v51UVyjNbQYs6U18fhQhI1/1zdq7+NUKc8HSA0LNkBRpbqf+3WzatEXBBew95dFSbVDiqi5R0A4n4IBC7fG2SJzVb6UifcG9i11FdXCz3ANjyfKBtOiQ348Op2hgVfVA5bSYb6/D5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G8cHud6P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G8cHud6P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855FA1F000E9;
	Thu,  2 Jul 2026 16:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010677;
	bh=aBLbFP07hcMsVsTElmr1+gT9T8tv2P0erjYQ1YnN9Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G8cHud6PokIsu1ZTaIUXFGhiDGZOLL+VGmzSZACYCxTo7V1CyVLEcrR8egJ/B18Lq
	 JP7WB8/U+RnHuJ7lvNzi/xCKlJ4z9Ip++EcNcysdjFKC6g5cObm5PUQnDP+Lyo5kgn
	 34LICnKSfOMw8hUecr/abSYLqQ8nO6cfpQo4690s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 198/204] crypto: qat - Return pointer directly in adf_ctl_alloc_resources
Date: Thu,  2 Jul 2026 18:20:55 +0200
Message-ID: <20260702155122.812366877@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 5ce9891ea928208a915411ce8227f8c3e37e5ad9 ]

Returning values through arguments is confusing and that has
upset the compiler with the recent change to memdup_user:

../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c: In function ‘adf_ctl_ioctl’:
../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c:308:26: warning: ‘ctl_data’ may be used uninitialized [-Wmaybe-uninitialized]
  308 |                  ctl_data->device_id);
      |                          ^~
../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c:294:39: note: ‘ctl_data’ was declared here
  294 |         struct adf_user_cfg_ctl_data *ctl_data;
      |                                       ^~~~~~~~
In function ‘adf_ctl_ioctl_dev_stop’,
    inlined from ‘adf_ctl_ioctl’ at ../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c:386:9:
../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c:273:48: warning: ‘ctl_data’ may be used uninitialized [-Wmaybe-uninitialized]
  273 |         ret = adf_ctl_is_device_in_use(ctl_data->device_id);
      |                                        ~~~~~~~~^~~~~~~~~~~
../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c: In function ‘adf_ctl_ioctl’:
../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c:261:39: note: ‘ctl_data’ was declared here
  261 |         struct adf_user_cfg_ctl_data *ctl_data;
      |                                       ^~~~~~~~
In function ‘adf_ctl_ioctl_dev_config’,
    inlined from ‘adf_ctl_ioctl’ at ../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c:382:9:
../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c:192:54: warning: ‘ctl_data’ may be used uninitialized [-Wmaybe-uninitialized]
  192 |         accel_dev = adf_devmgr_get_dev_by_id(ctl_data->device_id);
      |                                              ~~~~~~~~^~~~~~~~~~~
../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c: In function ‘adf_ctl_ioctl’:
../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c:185:39: note: ‘ctl_data’ was declared here
  185 |         struct adf_user_cfg_ctl_data *ctl_data;
      |                                       ^~~~~~~~

Fix this by returning the pointer directly.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Thorsten Blum <thorsten.blum@linux.dev>
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: d237230728c5 ("crypto: qat - remove unused character device and IOCTLs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c |   31 +++++++++-------------
 1 file changed, 13 insertions(+), 18 deletions(-)

--- a/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
@@ -89,19 +89,14 @@ err_chrdev_unreg:
 	return -EFAULT;
 }
 
-static int adf_ctl_alloc_resources(struct adf_user_cfg_ctl_data **ctl_data,
-				   unsigned long arg)
+static struct adf_user_cfg_ctl_data *adf_ctl_alloc_resources(unsigned long arg)
 {
 	struct adf_user_cfg_ctl_data *cfg_data;
 
 	cfg_data = memdup_user((void __user *)arg, sizeof(*cfg_data));
-	if (IS_ERR(cfg_data)) {
+	if (IS_ERR(cfg_data))
 		pr_err("QAT: failed to copy from user cfg_data.\n");
-		return PTR_ERR(cfg_data);
-	}
-
-	*ctl_data = cfg_data;
-	return 0;
+	return cfg_data;
 }
 
 static int adf_add_key_value_data(struct adf_accel_dev *accel_dev,
@@ -181,13 +176,13 @@ out_err:
 static int adf_ctl_ioctl_dev_config(struct file *fp, unsigned int cmd,
 				    unsigned long arg)
 {
-	int ret;
 	struct adf_user_cfg_ctl_data *ctl_data;
 	struct adf_accel_dev *accel_dev;
+	int ret = 0;
 
-	ret = adf_ctl_alloc_resources(&ctl_data, arg);
-	if (ret)
-		return ret;
+	ctl_data = adf_ctl_alloc_resources(arg);
+	if (IS_ERR(ctl_data))
+		return PTR_ERR(ctl_data);
 
 	accel_dev = adf_devmgr_get_dev_by_id(ctl_data->device_id);
 	if (!accel_dev) {
@@ -260,9 +255,9 @@ static int adf_ctl_ioctl_dev_stop(struct
 	int ret;
 	struct adf_user_cfg_ctl_data *ctl_data;
 
-	ret = adf_ctl_alloc_resources(&ctl_data, arg);
-	if (ret)
-		return ret;
+	ctl_data = adf_ctl_alloc_resources(arg);
+	if (IS_ERR(ctl_data))
+		return PTR_ERR(ctl_data);
 
 	if (adf_devmgr_verify_id(ctl_data->device_id)) {
 		pr_err("QAT: Device %d not found\n", ctl_data->device_id);
@@ -294,9 +289,9 @@ static int adf_ctl_ioctl_dev_start(struc
 	struct adf_user_cfg_ctl_data *ctl_data;
 	struct adf_accel_dev *accel_dev;
 
-	ret = adf_ctl_alloc_resources(&ctl_data, arg);
-	if (ret)
-		return ret;
+	ctl_data = adf_ctl_alloc_resources(arg);
+	if (IS_ERR(ctl_data))
+		return PTR_ERR(ctl_data);
 
 	ret = -ENODEV;
 	accel_dev = adf_devmgr_get_dev_by_id(ctl_data->device_id);


