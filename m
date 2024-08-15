Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1AC01714AE;
	Thu, 15 Aug 2024 13:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729106; cv=none; b=YG4YeZ3zRincAL0ZJ5bKlO725q9FNp+Yh4cQSSNHnpUOWleflrCtpC5SBH2SP7stMx1GpUyuof+07jQYtnBbtHS/X6t5l7cFd2bdSmhY0jRbxEMrNJ+4+7TgIOXvamwkhxgB38f9cD05qZyTckJiUs7ZHxp7K8IN9eYGCSaX6eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729106; c=relaxed/simple;
	bh=3NCVpMxeU0VSuxrDBDdeYhaIHyuz/ssuWmKZIHXUAqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MhOotl50eQDsffDY8/mWVsxy+gDFiwoocXHn23xJR5q3DAH7FKNmhV5bbxef3UJm8XC4iimdrE1WtkirkssXuo3+NoHqiRGG/wO+EBHEe9fqmuHphLT0fl6GO3AO0bW1zYcDnD8uZxD2qJ1mvIteIH49voqhCkUYCVMx+PUhYxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cuzu8Dlh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cuzu8Dlh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74AFDC4AF0A;
	Thu, 15 Aug 2024 13:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729105;
	bh=3NCVpMxeU0VSuxrDBDdeYhaIHyuz/ssuWmKZIHXUAqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cuzu8Dlh3WxnL2nX3vNsMJgIpnZ3nsI31fCqeMKixQsJ3tUwVJ4OWQeeUrA+vbXxq
	 u5UTKBxxQfvQTYooj9n0PXV5F1dgBHdhz/ezuZXrwtz/q5WV52WTzB51owbTMmAM4h
	 8kmZWgPpZRYI4egC0WRfQUGbU6v1rDU9VLhRR+7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patil Rajesh Reddy <Patil.Reddy@amd.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 16/22] platform/x86/amd/pmf: Fix to Update HPD Data When ALS is Disabled
Date: Thu, 15 Aug 2024 15:25:24 +0200
Message-ID: <20240815131831.885388207@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131831.265729493@linuxfoundation.org>
References: <20240815131831.265729493@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

[ Upstream commit 78296429e20052b029211b0aca64aadc5052d581 ]

If the Ambient Light Sensor (ALS) is disabled, the current code in the PMF
driver does not query for Human Presence Detection (HPD) data in
amd_pmf_get_sensor_info(). As a result, stale HPD data is used by PMF-TA
to evaluate policy conditions, leading to unexpected behavior in the policy
output actions.

To resolve this issue, modify the PMF driver to query HPD data
independently of ALS.

Since user_present is a boolean, modify the current code to return true if
the user is present and false if the user is away or if the sensor is not
detected, and report this status to the PMF TA firmware accordingly.

With this change, amd_pmf_get_sensor_info() now returns void instead of
int.

Fixes: cedecdba60f4 ("platform/x86/amd/pmf: Get ambient light information from AMD SFH driver")
Co-developed-by: Patil Rajesh Reddy <Patil.Reddy@amd.com>
Signed-off-by: Patil Rajesh Reddy <Patil.Reddy@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Link: https://lore.kernel.org/r/20240730142316.3846259-1-Shyam-sundar.S-k@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmf/spc.c | 32 ++++++++++--------------------
 1 file changed, 11 insertions(+), 21 deletions(-)

diff --git a/drivers/platform/x86/amd/pmf/spc.c b/drivers/platform/x86/amd/pmf/spc.c
index a3dec14c30043..3c153fb1425e9 100644
--- a/drivers/platform/x86/amd/pmf/spc.c
+++ b/drivers/platform/x86/amd/pmf/spc.c
@@ -150,36 +150,26 @@ static int amd_pmf_get_slider_info(struct amd_pmf_dev *dev, struct ta_pmf_enact_
 	return 0;
 }
 
-static int amd_pmf_get_sensor_info(struct amd_pmf_dev *dev, struct ta_pmf_enact_table *in)
+static void amd_pmf_get_sensor_info(struct amd_pmf_dev *dev, struct ta_pmf_enact_table *in)
 {
 	struct amd_sfh_info sfh_info;
-	int ret;
+
+	/* Get the latest information from SFH */
+	in->ev_info.user_present = false;
 
 	/* Get ALS data */
-	ret = amd_get_sfh_info(&sfh_info, MT_ALS);
-	if (!ret)
+	if (!amd_get_sfh_info(&sfh_info, MT_ALS))
 		in->ev_info.ambient_light = sfh_info.ambient_light;
 	else
-		return ret;
+		dev_dbg(dev->dev, "ALS is not enabled/detected\n");
 
 	/* get HPD data */
-	ret = amd_get_sfh_info(&sfh_info, MT_HPD);
-	if (ret)
-		return ret;
-
-	switch (sfh_info.user_present) {
-	case SFH_NOT_DETECTED:
-		in->ev_info.user_present = 0xff; /* assume no sensors connected */
-		break;
-	case SFH_USER_PRESENT:
-		in->ev_info.user_present = 1;
-		break;
-	case SFH_USER_AWAY:
-		in->ev_info.user_present = 0;
-		break;
+	if (!amd_get_sfh_info(&sfh_info, MT_HPD)) {
+		if (sfh_info.user_present == SFH_USER_PRESENT)
+			in->ev_info.user_present = true;
+	} else {
+		dev_dbg(dev->dev, "HPD is not enabled/detected\n");
 	}
-
-	return 0;
 }
 
 void amd_pmf_populate_ta_inputs(struct amd_pmf_dev *dev, struct ta_pmf_enact_table *in)
-- 
2.43.0



