Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215241;
	b=GUqYSk1r5plnY4vXp64grhwB7TULSZ1nFgsLKF424d1EPoM5rzHZsv+a0pJBPsX/hbKi
	 ShabYQb3lcL3jjyxsuBg66kmdU9TzgVgQnzfQwck9GUc/t9QRC983po8wgSjbwWEAOyBv
	 m4dawvk1phwWp3ts9g1F8cevyDMAyI95m11VUQULn/CCWXg3pNHf+FnnX4NRI6PeyoBOn
	 pSul8vkra5g/PWXtJR2fUgyssTbthvTjaOYoYHF5jJD270W8IULuaxqu4IyqWkIp9pwzl
	 BCJFIPZSD/GEFEPOaVDqmL4+VNtEJ6E9JG30DZTK56KD2+cwR5xbCfpWv5L8ojBukyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215241;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q+cervjzq7L8A4bPCDJQjnA/5fR4vT9MPqUuLaFBazQ=;
	b=C39hOqOA2DN3RR8mODHzuWGC6MEg8Jp74+sXuZzzjS28XDHPMMz+XWFjjVxbB1yZMrnl
	 1fNkSvTbZHfXdGDIOuBRaerChRZRJ9lMKIGl1g7DT8h4sNBSUfIBYEWV6OIabGz/cAWEM
	 LHdpLIIdAMFIiG9HFDR74zxQoCbWGmq36Aihdkheg3aBe8DK/P3wkYEyt1k/ed51znp+C
	 filGAcqKhKPnatW0AGJ6z2V6HnZoGK5ks9ZPXfrfWXAdbAUPeCzeZuEID17x7ME9jgWnz
	 mJLCQVxsR1uM97RrKsas6uq2crHAFxZzOGAiVHlwKpYSKIzUmiBMYQ4BgAS5ctkW81Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nSDPgxvm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9C7606A31A;
	Wed, 28 Oct 2026 19:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nSDPgxvm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE9601F01825;
	Wed, 28 Oct 2026 19:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215241;
	bh=Q+cervjzq7L8A4bPCDJQjnA/5fR4vT9MPqUuLaFBazQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nSDPgxvmFuL9KUy+mcMn4zmobgKqMH0qnseQAQF68lABtSjOtYwfIJUVwAeyTZPR+
	 vcqqy8CvndUdNMtVk7BDax99hFCrOhw90GHuBOvNMJRJjIuAqQhu2dxEldJbNxNb+e
	 UV7vVfz1fkU+29hN6DkbxfBv5ckoQctwmFhLdOUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Maksim Lukoshkov <maksim.lukoshkov@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1143/1887] crypto: qat - protect service table iterations with service_lock
Date: Wed, 28 Oct 2026 17:53:59 +0100
Message-ID: <20261028170525.417557534@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/crypto/qat/qat_common/adf_init.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/crypto/qat/qat_common/adf_init.c b/drivers/crypto/qat/qat_common/adf_init.c
index 9d54dc3beafd5..c397c58bd4a96 100644
--- a/drivers/crypto/qat/qat_common/adf_init.c
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -136,16 +136,19 @@ int adf_dev_init(struct adf_accel_dev *accel_dev)
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
@@ -190,16 +193,19 @@ int adf_dev_start(struct adf_accel_dev *accel_dev)
 		return -EFAULT;
 	}
 
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
@@ -249,6 +255,7 @@ void adf_dev_stop(struct adf_accel_dev *accel_dev)
 	}
 	clear_bit(ADF_STATUS_CRYPTO_ALGS_REGISTERED, &accel_dev->status);
 
+	mutex_lock(&service_lock);
 	list_for_each(list_itr, &service_table) {
 		service = list_entry(list_itr, struct service_hndl, list);
 		if (!test_bit(accel_dev->accel_id, service->start_status))
@@ -261,6 +268,7 @@ void adf_dev_stop(struct adf_accel_dev *accel_dev)
 			clear_bit(accel_dev->accel_id, service->start_status);
 		}
 	}
+	mutex_unlock(&service_lock);
 
 	if (wait)
 		msleep(100);
@@ -307,6 +315,7 @@ void adf_dev_shutdown(struct adf_accel_dev *accel_dev)
 				  &accel_dev->status);
 	}
 
+	mutex_lock(&service_lock);
 	list_for_each(list_itr, &service_table) {
 		service = list_entry(list_itr, struct service_hndl, list);
 		if (!test_bit(accel_dev->accel_id, service->init_status))
@@ -318,6 +327,7 @@ void adf_dev_shutdown(struct adf_accel_dev *accel_dev)
 		else
 			clear_bit(accel_dev->accel_id, service->init_status);
 	}
+	mutex_unlock(&service_lock);
 
 	hw_data->disable_iov(accel_dev);
 
@@ -347,6 +357,7 @@ int adf_dev_restarting_notify(struct adf_accel_dev *accel_dev)
 	struct service_hndl *service;
 	struct list_head *list_itr;
 
+	mutex_lock(&service_lock);
 	list_for_each(list_itr, &service_table) {
 		service = list_entry(list_itr, struct service_hndl, list);
 		if (service->event_hld(accel_dev, ADF_EVENT_RESTARTING))
@@ -354,6 +365,7 @@ int adf_dev_restarting_notify(struct adf_accel_dev *accel_dev)
 				"Failed to restart service %s.\n",
 				service->name);
 	}
+	mutex_unlock(&service_lock);
 	return 0;
 }
 
@@ -362,6 +374,7 @@ int adf_dev_restarted_notify(struct adf_accel_dev *accel_dev)
 	struct service_hndl *service;
 	struct list_head *list_itr;
 
+	mutex_lock(&service_lock);
 	list_for_each(list_itr, &service_table) {
 		service = list_entry(list_itr, struct service_hndl, list);
 		if (service->event_hld(accel_dev, ADF_EVENT_RESTARTED))
@@ -369,6 +382,7 @@ int adf_dev_restarted_notify(struct adf_accel_dev *accel_dev)
 				"Failed to restart service %s.\n",
 				service->name);
 	}
+	mutex_unlock(&service_lock);
 	return 0;
 }
 
-- 
2.53.0



