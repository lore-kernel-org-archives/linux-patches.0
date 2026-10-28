Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207459;
	b=oq097xc2407kkHyqj+Xazrc/SVmFLnptgQ5yGZ8o3e9nDFTgPXG7jStlCy1YUyqliQ9S
	 PNTwDTdx7WtCwKYz0eze7KEmbrpTgOB8CgcXLcnc8PMcl4nO0xHW1z88RalJ3ZOOH97KB
	 g8EVBYezlm1WZWj1a7FQ67VW3yZtPn3XFzr+oua5QDHXd6sRs004VDvGGCOMGf/7GucY6
	 28PjaCxJwkmN7+qMB0hJYRLBVuLOGxM7vdrbIj8zN8UkVb5d3EUc2F9c/I2DvFDuH5Qmw
	 IKNodOLm7V/Ku3nJPAxInFRMXdP2XRWH69M4esuy+kZAt9jgaVnXSqVZlNZE77EYSIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207459;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u7zaThlMxq/EWt/UDKVSYfc5oyRVYJJUcNgTeV0Hku8=;
	b=E3Pzl6bJdBqiVy5y8heqGo2jLu+1xqcafFFxbVaPtu/KXMaqgZhf1IKKtLAa5BG6LCmo
	 SyvyLc34BTGjeivrZOvwgW5BTsDPaWCDxeOqMVIGUFVCY7wnb1vCezn11OltVS10L3uuZ
	 ZSC5o34Xwmx/FkrThi9+g3GiLPZMNsmgrOoPLsmIZf64Qv78mhlKseGML5k+bG8U6oZCV
	 kG2KimQ0xwncdVBJC6Fbo8LWE5JgSYw9qcNHPRvaYyhuRrX5nNXKj77h+FpfUl45jWwYJ
	 a2FJeN4XQfDUMe3USX3jBYfMzRK5yT4KuLeovmiCRIsXX2p5/NoNlPcXa++fpMJz7eA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YwfmuVdi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D407606A31C;
	Wed, 28 Oct 2026 17:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YwfmuVdi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EACB51F01828;
	Wed, 28 Oct 2026 17:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207459;
	bh=u7zaThlMxq/EWt/UDKVSYfc5oyRVYJJUcNgTeV0Hku8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YwfmuVdi410Re6wAyAoe0Tt+2hem+k2IKTci0js3gqHSysr/r/psbE1AT6MGESoLJ
	 0K5W+7m60AxJDBHYDtwZngASLnzwlyPI+T1qCxUsgLoi9eQ+DzzW/3rCKvSJWEJijR
	 uWiiRMz2Y+51yWh7CfOpljAsaLy4ouWpIu+uOTbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 024/247] power: supply: generic-adc-battery: Fix temperature IIO channel conversion
Date: Wed, 28 Oct 2026 17:57:07 +0100
Message-ID: <20261028165947.938509246@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Svyatoslav Ryhel <clamor95@gmail.com>

[ Upstream commit 6bca94e64255053ab2aa56f2588fda73d399b790 ]

Temperature IIO channel data is provided in milli-degrees, while
POWER_SUPPLY_PROP_TEMP is expected to be in deci-degrees. Adjust the
existing logic to reflect this conversion properly.

Fixes: 33088c0513818 ("power: supply: generic-adc-battery: add temperature support")
Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Link: https://patch.msgid.link/20260926142905.206215-2-clamor95@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/generic-adc-battery.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/generic-adc-battery.c b/drivers/power/supply/generic-adc-battery.c
index 7bdc6b2636090..aebc824aa2ede 100644
--- a/drivers/power/supply/generic-adc-battery.c
+++ b/drivers/power/supply/generic-adc-battery.c
@@ -90,12 +90,17 @@ static int gab_read_channel(struct gab *adc_bat, enum gab_chan_type channel,
 	int ret;
 
 	ret = iio_read_channel_processed(adc_bat->channel[channel], result);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(&adc_bat->psy->dev, "read channel error: %d\n", ret);
+		return ret;
+	}
+
+	if (channel == GAB_TEMP)
+		*result /= 100; /* Convert from milli- to deci-degree */
 	else
 		*result *= 1000;
 
-	return ret;
+	return 0;
 }
 
 static int gab_get_property(struct power_supply *psy,
-- 
2.53.0



