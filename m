Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438262F617C;
	Sat, 12 Sep 2026 18:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238568; cv=none; b=NykP30tjXVidBYLcY1kmN74VKUQKDD9VnBij3EortBIjkfMhPEuKhQiPq162BQcpONZljEI9xEBlAilxHviB7P7h8Oq4HMRGx7AQYvePFBkGzmAWCvi2jlrITKFhR4Oy2QGIkprDjdMStQJV1jSM9F4r8F2Xow5uWHzMPL1IkuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238568; c=relaxed/simple;
	bh=A7y9KCtrqDkruFNepWh9L5qAPfa5riVZK4Y/01cMEZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GQ+0DJ0jmZRtrKM4VUnZsYB5qw4td+2rhpxykxVMrBPhHlK6Y4hHCo1go2MyTu8y3EB+nrnV4qUG0OEW4qGPw0TNCv2k7RbShV9S6TB7JO3ITYWMrJnF5fabdupbMhVarHgSr3rqqdIdePvxN2uhuqlZDGLMrcmHgn9dJmmX2mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OTIzSqFu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OTIzSqFu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2AB71F000FF;
	Sat, 12 Sep 2026 18:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238567;
	bh=8Y2ddebjfuwH5NZGHNRFqr3as4dDMom5hzm7KS9qN/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OTIzSqFuG1OCeMBV8yG920wDYyso+nMHifzukKjDta9oE/nmXC742ZR+Gf4D28X4L
	 FC/j4pewYpbsZmLNI92qfUqLh93Uvow1u51lXV0Bozo//CkKNs2Ey5LLCZhQNi/78w
	 jw085j8TyfuimxngxDMBWj6bsZmamOHR5ZgSEepA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 486/935] platform/x86: dell-wmi-base: Fix resource leak on module load failure
Date: Sat, 12 Sep 2026 08:58:36 +0200
Message-ID: <20260912065537.968862515@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index cc210e45c508d..e0c2839fea399 100644
--- a/drivers/platform/x86/dell/dell-wmi-base.c
+++ b/drivers/platform/x86/dell/dell-wmi-base.c
@@ -780,9 +780,22 @@ static int __init dell_wmi_init(void)
 
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



