Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3BA595749;
	Wed,  9 Sep 2026 14:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963703; cv=none; b=QNoWE2B32+e+r8/WHucn4/F31SyoCexCyEzNr7TRgdVB8wNH7i9zKlnPnVhrlu3Eei3RsfVUwseTZwJBoE7HvzsOm5zKpfTNjXMwAv2g2Z5ZMY5uSKHNUm3SCVkGsp6WRRYfo+CbheOGVvPjM707JKwLegKbUqM0sVYbReckutI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963703; c=relaxed/simple;
	bh=l2w4rE1KyCsa+rhPN6ccPXCkHaJ05kfmgfjLVtHKEGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aAsK3v/ZzBKdbTZ0FwG4eJojFKM+htF5CW+LG79RVfO8vPS0LGI6lai5MjPktCwBNWO1g3lGiex5qUhZFt0HiVNDwXmfRxp3dlf66boU4LMb+mLhMOZDDWa8Hyuqu/LJ0UA9aFesQ+hWAN6eWYpaMktjmxtz8jIz5BNG/YODNfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i0qA/m54; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i0qA/m54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58EC1F00A3D;
	Wed,  9 Sep 2026 14:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963702;
	bh=Ex4+zVuWy8owRmt/0miLgf70L/7BcXE9wJ4ENrEPIvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i0qA/m54pynfMtJXKyXcHVQhzE6QAw296PwCs5EVVM66k8HYc/6y9NOq/OiK9Zm6X
	 WzYo1gh9Ed5Vf3YRQmquYdSllEBIdcec8GCRjJqTOr/C+Ukeb+USRMMeXEe6rfGta6
	 1XySOlzYFfuucrVy7iyQyHbMGPSN9GIq/AmgZtYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 167/583] ASoC: loongson: Fix error handling in ACPI property parsing
Date: Wed,  9 Sep 2026 15:37:32 +0200
Message-ID: <20260909134243.988038352@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Binbin Zhou <zhoubinbin@loongson.cn>

commit 0eb0e3c623ac1da8b85d518043fef7660af7805d upstream.

In loongson_card_parse_acpi(), the return value of
device_property_read_string() for the `codec-dai-name` property was
ignored. If the property is missing or invalid, an uninitialized pointer
would be used later, potentially leading to undefined behavior.

Fix this by checking the return value and propagating the error
appropriately.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/cover.1780538113.git.zhoubinbin@loongson.cn?part=5
Fixes: ddb538a3004b ("ASoC: loongson: Factor out loongson_card_acpi_find_device() function")
Signed-off-by: Binbin Zhou <zhoubinbin@loongson.cn>
Link: https://patch.msgid.link/08e44a54708eae053be148524346bb8dfcd55b03.1782439646.git.zhoubinbin@loongson.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/loongson/loongson_card.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/sound/soc/loongson/loongson_card.c
+++ b/sound/soc/loongson/loongson_card.c
@@ -91,7 +91,7 @@ static int loongson_card_parse_acpi(stru
 	const char *codec_dai_name;
 	struct acpi_device *adev;
 	struct device *phy_dev;
-	int i;
+	int i, ret;
 
 	/* fixup platform name based on reference node */
 	adev = loongson_card_acpi_find_device(card, "cpu");
@@ -108,7 +108,9 @@ static int loongson_card_parse_acpi(stru
 		return -ENOENT;
 	snprintf(codec_name, sizeof(codec_name), "i2c-%s", acpi_dev_name(adev));
 
-	device_property_read_string(card->dev, "codec-dai-name", &codec_dai_name);
+	ret = device_property_read_string(card->dev, "codec-dai-name", &codec_dai_name);
+	if (ret)
+		return ret;
 
 	for (i = 0; i < card->num_links; i++) {
 		loongson_dai_links[i].platforms->name = dev_name(phy_dev);


