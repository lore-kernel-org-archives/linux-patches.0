Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126D737F00C;
	Thu, 20 Aug 2026 17:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247211; cv=none; b=IllzErkBWMb5D5eBJ9f7Nk0OXChnm3o11h6F3arXycSZjfQqCwnVesDjoqkCEd/7KNhmQTsDZTI+jRwrtYZjGS9cmqeZEkVz7Z2U2Ii1rDvP/sdc2m3U3Mk/3TKQuSz94SnftWwiTiEkB0DES1FB1w3Pz0pdqdnVzURAZ7NP4xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247211; c=relaxed/simple;
	bh=Y7qEQiUpvJjqFQCGCn/AAXArKEbGhTS1fJz2+PQog0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FFpkiCyZ7SbjsF0KbyV9cg9kuPvzhOa6YNMLfx3MIb11Mn1aYqxErhjHmhz5otNi0klK4OE8XrvwygVV2YdJKkNEq+cVzVHH7Yy+KyoH2lWhnAT+viSFcLcSUrJ65ipZdUdXvp52ZygFagN5/KoENY6fFyZpt5KRQ7pJdHrpCWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OIXWR754; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OIXWR754"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CAA1F000E9;
	Thu, 20 Aug 2026 17:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247210;
	bh=Ul4FoNSFgyy5EP0+8focSRwrZehfrUtnb2Sss2mO3OI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OIXWR75485aKPYhVzk3pA/2QgZocNIx2ShCWxHyr03Hozx5dn8ktXnGCCSZqiUyvF
	 +7UCeZbK1JbNdwYBkkIGCnHr4eIiqA3Djvl4tHi//eyJjpNZ/Qr0+aohfn3GRvQczl
	 hzkrhKoXgDpTsy+WrY5kc58JWKmUTEou1NPc5Tn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 148/220] ASoC: tas2562: Validate values for volume writes
Date: Thu, 20 Aug 2026 16:55:38 +0200
Message-ID: <20260820145227.919483100@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 8fb41964f7e4e4207c8999af2056894caa7a252a ]

tas2562_volume_control_put() does not do any validation of the control
value written by userspace, it uses it to look up a value in a fixed
size array which can easily be overflowed and then writes whatever value
it gets back to the device.  Add validation that we are loading a value
we have in the array.

Cc: stable@vger.kernel.org
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20260715-asoc-tas2562-put-retval-v1-1-97bf467c924e@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/tas2562.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/tas2562.c
+++ b/sound/soc/codecs/tas2562.c
@@ -472,10 +472,15 @@ static int tas2562_volume_control_put(st
 {
 	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
 	struct tas2562_data *tas2562 = snd_soc_component_get_drvdata(component);
-	int ret;
+	int ret, index;
 	u32 reg_val;
 
-	reg_val = float_vol_db_lookup[ucontrol->value.integer.value[0]/2];
+	index = ucontrol->value.integer.value[0] / 2;
+	if (index < 0 || index >= ARRAY_SIZE(float_vol_db_lookup))
+		return -EINVAL;
+
+	reg_val = float_vol_db_lookup[index];
+
 	/*
 	 * The device applies the 32-bit coefficient to the playback path on
 	 * the write to DVC_CFG4 (the LSB, book 0 page 2 reg 0x0F), so the


