Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DFB4A207F;
	Thu, 17 Sep 2026 17:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664827; cv=none; b=e8Ye1jNwArP3484nwgOtyYae7cHAg1cLURnvjj+ajmH3zXqSc2uQ959wGr7KajsfkiknbMTPGivlInWa3tvlvfB+vzxbPDQO0jER68rfabcaqSeEk+KBq4okK+e1M2rgv3WstH5Qo5Idg1euSM7fXkq1YJHsWI8m9JjTnt1X1wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664827; c=relaxed/simple;
	bh=n9sLzYCfOT26hwp++KaosXyEgKrX44HPUmLb1U6gwio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c21ep0D2dCedEbUN2lJkye6shHjfQTvtktwvkdMRLnEcrijHOhIInUNAF9KxxHUbIEUPDXY7DNoabaymWbOSeCo499182M0p0K2P7Pscn0LPbb4/C5woGitI6F7rsvkBDg5+C6BysHe6dj1Z5GkIP5sH41mAfG9Wk74WLZm2kVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NZmJsgvm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NZmJsgvm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8920E1F000FF;
	Thu, 17 Sep 2026 17:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664826;
	bh=y55eeXiw0VrL6ac5r51m6KWjiq3n1RGQyn3ifcz1EqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NZmJsgvm7f0Fmi6DJFBC2Wum6Cp/WAmhnz0U7yYWQxT0Qa0Ma32f6YEulG/a0DiE/
	 Oaw0W/agBcZiHRgVFhzf2ztBOgj2cAROuyZEUfjPuXnqAHcfo6ZrhG1tsx/X11/Ofy
	 HG6pcya+Is1YyoX1aNmxPKLfbnaNiUQJhUXe1/QM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Praveen Talari <praveen.talari@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0474/1250] spi: core: Abort active target transfer on controller suspend
Date: Thu, 17 Sep 2026 16:04:29 +0100
Message-ID: <20260917151604.819365503@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Praveen Talari <praveen.talari@oss.qualcomm.com>

[ Upstream commit c1bab046d4786c5b17aab7c5225bf0d4a2a2d19b ]

When an SPI controller operating in target mode has a transfer in
progress at the time of system suspend, the suspend path proceeds
without aborting the ongoing transfer. This can leave the hardware in
an inconsistent state, potentially causing the system to hang or fail
to resume cleanly.

Fix this by invoking the controller's target_abort callback from
spi_controller_suspend() when the controller is in target mode and the
callback is registered. This ensures any active target transfer is
cleanly terminated before the controller is suspended.

Signed-off-by: Praveen Talari <praveen.talari@oss.qualcomm.com>
Link: https://patch.msgid.link/20260625-abort_active_transfer_duirng_s2r-v2-1-1d6f724406b6@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 1be9dd4c89fe5..e103a003e6a65 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -3503,6 +3503,9 @@ int spi_controller_suspend(struct spi_controller *ctlr)
 {
 	int ret = 0;
 
+	if (ctlr->cur_msg && spi_controller_is_target(ctlr) && ctlr->target_abort)
+		ctlr->target_abort(ctlr);
+
 	/* Basically no-ops for non-queued controllers */
 	if (ctlr->queued) {
 		ret = spi_stop_queue(ctlr);
-- 
2.53.0



