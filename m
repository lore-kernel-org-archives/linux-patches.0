Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFBF2931F5;
	Sat, 12 Sep 2026 14:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222989; cv=none; b=DPVK3vOJGIO4iY7RWe3O1gsG+gMBuwsbjh3b7egtKns4+oOM4s7Xdlu2Mp25ZI4AVoCnEHTJS1V6fuhNO/hPsO77f0Pgl37CKW2z0TrCmQQ8WWI8dUJwghDsWq3Z1AYudBJCIQBCQJAn8cVnOvq53PCRP3PzhtadtTLNCrisAG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222989; c=relaxed/simple;
	bh=5XYs7A+yPRbc4sNEpjazS1PQzxuCFoVt5PsZ6CHXXhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eGA+/ZJiMCiOCXYUZHiu3er3oSVLV2A3w2xqLX5ZxXBtofyIQ1smzIfoy0ap0tN0FBvqKnWFq48G6XjHc3jknRB6x6RhomlB3mNi2XttbGs4hdPu469CJ/LDmCh/zXcRX+PVZfqvgyxXwNbeB1HFDqtVsI4WguSmwZscozUxl7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dHGIc8TH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dHGIc8TH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758D31F000FF;
	Sat, 12 Sep 2026 14:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222988;
	bh=rjfQOPTGejXOdLu8l5t1NESWLlO+j7UM5HwPQ3TCMQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dHGIc8TH48G2tnVg+cNGbeGN6d1eDcnj0JDwACPXZrRDhMvYRCQ8+7bYy2GXtw+Uk
	 PHWX6xMM3q6DTcl/QqrrJ/6oMDiPxpmUcpxLHvztFxABoCYHPCSaiLXR6TbZ8cOxzN
	 sFaSKIXSRxMDd3Lts7/qsISfO1U06K/uGushvhfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0698/1424] platform/x86: dell-wmi-base: Fix resource leak on module load failure
Date: Sat, 12 Sep 2026 08:52:10 +0200
Message-ID: <20260912065622.929336338@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 072841e02cf9c00a7e8a9c567a14239e02ca47ad ]

We need to properly clean up the SMBIOS request and the privacy driver
when the module load fails.

Fixes: 8af9fa37b8a3 ("platform/x86: dell-privacy: Add support for Dell hardware privacy")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/20260612173451.467629-3-W_Armin@gmx.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell-wmi-base.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/dell/dell-wmi-base.c b/drivers/platform/x86/dell/dell-wmi-base.c
index 01f3ff21c8884..713ec2c12a04e 100644
--- a/drivers/platform/x86/dell/dell-wmi-base.c
+++ b/drivers/platform/x86/dell/dell-wmi-base.c
@@ -839,9 +839,22 @@ static int __init dell_wmi_init(void)
 
 	err = dell_privacy_register_driver();
 	if (err)
-		return err;
+		goto out_smbios;
 
-	return wmi_driver_register(&dell_wmi_driver);
+	err = wmi_driver_register(&dell_wmi_driver);
+	if (err)
+		goto out_privacy;
+
+	return 0;
+
+out_privacy:
+	dell_privacy_unregister_driver();
+
+out_smbios:
+	if (wmi_requires_smbios_request)
+		dell_wmi_events_set_enabled(false);
+
+	return err;
 }
 late_initcall(dell_wmi_init);
 
-- 
2.53.0



