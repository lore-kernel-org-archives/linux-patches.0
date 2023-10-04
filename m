Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCDA1DA24
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="om6uoU1A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2084C433C7;
	Wed,  4 Oct 2023 18:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444160;
	bh=L8LaOqFkSu/1mS9wP4NDPmcxf+q4DCTQ2iBAYeoNbmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=om6uoU1AQoUsLa8W5OpFyQW9FYvKaHKvGfaQ4vckHRkzSEwrBJI/zj+dHDqMQ3WF2
	 XepQvFgCIHj2DNSikoUCMXl8NgKVQOngFKF0pnIxWcUzuQiKgw1nWu/QM5dU4hMoIW
	 ln54PwxUL4pdDLRe+Vv3pLvMU5KvrvwUbMOC406I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 122/321] bus: ti-sysc: Fix missing AM35xx SoC matching
Date: Wed,  4 Oct 2023 19:54:27 +0200
Message-ID: <20231004175234.885806724@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 11729caa520950e17cd81bc43ffc477c46cf791e ]

Commit feaa8baee82a ("bus: ti-sysc: Implement SoC revision handling")
created a list of SoC types searching for strings based on names
and wildcards which associates the SoC to different families.

The OMAP34xx and OMAP35xx are treated as SOC_3430 while
OMAP36xx and OMAP37xx are treated as SOC_3630, but the AM35xx
isn't listed.

The AM35xx is mostly an OMAP3430, and a later commit a12315d6d270
("bus: ti-sysc: Make omap3 gpt12 quirk handling SoC specific") looks
for the SOC type and behaves in a certain way if it's SOC_3430.

This caused a regression on the AM3517 causing it to return two
errors:

 ti-sysc: probe of 48318000.target-module failed with error -16
 ti-sysc: probe of 49032000.target-module failed with error -16

Fix this by treating the creating SOC_AM35 and inserting it between
the SOC_3430 and SOC_3630.  If it is treaed the same way as the
SOC_3430 when checking the status of sysc_check_active_timer,
the error conditions will disappear.

Fixes: a12315d6d270 ("bus: ti-sysc: Make omap3 gpt12 quirk handling SoC specific")
Fixes: feaa8baee82a ("bus: ti-sysc: Implement SoC revision handling")
Signed-off-by: Adam Ford <aford173@gmail.com>
Message-ID: <20230906233442.270835-1-aford173@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 76116a9f6f87e..00ee7cc8248af 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -38,6 +38,7 @@ enum sysc_soc {
 	SOC_2420,
 	SOC_2430,
 	SOC_3430,
+	SOC_AM35,
 	SOC_3630,
 	SOC_4430,
 	SOC_4460,
@@ -1861,7 +1862,7 @@ static void sysc_pre_reset_quirk_dss(struct sysc *ddata)
 		dev_warn(ddata->dev, "%s: timed out %08x !+ %08x\n",
 			 __func__, val, irq_mask);
 
-	if (sysc_soc->soc == SOC_3430) {
+	if (sysc_soc->soc == SOC_3430 || sysc_soc->soc == SOC_AM35) {
 		/* Clear DSS_SDI_CONTROL */
 		sysc_write(ddata, 0x44, 0);
 
@@ -3023,6 +3024,7 @@ static void ti_sysc_idle(struct work_struct *work)
 static const struct soc_device_attribute sysc_soc_match[] = {
 	SOC_FLAG("OMAP242*", SOC_2420),
 	SOC_FLAG("OMAP243*", SOC_2430),
+	SOC_FLAG("AM35*", SOC_AM35),
 	SOC_FLAG("OMAP3[45]*", SOC_3430),
 	SOC_FLAG("OMAP3[67]*", SOC_3630),
 	SOC_FLAG("OMAP443*", SOC_4430),
@@ -3227,7 +3229,7 @@ static int sysc_check_active_timer(struct sysc *ddata)
 	 * can be dropped if we stop supporting old beagleboard revisions
 	 * A to B4 at some point.
 	 */
-	if (sysc_soc->soc == SOC_3430)
+	if (sysc_soc->soc == SOC_3430 || sysc_soc->soc == SOC_AM35)
 		error = -ENXIO;
 	else
 		error = -EBUSY;
-- 
2.40.1



