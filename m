Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A342A1FE455;
	Tue,  3 Dec 2024 15:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240154; cv=none; b=adxoXxLfGlS3PM3Ck9276A6Szf60SbfviOLEL0+B9bvUWu5TxKmtqgV8tZxxK/cpAXGWLPa6oya5jLGyuYsc5FBTiuUJJpg9Vk7FxLmyY/VPPtxipAjLenUL3bHvWrJvf+d2xwZ2TPG0aWTmz/Ar7P/0xdS6CbzJOf59B2nbSMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240154; c=relaxed/simple;
	bh=gnG15LgWMZdw8gnOzPeabwZvOPFk2msr6K9eTq6Njls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OUbDzlo6/teUKoMXjMWkiOzMpZBVer4Gqv+T0vYcjABC+q+Kp1eCFaEbCzSr9S3LAJp+N7g+ThMy8Mzxs/I1tYzHXCy9JvBy5qcft23PHf5HsIDsIYvuBbU89ixqvN95jng0YyGvLlh8hJyvosVszfKWZ9ZPJFoa2vufpz/4aps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1owAmjD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1owAmjD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29ED6C4CECF;
	Tue,  3 Dec 2024 15:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240154;
	bh=gnG15LgWMZdw8gnOzPeabwZvOPFk2msr6K9eTq6Njls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U1owAmjDz6NvgQQFRYcVoC8T0YDZYMEG5DTXIVOHRnZWWz+DzLEirCLJpi29/uPiG
	 cNnIeUeFythDHkJ5XwmJBpkIj65obk+Ok7Y45UDk1P/amOSf8NUQ/4izmYrY85xcdo
	 LJVHom8HE9tezT2W+edW3AB6AWY7AHT+HjPS48TQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 042/826] crypto: qat - remove check after debugfs_create_dir()
Date: Tue,  3 Dec 2024 15:36:09 +0100
Message-ID: <20241203144745.105644560@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



