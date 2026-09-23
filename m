Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBB95349AD;
	Wed, 23 Sep 2026 14:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173592; cv=none; b=tj8tZMaDNyk892xo1EMZBKb7oLweHxCHhki8lSkgkKnPop19hfiEl4zeIsBlNotukkwoHZm81u5TkC5zLqEw1B2ktVmN0o4F8g7zTuJv2ngzdMS8pLR//2MFHeaKiXmK74/HB+XbVd1j4eBd+qjNrhB5k/4u+tB5op+1qcJg1lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173592; c=relaxed/simple;
	bh=5TVAdq/eRbvO22sLaF3YzcBXmXWEWvgjPuliXzCVvi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjGhYRV7niyv6XaE5D51IYMAroLwhtsvEvkytBcCiTSeoXdgdc3Z7LPZDdt0rSlgj06UpuMDc71bEpGALlh3Ku2g0YXBiJysmVg7wyes1vk27DEhgD6Jwf766Vo/MLSPMXJ41Lj8KGWx/YKi244zjV8Q6rn8m+lr8YJN+3klA4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SFHvX9fS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SFHvX9fS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3CEF1F000FF;
	Wed, 23 Sep 2026 14:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173591;
	bh=SzoJZ47hulTPrcLnIETkMzt13oyAdOzC/1QCLDrRM/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SFHvX9fSLeT9OrkgfgCEyWLKWDr3YI5+7GONsxkljZlsjGjfWd+SUImtKH8kfnpZO
	 cJLTEIkQy+/wLP7xJ3pd7f/XNdUqJoIpeYo7OaPjHL/Z+5BsIk2hPi6C+benFvWSs8
	 vOp0D5uSNIKtWZWcnXA12XGy6Ea8U6bVD1hiq2KU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Luites <ian@luites.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 7.2 261/438] soundwire: dmi-quirks: Disable ghost Realtek on Asus GX651AX
Date: Wed, 23 Sep 2026 16:04:42 +0200
Message-ID: <20260923140651.538119044@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Luites <ian@luites.com>

commit 6d49beec658f61801e79019fd73691b17252dee3 upstream.

The Asus ROG Zephyrus Duo GX651AX exposes a Realtek RT722 device in
ACPI which does not exist in the physical hardware. The device remains
unattached while the CS42L43 and both CS35L56 devices attach
successfully.

This confuses the function topology machine driver into creating
duplicate DAI links named SDW3-Playback-SimpleJack, and the sof_sdw
probe fails with error -12. Add a model-specific quirk to remove the
ghost RT722 device.

Fixes: 45cf24da0a10 ("ASoC: Intel: soc-acpi-intel-ptl-match: Remove unnecessary cs42l43 match")
Cc: stable@vger.kernel.org # 7.2.x
Assisted-by: LLM
Signed-off-by: Ian Luites <ian@luites.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260831082534.224716-1-ian@luites.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soundwire/dmi-quirks.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/soundwire/dmi-quirks.c
+++ b/drivers/soundwire/dmi-quirks.c
@@ -194,6 +194,13 @@ static const struct dmi_system_id adr_re
 	},
 	{
 		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUS"),
+			DMI_MATCH(DMI_BOARD_NAME, "GX651AX"),
+		},
+		.driver_data = (void *)ghost_realtek,
+	},
+	{
+		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "83SF"),
 		},


