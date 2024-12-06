Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B081442E8;
	Fri,  6 Dec 2024 14:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496806; cv=none; b=Pgx5K6D+7Vy9ObYJ0d2EyHm7kR1HdH1gRjjtPqEdSoLPt8XsR/cPrW86+tYfAL6SkviY0apyXguBrIRSpLStowk8eWz+KZfM5Gg+iepPvEbAZv3uKmhuqR9V1b+mvKRqlWzkA7n57UY7BXMVE4ZHn4aePOH/LafgIKW1jJ9G2Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496806; c=relaxed/simple;
	bh=6sEKwuwj5H+swAyKIBOfA0OqpapaGVJsIRfWLwkG6WM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Io1LYDVB5r+LHCFhO5OciRKVxu7uo3c8h53rcBdzWukgqlZyGoaY72fMxwd2FJ7nLCHQUGEX1CgvHenCqwZD8GRJ8xW3s6Pxic7THWgvXYSRMDlAxGUlCpM2K6s27uiHOFhkpgOkgQJ7MNnGGZm3pA21awWosAp+t5VeSRBRfKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h4kOC/nz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h4kOC/nz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2DAC4CED1;
	Fri,  6 Dec 2024 14:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496806;
	bh=6sEKwuwj5H+swAyKIBOfA0OqpapaGVJsIRfWLwkG6WM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h4kOC/nzdT0zOvaC1+noPgussKPFGyjXk3gk+OPJ48U7PFXJ38xYt3EtAHR67+do/
	 fVTagFT/I7kI7vu1O0Hk8Seny7W6kkf+Txdpqu7yE8YqeS2e6jFy7QLSTlBFSgpDjq
	 3QB6VP7tUznLpSAVLuXklQbGWryjv81o3TMA4/Xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 078/676] crypto: qat - remove check after debugfs_create_dir()
Date: Fri,  6 Dec 2024 15:28:17 +0100
Message-ID: <20241206143656.415023581@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cabiddu, Giovanni <giovanni.cabiddu@intel.com>

[ Upstream commit 23717055a79981daf7fafa09a4b0d7566f8384aa ]

The debugfs functions are guaranteed to return a valid error code
instead of NULL upon failure. Consequently, the driver can directly
propagate any error returned without additional checks.

Remove the unnecessary `if` statement after debugfs_create_dir(). If
this function fails, the error code is stored in accel_dev->debugfs_dir
and utilized in subsequent debugfs calls.

Additionally, since accel_dev->debugfs_dir is assured to be non-NULL,
remove the superfluous NULL pointer checks within the adf_dbgfs_add()
and adf_dbgfs_rm().

Fixes: 9260db6640a6 ("crypto: qat - move dbgfs init to separate file")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_dbgfs.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_dbgfs.c b/drivers/crypto/intel/qat/qat_common/adf_dbgfs.c
index 04845f8d72be6..056fc59b5ae61 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_dbgfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_dbgfs.c
@@ -19,18 +19,13 @@
 void adf_dbgfs_init(struct adf_accel_dev *accel_dev)
 {
 	char name[ADF_DEVICE_NAME_LENGTH];
-	void *ret;
 
 	/* Create dev top level debugfs entry */
 	snprintf(name, sizeof(name), "%s%s_%s", ADF_DEVICE_NAME_PREFIX,
 		 accel_dev->hw_device->dev_class->name,
 		 pci_name(accel_dev->accel_pci_dev.pci_dev));
 
-	ret = debugfs_create_dir(name, NULL);
-	if (IS_ERR_OR_NULL(ret))
-		return;
-
-	accel_dev->debugfs_dir = ret;
+	accel_dev->debugfs_dir = debugfs_create_dir(name, NULL);
 
 	adf_cfg_dev_dbgfs_add(accel_dev);
 }
@@ -56,9 +51,6 @@ EXPORT_SYMBOL_GPL(adf_dbgfs_exit);
  */
 void adf_dbgfs_add(struct adf_accel_dev *accel_dev)
 {
-	if (!accel_dev->debugfs_dir)
-		return;
-
 	if (!accel_dev->is_vf) {
 		adf_fw_counters_dbgfs_add(accel_dev);
 		adf_heartbeat_dbgfs_add(accel_dev);
@@ -71,9 +63,6 @@ void adf_dbgfs_add(struct adf_accel_dev *accel_dev)
  */
 void adf_dbgfs_rm(struct adf_accel_dev *accel_dev)
 {
-	if (!accel_dev->debugfs_dir)
-		return;
-
 	if (!accel_dev->is_vf) {
 		adf_heartbeat_dbgfs_rm(accel_dev);
 		adf_fw_counters_dbgfs_rm(accel_dev);
-- 
2.43.0



