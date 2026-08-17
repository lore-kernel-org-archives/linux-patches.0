Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4410422522;
	Mon, 17 Aug 2026 15:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979972; cv=none; b=s9tW9flP5pzNaFEKA1ZgIfRDHwzNzuVEQic4TuHWUfHouJU4i6eaCDvEupVeYbDRRnFcdzbaJ48dInm6X8bxIcb9f1hOKdWEKe7RLtaKaCwBPyNWNIL0Qwmj4xp+Sd8Zm8H8RRwGZVGG2zDHTCL4CuK8v7Od4H6aeH6yw+AJM/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979972; c=relaxed/simple;
	bh=SGhx4/eSrTqy+vblh6YXrtyxBcre7QWN4+gs3pf5Bns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8gjHDu/DoqyQrrcwtPlUGDnHy3jE8qafrE/8o3iqqKbHmuR3g2mkwBmOvCxypShu7vJvM0JciaL5B4DhS1YTDceDEF734Wx+juecDpkUFUx2PnDJkV9uUUu3HkCiZVYB8ZxQVHyoyXcEEIJgj4Vb0fcyg5cZqWPDjAgOQ0cY5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PRekley0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PRekley0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B2D1F00A3E;
	Mon, 17 Aug 2026 15:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979962;
	bh=WdEzIR83KvZ8isEoIp7MZRkDUEJpTnm10FERMdXkYSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PRekley0A2M+wIKALOqDosRs4y3B4F7skrPtIbQflENRfxXbt/Z9bdbhu183VzRuK
	 aU4/G7bzm6rNJHEyjasAujDb6sZSFYCkzw2EZ4wC+OXQdeJtQ5Zalogvc2NMTIULMJ
	 iHiIoyucHeWj6NfskLGJHFfuZwVBbZLAZUUoA6FI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haidar Lee <haidar.lee@adlinktech.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 401/609] ASoC: tas2562: fix broken entries in the volume lookup table
Date: Mon, 17 Aug 2026 15:31:37 +0200
Message-ID: <20260817132557.618971290@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haidar Lee <haidar.lee@adlinktech.com>

commit bdb0fd6de403fcea7b85dc9d38f0a571583ebe80 upstream.

The float_vol_db_lookup table is supposed to hold
round(10^(dB/20) * 2^30) for every 2 dB step from -110 dB to 0 dB,
which is 56 entries, but it only has 55: the -90 dB entry duplicates
the -92 dB value (0x0000695b) and the -20 dB entry (0x06666666) is
missing altogether. As a result every step between -90 dB and -22 dB
is off by 2 dB, and the control's maximum raw value of 110 indexes one
element past the end of the array.

Replace the duplicated -90 dB entry with the correct value 0x000084a3
and add the missing -20 dB entry, bringing the table to the full 56
entries so index 55 (raw value 110, 0 dB) is in range again.

Fixes: bf726b1c86f2 ("ASoC: tas2562: Add support for digital volume control")
Cc: stable@vger.kernel.org
Signed-off-by: Haidar Lee <haidar.lee@adlinktech.com>
Link: https://patch.msgid.link/20260715-tas2562-dvc-fix-v1-2-072b13901b20@adlinktech.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/tas2562.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/sound/soc/codecs/tas2562.c
+++ b/sound/soc/codecs/tas2562.c
@@ -33,15 +33,16 @@
 static const unsigned int float_vol_db_lookup[] = {
 0x00000d43, 0x000010b2, 0x00001505, 0x00001a67, 0x00002151,
 0x000029f1, 0x000034cd, 0x00004279, 0x000053af, 0x0000695b,
-0x0000695b, 0x0000a6fa, 0x0000d236, 0x000108a4, 0x00014d2a,
+0x000084a3, 0x0000a6fa, 0x0000d236, 0x000108a4, 0x00014d2a,
 0x0001a36e, 0x00021008, 0x000298c0, 0x000344df, 0x00041d8f,
 0x00052e5a, 0x000685c8, 0x00083621, 0x000a566d, 0x000d03a7,
 0x0010624d, 0x0014a050, 0x0019f786, 0x0020b0bc, 0x0029279d,
 0x0033cf8d, 0x004139d3, 0x00521d50, 0x00676044, 0x0082248a,
 0x00a3d70a, 0x00ce4328, 0x0103ab3d, 0x0146e75d, 0x019b8c27,
 0x02061b89, 0x028c423f, 0x03352529, 0x0409c2b0, 0x05156d68,
-0x080e9f96, 0x0a24b062, 0x0cc509ab, 0x10137987, 0x143d1362,
-0x197a967f, 0x2013739e, 0x28619ae9, 0x32d64617, 0x40000000
+0x06666666, 0x080e9f96, 0x0a24b062, 0x0cc509ab, 0x10137987,
+0x143d1362, 0x197a967f, 0x2013739e, 0x28619ae9, 0x32d64617,
+0x40000000
 };
 
 struct tas2562_data {


