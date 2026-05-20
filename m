Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3AEF1B7910;
	Wed, 20 May 2026 17:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298148; cv=none; b=nd+7HnNXHBoyrHlhsajvBa57O9Drm9bDQ239jOACULfBh+s2cvFpgA01a5pU6M+VCQ4T9sft55QJ+JimvaQLO6mqIKaGqfX6FjzVD5tKlXdtp5MkrfTnErPUuBRyMIW7qdpXsPEwJ8AqL0eC+94jz/sF+phOTfUcrA9nOJZ7n6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298148; c=relaxed/simple;
	bh=ZsTpjTxMCmmdeDrUROEYgkmY94bv9Z0qCstTQN7ERag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P8GEAqDPUW2o8pJA1bQxGjuicNWfPNDB9WudwLfZ5daxlvBaFV6D0mZOXq6xlBusQ1/QsCfn8qwQzyRqr1PdtO5A61UjZe+2T63saxupjFZSIJr0SrEfb0P7qE/FMXNwrmo6f0kMAQa60x/bqCxGEbV56bTJY0uGb6eUGQTI7Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v1abocQD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v1abocQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 440E31F000E9;
	Wed, 20 May 2026 17:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298146;
	bh=HFaWfXOeTE/U6koVfeTf/fRZVY9LItVSSagcyaECILo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v1abocQDcfRfMEnVJHtISRdWWqchQXY7ZL7qyaeYot0s9fJVZsGijELpYEHg8jRLh
	 NK8VP5i89PCMHRFARC4+jwuvJg+7JMttKH5O3/1MRillePMQHIuQsvm8JmHbqfTiT0
	 fRyqvwYXDWZ51+WVmYZXCFQgqmO8RSAVCNKAgdQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 299/957] crypto: qat - disable 420xx AE cluster when lead engine is fused off
Date: Wed, 20 May 2026 18:13:02 +0200
Message-ID: <20260520162141.018027105@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahsan Atta <ahsan.atta@intel.com>

[ Upstream commit f216e0f2d1787e662bb6662c9c522185aa3b855a ]

The get_ae_mask() function only disables individual engines based on
the fuse register, but engines are organized in clusters of 4. If the
lead engine of a cluster is fused off, the entire cluster must be
disabled.

Replace the single bitmask inversion with explicit test_bit() checks
on the lead engine of each group, disabling the full ADF_AE_GROUP
when the lead bit is set.

Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Fixes: fcf60f4bcf54 ("crypto: qat - add support for 420xx devices")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../intel/qat/qat_420xx/adf_420xx_hw_data.c   | 20 +++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
index 53fa91d577ed0..cb52aaa323a7e 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
@@ -96,9 +96,25 @@ static struct adf_hw_device_class adf_420xx_class = {
 
 static u32 get_ae_mask(struct adf_hw_device_data *self)
 {
-	u32 me_disable = self->fuses[ADF_FUSECTL4];
+	unsigned long fuses = self->fuses[ADF_FUSECTL4];
+	u32 mask = ADF_420XX_ACCELENGINES_MASK;
 
-	return ~me_disable & ADF_420XX_ACCELENGINES_MASK;
+	if (test_bit(0, &fuses))
+		mask &= ~ADF_AE_GROUP_0;
+
+	if (test_bit(4, &fuses))
+		mask &= ~ADF_AE_GROUP_1;
+
+	if (test_bit(8, &fuses))
+		mask &= ~ADF_AE_GROUP_2;
+
+	if (test_bit(12, &fuses))
+		mask &= ~ADF_AE_GROUP_3;
+
+	if (test_bit(16, &fuses))
+		mask &= ~ADF_AE_GROUP_4;
+
+	return mask;
 }
 
 static u32 uof_get_num_objs(struct adf_accel_dev *accel_dev)
-- 
2.53.0



