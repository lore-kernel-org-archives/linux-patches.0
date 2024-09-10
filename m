Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2034518787E;
	Tue, 10 Sep 2024 10:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962505; cv=none; b=iSKyAKBesGO480M4mf7vWEGRD/Y4PKbKrMGTK2RGsF9Mh7y+Fi1p5kZwafjIxVnmb8TALvt0Gl1+EcIxjn1WOeVNOHbVqxcrDsP6QxUUicxRhf5SPDC2CUWY1UQbfNyJzlvWo2HyGTNvPOBfOgbOBkkA/Gf9ar+ZqGPPIJMJpEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962505; c=relaxed/simple;
	bh=bJ+JxkF1j6m9wXDDFth/Rkk2Yly4wH/nKH4pAwOu+C0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DML50mq0fc5USNjAegNAUdAYk6UrXSWhZiDKP6vSu0eSDlYpHDn7FkANaOep2t/lajHbS5d97anUcKnNaOMgXu3EKv8Xj+pcNJAa4p11ljj4R7pvjbb+ok2D1lta6siCzOZ3VMbWc8S0+o+eAzodHXQ4tB4NrygFk0ICSOYZiSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UTDAbtcd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UTDAbtcd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94246C4CEC6;
	Tue, 10 Sep 2024 10:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962505;
	bh=bJ+JxkF1j6m9wXDDFth/Rkk2Yly4wH/nKH4pAwOu+C0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UTDAbtcdxuEKrhIi0DpYULcH3f62ej1qzCZGlicbAynUFnzneXr357XjWDAoe1VWP
	 CXap2UTtsMnEbls4nNwjOjofRCDOvxUMhyttOC5GazsmMQYC7Li5699yeWAYWa0D7N
	 el8RQJzkYKYtJzqY1QHXY6U1FfC6LnfDLGRMX2cQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 056/121] platform/x86: dell-smbios: Fix error path in dell_smbios_init()
Date: Tue, 10 Sep 2024 11:32:11 +0200
Message-ID: <20240910092548.480379895@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/platform/x86/dell-smbios-base.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/dell-smbios-base.c b/drivers/platform/x86/dell-smbios-base.c
index ceb8e701028d..2f9c3c1f76f1 100644
--- a/drivers/platform/x86/dell-smbios-base.c
+++ b/drivers/platform/x86/dell-smbios-base.c
@@ -610,7 +610,10 @@ static int __init dell_smbios_init(void)
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



