Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0858258EC2;
	Thu, 15 Jan 2026 17:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497495; cv=none; b=T1VEloK89KEXGXMX2zowR0h4Dbt/OxMwZCGN/Z/Qa4plootjHjlYihcZWeSvsqpMcx7ZuSvRLjz0l+GkqSmSy5KbxdPs7pzOhJRwcQoLOVGki0kJ94DUdqI3EuRdZlFOiRMPFsky+1BAHI+CpQYgI9XromqBeatNK7ocIBNIBL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497495; c=relaxed/simple;
	bh=GFaI0YiauHOrvpDtgcl7kc4jc1/lv4gs5dHaoQ2Iq8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GGBhW+D36WYnpQwIY3CgesGZexwHPF0BNNVdYxHxc0OzYbsU0pCxRu19jH6T52pmQA/MThnpCfyZN12ovySZEowrLvRH/8VWKmkJX9WMqJEP0sIUE+/4E7tumxI1MBX7yBJOagd263cfw8SEctCIx++gl689569//t8cdn01+TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZLn31zPE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZLn31zPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1123CC116D0;
	Thu, 15 Jan 2026 17:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497495;
	bh=GFaI0YiauHOrvpDtgcl7kc4jc1/lv4gs5dHaoQ2Iq8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZLn31zPEYV0BRrqUsjEraEDvQuH2rfe8Kb1IpW+SIg1j0Jtp5irSCxP8SsLaKlcAx
	 eLhflUEHfC6PrfsgTcY7doxBZWPTQONOQb2E5Fs7X2JVrF36CC7N//4IxX8n8Umw6J
	 fmNpPefdqNpJZc5YE2+g/oHLXcUtls1bRbGCAM0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ahelenia=20Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 069/554] power: supply: apm_power: only unset own apm_get_power_status
Date: Thu, 15 Jan 2026 17:42:15 +0100
Message-ID: <20260115164248.740286096@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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



