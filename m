Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36A63451D4;
	Tue, 16 Dec 2025 11:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885502; cv=none; b=YiqN8Yp9djUfkF6FNvOZwwbSQf0OVDZUWOAof629qGLRYGAJrhPEGTE4Nh6LTcRyXDg5TA1YMuh1vqTHQkRqiJ06PUijTeLdaP724PRSFKPgeeWruwu/JXZQR3+mnYfEPtb2n5ONSY+agX0W27SKQH+OBcGKCgZa1mHK+7jgUJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885502; c=relaxed/simple;
	bh=Wz5zolmVx5uRpigTo3Pk9EPB83pnDfOdB/YZ0ur6ek4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KTtf7eDsG5+8/fhfF3WmZZqHmCNLkWZqpgdGG8a9N8d9B7dCA4l8b5+p2xBo5Bymj50B0uU0XUeqxMxgv9u5vriEu6/yRMjKwbPUf/sFALTmNSJqCgnGip3OX+RinqADH1JnOY64axfWkgmgDHbWuXNV7BTzK6qee2XnQ92qzVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wHbkx9qn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wHbkx9qn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20BC9C4CEF1;
	Tue, 16 Dec 2025 11:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885502;
	bh=Wz5zolmVx5uRpigTo3Pk9EPB83pnDfOdB/YZ0ur6ek4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wHbkx9qnkPak2OkDQHUvmdg0DKd0Rzt8SVLrESQdk9bVS3bJibSLX/wHvXO1K0+92
	 bhmho4ru+6xgQuo5aoShamJTbOeCWz0w5D0xtkfkEvIfPFZjGw+z3Q2zfnb3jgP2pA
	 NaP1ITvd4vm8JcI1fMbgK5Pgsv2QP7F017bwiomI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ahelenia=20Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 158/507] power: supply: apm_power: only unset own apm_get_power_status
Date: Tue, 16 Dec 2025 12:09:59 +0100
Message-ID: <20251216111351.246566167@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 9236e00785786..9933cdc5c387a 100644
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



