Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D3B197A76;
	Tue, 10 Sep 2024 10:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962946; cv=none; b=q5Mu+2w1XoOajlRPQgJ47OQuinr/ZQebh45hJu93AAL4B4eFv/E6C8XWfMf6UpH/Ci9pYSvfGuXL28VXEM5bMMpp374D6ZhzAeBxYpAzHMkgfXuNFTG5gBGeKAhYD38pbBSoNXCFBvkwun2NU338Mx30zrsQsdGB1dSub6IklO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962946; c=relaxed/simple;
	bh=7lmZPbnTzV/D55XS3eDeukoYQAEAA5tIiQAtShINJZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bjDtVx7YYC5+ZL2HwHKeBky8HR6/EWruiKpG2oj77ZAnGwh53gdwn52F//1WOLhmBjG5DbhgpcFkNArZhE34o76PnrfZt61CMx1ykdmLhqSwzznA187he/OTdrZ0qGMBRrVa20ULqmWL6hS3hAWjXeXHRFTI2/w8pz5lzKrDCkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rjFPCaSh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rjFPCaSh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC8CC4CEC3;
	Tue, 10 Sep 2024 10:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962945;
	bh=7lmZPbnTzV/D55XS3eDeukoYQAEAA5tIiQAtShINJZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rjFPCaShdn7dprrqysmXWe9v3rjAf++Q8LFh9fH3rwudi8jGt0POZ4e7YVXjHBtWD
	 h+NSf3CFWk57SB57bLupZjPkLRU50f1FJqciLl5s+w1PJEbnTTyqdBAvZT/Eqw189B
	 wzZG3klT0CdErXDRdhFBy5SaAZNKArEhBuqmQWAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 076/192] platform/x86: dell-smbios: Fix error path in dell_smbios_init()
Date: Tue, 10 Sep 2024 11:31:40 +0200
Message-ID: <20240910092601.112462278@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit ffc17e1479e8e9459b7afa80e5d9d40d0dd78abb ]

In case of error in build_tokens_sysfs(), all the memory that has been
allocated is freed at end of this function. But then free_group() is
called which performs memory deallocation again.

Also, instead of free_group() call, there should be exit_dell_smbios_smm()
and exit_dell_smbios_wmi() calls, since there is initialization, but there
is no release of resources in case of an error.

Fix these issues by replacing free_group() call with
exit_dell_smbios_wmi() and exit_dell_smbios_smm().

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 33b9ca1e53b4 ("platform/x86: dell-smbios: Add a sysfs interface for SMBIOS tokens")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Link: https://lore.kernel.org/r/20240830065428.9544-1-amishin@t-argos.ru
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell-smbios-base.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/dell/dell-smbios-base.c b/drivers/platform/x86/dell/dell-smbios-base.c
index 86b95206cb1b..6fb538a13868 100644
--- a/drivers/platform/x86/dell/dell-smbios-base.c
+++ b/drivers/platform/x86/dell/dell-smbios-base.c
@@ -590,7 +590,10 @@ static int __init dell_smbios_init(void)
 	return 0;
 
 fail_sysfs:
-	free_group(platform_device);
+	if (!wmi)
+		exit_dell_smbios_wmi();
+	if (!smm)
+		exit_dell_smbios_smm();
 
 fail_create_group:
 	platform_device_del(platform_device);
-- 
2.43.0



