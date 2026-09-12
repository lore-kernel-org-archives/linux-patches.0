Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8743F1AAD;
	Sat, 12 Sep 2026 07:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198074; cv=none; b=ba3jWtrGZxeRmr3cC0TIs5gK5p3v7a6Q0NtFxXWKImEcP9fQ/RPwxhxhfx32n5NmYvu1u7x4FanZ1lcJtxT6+RS2GfbIDcPF1IJz8FkrCIR7A//vlktzqKcbbIgOph1iY1+KiNxa9s2WDQKJsmFVDFN/6RNzaIjH0vOeu+EHCbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198074; c=relaxed/simple;
	bh=8+iHo31skNS4F3K2XeiPEkccG/FkRtd+j9e5PKekfq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=azOxLl6HpNYCCiLstuGvSicr8tB39RfNABajzITexL0Sttr1e28aTKMnHwYR7TNSvgwrVX9bkXvhip/wU2nrHVpc6bm4c/JocvGbIR6G1lqhn1Q6kL9/vcvXpBbx+SmYtCPC59QQVN6bOq2XTZ5mClrB/3q0UJKQ+epC6pmkx0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yr2Npokn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yr2Npokn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44141F00893;
	Sat, 12 Sep 2026 07:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198071;
	bh=8J/855Svw0G7hfbwS7XJfOJB7T1dQNLYZHSZiedkwVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yr2NpoknaghGZOx3j7jPPI8XjwzKLEHDgg+NYBBA1nKTznzwOkqWQBjmLqo5PabLB
	 ABq9Xu+dRMBmaxYHUgjBphoerutSqVi2/qLmV6QCJz7sor6L7DzhKYdGZzu3LZ8mmq
	 oBbOic7pK0zlEZzWwMOkUPCyLhwqef0tfePzwz0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0304/1815] platform/x86: dell-wmi-base: Fix resource leak on module load failure
Date: Sat, 12 Sep 2026 08:34:14 +0200
Message-ID: <20260912065656.084634594@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 997383ba18465..fd6a508cd902c 100644
--- a/drivers/platform/x86/dell/dell-wmi-base.c
+++ b/drivers/platform/x86/dell/dell-wmi-base.c
@@ -843,9 +843,22 @@ static int __init dell_wmi_init(void)
 
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



