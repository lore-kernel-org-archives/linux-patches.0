Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD42B56853C;
	Wed,  9 Sep 2026 13:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962262; cv=none; b=Yj95RJEft6gEfzrivs/Mkuebb+EYhicg/PSiCD8W6LJj/y9nmitrlMZYAau9eDtzrC8M8FIG/phHKjR0T1o6sNfK0VtwvSkXuUWOeqWWQSxxQNiUC6sWXMNblIugi63i0swu61OUBnWZfbePEcRnGMKJOdvVZvwYP3SQO0KHiP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962262; c=relaxed/simple;
	bh=QU/KCZ2BWJLNtnGLe13VbCPUt/gL2pS0YswJuHbrM50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qe7CXKzF642qddNyJfv9IduWvthcybBCZjWbMSdeuh9DQmQHKaPo8HJSCtX24rkCNiZd8u5nUbHr1xcco2SrHCuW7QYb82miIXDLUIug+evgj4RjKu4LDiZn1DUFBV7dm3sWcx1EOD3uybc+hsSDJLVNDzVkwa0TA4njnc2T23I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N7jb2S8J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N7jb2S8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F631F00A3A;
	Wed,  9 Sep 2026 13:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962260;
	bh=qUc3Jyi9fyklgGaoayK2QRTlDHwSCTaklQbHEMGBf+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N7jb2S8JLeV3L7DFcJTFbSCSVV9I741ydjRiNHBwFAduy6AXovEK0YCv4XxIDu/+c
	 25KSeOZwKmD0+p5lDKZP6C3+1DerT/lVeRfq+x3hT6mHIi8cZkJYjGUYFoQos/0c/1
	 WTlegkK82rlAPI4m8SQxZwEoOT72EfTrLkC1vq8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 229/556] ASoC: loongson: Fix error handling in ACPI property parsing
Date: Wed,  9 Sep 2026 15:38:29 +0200
Message-ID: <20260909134238.467360173@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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


