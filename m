Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0A834DB46;
	Tue,  6 Jan 2026 17:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720064; cv=none; b=hk/u/xN8PjIzt07tV9GxLkAEBulhQhdL9Ozs5/T/52VOCxU4+hdylAnSqtgnK/7xsgdJc/zlaR0Op4tQ5YtbtaKI3tj0QMoQLKkL1V64NE5z4LNouGzcIBk4Y4MXgoVTvmHo4Pe+18LXlQ5jpmu5oUyzta7A+5yskeKMG6AmMo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720064; c=relaxed/simple;
	bh=DcPvuEoB6K8eOkPQa+D8IjCPAPuULBtBmipdocwYDuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=doc+w9VN4OGCb71wEVayhYT1zJLnTbYqknlEYGKU2P3/JugIKeVpVj5EPrHx8BGfwTE74jO0hNP9HcRRrBEKw42gSoqxNbJfe+582H+C8K8w55+PS2Jw+EgkCk8bei/d7B8iKjpq9f9zVf5ib/j6zoiFXXMXuPLQKd3DcuPbi8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jbAp+a7v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jbAp+a7v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D190BC116C6;
	Tue,  6 Jan 2026 17:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720064;
	bh=DcPvuEoB6K8eOkPQa+D8IjCPAPuULBtBmipdocwYDuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jbAp+a7vnITAm9A/xPLQrxjSCVWgX1uojKJsRyy7czTGePxr7x8u6Y9wqALEhidyt
	 i+qgEBOyC4//eoLoF5ZgrwGDygPhsd5p+i8vaNAVKW56GpROPRsTAOoxilIR/Ksxi3
	 LCvOQBUWCx4D+gsnhjAZfFnM/5533KIdiNqXLnh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Schiffer <matthias.schiffer@tq-group.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 123/567] ti-sysc: allow OMAP2 and OMAP4 timers to be reserved on AM33xx
Date: Tue,  6 Jan 2026 17:58:25 +0100
Message-ID: <20260106170455.878041654@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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
index f715c8d28129..27149eb29afb 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -48,6 +48,7 @@ enum sysc_soc {
 	SOC_UNKNOWN,
 	SOC_2420,
 	SOC_2430,
+	SOC_AM33,
 	SOC_3430,
 	SOC_AM35,
 	SOC_3630,
@@ -2896,6 +2897,7 @@ static void ti_sysc_idle(struct work_struct *work)
 static const struct soc_device_attribute sysc_soc_match[] = {
 	SOC_FLAG("OMAP242*", SOC_2420),
 	SOC_FLAG("OMAP243*", SOC_2430),
+	SOC_FLAG("AM33*", SOC_AM33),
 	SOC_FLAG("AM35*", SOC_AM35),
 	SOC_FLAG("OMAP3[45]*", SOC_3430),
 	SOC_FLAG("OMAP3[67]*", SOC_3630),
@@ -3101,10 +3103,15 @@ static int sysc_check_active_timer(struct sysc *ddata)
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



