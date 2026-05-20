Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6843F6619;
	Wed, 20 May 2026 18:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300556; cv=none; b=QPA2JgBKJiSq8DUh+WF6gYaO1feEEW1z1fe97+hxX7ejq7jbuElUwZupgP6Ufw+8l++Tc90sqNgQTOx+QZw3sBbVs3sURdg+I8AM+5OlUkcEgbdI7gSWnSNLvV6Z4nCFzS04ou3lv3SgzHdueUONCGx86B91+zSwEsZL3PIkz3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300556; c=relaxed/simple;
	bh=+iwJKNwSZXDuh4ETO8HZwLS7YkRb/7J6Io8QJ5pTd3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HaZl5bgybp9DQRfFGlPmNnxm+wdV6IJgH85By67UqudlHFj8d6IfItnFBD0GwvLT+yAtSnTgyQT9eTEf7M9TzotxoiGc6QEvTOJaiuyIIQW12sk1kzchQGFQy1iRoN5IS+AS99GhLGcxgLkov15eaqvzdY91ilNd4q9wzQEp0KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iP/K/RpB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iP/K/RpB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F521F000E9;
	Wed, 20 May 2026 18:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300554;
	bh=TNd6X7BwiwBzrpOyLmO9Tw/zyBr+6abSALEk0ods7KQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iP/K/RpBkrkiwTjNFec3X4xNdvrWqQEO0pG0HrLbsc9Zz0ea9LRk+RCm/osXt2CtS
	 DEmndM8jho+uNUjW8TKGpK//D33JI0/88WoRevUgCPiZE78CaljGGrrzqCiS/Yj2Q0
	 w4t7mRJR6RX4H1hnCqi7YjtW6+79liIbAj67XZ4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 220/666] crypto: qat - disable 420xx AE cluster when lead engine is fused off
Date: Wed, 20 May 2026 18:17:11 +0200
Message-ID: <20260520162115.978031870@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0e7d0db475d5d..5d32f2958da87 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
@@ -98,9 +98,25 @@ static struct adf_hw_device_class adf_420xx_class = {
 
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



