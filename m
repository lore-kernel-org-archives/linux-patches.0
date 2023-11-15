Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F493DB8F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h4Bsuy5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABAE7C433C7;
	Wed, 15 Nov 2023 19:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078252;
	bh=3YBXlBN2L5oCPeTJN8aVSVByeyOLEBIWnnf8nkCEaUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h4Bsuy5L2vgGw/FNpbjSTcqDcPqfkXt+GykutO55CQxVjSUB8qxGU0JfLfVdafpv7
	 3FrxIo+N/xK02P7o7EZySei6LVuE3Iy74oQPiD4NQgHr8oN8jZ4AY6VXnK7MTF9iCC
	 vj3nPzNZmE5bBUVCLhRt3HS1Pj8NYDc2VwNI1bh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Damian Muszynski <damian.muszynski@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 207/379] crypto: qat - increase size of buffers
Date: Wed, 15 Nov 2023 14:24:42 -0500
Message-ID: <20231115192657.356713094@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit 4e4e2ed22d505c5bacf65c6a39bfb6d120d24785 ]

Increase the size of the buffers used for composing the names used for
the transport debugfs entries and the vector name to avoid a potential
truncation.

This resolves the following errors when compiling the driver with W=1
and KCFLAGS=-Werror on GCC 12.3.1:

    drivers/crypto/intel/qat/qat_common/adf_transport_debug.c: In function ‘adf_ring_debugfs_add’:
    drivers/crypto/intel/qat/qat_common/adf_transport_debug.c:100:60: error: ‘snprintf’ output may be truncated before the last format character [-Werror=format-truncation=]
    drivers/crypto/intel/qat/qat_common/adf_isr.c: In function ‘adf_isr_resource_alloc’:
    drivers/crypto/intel/qat/qat_common/adf_isr.c:197:47: error: ‘%d’ directive output may be truncated writing between 1 and 11 bytes into a region of size between 0 and 5 [-Werror=format-truncation=]

Fixes: a672a9dc872e ("crypto: qat - Intel(R) QAT transport code")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/adf_accel_devices.h   | 2 +-
 drivers/crypto/qat/qat_common/adf_transport_debug.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 20f50d0e65f89..ad01d99e6e2ba 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -27,7 +27,7 @@
 #define ADF_PCI_MAX_BARS 3
 #define ADF_DEVICE_NAME_LENGTH 32
 #define ADF_ETR_MAX_RINGS_PER_BANK 16
-#define ADF_MAX_MSIX_VECTOR_NAME 16
+#define ADF_MAX_MSIX_VECTOR_NAME 48
 #define ADF_DEVICE_NAME_PREFIX "qat_"
 
 enum adf_accel_capabilities {
diff --git a/drivers/crypto/qat/qat_common/adf_transport_debug.c b/drivers/crypto/qat/qat_common/adf_transport_debug.c
index 08bca1c506c0e..e2dd568b87b51 100644
--- a/drivers/crypto/qat/qat_common/adf_transport_debug.c
+++ b/drivers/crypto/qat/qat_common/adf_transport_debug.c
@@ -90,7 +90,7 @@ DEFINE_SEQ_ATTRIBUTE(adf_ring_debug);
 int adf_ring_debugfs_add(struct adf_etr_ring_data *ring, const char *name)
 {
 	struct adf_etr_ring_debug_entry *ring_debug;
-	char entry_name[8];
+	char entry_name[16];
 
 	ring_debug = kzalloc(sizeof(*ring_debug), GFP_KERNEL);
 	if (!ring_debug)
@@ -192,7 +192,7 @@ int adf_bank_debugfs_add(struct adf_etr_bank_data *bank)
 {
 	struct adf_accel_dev *accel_dev = bank->accel_dev;
 	struct dentry *parent = accel_dev->transport->debug;
-	char name[8];
+	char name[16];
 
 	snprintf(name, sizeof(name), "bank_%02d", bank->bank_number);
 	bank->bank_debug_dir = debugfs_create_dir(name, parent);
-- 
2.42.0



