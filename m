Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA1135DA41;
	Sat, 17 Oct 2026 17:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258971; cv=none; b=eUA+WnLwm9IZ6S4Km/W/23rAJD5uTkZvz5QMoGhvy6UuK1/4Sj5o7IjPmq1NTV+tJ0HzYsGeNAJ56sgEfH09dnEkHsFW4kvBPDgzBxWkdV72louAVD3xOPKO076yV1/GIxIsO8+AqqxVQUlJk5IfOzyB2ycL7nkAV8TNxMe0n0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258971; c=relaxed/simple;
	bh=+VAnGCmlqB0AAnH7FPOb/MlW8whqfAXob6pcaBIW5AM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JNB0CbGzu0GpUcaGz80tV7JbTkCKyuciJL7WQJt/Ie0a+q8vUJQ/ZAOCs2OBmwPKoNQ0SBk1lphYl5Y8+mi4AAFaVdRySMZ/EkkuVoThJ3XDDpyOWkfS2VOTB+o6Av9LUcusd0XW4mtOBmWnuR6wE/WEFo5H/WoyrzbgQ90OecM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vwROdjtd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vwROdjtd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6331E1F000C4;
	Sat, 17 Oct 2026 17:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258970;
	bh=QGK0FIn/Hqmfq/tEdM67M+lzNFLqFFj3X87dTioIcNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vwROdjtdbyqlUWE2a4/FdUKgVpubAJCtSfMQelTJgU4E0hE9eXYasyNWs3rLutB3+
	 KUxUuU2WK2YU4FKQQ8qDb4tlKe6kHvHAxJBPUku2DL/SkfpEnquCw+BMbYATzxm2Hw
	 7JUy115LOOHUlbybyAukNbSt/ZgrdzTiWqrDTm9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Maksim Lukoshkov <maksim.lukoshkov@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1057/1674] crypto: qat - protect service table iterations with service_lock
Date: Sat, 17 Oct 2026 17:55:29 +0200
Message-ID: <20261017160458.258764135@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahsan Atta <ahsan.atta@intel.com>

[ Upstream commit 5c6f845e77ec35f9b7b047cc8f9789bf397cdd3e ]

The service_table list is protected by service_lock when entries are
added or removed (in adf_service_add() and adf_service_remove()), but
several functions iterate over the list without holding this lock.

A concurrent adf_service_register() or adf_service_unregister() call
could modify the list during traversal, leading to list corruption or
a use-after-free.

Fix this by holding service_lock across all list_for_each_entry()
iterations of service_table in adf_dev_init(), adf_dev_start(),
adf_dev_stop(), adf_dev_shutdown(), adf_dev_restarting_notify(),
adf_dev_restarted_notify(), and adf_error_notifier().

The lock ordering is safe: callers of the static helpers (adf_dev_up()
and adf_dev_down()) acquire state_lock before service_lock, and no
event_hld callback or service_lock holder ever acquires state_lock in
the reverse order.

Cc: stable@vger.kernel.org
Fixes: d8cba25d2c68 ("crypto: qat - Intel(R) QAT driver framework")
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Co-developed-by: Maksim Lukoshkov <maksim.lukoshkov@intel.com>
Signed-off-by: Maksim Lukoshkov <maksim.lukoshkov@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_init.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_init.c b/drivers/crypto/intel/qat/qat_common/adf_init.c
index 9c1b587a87e5b..718bedff9c16e 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_init.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_init.c
@@ -140,16 +140,19 @@ static int adf_dev_init(struct adf_accel_dev *accel_dev)
 	 * This is to facilitate any ordering dependencies between services
 	 * prior to starting any of the accelerators.
 	 */
+	mutex_lock(&service_lock);
 	list_for_each(list_itr, &service_table) {
 		service = list_entry(list_itr, struct service_hndl, list);
 		if (service->event_hld(accel_dev, ADF_EVENT_INIT)) {
 			dev_err(&GET_DEV(accel_dev),
 				"Failed to initialise service %s\n",
 				service->name);
+			mutex_unlock(&service_lock);
 			return -EFAULT;
 		}
 		set_bit(accel_dev->accel_id, service->init_status);
 	}
