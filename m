Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B703DBBF
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qrXmFsLH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B97C433CA;
	Wed, 15 Nov 2023 19:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076581;
	bh=vZqNOe8gOplY7Xd9E5LYGMIm5oXzfrv44JR9xCctvDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qrXmFsLHqKPH8ytJYtYNeSvAo0+odKOJgr78IIzcmK93KjHpwI+84m2BFypES7bke
	 cRnnE9OwsSWF0k9cF7NzV7y/FrgziwD2f3STH9Jv6l0hcWw+XuyC14ONen+Uu3kPNf
	 WTpuPH3CSTvbvu+iFCdMj3PwatsSwBTVRc6D43Gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Adam Guerin <adam.guerin@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 319/550] crypto: qat - fix unregistration of compression algorithms
Date: Wed, 15 Nov 2023 14:15:03 -0500
Message-ID: <20231115191622.881328405@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit 11af152f784d9eca54e193140891ac52de36e9a9 ]

The function adf_dev_init(), through the subsystem qat_compression,
populates the list of list of compression instances
accel_dev->compression_list. If the list of instances is not empty,
the function adf_dev_start() will then call qat_compression_registers()
register the compression algorithms into the crypto framework.

If any of the functions in adf_dev_start() fail, the caller of such
function, in the error path calls adf_dev_down() which in turn call
adf_dev_stop() and adf_dev_shutdown(), see for example the function
state_store in adf_sriov.c.
However, if the registration of compression algorithms is not done,
adf_dev_stop() will try to unregister the algorithms regardless.
This might cause the counter active_devs in qat_compression.c to get
to a negative value.

Add a new state, ADF_STATUS_COMPRESSION_ALGS_REGISTERED, which tracks
if the compression algorithms are registered into the crypto framework.
Then use this to unregister the algorithms if such flag is set. This
ensures that the compression algorithms are only unregistered if
previously registered.

Fixes: 1198ae56c9a5 ("crypto: qat - expose deflate through acomp api for QAT GEN2")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_common_drv.h | 1 +
 drivers/crypto/intel/qat/qat_common/adf_init.c       | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
index 7d3d67285ff8a..0af8606eac5b2 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
@@ -26,6 +26,7 @@
 #define ADF_STATUS_PF_RUNNING 7
 #define ADF_STATUS_IRQ_ALLOCATED 8
 #define ADF_STATUS_CRYPTO_ALGS_REGISTERED 9
+#define ADF_STATUS_COMP_ALGS_REGISTERED 10
 
 enum adf_dev_reset_mode {
 	ADF_DEV_RESET_ASYNC = 0,
diff --git a/drivers/crypto/intel/qat/qat_common/adf_init.c b/drivers/crypto/intel/qat/qat_common/adf_init.c
index e4b823d21c505..67bdbee584991 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_init.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_init.c
@@ -218,6 +218,7 @@ static int adf_dev_start(struct adf_accel_dev *accel_dev)
 		clear_bit(ADF_STATUS_STARTED, &accel_dev->status);
 		return -EFAULT;
 	}
+	set_bit(ADF_STATUS_COMP_ALGS_REGISTERED, &accel_dev->status);
 
 	adf_dbgfs_add(accel_dev);
 
@@ -257,8 +258,10 @@ static void adf_dev_stop(struct adf_accel_dev *accel_dev)
 	}
 	clear_bit(ADF_STATUS_CRYPTO_ALGS_REGISTERED, &accel_dev->status);
 
-	if (!list_empty(&accel_dev->compression_list))
+	if (!list_empty(&accel_dev->compression_list) &&
+	    test_bit(ADF_STATUS_COMP_ALGS_REGISTERED, &accel_dev->status))
 		qat_comp_algs_unregister();
+	clear_bit(ADF_STATUS_COMP_ALGS_REGISTERED, &accel_dev->status);
 
 	list_for_each(list_itr, &service_table) {
 		service = list_entry(list_itr, struct service_hndl, list);
-- 
2.42.0



