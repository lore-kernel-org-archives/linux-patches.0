Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117F746A5FB;
	Tue, 21 Jul 2026 15:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649542; cv=none; b=VCxzOX2zefwRasHRZS14eVB+xi8UwLuBV0G3IHzfagFAu6LZAqk0T221Hcba5nDRQlJTJye5vicHO6Q8lUMRKAIENNvccrl0nHgnh4RqwBmvfWXNtnthhtmcV/ZSmAJ3OIsfYG+xhnqD37WYBPEkgwrJIevzsdTgp3jtDG5Gigc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649542; c=relaxed/simple;
	bh=gqR11tV6/cedXs97fNeURHVJQZHVr0ZXBVZ8a+OmSGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LVwF1Z1nu1rFoeMkKfeGzBqhOTbbClrOFcolwxIXzWLNcdYbsJ1l9rstQLkkiSgE1T2S11lAJad7eIALQ+4rEOwyhzCLGX/Yypx+3IOBd6CyrAxR+dqWPhBdEJH0BK7W2lxt2Z3b1eifxhx8BC4uGCVqqF3TPFRR1tyJA+JbCf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EVDQneIu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EVDQneIu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E8C11F000E9;
	Tue, 21 Jul 2026 15:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649540;
	bh=T+0nIP3NfYPh+A1GxJN+FyvrC03fvDqafR3iNIy6pbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EVDQneIunS8zwcmkdUjzJ3dzF6Nu1on7Gd6QLOTEfjY82sYm+vGGIwV0C3fgML8Yc
	 U3rKyT3PUhNoGk6lxq8Nmyqa2WsCJHEetKMfPzxv1tIBU/X8qyTkEPogO2ssOgQm/G
	 GxtLDykWs4xzyIYz9RypSbAkOG6iID2jcoUsErUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0617/2077] ASoC: sma1307: Fix uevent string leaks in fault worker
Date: Tue, 21 Jul 2026 17:04:50 +0200
Message-ID: <20260721152607.358201353@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit a750ca72af72dde9744468fdca6eda0b698a1cfc ]

sma1307_check_fault_worker() stores dynamically allocated uevent strings in
envp[0]. Several fault conditions are checked in sequence, so a later fault
can overwrite envp[0] before the final kfree() and leak the previous
allocation.

The same flow can leave an OT1 volume entry in envp[1] while envp[0]
has been overwritten by a later non-OT1 fault, causing an inconsistent
uevent payload.

Use static STATUS strings and a stack buffer for the optional VOLUME entry.
This removes the allocations from the worker and keeps VOLUME tied only
to the OT1 events that produce it.

Fixes: 576c57e6b4c1 ("ASoC: sma1307: Add driver for Iron Device SMA1307")
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260609-asoc-sma1307-uevent-leak-v1-1-cd7f5b062ab7@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/sma1307.c | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/sound/soc/codecs/sma1307.c b/sound/soc/codecs/sma1307.c
index 5850bf6e71cade..5cc0834873f00b 100644
--- a/sound/soc/codecs/sma1307.c
+++ b/sound/soc/codecs/sma1307.c
@@ -1592,6 +1592,7 @@ static void sma1307_check_fault_worker(struct work_struct *work)
 	struct sma1307_priv *sma1307 =
 	    container_of(work, struct sma1307_priv, check_fault_work.work);
 	unsigned int status1_val, status2_val;
+	char volume[sizeof("VOLUME=0x12345678")];
 	char *envp[3] = { NULL, NULL, NULL };
 
 	if (sma1307->tsdw_cnt)
