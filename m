Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED872594BD;
	Sat, 12 Sep 2026 16:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229356; cv=none; b=VeHu3/pac+1rK+xQNrNSSBE6iaV+mmkoUmmmZLY9AEhxJAxZMTmn/djWYvSCexbdPHlF4kqCfOVphG2Db4AgCMxq5Ln9QX8/7CGgu0L75M5TLAo+HydN+G7Exmbr2vR7URiIa3aHZ3F9VYfXHI5dWi6VoSsJFoypw5T/akANA0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229356; c=relaxed/simple;
	bh=Sy1zKfGSg9xzDutEa6nBLk0lkigKpyC0zmkjYhImWjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EItLvtG0PnxWWaJJjZrdWWXpYspPjQeoAFEnC38OFFwSg/FHMX/E2txXV8jmzmCsCDriOf3tWPS1ZbLwe5XXX8LgW7+jD6LeqWwwl+F5urZqdrxEo4BowvN7nqAiFmy28rqWGy/gz1FtTRQ7yyecPZ6yj5JJ2DDK5Qc723WpTtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ITnnHQYG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ITnnHQYG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E32C51F000FF;
	Sat, 12 Sep 2026 16:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229354;
	bh=z8CbqrsnPpfHRbw7U6zEa9NSNbaSfwblhWBdBbkzyh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ITnnHQYG5TK1chQTKBpNpfp/gYg16KSnOBfRcrFzbyadrlD+4a2430juiS7NzDHDM
	 1SOx7Wh2r61FbMIHkpIwfiiFTECgr7HTDgbEpv/9BUqncJkzqZdvJ2TVNavrXMaVl0
	 86/HMd1At1bNsksfEzH8p6gfiPsJcCl5DZTD2G8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0573/1191] platform/x86: dell-wmi-base: Fix resource leak on module load failure
Date: Sat, 12 Sep 2026 08:55:01 +0200
Message-ID: <20260912065601.116817442@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



