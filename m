Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622406;
	b=aDRDT7b3hGPSl6ojoLW/IXaRUmAFvR+7Oh1fkXS4mYv3/PAQKLDZokFJw4FnygfuAeSC
	 geyPud8L0/TdpcZ36fExfnhlPZqFUNH/Tr4UkpU+pEhk9nVSfAYq0OLQnfBQoFDwbM4NR
	 BPJZ3OEpN1P95yfZIm4M+sgi1EbhPiknH4xmPWS86Mj819HZfCKlzYzVWaQsMAkyHGPdS
	 pbeG85e9mPiLgH3mGt/QRm75cWmkOhtrK5onycWDufseOXO016RRB+lhT+9sj3swjSI48
	 a1UrRMgyLd0Vn4FwGqulPEZvA82qCaPfQLHQ22thmWQALo2A0w+N3Cy7JoHPDpiDYWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622406;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HXbXflOsoHf2SPyAnuMerd6oNwHAVv6ibzz4q9/znmk=;
	b=rTZBPUF8G1PbosgX3zSUDEOAGnJjvfvcDlNZAj60WfA9ZoMo4TMULIVlMcD21kQdiO1n
	 kGQSHR0aXFWG9CRDT0GcgHMYgx08EYkQrMCesE+vZMw2ME5zK2CbODexeosGy7TH5hD32
	 loKzR/P7kIcf451P8QY6T3Gt01RV+iG4zwCa64OEjP3XtwoT9I/mRKK2R+2J9SyLLqtxz
	 qdqsXKc7GBRqyd6reuCDoZzrOQWtFpf4DDGoKMwptiq0YUaSCedq03tpuJvuwnW5rsXRV
	 TsORUcdN5Tpy0t27U8lcmRuzdKrAIIvBESvKkKmehYvu/s/8azsK5l9mPWeOoRhtqxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=12fSWdYA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6D3606A326;
	Wed, 25 Nov 2026 16:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=12fSWdYA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F08C1F000ED;
	Wed, 25 Nov 2026 16:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622405;
	bh=HXbXflOsoHf2SPyAnuMerd6oNwHAVv6ibzz4q9/znmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=12fSWdYADXzzXV6dzl1960Fn5KvvPrJfYimdCZrj61WWB8pkjYXMHs/y30QQ+yWiM
	 LlUwwQ4EzROALCxx8kojWhql4U6tgTPS7BAheo+8APqsQnMozgdp2y4iWO4+RgUuXu
	 frK1HVcw9rLb5h10aH7xRwQzIWzWr1XQhuJNMc/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 526/990] crypto: qat - hold cfg->lock when accessing config sections
Date: Wed, 25 Nov 2026 15:31:33 +0100
Message-ID: <20261125143834.414963429@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced the new kzalloc_obj(*sec) allocator call with this tree's existing kzalloc(sizeof(*sec), GFP_KERNEL) in adf_cfg_section_add(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_cfg.c | 49 +++++++++++--------
 1 file changed, 29 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg.c b/drivers/crypto/intel/qat/qat_common/adf_cfg.c
index 7180dd2b504a1..f60034387fd55 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
 /* Copyright(c) 2014 - 2020 Intel Corporation */
-#include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/list.h>
@@ -9,13 +8,11 @@
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
 
@@ -43,7 +40,9 @@ static void *qat_dev_cfg_next(struct seq_file *sfile, void *v, loff_t *pos)
 
 static void qat_dev_cfg_stop(struct seq_file *sfile, void *v)
 {
-	mutex_unlock(&qat_cfg_read_lock);
+	struct adf_cfg_device_data *dev_cfg = sfile->private;
+
+	up_read(&dev_cfg->lock);
 }
 
 static const struct seq_operations qat_dev_cfg_sops = {
@@ -272,13 +271,10 @@ int adf_cfg_add_key_value_param(struct adf_accel_dev *accel_dev,
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
@@ -308,20 +304,28 @@ int adf_cfg_add_key_value_param(struct adf_accel_dev *accel_dev,
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
 
@@ -339,21 +343,26 @@ EXPORT_SYMBOL_GPL(adf_cfg_add_key_value_param);
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
 
 	strscpy(sec->name, name);
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



