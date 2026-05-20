Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D8A3FE352;
	Wed, 20 May 2026 18:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302431; cv=none; b=gGiSf6xPDmiLvMIZ3MVwmY+PEN8fXSOTwsQCXMZHUOsrqsSEyJhE4ypkDbDCbq48L4kv12cTMbmgyYIdRS3Fyy38gwK9fy/EURDLWb3WyLNcAHmaEZGgsswfZH8oKcb75k6TSsU9NSPZ7mXq8v8kA7zO+BnXAxEHnXx+541S9Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302431; c=relaxed/simple;
	bh=looRX9ufzxudajCiSRlU7v3pAqsrpHFPWV9yD+rnwXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gXSKGnZdmPwxlQGtXHaNrOh0bN9CxGggZNZGzxrk8z9YeYuDf51pKWBoZlVWe22avQor//NHqckQNOepO43/C6GHvryNp2pB8LxPC0IgqaDpXRgAr6BvLKE+pPaGIFnWTE66Fmpr1himGEh2/SCRBXuaTCcwFKTa7/nfVTEG50Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qop/pQPA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qop/pQPA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26DD1F000E9;
	Wed, 20 May 2026 18:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302430;
	bh=H1/FjnwBYEo/ZFjC27HkZgwLtFOpSEFnOMP2TUieAQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qop/pQPAiocYFuuhy89zLRFG/kAdJKPEm5bttAlt/QNQf7msDBtl7YMojmvYazDcG
	 uh0+4sfxkPyatlCW73pG0oskkX+p8LApirbh8pyJFfCzIqFAVZw6xfaj/aOlhy0qPz
	 VffVmLyHCpfkdrFXvX1tKhjEWFT8wn7ipRF2EMPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 265/508] platform/x86: panasonic-laptop: Fix OPTD notifier registration and cleanup
Date: Wed, 20 May 2026 18:21:28 +0200
Message-ID: <20260520162104.387515655@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 8baeff2c1d33dad8572216c6ad3a7425852507d4 ]

An ACPI notify handler is leaked if device_create_file() returns an
error in acpi_pcc_hotkey_add().

Also, it is pointless to call pcc_unregister_optd_notifier() in
acpi_pcc_hotkey_remove() if pcc->platform is NULL and it is better
to arrange the cleanup code in that function in the same order as
the rollback code in acpi_pcc_hotkey_add().

Address the above by placing the pcc_register_optd_notifier() call in
acpi_pcc_hotkey_add() after the device_create_file() return value
check and placing the pcc_unregister_optd_notifier() call in
acpi_pcc_hotkey_remove() right before the device_remove_file() call.

Fixes: d5a81d8e864b ("platform/x86: panasonic-laptop: Add support for optical driver power in Y and W series")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/2411055.ElGaqSPkdT@rafael.j.wysocki
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/panasonic-laptop.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/panasonic-laptop.c b/drivers/platform/x86/panasonic-laptop.c
index ad907c558997a..f6dcf8d6a1dbb 100644
--- a/drivers/platform/x86/panasonic-laptop.c
+++ b/drivers/platform/x86/panasonic-laptop.c
@@ -1081,9 +1081,10 @@ static int acpi_pcc_hotkey_add(struct acpi_device *device)
 		}
 		result = device_create_file(&pcc->platform->dev,
 			&dev_attr_cdpower);
-		pcc_register_optd_notifier(pcc, "\\_SB.PCI0.EHCI.ERHB.OPTD");
 		if (result)
 			goto out_platform;
+
+		pcc_register_optd_notifier(pcc, "\\_SB.PCI0.EHCI.ERHB.OPTD");
 	} else {
 		pcc->platform = NULL;
 	}
@@ -1117,10 +1118,10 @@ static void acpi_pcc_hotkey_remove(struct acpi_device *device)
 	i8042_remove_filter(panasonic_i8042_filter);
 
 	if (pcc->platform) {
+		pcc_unregister_optd_notifier(pcc, "\\_SB.PCI0.EHCI.ERHB.OPTD");
 		device_remove_file(&pcc->platform->dev, &dev_attr_cdpower);
 		platform_device_unregister(pcc->platform);
 	}
-	pcc_unregister_optd_notifier(pcc, "\\_SB.PCI0.EHCI.ERHB.OPTD");
 
 	sysfs_remove_group(&device->dev.kobj, &pcc_attr_group);
 
-- 
2.53.0



