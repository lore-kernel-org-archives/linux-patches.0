Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CCB168A2
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87451C433EF;
	Mon,  8 May 2023 10:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541998;
	bh=7k1f7joZo1YjPW06nG9XCmo++fUu2Aw18ach7E2efPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e0R2Xn4+AvH8kqIFRI/4MbJgiCZNG3hqUau2Ti67zpSGn9+/2Yu46LhevTdRrJhDk
	 /z8sACsgNw3ijQjrn8C7CkuB/HngDN7gwGt5kJ+fsOAPrByBYI05pdqs4rMYbpO+fB
	 8DZopdxYKAnxpeimtz41zID1GfJoGtk+qt8QNbXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shashank Gupta <shashank.gupta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 294/663] crypto: qat - fix concurrency issue when device state changes
Date: Mon,  8 May 2023 11:42:00 +0200
Message-Id: <20230508094437.727797634@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shashank Gupta <shashank.gupta@intel.com>

[ Upstream commit 1bdc85550a2b59bb7f62ead7173134e66dd2d60e ]

The sysfs `state` attribute is not protected against race conditions.
If multiple processes perform a device state transition on the same
device in parallel, unexpected behaviors might occur.

For transitioning the device state, adf_sysfs.c calls the functions
adf_dev_init(), adf_dev_start(), adf_dev_stop() and adf_dev_shutdown()
which are unprotected and interdependent on each other. To perform a
state transition, these functions needs to be called in a specific
order:
  * device up:   adf_dev_init() -> adf_dev_start()
  * device down: adf_dev_stop() -> adf_dev_shutdown()

This change introduces the functions adf_dev_up() and adf_dev_down()
which wrap the state machine functions and protect them with a
per-device lock. These are then used in adf_sysfs.c instead of the
individual state transition functions.

Fixes: 5ee52118ac14 ("crypto: qat - expose device state through sysfs for 4xxx")
Signed-off-by: Shashank Gupta <shashank.gupta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../crypto/qat/qat_common/adf_accel_devices.h |  1 +
 .../crypto/qat/qat_common/adf_common_drv.h    |  3 +
 drivers/crypto/qat/qat_common/adf_dev_mgr.c   |  2 +
 drivers/crypto/qat/qat_common/adf_init.c      | 64 +++++++++++++++++++
 drivers/crypto/qat/qat_common/adf_sysfs.c     | 23 +------
 5 files changed, 73 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 284f5aad3ee0b..7be933d6f0ffa 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -310,6 +310,7 @@ struct adf_accel_dev {
 			u8 pf_compat_ver;
 		} vf;
 	};
+	struct mutex state_lock; /* protect state of the device */
 	bool is_vf;
 	u32 accel_id;
 };
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index 7189265573c08..4bf1fceb7052b 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -58,6 +58,9 @@ void adf_dev_stop(struct adf_accel_dev *accel_dev);
 void adf_dev_shutdown(struct adf_accel_dev *accel_dev);
 int adf_dev_shutdown_cache_cfg(struct adf_accel_dev *accel_dev);
 
+int adf_dev_up(struct adf_accel_dev *accel_dev, bool init_config);
+int adf_dev_down(struct adf_accel_dev *accel_dev, bool cache_config);
+
 void adf_devmgr_update_class_index(struct adf_hw_device_data *hw_data);
 void adf_clean_vf_map(bool);
 
diff --git a/drivers/crypto/qat/qat_common/adf_dev_mgr.c b/drivers/crypto/qat/qat_common/adf_dev_mgr.c
index 4c752eed10fea..86ee36feefad3 100644
--- a/drivers/crypto/qat/qat_common/adf_dev_mgr.c
+++ b/drivers/crypto/qat/qat_common/adf_dev_mgr.c
@@ -223,6 +223,7 @@ int adf_devmgr_add_dev(struct adf_accel_dev *accel_dev,
 		map->attached = true;
 		list_add_tail(&map->list, &vfs_table);
 	}
+	mutex_init(&accel_dev->state_lock);
 unlock:
 	mutex_unlock(&table_lock);
 	return ret;
@@ -269,6 +270,7 @@ void adf_devmgr_rm_dev(struct adf_accel_dev *accel_dev,
 		}
 	}
 unlock:
