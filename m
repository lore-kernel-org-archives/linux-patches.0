Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BE32EC54D;
	Fri,  9 Jan 2026 12:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961624; cv=none; b=UQ3wEXI1Nummg5LaLJOot8l8IfB3M2+TMMrjKx2vJ3Q0lYHyMjNIXOXGhJLQevLWWCxT6FCjF6miOdZlaJSh/26eoum6fNlBnF3aSfJ2fum1ah2ita2RwJQ1LgVnQezUZnGgR/b623/xr6qKe/Ee/dL0llLfbJmK29fg3G2jvio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961624; c=relaxed/simple;
	bh=z20ZWWGU5ehd9s9IYoQp2mOxiP8ckNwudPjCWD8myfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b0q8tmU1WjQ51zIkUeFc5HKV0ZZ4HFlXUHXtE2vTZIi08joe+fezWvAuJ4o/GDg8181LUEmtB9QXfhXwtqOwfixmnu9CnJwgo3PVFe/O48MGGUdF+kPFOolJ205B5dG34L6pTJu3KXbawqcogOphTo+OSRGiqK+c5ffQfxAP67E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PpEeXcwy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PpEeXcwy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF02C4CEF1;
	Fri,  9 Jan 2026 12:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961623;
	bh=z20ZWWGU5ehd9s9IYoQp2mOxiP8ckNwudPjCWD8myfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PpEeXcwyoHsIBPoLw/FWM43rY2JvM1T7IfZSxgrfIMkkYr8B0Ajb5poyjbYmRRaLm
	 CE1oxbui31j+x1AWMcwy8A2swLKPB8HzjpeTjE/bMeabVFpx2JQRebmAr6sXqwfQhZ
	 SLLZAkzxU4llno8e7Pk46G7LB7KmfCo5J4b0Pheg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ahelenia=20Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 080/634] power: supply: apm_power: only unset own apm_get_power_status
Date: Fri,  9 Jan 2026 12:35:58 +0100
Message-ID: <20260109112120.449754836@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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



