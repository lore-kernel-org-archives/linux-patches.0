Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA6E1C5799;
	Sat, 30 May 2026 17:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161499; cv=none; b=IEP3V7+ioQwk+0Sh41vDxvzzLdHy37wY77p8Sqpn6OqJCmKAG+sruK5rlQ9BAnlal70M64DSChnOTV9caeZc5Q9n8h2eq/NSnTn1hAOxR891pzqkhdAPZESSqEuNpWiUeTfyD2iN9pT3V1FDomlBcj7aiBejX/BddC5DxNKmBeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161499; c=relaxed/simple;
	bh=qqzRkD4BiN+enyNY9+vX9t0gtbAxY+NaQfheLaqADjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hGWQ6gNtVpfkjwQG9KpT6ZmSUWEeOx8umwxuB7mEgc3m65Ye9/3J5pFHOO/iKA/dHaHqxmKkW5/ZJJKJNjXS+aM+WMmY6BPHn/mt9LHmw1LLlFOsocHRHs48A5EpjwjTLEoif5ZggRMDTgqq3YSrxAPzLmiteoqY08V39dzdDdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nTM/hlZ3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nTM/hlZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D4D1F00893;
	Sat, 30 May 2026 17:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161498;
	bh=kQABOeLYcUMuWqf72NcYv2QuttdZyghqHjRBwRfHElg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nTM/hlZ3kDvjG2FB6NLS15q/YyIz75s0Uz1gbQWsjmFM30QVBoIjgLQ7zIKQvrCG3
	 0trESd3t+3UTSkuehdmSEP2oY6q89ClwhP2ss/+Dy8aYMxwMYWOn35F+eyalEWzO0X
	 wvYKN5CkEdLjiSD5qN05zcrv7YJQ41/CSMEIzvrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 642/969] platform/x86: panasonic-laptop: Fix OPTD notifier registration and cleanup
Date: Sat, 30 May 2026 18:02:46 +0200
Message-ID: <20260530160318.183919596@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
index 99cbacd0cbba4..0a7c4e83cdea9 100644
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
@@ -1117,10 +1118,10 @@ static int acpi_pcc_hotkey_remove(struct acpi_device *device)
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