+	mutex_destroy(&accel_dev->state_lock);
 	list_del(&accel_dev->list);
 	mutex_unlock(&table_lock);
 }
diff --git a/drivers/crypto/qat/qat_common/adf_init.c b/drivers/crypto/qat/qat_common/adf_init.c
index cef7bb8ec0073..988cffd0b8338 100644
--- a/drivers/crypto/qat/qat_common/adf_init.c
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -400,3 +400,67 @@ int adf_dev_shutdown_cache_cfg(struct adf_accel_dev *accel_dev)
 
 	return 0;
 }
+
+int adf_dev_down(struct adf_accel_dev *accel_dev, bool reconfig)
+{
+	int ret = 0;
+
+	if (!accel_dev)
+		return -EINVAL;
+
+	mutex_lock(&accel_dev->state_lock);
+
+	if (!adf_dev_started(accel_dev)) {
+		dev_info(&GET_DEV(accel_dev), "Device qat_dev%d already down\n",
+			 accel_dev->accel_id);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (reconfig) {
+		ret = adf_dev_shutdown_cache_cfg(accel_dev);
+		goto out;
+	}
+
+	adf_dev_stop(accel_dev);
+	adf_dev_shutdown(accel_dev);
+
+out:
+	mutex_unlock(&accel_dev->state_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(adf_dev_down);
+
+int adf_dev_up(struct adf_accel_dev *accel_dev, bool config)
+{
+	int ret = 0;
+
+	if (!accel_dev)
+		return -EINVAL;
+
+	mutex_lock(&accel_dev->state_lock);
+
+	if (adf_dev_started(accel_dev)) {
+		dev_info(&GET_DEV(accel_dev), "Device qat_dev%d already up\n",
+			 accel_dev->accel_id);
+		ret = -EALREADY;
+		goto out;
+	}
+
+	if (config && GET_HW_DATA(accel_dev)->dev_config) {
+		ret = GET_HW_DATA(accel_dev)->dev_config(accel_dev);
+		if (unlikely(ret))
+			goto out;
+	}
+
+	ret = adf_dev_init(accel_dev);
+	if (unlikely(ret))
+		goto out;
+
+	ret = adf_dev_start(accel_dev);
+
+out:
+	mutex_unlock(&accel_dev->state_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(adf_dev_up);
diff --git a/drivers/crypto/qat/qat_common/adf_sysfs.c b/drivers/crypto/qat/qat_common/adf_sysfs.c
index e8b078e719c20..3eb6611ab1b11 100644
--- a/drivers/crypto/qat/qat_common/adf_sysfs.c
+++ b/drivers/crypto/qat/qat_common/adf_sysfs.c
@@ -50,38 +50,21 @@ static ssize_t state_store(struct device *dev, struct device_attribute *attr,
 
 	switch (ret) {
 	case DEV_DOWN:
-		if (!adf_dev_started(accel_dev)) {
-			dev_info(dev, "Device qat_dev%d already down\n",
-				 accel_id);
-			return -EINVAL;
-		}
-
 		dev_info(dev, "Stopping device qat_dev%d\n", accel_id);
 
-		ret = adf_dev_shutdown_cache_cfg(accel_dev);
+		ret = adf_dev_down(accel_dev, true);
 		if (ret < 0)
 			return -EINVAL;
 
 		break;
 	case DEV_UP:
-		if (adf_dev_started(accel_dev)) {
-			dev_info(dev, "Device qat_dev%d already up\n",
-				 accel_id);
-			return -EINVAL;
-		}
-
 		dev_info(dev, "Starting device qat_dev%d\n", accel_id);
 
-		ret = GET_HW_DATA(accel_dev)->dev_config(accel_dev);
-		if (!ret)
-			ret = adf_dev_init(accel_dev);
-		if (!ret)
-			ret = adf_dev_start(accel_dev);
-
+		ret = adf_dev_up(accel_dev, true);
 		if (ret < 0) {
 			dev_err(dev, "Failed to start device qat_dev%d\n",
 				accel_id);
-			adf_dev_shutdown_cache_cfg(accel_dev);
+			adf_dev_down(accel_dev, true);
 			return ret;
 		}
 		break;
-- 
2.39.2



