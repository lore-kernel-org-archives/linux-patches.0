Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15B133C53A;
	Fri,  9 Jan 2026 12:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962251; cv=none; b=pjzqZqmS+uqTqa3ufasrxIoVEuO8K7OWBwaPkEwlM2Z4G9lagpLE+IIqVV99E+oqgtxo2UnhHueKaSm+S4t7M9mhpAWJiEUcvUvN5IGM/SyQMGU4DVTHO7v5A2mKf88In0p6PducwhQ6GczKnUXf28ThFqzRTCoMtTbLwKCEHhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962251; c=relaxed/simple;
	bh=rGwSqeHKEKysPH3M+UrFg4M0oE4qq9/6S3qN1zzOvXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UkkjIk8r21gpp0ab/I0sOusBkZSBTrsL5lWIdBYyJ5g8YNxkYdOtQlf0xAqZ5Axbk3sXPAeqUbvmhcC4bUDdyTFZrpIugOyRrXXMAztgLFamXPwkzN2mfb/sbUJTjo1+t5rmyNU8k1xelOylt+tZu0tfWo7VVJE2I61KWBvAFZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lGLxswEK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lGLxswEK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82499C4CEF1;
	Fri,  9 Jan 2026 12:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962250;
	bh=rGwSqeHKEKysPH3M+UrFg4M0oE4qq9/6S3qN1zzOvXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lGLxswEK0t6VqikLGciHSRiIPFTyHl/XBtRg+fAVxCaJT6SxqCf05YRPqN/BWydp1
	 k8jiI4wQfgsPROLjae9A/e2Gi1wceoTvk+XpYTuJR4Ieez/+mOvfcvBsVCoK3Ti7i2
	 5h0NW8j9yPUQKvH7m9HgFfBWirRerhKYhpfNOiXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Schiffer <matthias.schiffer@tq-group.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 299/634] ti-sysc: allow OMAP2 and OMAP4 timers to be reserved on AM33xx
Date: Fri,  9 Jan 2026 12:39:37 +0100
Message-ID: <20260109112128.784131749@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Matthias Schiffer <matthias.schiffer@tq-group.com>

[ Upstream commit 3f61783920504b2cf99330b372d82914bb004d8e ]

am33xx.dtsi has the same clock setup as am35xx.dtsi, setting
ti,no-reset-on-init and ti,no-idle on timer1_target and timer2_target,
so AM33 needs the same workaround as AM35 to avoid ti-sysc probe
failing on certain target modules.

Signed-off-by: Matthias Schiffer <matthias.schiffer@tq-group.com>
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/20250825131114.2206804-1-alexander.stein@ew.tq-group.com
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 172b17fe87c4..42037b15594a 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -37,6 +37,7 @@ enum sysc_soc {
 	SOC_UNKNOWN,
 	SOC_2420,
 	SOC_2430,
+	SOC_AM33,
 	SOC_3430,
 	SOC_AM35,
 	SOC_3630,
@@ -3016,6 +3017,7 @@ static void ti_sysc_idle(struct work_struct *work)
 static const struct soc_device_attribute sysc_soc_match[] = {
 	SOC_FLAG("OMAP242*", SOC_2420),
 	SOC_FLAG("OMAP243*", SOC_2430),
+	SOC_FLAG("AM33*", SOC_AM33),
 	SOC_FLAG("AM35*", SOC_AM35),
 	SOC_FLAG("OMAP3[45]*", SOC_3430),
 	SOC_FLAG("OMAP3[67]*", SOC_3630),
@@ -3223,10 +3225,15 @@ static int sysc_check_active_timer(struct sysc *ddata)
 	 * can be dropped if we stop supporting old beagleboard revisions
 	 * A to B4 at some point.
 	 */
-	if (sysc_soc->soc == SOC_3430 || sysc_soc->soc == SOC_AM35)
+	switch (sysc_soc->soc) {
+	case SOC_AM33:
+	case SOC_3430:
+	case SOC_AM35:
 		error = -ENXIO;
-	else
+		break;
+	default:
 		error = -EBUSY;
+	}
 
 	if ((ddata->cfg.quirks & SYSC_QUIRK_NO_RESET_ON_INIT) &&
 	    (ddata->cfg.quirks & SYSC_QUIRK_NO_IDLE))
-- 
2.51.0



