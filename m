Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DF130214B;
	Thu, 15 Jan 2026 17:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497947; cv=none; b=VmNhmxTV2LgMmg8PNyr9+30RV7PCUFo5/Xr8sbwIac9u47kmahpl2vpteWbxYISPI4pJMh7aemuTWqGb/XlQppsmNGlqYMHyG7w81wQyLI/ErgFzqtBUZh5g2w4mSzHSwmuqx8Yrqd4Lk9UK9l9HhzEu9oz8rF9NRZ2tu9JGKKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497947; c=relaxed/simple;
	bh=ONbqCqpG0nPF2wS6OFUNHHZM6xTLdKiyko9aUalB9Nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MuT7FUqA5mwDgfreske/fBYtdlQelsgmT+GJSGEWJV4lhAfomJYjwyCd0pcijbq73z9l8JqzTSPx8mSxzZmSYuzaZ1yEhHdwfFT0E7YaE3i68Tw9ZE8SWCOYF5TIauRsVtJyxhSz8iqJFiR94pk5EBfhfccnruGEdcN6f12ZRPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hg+jUDmC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hg+jUDmC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02626C116D0;
	Thu, 15 Jan 2026 17:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497947;
	bh=ONbqCqpG0nPF2wS6OFUNHHZM6xTLdKiyko9aUalB9Nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hg+jUDmCIH6K59qSU9ze80gdE4ktaVFv145NCSBtaCBEHHzFrB0iQ8dN3rmLbICZB
	 gEbz+BGhQeoBOkogX5DauhqXygM49hXyjfTtww7ugdGbk7Mr4S9on5Dpdxqk5uYUKn
	 uBUDFAjdnZ9ob9hGr+MhC4p5JlJ+vEVmMzK+tJic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Schiffer <matthias.schiffer@tq-group.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 259/554] ti-sysc: allow OMAP2 and OMAP4 timers to be reserved on AM33xx
Date: Thu, 15 Jan 2026 17:45:25 +0100
Message-ID: <20260115164255.607570291@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 20e090723485..12ab9bf160c9 100644
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
@@ -2946,6 +2947,7 @@ static void ti_sysc_idle(struct work_struct *work)
 static const struct soc_device_attribute sysc_soc_match[] = {
 	SOC_FLAG("OMAP242*", SOC_2420),
 	SOC_FLAG("OMAP243*", SOC_2430),
+	SOC_FLAG("AM33*", SOC_AM33),
 	SOC_FLAG("AM35*", SOC_AM35),
 	SOC_FLAG("OMAP3[45]*", SOC_3430),
 	SOC_FLAG("OMAP3[67]*", SOC_3630),
@@ -3153,10 +3155,15 @@ static int sysc_check_active_timer(struct sysc *ddata)
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



