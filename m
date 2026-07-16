Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF9E4248C8;
	Thu, 16 Jul 2026 13:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209970; cv=none; b=QI7snHtk6fHCIJjaBjznprKe7Ds4vDVJugYhNPWwuKlG0aE9njn1/j+V+9Kz2QYjXeTKkShakk96dx/loavC8boNUo40q0eN8VrMn+Aw+FLcbUoziMABTrO/6FFcjlNBC8VbR0/cGMiA0lcZcx/z7ecu7Kxlz6f10DWpwfMBr+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209970; c=relaxed/simple;
	bh=poOOAWJOqgDC1DuvT7jiLBYCc78wOnQsSWhrGpyM3gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PAEcFMKLa7LW/30CIJCU2Jr+JNCAVG97N9khU0itZaQDKB52DsOIFOv0KaiqHc1qhvSBdAntyhxi1jX3n3LksPprBNIg2OEnb7Rhy7RhOm8MRehv5qvoOPlaecTFLpvGjkBOBRQbxELOpVOIcCH24MfuDUg8w7v9/cihDt7eUds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Np8ab963; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Np8ab963"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709771F00A3A;
	Thu, 16 Jul 2026 13:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209964;
	bh=5iD0IU7pA38SviRHYaR8V+6KChMfMnEU803e+vdP5As=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Np8ab963PxBwcO1LU0kWuveLj4EB55Om3DHphIOFgbNxuf76lcDFyFgjGn+n6UE8/
	 SMSXNh8F/nZAvgjNrSV652gNp9pGOiycFLy6N4ow8YMrUg1D1ofL0xENkIIuhXaZGn
	 j7nH69dk33Qmg1Qr8sST5tITEYcj1u4UXxL7dQdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Maksim Lukoshkov <maksim.lukoshkov@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.1 385/518] crypto: qat - protect service table iterations with service_lock
Date: Thu, 16 Jul 2026 15:30:53 +0200
Message-ID: <20260716133056.255661353@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahsan Atta <ahsan.atta@intel.com>

commit 5c6f845e77ec35f9b7b047cc8f9789bf397cdd3e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/intel/qat/qat_common/adf_init.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/crypto/intel/qat/qat_common/adf_init.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_init.c
@@ -155,15 +155,18 @@ static int adf_dev_init(struct adf_accel
 	 * This is to facilitate any ordering dependencies between services
 	 * prior to starting any of the accelerators.
 	 */
+	mutex_lock(&service_lock);
 	list_for_each_entry(service, &service_table, list) {
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
@@ -233,15 +236,18 @@ static int adf_dev_start(struct adf_acce
 	if (ret && ret != -EOPNOTSUPP)
 		return ret;
 
+	mutex_lock(&service_lock);
 	list_for_each_entry(service, &service_table, list) {
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
@@ -315,6 +321,7 @@ static void adf_dev_stop(struct adf_acce
 		qat_comp_algs_unregister(hw_data->accel_capabilities_ext_mask);
 	clear_bit(ADF_STATUS_COMP_ALGS_REGISTERED, &accel_dev->status);
 
+	mutex_lock(&service_lock);
 	list_for_each_entry(service, &service_table, list) {
 		if (!test_bit(accel_dev->accel_id, service->start_status))
 			continue;
@@ -326,6 +333,7 @@ static void adf_dev_stop(struct adf_acce
 			clear_bit(accel_dev->accel_id, service->start_status);
 		}
 	}
+	mutex_unlock(&service_lock);
 
 	if (hw_data->stop_timer)
 		hw_data->stop_timer(accel_dev);
@@ -375,6 +383,7 @@ static void adf_dev_shutdown(struct adf_
 				  &accel_dev->status);
 	}
 
+	mutex_lock(&service_lock);
 	list_for_each_entry(service, &service_table, list) {
 		if (!test_bit(accel_dev->accel_id, service->init_status))
 			continue;
@@ -385,6 +394,7 @@ static void adf_dev_shutdown(struct adf_
 		else
 			clear_bit(accel_dev->accel_id, service->init_status);
 	}
+	mutex_unlock(&service_lock);
 
 	adf_rl_exit(accel_dev);
 
@@ -419,12 +429,14 @@ int adf_dev_restarting_notify(struct adf
 {
 	struct service_hndl *service;
 
+	mutex_lock(&service_lock);
 	list_for_each_entry(service, &service_table, list) {
 		if (service->event_hld(accel_dev, ADF_EVENT_RESTARTING))
 			dev_err(&GET_DEV(accel_dev),
 				"Failed to restart service %s.\n",
 				service->name);
 	}
+	mutex_unlock(&service_lock);
 	return 0;
 }
 
@@ -432,12 +444,14 @@ int adf_dev_restarted_notify(struct adf_
 {
 	struct service_hndl *service;
 
+	mutex_lock(&service_lock);
 	list_for_each_entry(service, &service_table, list) {
 		if (service->event_hld(accel_dev, ADF_EVENT_RESTARTED))
 			dev_err(&GET_DEV(accel_dev),
 				"Failed to restart service %s.\n",
 				service->name);
 	}
+	mutex_unlock(&service_lock);
 	return 0;
 }
 
@@ -445,12 +459,14 @@ void adf_error_notifier(struct adf_accel
 {
 	struct service_hndl *service;
 
+	mutex_lock(&service_lock);
 	list_for_each_entry(service, &service_table, list) {
 		if (service->event_hld(accel_dev, ADF_EVENT_FATAL_ERROR))
 			dev_err(&GET_DEV(accel_dev),
 				"Failed to send error event to %s.\n",
 				service->name);
 	}
+	mutex_unlock(&service_lock);
 }
 
 int adf_dev_down(struct adf_accel_dev *accel_dev)


