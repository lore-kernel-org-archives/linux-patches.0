Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2A121C16A;
	Tue, 16 Jun 2026 17:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631771; cv=none; b=jH4HvJbDiROy6AjKx9liVTYzy5N/C5YbA6qkY38hFvwE41SegzlIpEO3aUfd6Q0wEymor5Wle+xqwISi6rtCAG1JrdyOQ6BUOLfxkOo6/gLgpiazBAxUlWgTH4YalOnjBgpPNpMRLagv2ZsoxShtxXzzk5mV6K8mdDAnoAXPIjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631771; c=relaxed/simple;
	bh=dK22F0HUs+t8y9FIoa2ymLrcP/etMrg8HuMsOnVPbo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/jbiehmTqKCfI2vGmXVVzKBhaRbYQTO8grz8ZhoDuDKV2c8VRMqpj4wpW4Uyrdigd5UYc3+V9Vl4VSKEC33T20T/sV2OxbbDTb22RvNGClk99LDZIDiutbEqsxsmQ6b5r8HBHvXSspmjZP2SMyUgknN/p3cV9DCBba/o0vK4pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xCnW3O59; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xCnW3O59"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21CBD1F000E9;
	Tue, 16 Jun 2026 17:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631768;
	bh=0R+gDhRpUY1Aa4TGNg1D4+WZZmHNGMGYWtbrRJtgp5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xCnW3O59w8WEmtBIIpFnhOeaoDLRsnBxHraW/rN871tO1k3ZASWJncNOcmmGdEo/D
	 q9OpIzjAtEOPkiSbWzL0zDa4g2UAu7T8ZyqQ9MUdGHQwLxSmtZCKw/Vo747RJpm0o9
	 tcrKmON2uvqkLBMdnmLuqw1G0oqMmbOizDXmGyJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 242/522] ASoC: wm_adsp: Fix NULL dereference when removing firmware controls
Date: Tue, 16 Jun 2026 20:26:29 +0530
Message-ID: <20260616145137.303655475@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 7d3fb78b550301e43fdc60312aed733069694426 ]

In wm_adsp_control_remove() check that the priv pointer is not NULL
before attempting to cleanup what it points to.

When cs_dsp creates a control it calls wm_adsp_control_add_cb() so that
wm_adsp can create its own private control data. There are two cases
where private data is not created:

1. The control is a SYSTEM control, so an ALSA control is not created.

2. The codec driver has registered a control_add() callback that
   hides the control, so wm_adsp_control_add() is not called.

When cs_dsp_remove destroys its control list it calls
wm_adsp_control_remove() for each control. But wm_adsp_control_remove()
was attempting to cleanup the private data pointed to by cs_ctl->priv
without checking the pointer for NULL.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 0700bc2fb94c ("ASoC: wm_adsp: Separate generic cs_dsp_coeff_ctl handling")
Link: https://patch.msgid.link/20260604101244.1402862-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm_adsp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index 47a4c363227ccd..bc9798ea5a25e2 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -666,6 +666,9 @@ static void wm_adsp_control_remove(struct cs_dsp_coeff_ctl *cs_ctl)
 {
 	struct wm_coeff_ctl *ctl = cs_ctl->priv;
 
+	if (!ctl)
+		return;
+
 	cancel_work_sync(&ctl->work);
 
 	kfree(ctl->name);
-- 
2.53.0



