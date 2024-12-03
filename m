Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC5B1F76C3;
	Tue,  3 Dec 2024 14:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237864; cv=none; b=DZXNLy0RII4r5VR1Fwr/cG3+qBZH727DYfBhUIqkX2xHTt4QZpU4GXf8S57XDzsIVi1tVsis91lF9jTtb2XCAyqhwppH0G6YQpYYjLZyosHWv/xr7GI/RJMezG55WS0jBx8IDNxOc5EwxZSwIhULhA3MU4rDwjeNPM/IaErRx/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237864; c=relaxed/simple;
	bh=u76+sv2lgQkEVMtNd4oGpLExGOOMSQiJjgFX3S0eE5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/9GV91PRtfMFurRvrEkyFzur2pfbGRKCGBotUybpBM950zBj2nCX/JMpe+1J78J4ZHEElgC5jgtCmsXq13XbFQHF+oiAL7DpPGtnvkf3+uuekBshyfIxpBYDskHUImabjtdawN2OXiBYXJITsflyH3NxR5H16js6YYE/7yrHrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TDRi6T1g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TDRi6T1g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9C9C4CECF;
	Tue,  3 Dec 2024 14:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237864;
	bh=u76+sv2lgQkEVMtNd4oGpLExGOOMSQiJjgFX3S0eE5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TDRi6T1gSbPL+5WyywRkW1HqDj5TOfltDK2d3dnukE5nMiSu9yyur3o+HTqQ6S+w+
	 nG5iZd5VaHUrxcSU1vbJx+ciIv2qrCQh+//eVkGBg8Zu8KaeVnNW1/KClDAzguWphI
	 6qhOhwaW82TLQ5KHt8t30aZTV0aVvVl3TRds7Sd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 090/817] crypto: qat - remove check after debugfs_create_dir()
Date: Tue,  3 Dec 2024 15:34:22 +0100
Message-ID: <20241203143959.214797262@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index c42f5c25aabdf..4c11ad1ebcf0f 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_dbgfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_dbgfs.c
@@ -22,18 +22,13 @@
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
@@ -59,9 +54,6 @@ EXPORT_SYMBOL_GPL(adf_dbgfs_exit);
  */
 void adf_dbgfs_add(struct adf_accel_dev *accel_dev)
 {
-	if (!accel_dev->debugfs_dir)
-		return;
-
 	if (!accel_dev->is_vf) {
 		adf_fw_counters_dbgfs_add(accel_dev);
 		adf_heartbeat_dbgfs_add(accel_dev);
@@ -77,9 +69,6 @@ void adf_dbgfs_add(struct adf_accel_dev *accel_dev)
  */
 void adf_dbgfs_rm(struct adf_accel_dev *accel_dev)
 {
-	if (!accel_dev->debugfs_dir)
-		return;
-
 	if (!accel_dev->is_vf) {
 		adf_tl_dbgfs_rm(accel_dev);
 		adf_cnv_dbgfs_rm(accel_dev);
-- 
2.43.0



