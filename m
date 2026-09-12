Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1508E357CFC;
	Sat, 12 Sep 2026 12:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215372; cv=none; b=uVBx0HX+TOcRVIrvuMVtCoF4K3Up7FIIoD4mghovgUYnlm1adap8nAqr3F3hCmaIAuVPaeN6KRrlgJG/CnzVA8dtUWG1mGifWywU2qiQMEmlb78BgZpPEZiItA2XnB+Rv1CceQtVM2xBk77GHFb9ZvznrgVVT8dWfJW+TnDiXhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215372; c=relaxed/simple;
	bh=lqM2IOxR8yebfU7ajPQwF2G8W0F8eDuUlHbLaFm8e4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UWWpL+rS1wjaXc9JDU277LFr4e09F6t+HIHFU4jV1iSLvuCTBBpw8Uj0XuxQj1LQdw3feewfJMpxmhR7LcuU0ia3CmQsvyRsV/RIvoroDFg7Mm5Xf1AvUHwt/yq/19x50gqTDozoy6Ahpibws5yJZyyQYPwTIUV5qmVJPZPrqPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dkSbr05n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dkSbr05n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D371F000FF;
	Sat, 12 Sep 2026 12:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215370;
	bh=Xgjb+93cBRHf3Z1yayZa7yPj6B2CW8AJYZSRWNqX2lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dkSbr05nljjlgmliYUc7x2RVNm3e0xPB291YJvwJIHBEKvF4rbm98c9NJYyM/0HfN
	 4Si6xo0+rKOxtJ2vo1EvTL6Sxkf/ywjp0bLBhE0If0/N635i9Fv8QX0OewADAl81Hv
	 QDOBvKrCBMBtCvfIs8g1a4nzrN0yIrSmPKEZHaU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0475/1376] platform/x86: dell-wmi-base: Fix resource leak on module load failure
Date: Sat, 12 Sep 2026 08:48:21 +0200
Message-ID: <20260912065618.121114996@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



