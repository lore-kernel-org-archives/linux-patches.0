Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41ABF36F421;
	Wed, 20 May 2026 17:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298145; cv=none; b=ZhZYYqK9x1IBVh732jlUvdTmm9KcL/5Eai0aVs0zZbaMip09dGqS2jK8eV06bvOpYkLivpGnor7X0tmjopofEyMegJHnSuRSYKvYNjbX9+KfPy/MI6ySRWL4/vDyPE9DNrtAsqKmb7hLFQIRWqZimv+QqGNwJJ9hC6Erk5zs7CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298145; c=relaxed/simple;
	bh=uXrW/5mTZJ3Fcm0gH2JgUi/E8tl/QfYtJHWmsx+eD24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vtej6tPLp05v3NZBTqxcJWFd9pr5YyxDeOE3c6RwzmCSPNhYUWUh/XU4DSgsv7RFnNkTfWIl+WVQAzQCvhGd2i/I4ZcwrNfmQNBdetlL63gFsHu4a40rGbY+/mY4MctLc0Joc9HSK4+plbW+2xLzq1NyyGM0y+DWOULO2ro00aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BZ5h62+1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BZ5h62+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E701F00898;
	Wed, 20 May 2026 17:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298144;
	bh=Uz62lImJyOSNNc1wzem6azP+w6gRp1bxuNMvOXDq40U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BZ5h62+1MkMw/tW7qq5pDpEd9bSxihIsFqJtqCzL6TQ3tPF8RHHdDhmHENv6SQ4Km
	 2v1O/u3zu+XKBj7ZvlaOZVaSZso8Jmahk82XO6W1Q5x6TMHyhKefXNgCmzfnPQcAYa
	 Z/sSKBTfe1kAosmgGf//1abDWToY1GsobZZXXANw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 298/957] crypto: qat - disable 4xxx AE cluster when lead engine is fused off
Date: Wed, 20 May 2026 18:13:01 +0200
Message-ID: <20260520162140.997042359@linuxfoundation.org>
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



