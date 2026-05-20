Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32BF3DBD73;
	Wed, 20 May 2026 16:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295367; cv=none; b=RE4UdOE2bmrJG2RXW1JG2ey1mAF1s/0o4yVJyeeHULxp19Duf1mUU2i/8Z2esX5ZmJ7bYcp7Xq55iqGsGg4ppY0jaXc0hRpHicikOlHX5KtPfEH8uD2Ka/kFyx+ITRGbaZj4IHT7AwdM47JvgEopwMJc6OJgFHqAiZAoztX6flw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295367; c=relaxed/simple;
	bh=sDXCVW8SprjKSXTlHXjqPzwfATgUwSZl6valr3SvMJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KXHdq5rhGiwhhJzKhEULQT5DdHZ+leq4k6J//ssOOiFfXr+b6NYT72osyoz83AJqTX8i0lj+TauNLe/pH5OQ2jlJlvWJHiRytCcNT5NpXaXA1R68aEqSi9Cdrg7owzr6ERs3n9tfZZnvX3j0l4w4NPMCBJrg72yoAt0s9rYVAqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T8d6P1cG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T8d6P1cG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3673C1F000E9;
	Wed, 20 May 2026 16:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295366;
	bh=4RXR5x1boD1GQmFv+HU+NXvZHxtgWL/K82A0rXXC8U0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T8d6P1cGzyb9o4qUylyx4tFbufTunOoQVDNe8nBFjxYfQ61n2p8ZuQMoMpkJd30Xs
	 B66UuFN3lXtdbmGpev8O9kYxGDvGIrmIA7m2mAOm2xpWIpRQJ/AnnbFMMDa70TGpG/
	 UK2nr0S4v2zemYvIa7iMzQSRDta9cT6KcvP26ZAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0385/1146] crypto: qat - disable 420xx AE cluster when lead engine is fused off
Date: Wed, 20 May 2026 18:10:35 +0200
Message-ID: <20260520162156.913924122@linuxfoundation.org>
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
index 35105213d40c0..0002122219bcb 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
@@ -97,9 +97,25 @@ static struct adf_hw_device_class adf_420xx_class = {
 
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



