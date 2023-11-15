Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4C2364CB
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0yRQYecL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF263C433C8;
	Wed, 15 Nov 2023 19:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077522;
	bh=0tszDPs82ppgeqH/mftNrUIbjLm7yzJ8MR8sL8crsOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0yRQYecLHiv6u0EIMyQiApKp0jICCCwteCH3pIGUTt8mTFBrzPI47aXJs0pezyo6y
	 FlUKSI+Ig5wv2ZdZ4AnYYOJ22FYUAVWs7GdO5NNOO7uYi+rXFT10v7t6pbl5+5tXIs
	 yqm0mvEoZj9mprIPnPFCQ7/vJG4NRuQGPspQBATM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Adam Guerin <adam.guerin@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 347/603] crypto: qat - fix state machines cleanup paths
Date: Wed, 15 Nov 2023 14:14:52 -0500
Message-ID: <20231115191637.538204659@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit c9ca9756f376f51f985130a0e599d956065d4c44 ]

Commit 1bdc85550a2b ("crypto: qat - fix concurrency issue when device
state changes") introduced the function adf_dev_down() which wraps the
functions adf_dev_stop() and adf_dev_shutdown().
In a subsequent change, the sequence adf_dev_stop() followed by
adf_dev_shutdown() was then replaced across the driver with just a call
to the function adf_dev_down().

The functions adf_dev_stop() and adf_dev_shutdown() are called in error
paths to stop the accelerator and free up resources and can be called
even if the counterparts adf_dev_init() and adf_dev_start() did not
complete successfully.
However, the implementation of adf_dev_down() prevents the stop/shutdown
sequence if the device is found already down.
For example, if adf_dev_init() fails, the device status is not set as
started and therefore a call to adf_dev_down() won't be calling
adf_dev_shutdown() to undo what adf_dev_init() did.

Do not check if a device is started in adf_dev_down() but do the
equivalent check in adf_sysfs.c when handling a DEV_DOWN command from
the user.

Fixes: 2b60f79c7b81 ("crypto: qat - replace state machine calls")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_init.c  | 7 -------
 drivers/crypto/intel/qat/qat_common/adf_sysfs.c | 7 +++++++
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_init.c b/drivers/crypto/intel/qat/qat_common/adf_init.c
index 89001fe92e762..35aef5e8fc386 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_init.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_init.c
@@ -440,13 +440,6 @@ int adf_dev_down(struct adf_accel_dev *accel_dev, bool reconfig)
 
 	mutex_lock(&accel_dev->state_lock);
 
-	if (!adf_dev_started(accel_dev)) {
-		dev_info(&GET_DEV(accel_dev), "Device qat_dev%d already down\n",
-			 accel_dev->accel_id);
-		ret = -EINVAL;
-		goto out;
-	}
-
 	if (reconfig) {
 		ret = adf_dev_shutdown_cache_cfg(accel_dev);
 		goto out;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
index a74d2f9303670..a8f33558d7cb8 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
@@ -52,6 +52,13 @@ static ssize_t state_store(struct device *dev, struct device_attribute *attr,
 	case DEV_DOWN:
 		dev_info(dev, "Stopping device qat_dev%d\n", accel_id);
 
+		if (!adf_dev_started(accel_dev)) {
+			dev_info(&GET_DEV(accel_dev), "Device qat_dev%d already down\n",
+				 accel_id);
+
+			break;
+		}
+
 		ret = adf_dev_down(accel_dev, true);
 		if (ret < 0)
 			return -EINVAL;
-- 
2.42.0



