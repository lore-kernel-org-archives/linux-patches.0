Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2FE32C93E;
	Fri, 17 Oct 2025 15:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715390; cv=none; b=TPGwt/guK3QmylOnn8VGlC1wgZALxmqyvkK9pXw4tgePQdb2wGa6jEFqzlClIsn6ARkEFptxfPTQBWLiqChLnBQUjCBiizmc5iz6DAzDmyrXs0eC+Kzn6ACG+hHoHxPoe33BzVo5wTF6k9GI1aalfhauVrruV0dYEDtaCUCL7oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715390; c=relaxed/simple;
	bh=Fcxc3hYLMEWtBCTynYoltiNTZdJ8EY8lwEPzcYAR9+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQU9Sdvl6OUzcWqD+3KVDGdq1zag6MUXVOKj6ZDcwLAMRg2kV/0FLpplfYGM1XMF44cJAZeE/iqvPoOhrvfAbMQpR8rV/qGgeI/bVXHZICDR7jDLn3GX4Jrftt6nA+BYPEBPAd8j7wenzMtNuLC9VBBhNo/lPMtOTbnjOEL77SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iq93XGLN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iq93XGLN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ECE8C4CEE7;
	Fri, 17 Oct 2025 15:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715390;
	bh=Fcxc3hYLMEWtBCTynYoltiNTZdJ8EY8lwEPzcYAR9+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iq93XGLNnfrtKCkedrd/NyRZilFgsx6zQV5KzsLLjKXpTIjG+uwq3KcUtH+KZzh3Y
	 eqiT7Nrd2uJ8vQiVTuYQwXoTLO2JEbh+bPt0WS9EdQO67Y7dCvewEFgd4JGHnvt3Tn
	 xcLxh5wwM1iXfmCbvLP2RWWa3LzYNbH0GSKF85Ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.17 166/371] firmware: exynos-acpm: fix PMIC returned errno
Date: Fri, 17 Oct 2025 16:52:21 +0200
Message-ID: <20251017145207.937066273@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tudor Ambarus <tudor.ambarus@linaro.org>

commit 1da4cbefed4a2e69ebad81fc9b356cd9b807f380 upstream.

ACPM PMIC command handlers returned a u8 value when they should
have returned either zero or negative error codes.
Translate the APM PMIC errno to linux errno.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/linux-input/aElHlTApXj-W_o1r@stanley.mountain/
Fixes: a88927b534ba ("firmware: add Exynos ACPM protocol driver")
Cc: stable@vger.kernel.org
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/samsung/exynos-acpm-pmic.c | 25 ++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/samsung/exynos-acpm-pmic.c b/drivers/firmware/samsung/exynos-acpm-pmic.c
index 39b33a356ebd..961d7599e422 100644
--- a/drivers/firmware/samsung/exynos-acpm-pmic.c
+++ b/drivers/firmware/samsung/exynos-acpm-pmic.c
@@ -4,7 +4,9 @@
  * Copyright 2020 Google LLC.
  * Copyright 2024 Linaro Ltd.
  */
+#include <linux/array_size.h>
 #include <linux/bitfield.h>
+#include <linux/errno.h>
 #include <linux/firmware/samsung/exynos-acpm-protocol.h>
 #include <linux/ktime.h>
 #include <linux/types.h>
@@ -33,6 +35,19 @@ enum exynos_acpm_pmic_func {
 	ACPM_PMIC_BULK_WRITE,
 };
 
+static const int acpm_pmic_linux_errmap[] = {
+	[0] = 0, /* ACPM_PMIC_SUCCESS */
+	[1] = -EACCES, /* Read register can't be accessed or issues to access it. */
+	[2] = -EACCES, /* Write register can't be accessed or issues to access it. */
+};
+
+static int acpm_pmic_to_linux_err(int err)
+{
+	if (err >= 0 && err < ARRAY_SIZE(acpm_pmic_linux_errmap))
+		return acpm_pmic_linux_errmap[err];
+	return -EIO;
+}
+
 static inline u32 acpm_pmic_set_bulk(u32 data, unsigned int i)
 {
 	return (data & ACPM_PMIC_BULK_MASK) << (ACPM_PMIC_BULK_SHIFT * i);
@@ -79,7 +94,7 @@ int acpm_pmic_read_reg(const struct acpm_handle *handle,
 
 	*buf = FIELD_GET(ACPM_PMIC_VALUE, xfer.rxd[1]);
 
-	return FIELD_GET(ACPM_PMIC_RETURN, xfer.rxd[1]);
+	return acpm_pmic_to_linux_err(FIELD_GET(ACPM_PMIC_RETURN, xfer.rxd[1]));
 }
 
 static void acpm_pmic_init_bulk_read_cmd(u32 cmd[4], u8 type, u8 reg, u8 chan,
@@ -110,7 +125,7 @@ int acpm_pmic_bulk_read(const struct acpm_handle *handle,
 	if (ret)
 		return ret;
 
-	ret = FIELD_GET(ACPM_PMIC_RETURN, xfer.rxd[1]);
+	ret = acpm_pmic_to_linux_err(FIELD_GET(ACPM_PMIC_RETURN, xfer.rxd[1]));
 	if (ret)
 		return ret;
 
@@ -150,7 +165,7 @@ int acpm_pmic_write_reg(const struct acpm_handle *handle,
 	if (ret)
 		return ret;
 
-	return FIELD_GET(ACPM_PMIC_RETURN, xfer.rxd[1]);
+	return acpm_pmic_to_linux_err(FIELD_GET(ACPM_PMIC_RETURN, xfer.rxd[1]));
 }
 
 static void acpm_pmic_init_bulk_write_cmd(u32 cmd[4], u8 type, u8 reg, u8 chan,
@@ -190,7 +205,7 @@ int acpm_pmic_bulk_write(const struct acpm_handle *handle,
 	if (ret)
 		return ret;
 
-	return FIELD_GET(ACPM_PMIC_RETURN, xfer.rxd[1]);
+	return acpm_pmic_to_linux_err(FIELD_GET(ACPM_PMIC_RETURN, xfer.rxd[1]));
 }
 
 static void acpm_pmic_init_update_cmd(u32 cmd[4], u8 type, u8 reg, u8 chan,
@@ -220,5 +235,5 @@ int acpm_pmic_update_reg(const struct acpm_handle *handle,
 	if (ret)
 		return ret;
 
-	return FIELD_GET(ACPM_PMIC_RETURN, xfer.rxd[1]);
+	return acpm_pmic_to_linux_err(FIELD_GET(ACPM_PMIC_RETURN, xfer.rxd[1]));
 }
-- 
2.51.0



