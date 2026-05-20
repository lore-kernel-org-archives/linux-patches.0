Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075B5370AE5;
	Wed, 20 May 2026 16:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295478; cv=none; b=qCH9dcYG7663mUQrXVxkDtPcju+Cxmlj5+nbu318oAl9uLZZC0zh8HoAQXhQtb4PYUAFVFFkuhFQVQ9VWNum0/lwvnsZbBoKrrE8JrByFy4kXZF4YwCZldIwjR6Wotuk8/IaX1httOaBg4B9nA6CwKEghcuYAFBFsYP4en89luI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295478; c=relaxed/simple;
	bh=0oIgHwj5b5Ye7KV2F1DMynQ9pKTkRCPPcqG/KV9mTW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZeYhOGqUuHS3h6T93CXuHkIQK2SK6DnFVeOrnEhj2GdFYWIpG+6LxmIWpa8zTr91G9Kba+aEXOZYDu+DB2bPPE8liaiRwlLsOJVSquwb7khdwmWOMFunnZmR/iCUvq7T2ZjoRH6R6+1XZfvGRjkr7RKkS0Cc5mLdZdHaEbmv2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oBT6+Lkj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oBT6+Lkj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3021F000E9;
	Wed, 20 May 2026 16:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295476;
	bh=EotuGJLapoGY4C6j95QAeHeasv6oE9A6AspuPerN67Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oBT6+LkjCLe3SZcdAxkLL6lNV9XsyfVa3eKJZ39twFF4PzsibUH8AbJrt4hPoHAkN
	 rSASD0W1jT5WzovGf6IVmUP+7FtE05yvehcheOP/JdHWl81zgNcd5RGGJwkTFTXToj
	 RXrOxkGt4+ySXNhvk8kMsyMIFtQoBI4Qg9gZ11DU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0384/1146] crypto: qat - disable 4xxx AE cluster when lead engine is fused off
Date: Wed, 20 May 2026 18:10:34 +0200
Message-ID: <20260520162156.891123249@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahsan Atta <ahsan.atta@intel.com>

[ Upstream commit b260d53561dd69b29505222ec44cf386ac2c2ca6 ]

The get_ae_mask() function only disables individual engines based on
the fuse register, but engines are organized in clusters of 4. If the
lead engine of a cluster is fused off, the entire cluster must be
disabled.

Replace the single bitmask inversion with explicit test_bit() checks
on the lead engine of each group, disabling the full ADF_AE_GROUP
when the lead bit is set.

Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Fixes: 8c8268166e834 ("crypto: qat - add qat_4xxx driver")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c   | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index 740f68a36ac51..900f19b90b2dc 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -100,9 +100,19 @@ static struct adf_hw_device_class adf_4xxx_class = {
 
 static u32 get_ae_mask(struct adf_hw_device_data *self)
 {
-	u32 me_disable = self->fuses[ADF_FUSECTL4];
+	unsigned long fuses = self->fuses[ADF_FUSECTL4];
+	u32 mask = ADF_4XXX_ACCELENGINES_MASK;
 
-	return ~me_disable & ADF_4XXX_ACCELENGINES_MASK;
+	if (test_bit(0, &fuses))
+		mask &= ~ADF_AE_GROUP_0;
+
+	if (test_bit(4, &fuses))
+		mask &= ~ADF_AE_GROUP_1;
+
+	if (test_bit(8, &fuses))
+		mask &= ~ADF_AE_GROUP_2;
+
+	return mask;
 }
 
 static u32 get_accel_cap(struct adf_accel_dev *accel_dev)
-- 
2.53.0



