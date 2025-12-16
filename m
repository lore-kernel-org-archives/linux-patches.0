Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D52341069;
	Tue, 16 Dec 2025 11:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884156; cv=none; b=V/q0O7j1nkVt95W7TFNzjrgrn0e693EPFxrPuH+cClOKNqlhq0mcHsnY7ZEA33ku7pn18EBublFuXrYC5mBul0b5tYfLsDZL2N7IGyJ6yD5IzAD2ib7AWpffiEpShguCh6wAvYY7VYdSUGiq2u6uZFjWLYVzDh+6CCbyGHBZg/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884156; c=relaxed/simple;
	bh=Izk31lSKx+FkHvHoY2lOw/p8lzJMJP/9SnIO9DitqZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=caQlAsQWzDtkDgmUhCGBkp4RbLxQfEZhPN7VQbDuNUE6FsvUZ2mmsZRXedUdmAdcFe8xY7pOJIFN9Xnqb5NUcHaDsNZr04oNiq9QwAEo8IG4My+lJOvvVRWvly9lcmjeLKtCsejumAUdUJ3BNFyqnhC1ROgvv5PvDN0iw/p1i0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RyCuqv4H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RyCuqv4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F45FC4CEF1;
	Tue, 16 Dec 2025 11:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884156;
	bh=Izk31lSKx+FkHvHoY2lOw/p8lzJMJP/9SnIO9DitqZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RyCuqv4HRHtX5zJeMoHAGcSGggVEIqt2JRWaykXkricJ5Jv1ziSHT+8FrlQwgiDOC
	 sxbPAMUMxZx0OrzurgHyby/bNypOvVjt/vCVaLMJAMVmGEiBzSO79BP9GbFzakoUyF
	 vejF8LftHdIJFDrecBunJS0aQPScKbac/xsJSDSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ahelenia=20Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 109/354] power: supply: apm_power: only unset own apm_get_power_status
Date: Tue, 16 Dec 2025 12:11:16 +0100
Message-ID: <20251216111324.869696321@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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
index 8ef1b6f1f7879..2dbb474acea67 100644
--- a/drivers/power/supply/apm_power.c
+++ b/drivers/power/supply/apm_power.c
@@ -364,7 +364,8 @@ static int __init apm_battery_init(void)
 
 static void __exit apm_battery_exit(void)
 {
-	apm_get_power_status = NULL;
+	if (apm_get_power_status == apm_battery_apm_get_power_status)
+		apm_get_power_status = NULL;
 }
 
 module_init(apm_battery_init);
-- 
2.51.0