@@ -1607,7 +1608,7 @@ static void sma1307_check_fault_worker(struct work_struct *work)
 	if (~status1_val & SMA1307_OT1_OK_STATUS) {
 		dev_crit(sma1307->dev,
 			 "%s: OT1(Over Temperature Level 1)\n", __func__);
-		envp[0] = kasprintf(GFP_KERNEL, "STATUS=OT1");
+		envp[0] = "STATUS=OT1";
 		if (sma1307->sw_ot1_prot) {
 			/* Volume control (Current Volume -3dB) */
 			if ((sma1307->cur_vol + 6) <= 0xFA) {
@@ -1615,8 +1616,9 @@ static void sma1307_check_fault_worker(struct work_struct *work)
 				regmap_write(sma1307->regmap,
 						     SMA1307_0A_SPK_VOL,
 						     sma1307->cur_vol);
-				envp[1] = kasprintf(GFP_KERNEL,
-					"VOLUME=0x%02X", sma1307->cur_vol);
+				snprintf(volume, sizeof(volume),
+					 "VOLUME=0x%02X", sma1307->cur_vol);
+				envp[1] = volume;
 			}
 		}
 		sma1307->tsdw_cnt++;
@@ -1625,48 +1627,53 @@ static void sma1307_check_fault_worker(struct work_struct *work)
 				     SMA1307_0A_SPK_VOL, sma1307->init_vol);
 		sma1307->tsdw_cnt = 0;
 		sma1307->cur_vol = sma1307->init_vol;
-		envp[0] = kasprintf(GFP_KERNEL, "STATUS=OT1_CLEAR");
-		envp[1] = kasprintf(GFP_KERNEL,
-				"VOLUME=0x%02X", sma1307->cur_vol);
+		envp[0] = "STATUS=OT1_CLEAR";
+		snprintf(volume, sizeof(volume), "VOLUME=0x%02X",
+			 sma1307->cur_vol);
+		envp[1] = volume;
 	}
 
 	if (~status1_val & SMA1307_OT2_OK_STATUS) {
 		dev_crit(sma1307->dev,
 			 "%s: OT2(Over Temperature Level 2)\n", __func__);
-		envp[0] = kasprintf(GFP_KERNEL, "STATUS=OT2");
+		envp[0] = "STATUS=OT2";
+		envp[1] = NULL;
 	}
 	if (status1_val & SMA1307_UVLO_STATUS) {
 		dev_crit(sma1307->dev,
 			 "%s: UVLO(Under Voltage Lock Out)\n", __func__);
-		envp[0] = kasprintf(GFP_KERNEL, "STATUS=UVLO");
+		envp[0] = "STATUS=UVLO";
+		envp[1] = NULL;
 	}
 	if (status1_val & SMA1307_OVP_BST_STATUS) {
 		dev_crit(sma1307->dev,
 			 "%s: OVP_BST(Over Voltage Protection)\n", __func__);
-		envp[0] = kasprintf(GFP_KERNEL, "STATUS=OVP_BST");
+		envp[0] = "STATUS=OVP_BST";
+		envp[1] = NULL;
 	}
 	if (status2_val & SMA1307_OCP_SPK_STATUS) {
 		dev_crit(sma1307->dev,
 			 "%s: OCP_SPK(Over Current Protect SPK)\n", __func__);
-		envp[0] = kasprintf(GFP_KERNEL, "STATUS=OCP_SPK");
+		envp[0] = "STATUS=OCP_SPK";
+		envp[1] = NULL;
 	}
 	if (status2_val & SMA1307_OCP_BST_STATUS) {
 		dev_crit(sma1307->dev,
 			 "%s: OCP_BST(Over Current Protect Boost)\n", __func__);
-		envp[0] = kasprintf(GFP_KERNEL, "STATUS=OCP_BST");
+		envp[0] = "STATUS=OCP_BST";
+		envp[1] = NULL;
 	}
 	if (status2_val & SMA1307_CLK_MON_STATUS) {
 		dev_crit(sma1307->dev,
 			 "%s: CLK_FAULT(No clock input)\n", __func__);
-		envp[0] = kasprintf(GFP_KERNEL, "STATUS=CLK_FAULT");
+		envp[0] = "STATUS=CLK_FAULT";
+		envp[1] = NULL;
 	}
 
 	if (envp[0] != NULL) {
 		if (kobject_uevent_env(sma1307->kobj, KOBJ_CHANGE, envp))
 			dev_err(sma1307->dev,
 				"%s: Error sending uevent\n", __func__);
-		kfree(envp[0]);
-		kfree(envp[1]);
 	}
 
 	if (sma1307->check_fault_status) {
-- 
2.53.0



