Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7502D2C0F83;
	Thu, 15 Jan 2026 17:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499024; cv=none; b=NhbAwS7BM7kEG1zFDtMSC3HSEZ0p4R8EifgKAA5efGLYCQmCAwAP4EzV2Gd4CovfVNKyGo3GVgoNOTZE1tHSdmTJ7B67eEWzMHypLGCrPIx1w0PVJfdzFtfCe1UcDDSKvvQjE/bgVLg/7MIWNwWOhfpN+U/Nw+yvTbSxOW2ZTSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499024; c=relaxed/simple;
	bh=NvnSMGXtlSqjRaiPDjNU7RxrrJCyqfIwV07HxsiABw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cmIf3UuZVlC9t8+4+VfBm6UksestZ8d0yzywYEjzCBlP9Hx+Im7HVkQX3nkfgEp5ITk/pDH/e6LEEEqCdvYekY/0TwLSfi6spEDuHMP3QaXoZ14U2dEt/t1hOwwt8osPugs/T17XUqmmnCYNVEfhOzAPV4KKOcmfIYky8bcnF48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6pmbPQc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6pmbPQc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF3CAC116D0;
	Thu, 15 Jan 2026 17:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499024;
	bh=NvnSMGXtlSqjRaiPDjNU7RxrrJCyqfIwV07HxsiABw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j6pmbPQcUGwZ0jawC5yctZQgqfeOztqgerZRb9SDf67DdNE/LC6KpfP2Aj3wnCwam
	 16NnT/zRPWiJwT0DBvz0THfunCLPS9fvgoCpUeH58IV8r2RTN0C0FxL1UdvaH0QMc9
	 o03Nt41YmivhnIQBS+9elK+m1B+AgRPX+4kdvmqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ahelenia=20Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 054/451] power: supply: apm_power: only unset own apm_get_power_status
Date: Thu, 15 Jan 2026 17:44:15 +0100
Message-ID: <20260115164232.854094965@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahelenia Ziemiańska <nabijaczleweli@nabijaczleweli.xyz>

[ Upstream commit bd44ea12919ac4e83c9f3997240fe58266aa8799 ]

Mirroring drivers/macintosh/apm_emu.c, this means that
  modprobe apm_power && modprobe $anotherdriver && modprobe -r apm_power
leaves $anotherdriver's apm_get_power_status instead of deleting it.

Fixes: 3788ec932bfd ("[BATTERY] APM emulation driver for class batteries")
Signed-off-by: Ahelenia Ziemiańska <nabijaczleweli@nabijaczleweli.xyz>
Link: https://patch.msgid.link/xczpgox57hxbunkcbdl5fxhc4gnsajsipldfidi7355afezk64@tarta.nabijaczleweli.xyz
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/apm_power.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/apm_power.c b/drivers/power/supply/apm_power.c
index 9d1a7fbcaed42..50b9636945599 100644
--- a/drivers/power/supply/apm_power.c
+++ b/drivers/power/supply/apm_power.c
@@ -365,7 +365,8 @@ static int __init apm_battery_init(void)
 
 static void __exit apm_battery_exit(void)
 {
-	apm_get_power_status = NULL;
+	if (apm_get_power_status == apm_battery_apm_get_power_status)
+		apm_get_power_status = NULL;
 }
 
 module_init(apm_battery_init);
-- 
2.51.0



