Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625219;
	b=T8bN9nEyfXUId1ImgKhmlq9gae1iCxgoHh2VcH0ZPX2IIwasTBrga/9Gjd3QnD6AhwhH
	 fQwCdYh71cMUpGxAv1/snjQzMIRRHkcxvAHg/hvmmrPDMUfiY0GmFdk4ArqMwYmMA/s6I
	 l2M8HqDnZ5SYNeB6+6cyyrqyR8x+h4vUhF/E+hihP2dZ3gH5PSNNyKPMRVKEpOJ7+I4Bx
	 3eg8GJLF78Lew78uHy0RQTmAalMNvcuHaXWQ1Iaa00kRcPilpjN5iX3W51W1k/hDTZbAC
	 8XrLidpeGHPfmzDxQfYwL6hn82sqllcvgfsFbTt+YgCYUMrXaXQs99hvY7UUo5as2TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625219;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lYxE/bXaEwhhnpNfkUVp/kOG9AHIqqebffbOBQk3l7o=;
	b=ZFxXoNuZonjiZNB6WcL9OCVcJo3havRjnvxF6IaYciI5j1gtWWfrX0kYQKepPuITRiNS
	 YdZWgukFT3qF6Pk6nnn6Z0t9ewTXeRU9wnR3EXKxCmnWyfFqdnjBkyGpPtnciemgxAUEI
	 zpAvR0VokohQpYSo5d6NDTty26g90wNzTPN9isy1A5QapDrzxdU53R+wKO//TiZsmD7Wz
	 ktfllxdVWYO32C4M2qnnKZUu6+iauAdVOehKA0Pdsg5o1o1WW5uNhOKZe7P+JzXulnUx1
	 R6hKZIlNzoDIoILuDkFyhYiqbpAgMgpl+Q7cQ4pT967Xj5JzpojpWZlFAgjE7iRk8/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wDimayhD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFB9606A32A;
	Wed, 25 Nov 2026 16:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wDimayhD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47FF51F000CA;
	Wed, 25 Nov 2026 16:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625218;
	bh=lYxE/bXaEwhhnpNfkUVp/kOG9AHIqqebffbOBQk3l7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wDimayhDkN373cRWak4E8eBKgwlMHtOYa2bmNm3tVtVvuA2lc3Ziwx3pG47vqZPEJ
	 nd2WDUtRP+NeJCM0bxmM5bkMG849a6PKxqXe2pwQ3nghAkTEvI7viSC/nSK2GKqYa8
	 uai5tOIZrIoC3FwV8az0pSobBVKpnq8DuC/CBGQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 418/816] crypto: qat - hold cfg->lock when accessing config sections
Date: Wed, 25 Nov 2026 15:32:46 +0100
Message-ID: <20261125143858.872338467@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahsan Atta <ahsan.atta@intel.com>

[ Upstream commit cb3a1364fed9ea7b063e3ae026177a145abb5940 ]

adf_cfg_sec_find() walks the per-device section list without holding
cfg->lock, and the returned section pointer is used later under the
lock. A concurrent section deletion under cfg->lock
(adf_cfg_del_all_except() on device down, or adf_cfg_dev_remove() on
removal) can free the section first, leading to a use-after-free.

The debugfs dev_cfg reader has the same problem: qat_dev_cfg_show()
walks both the section list and each section's param_head under the
global qat_cfg_read_lock mutex, not the per-device cfg->lock used by the
add and delete paths, so the two do not serialise. Updating an existing
key frees the old key_val under cfg->lock, so even a config write
concurrent with an open dev_cfg read can free an entry mid-walk, a wider
window than section deletion alone.

Take cfg->lock around the section lookup in adf_cfg_add_key_value_param()
and around the lookup and insert in adf_cfg_section_add(), and use
down_read()/up_read(&cfg->lock) in the debugfs start/stop callbacks.
Remove the now-unused qat_cfg_read_lock.

While here, return -ENOENT rather than -EFAULT when the section is not
found; EFAULT (bad userspace address) is not meaningful for this case.

