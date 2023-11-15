Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154D73DBA1
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2hU742yc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB374C433C9;
	Wed, 15 Nov 2023 19:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078243;
	bh=458x0BszD38qTkCZujnbRqabhmIOi3/ZsTk65cUOZ/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2hU742yce6LSOWY81mhH4c7w6eJtUDEV3cNGrAtSJck/Hz6ShMle5DpAFKeMGXkx+
	 Vz420CJdesG+8nCeI5mJLZU6l3nPuxFMxxqeDkSDnfqaCdbOHJsu38/31OUkHNN9QJ
	 Bmw6ikwwMKhwLnN+7Fts6a5I0z2cxgqe8VZBLXtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Adam Guerin <adam.guerin@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 201/379] crypto: qat - fix unregistration of crypto algorithms
Date: Wed, 15 Nov 2023 14:24:36 -0500
Message-ID: <20231115192657.000350097@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit 9b2f33a1bfcda90b857431a764c9c8f9a412bbe5 ]

The function adf_dev_init(), through the subsystem qat_crypto, populates
the list of list of crypto instances accel_dev->crypto_list.
If the list of instances is not empty, the function adf_dev_start() will
then call qat_algs_registers() and qat_asym_algs_register() to register
the crypto algorithms into the crypto framework.

If any of the functions in adf_dev_start() fail, the caller of such
function, in the error path calls adf_dev_down() which in turn call
adf_dev_stop() and adf_dev_shutdown(), see for example the function
state_store in adf_sriov.c.
However, if the registration of crypto algorithms is not done,
adf_dev_stop() will try to unregister the algorithms regardless.
This might cause the counter active_devs in qat_algs.c and
qat_asym_algs.c to get to a negative value.

Add a new state, ADF_STATUS_CRYPTO_ALGS_REGISTERED, which tracks if the
crypto algorithms are registered into the crypto framework. Then use
this to unregister the algorithms if such flag is set. This ensures that
the crypto algorithms are only unregistered if previously registered.

Fixes: d8cba25d2c68 ("crypto: qat - Intel(R) QAT driver framework")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/adf_common_drv.h | 1 +
 drivers/crypto/qat/qat_common/adf_init.c       | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index bff613eec5c4b..d2bc2361cd069 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -25,6 +25,7 @@
 #define ADF_STATUS_AE_STARTED 6
 #define ADF_STATUS_PF_RUNNING 7
 #define ADF_STATUS_IRQ_ALLOCATED 8
+#define ADF_STATUS_CRYPTO_ALGS_REGISTERED 9
 
 enum adf_dev_reset_mode {
 	ADF_DEV_RESET_ASYNC = 0,
diff --git a/drivers/crypto/qat/qat_common/adf_init.c b/drivers/crypto/qat/qat_common/adf_init.c
index d6f3314246179..2e3481270c4ba 100644
--- a/drivers/crypto/qat/qat_common/adf_init.c
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -209,6 +209,8 @@ int adf_dev_start(struct adf_accel_dev *accel_dev)
 		clear_bit(ADF_STATUS_STARTED, &accel_dev->status);
 		return -EFAULT;
 	}
+	set_bit(ADF_STATUS_CRYPTO_ALGS_REGISTERED, &accel_dev->status);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(adf_dev_start);
@@ -237,10 +239,12 @@ void adf_dev_stop(struct adf_accel_dev *accel_dev)
 	clear_bit(ADF_STATUS_STARTING, &accel_dev->status);
 	clear_bit(ADF_STATUS_STARTED, &accel_dev->status);
 
-	if (!list_empty(&accel_dev->crypto_list)) {
+	if (!list_empty(&accel_dev->crypto_list) &&
+	    test_bit(ADF_STATUS_CRYPTO_ALGS_REGISTERED, &accel_dev->status)) {
 		qat_algs_unregister();
 		qat_asym_algs_unregister();
 	}
+	clear_bit(ADF_STATUS_CRYPTO_ALGS_REGISTERED, &accel_dev->status);
 
 	list_for_each(list_itr, &service_table) {
 		service = list_entry(list_itr, struct service_hndl, list);
-- 
2.42.0