+	mutex_unlock(&service_lock);
 
 	return 0;
 }
@@ -212,16 +215,19 @@ static int adf_dev_start(struct adf_accel_dev *accel_dev)
 
 	adf_heartbeat_start(accel_dev);
 
+	mutex_lock(&service_lock);
 	list_for_each(list_itr, &service_table) {
 		service = list_entry(list_itr, struct service_hndl, list);
 		if (service->event_hld(accel_dev, ADF_EVENT_START)) {
 			dev_err(&GET_DEV(accel_dev),
 				"Failed to start service %s\n",
 				service->name);
+			mutex_unlock(&service_lock);
 			return -EFAULT;
 		}
 		set_bit(accel_dev->accel_id, service->start_status);
 	}
+	mutex_unlock(&service_lock);
 
 	clear_bit(ADF_STATUS_STARTING, &accel_dev->status);
 	set_bit(ADF_STATUS_STARTED, &accel_dev->status);
@@ -289,6 +295,7 @@ static void adf_dev_stop(struct adf_accel_dev *accel_dev)
 		qat_comp_algs_unregister();
 	clear_bit(ADF_STATUS_COMP_ALGS_REGISTERED, &accel_dev->status);
 
+	mutex_lock(&service_lock);
 	list_for_each(list_itr, &service_table) {
 		service = list_entry(list_itr, struct service_hndl, list);
 		if (!test_bit(accel_dev->accel_id, service->start_status))
@@ -301,6 +308,7 @@ static void adf_dev_stop(struct adf_accel_dev *accel_dev)
 			clear_bit(accel_dev->accel_id, service->start_status);
 		}
 	}
+	mutex_unlock(&service_lock);
 
 	if (hw_data->stop_timer)
 		hw_data->stop_timer(accel_dev);
@@ -349,6 +357,7 @@ static void adf_dev_shutdown(struct adf_accel_dev *accel_dev)
 				  &accel_dev->status);
 	}
 
+	mutex_lock(&service_lock);
 	list_for_each(list_itr, &service_table) {
 		service = list_entry(list_itr, struct service_hndl, list);
 		if (!test_bit(accel_dev->accel_id, service->init_status))
@@ -360,6 +369,7 @@ static void adf_dev_shutdown(struct adf_accel_dev *accel_dev)
 		else
 			clear_bit(accel_dev->accel_id, service->init_status);
 	}
+	mutex_unlock(&service_lock);
 
 	adf_heartbeat_shutdown(accel_dev);
 
@@ -390,6 +400,7 @@ int adf_dev_restarting_notify(struct adf_accel_dev *accel_dev)
 	struct service_hndl *service;
 	struct list_head *list_itr;
 
+	mutex_lock(&service_lock);
 	list_for_each(list_itr, &service_table) {
 		service = list_entry(list_itr, struct service_hndl, list);
 		if (service->event_hld(accel_dev, ADF_EVENT_RESTARTING))
@@ -397,6 +408,7 @@ int adf_dev_restarting_notify(struct adf_accel_dev *accel_dev)
 				"Failed to restart service %s.\n",
 				service->name);
 	}
+	mutex_unlock(&service_lock);
 	return 0;
 }
 
@@ -405,6 +417,7 @@ int adf_dev_restarted_notify(struct adf_accel_dev *accel_dev)
 	struct service_hndl *service;
 	struct list_head *list_itr;
 
+	mutex_lock(&service_lock);
 	list_for_each(list_itr, &service_table) {
 		service = list_entry(list_itr, struct service_hndl, list);
 		if (service->event_hld(accel_dev, ADF_EVENT_RESTARTED))
@@ -412,6 +425,7 @@ int adf_dev_restarted_notify(struct adf_accel_dev *accel_dev)
 				"Failed to restart service %s.\n",
 				service->name);
 	}
+	mutex_unlock(&service_lock);
 	return 0;
 }
 
-- 
2.53.0