Fixes: d8cba25d2c68 ("crypto: qat - Intel(R) QAT driver framework")
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[ sashal: Used kzalloc(sizeof(*sec), GFP_KERNEL) and the three-argument strscpy instead of upstream's kzalloc_obj(*sec) and two-argument strscpy, since this branch lacks those helpers. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_cfg.c | 49 +++++++++++--------
 1 file changed, 29 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg.c b/drivers/crypto/intel/qat/qat_common/adf_cfg.c
index 97273da40b438..8db87e4e4824b 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
 /* Copyright(c) 2014 - 2020 Intel Corporation */
-#include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/list.h>
 #include <linux/seq_file.h>
@@ -8,13 +7,11 @@
 #include "adf_cfg.h"
 #include "adf_common_drv.h"
 
-static DEFINE_MUTEX(qat_cfg_read_lock);
-
 static void *qat_dev_cfg_start(struct seq_file *sfile, loff_t *pos)
 {
 	struct adf_cfg_device_data *dev_cfg = sfile->private;
 
-	mutex_lock(&qat_cfg_read_lock);
+	down_read(&dev_cfg->lock);
 	return seq_list_start(&dev_cfg->sec_list, *pos);
 }
 
@@ -42,7 +39,9 @@ static void *qat_dev_cfg_next(struct seq_file *sfile, void *v, loff_t *pos)
 
 static void qat_dev_cfg_stop(struct seq_file *sfile, void *v)
 {
-	mutex_unlock(&qat_cfg_read_lock);
+	struct adf_cfg_device_data *dev_cfg = sfile->private;
+
+	up_read(&dev_cfg->lock);
 }
 
 static const struct seq_operations qat_dev_cfg_sops = {
@@ -271,13 +270,10 @@ int adf_cfg_add_key_value_param(struct adf_accel_dev *accel_dev,
 				enum adf_cfg_val_type type)
 {
 	struct adf_cfg_device_data *cfg = accel_dev->cfg;
+	struct adf_cfg_section *section;
 	struct adf_cfg_key_val *key_val;
-	struct adf_cfg_section *section = adf_cfg_sec_find(accel_dev,
-							   section_name);
 	char temp_val[ADF_CFG_MAX_VAL_LEN_IN_BYTES];
-
-	if (!section)
-		return -EFAULT;
+	int ret = 0;
 
 	key_val = kzalloc(sizeof(*key_val), GFP_KERNEL);
 	if (!key_val)
@@ -310,20 +306,28 @@ int adf_cfg_add_key_value_param(struct adf_accel_dev *accel_dev,
 	 *    anything (the newly created key_val is freed).
 	 */
 	down_write(&cfg->lock);
+
+	section = adf_cfg_sec_find(accel_dev, section_name);
+	if (!section) {
+		kfree(key_val);
+		ret = -ENOENT;
+		goto unlock;
+	}
+
 	if (!adf_cfg_key_val_get(accel_dev, section_name, key, temp_val)) {
 		if (strncmp(temp_val, key_val->val, sizeof(temp_val))) {
 			adf_cfg_keyval_remove(key, section);
 		} else {
 			kfree(key_val);
-			goto out;
+			goto unlock;
 		}
 	}
 
 	adf_cfg_keyval_add(key_val, section);
 
-out:
+unlock:
 	up_write(&cfg->lock);
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(adf_cfg_add_key_value_param);
 
@@ -341,21 +345,26 @@ EXPORT_SYMBOL_GPL(adf_cfg_add_key_value_param);
 int adf_cfg_section_add(struct adf_accel_dev *accel_dev, const char *name)
 {
 	struct adf_cfg_device_data *cfg = accel_dev->cfg;
-	struct adf_cfg_section *sec = adf_cfg_sec_find(accel_dev, name);
+	struct adf_cfg_section *sec;
+	int ret = 0;
 
-	if (sec)
-		return 0;
+	down_write(&cfg->lock);
+
+	if (adf_cfg_sec_find(accel_dev, name))
+		goto unlock;
 
 	sec = kzalloc(sizeof(*sec), GFP_KERNEL);
-	if (!sec)
-		return -ENOMEM;
+	if (!sec) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
 
 	strscpy(sec->name, name, sizeof(sec->name));
 	INIT_LIST_HEAD(&sec->param_head);
-	down_write(&cfg->lock);
 	list_add_tail(&sec->list, &cfg->sec_list);
+unlock:
 	up_write(&cfg->lock);
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(adf_cfg_section_add);
 
-- 
2.53.0



