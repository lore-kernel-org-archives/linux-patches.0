Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024052;
	b=o4UW9zaFYo20JVa0u4oSvRwUuOyfMx2r436+aBWVo86JSnsr5G5e0kKAGdEOHqDCaOq1
	 prELZ+HuzAPr3mKUx/rQncgSTPKQ8DyklPNJOj9Z2lJjlplB6KXwDbHk4lSvnAnODXSDw
	 /3u3YQvHZ7EjGnermGuD5NsNnZfok+gSmOLTt+M0loxejqyDZnsDmdxEjigpa+IFeTloA
	 GaCvKdHerXSJ3jAJ6WSKXNpY5NeWmWDolL8CNlwqJV2flpqWqpInGRuo2SlZB5NKI5X8+
	 Z4StQWoIf7ONuJrdvozTuJT52ZsMDejXRBUJZpi5UwLKF2sMkuIjcF8So1RU4rUiqMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024052;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Akh8DA1UMuYdsEcVsZRwKjvvFsYrLjrDw3uruCfCJiQ=;
	b=rOW8FjslzmNRBHgQ4R71UPNFulSwKrFPGjom6eC4bUK91Gl4+R1r1KYaZtvyrzNy8DKc
	 HgsYbiaXWVJpnO+4kCWexLFN0LXMh6aa0vyxuqstleIKkyM9r6V8VY2KuHb77XyMpxm/5
	 gTqm5lQewus5cPt8RDBLy2O1n6FlT2IS+AHv4qnIxfXgHmSVh+Kiulmeses7JsLB4Gb/5
	 EsP83KBI/h7+JZZRdyvZzgsHBzf/sGtpvIIaByeXoNyDTresj95rVCZ+HwBjnFZb47n30
	 YtYDOujKspHI8AfPcumuhZYtUZgOyC8Dx3pBNsNkFiz/RortPFl/snlQA9H7g4SRbiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sCrlukjm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C320606A320;
	Wed, 18 Nov 2026 17:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sCrlukjm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3598A1F000C4;
	Wed, 18 Nov 2026 17:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024051;
	bh=Akh8DA1UMuYdsEcVsZRwKjvvFsYrLjrDw3uruCfCJiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sCrlukjmrm6waxUuVYVfpbalh7cLk2dahVMS0nPbsVtcbmd+NRX65gnZII/KXQ5Cz
	 F26q2oRTga693U5TN7D4GxuoG/rS8w6myD1B7l52bJW/nNG9qdtahSLrUpX330Uuch
	 rqKN75A+mTmCqoQ6qF2p9HldE/SeE4JIImwyH+RM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.rb@renesas.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0561/2151] thermal/drivers/renesas/rzg3e: Fix race between set_trips() and get_temp()
Date: Wed, 18 Nov 2026 15:38:16 +0100
Message-ID: <20261118150142.388938343@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Panait <ovidiu.panait.rb@renesas.com>

[ Upstream commit acd9bf8f9047b03f023514bceab6a00e037977ca ]

Datasheet section 7.11.9.2 "Conversion Start Trigger" states that a
conversion must only be started while no other conversion is in
progress:

  "Before making the setting to start conversion by software or an ELC
   trigger, check that the CONV bit of the sensor status register is 0b."

set_trips() starts a conversion at the end of the function and returns
without waiting for it to finish. A get_temp() call arriving right after
that starts a conversion while the CONV bit may still be set, violating
the requirement above.

Fix this by:
 - polling for CONV == 0 in get_temp() before starting a conversion
 - not starting a conversion at the end of set_trips() anymore

The conversion started at the end of set_trips() was supposed to check
whether the thresholds have been passed, since the hw cannot raise
interrupts on its own, but only when the temperature is read. However,
the thermal core reads the temperature and computes the trip window from
it just before calling into set_trips(), so reading the temperature again
straight away is useless.

Fixes: dc67521c20b7 ("thermal/drivers/renesas/rzg3e: Fix add thermal driver for the Renesas RZ/G3E SoC")
Signed-off-by: Ovidiu Panait <ovidiu.panait.rb@renesas.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Link: https://patch.msgid.link/20260916120003.87018-4-ovidiu.panait.rb@renesas.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/renesas/rzg3e_thermal.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/renesas/rzg3e_thermal.c b/drivers/thermal/renesas/rzg3e_thermal.c
index 423e852f4cbf1..94ac1935c64d4 100644
--- a/drivers/thermal/renesas/rzg3e_thermal.c
+++ b/drivers/thermal/renesas/rzg3e_thermal.c
@@ -220,6 +220,16 @@ static int rzg3e_thermal_get_temp(struct thermal_zone_device *tz, int *temp)
 
 	guard(mutex)(&priv->lock);
 
+	/* Make sure a previous conversion is not in progress */
+	ret = readl_poll_timeout(priv->base + TSU_SSR, status,
+				 !(status & TSU_SSR_CONV),
+				 TSU_POLL_DELAY_US,
+				 USEC_PER_MSEC);
+	if (ret) {
+		dev_err(priv->dev, "Timeout waiting for conversion\n");
+		goto out;
+	}
+
 	/* Clear any previous conversion status */
 	writel(TSU_SICR_ADCLR, priv->base + TSU_SICR);
 
@@ -299,9 +309,8 @@ static int rzg3e_thermal_set_trips(struct thermal_zone_device *tz,
 	/* Enable comparison with "out of range" mode (CMPCOND=0) */
 	writel(TSU_CMSR_CMPEN, priv->base + TSU_CMSR);
 
-	/* Unmask compare IRQ and start a conversion to evaluate window */
+	/* Unmask compare IRQ */
 	writel(TSU_SIER_CMPIE, priv->base + TSU_SIER);
-	writel(TSU_STRGR_ADST, priv->base + TSU_STRGR);
 
 	pm_runtime_mark_last_busy(priv->dev);
 	pm_runtime_put_autosuspend(priv->dev);
-- 
2.53.0



