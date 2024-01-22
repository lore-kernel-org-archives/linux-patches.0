Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9FC133402;
	Tue, 23 Jan 2024 00:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969134; cv=none; b=khQlfmYAvPIp6E9pAt52NcyBkDGEnP7dlEdquAf0LqrOHTNzm+Ho87mJ1R64TP8xZ11w2g/jvC5hp6Y2gnHn4OGMoHl3WHF3JF3VKkj+b5x8gymXkHRFQGGNVOogFzyH9A0PUjaAGE6N/eYPc6t9D2MAlW1toe36zMTA1fq3MOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969134; c=relaxed/simple;
	bh=5a1Qt70N1mscjsqKTu7+Glw+2vmv4L619owWIxq+wWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3hxOrpAEmgEnzUA1JeEDem3O0VF3+6Edj+FGV1LBiSJwKh25tvX9Su/OF7WzaemHDwdu9OJhC89tHZk6iaWjfu4WKtuL3YzK+m3Q+pyqxMPw8T718MWrnnM6zic6RXVOMr6+8t3uKA8Xc4s/fjFD666IrYd3xl+y43+Aj/k5Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ttiBRxCq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ttiBRxCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1961C43399;
	Tue, 23 Jan 2024 00:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969134;
	bh=5a1Qt70N1mscjsqKTu7+Glw+2vmv4L619owWIxq+wWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ttiBRxCqmqjCIyseCJ7CnkndKLecFnHU2yrkU6ir5bGg7wbemjLBm43V2PVTkJnib
	 p6TNfGm/Ga5r+cuNwtB28K5Qu64ukfSpA3b5dw46nqkTu7bIj9pySzyUfqRRkQRuNv
	 s7iuUOFUyvct4SlC8iMBZvjKN6fTYmnpB8L57GDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 044/641] crypto: qat - prevent underflow in rp2srv_store()
Date: Mon, 22 Jan 2024 15:49:08 -0800
Message-ID: <20240122235819.464711764@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit e53c741303a59ee1682e11f61b7772863e02526d ]

The "ring" variable has an upper bounds check but nothing checks for
negatives.  This code uses kstrtouint() already and it was obviously
intended to be declared as unsigned int.  Make it so.

Fixes: dbc8876dd873 ("crypto: qat - add rp2svc sysfs attribute")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_sysfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
index ddffc98119c6..6f0b3629da13 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
@@ -242,7 +242,8 @@ static ssize_t rp2srv_store(struct device *dev, struct device_attribute *attr,
 			    const char *buf, size_t count)
 {
 	struct adf_accel_dev *accel_dev;
-	int ring, num_rings, ret;
+	int num_rings, ret;
+	unsigned int ring;
 
 	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
 	if (!accel_dev)
-- 
2.43.0



