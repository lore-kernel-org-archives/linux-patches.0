Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2432778F49;
	Mon,  6 Jan 2025 15:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177674; cv=none; b=onHkXlYPoD6ZsSnMnIHnhKxAu5nd9RTy9vLLmKHLcAATcuJLDlHW7pvt/W/jQc+kYHdvfZWBWckNsboJ0reRBzPoHAiVSHRathbEkfRU05505Asdh6tHVEyTsfmbTxT4T5bKkTGX9S3LC6G4tA5UN+CnjdxPrBJrCxc9WFPVLPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177674; c=relaxed/simple;
	bh=NH47iz4ROhYyWR5dEtup1j6vXynDTBQnhWQTIN1VNMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8TiFtUUsr5plJCgGUvZJ6Z6IQPsajAPPC7JeEnu/tTJNBOdSLPyN9ozGB+y5cpENP766GOLdq6UJckvU7yDEfeP1QzcNVKDTgORKF+1c5VPss/Lw1S6zimYYnKu+SCeftp2fuXmu7cLC0vY+oAghqqBAZFejJnEt+uC8gLUItc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HjV0CcTc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HjV0CcTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A571C4CED2;
	Mon,  6 Jan 2025 15:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177674;
	bh=NH47iz4ROhYyWR5dEtup1j6vXynDTBQnhWQTIN1VNMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HjV0CcTcVf3CDGF7nIrqJ7/UNTL5FVAKZEwIEh+a37Mf4FxeJAABDTupc4N/25MR/
	 qDI1iK8iTZWsx0OgGYGhzseovIhIN5D8ofMRhgsmoR9JC9OYCnh5twbvZNFGn3akfD
	 EHS+8mFSWTRDpDbzfs+h8QZW61Y3m/7qCp5/TqM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.12 008/156] pmdomain: core: add dummy release function to genpd device
Date: Mon,  6 Jan 2025 16:14:54 +0100
Message-ID: <20250106151142.057904524@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Lucas Stach <l.stach@pengutronix.de>

commit f64f610ec6ab59dd0391b03842cea3a4cd8ee34f upstream.

The genpd device, which is really only used as a handle to lookup
OPP, but not even registered to the device core otherwise and thus
lifetime linked to the genpd struct it is contained in, is missing
a release function. After b8f7bbd1f4ec ("pmdomain: core: Add
missing put_device()") the device will be cleaned up going through
the driver core device_release() function, which will warn when no
release callback is present for the device. Add a dummy release
function to shut up the warning.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Tested-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Fixes: b8f7bbd1f4ec ("pmdomain: core: Add missing put_device()")
Cc: stable@vger.kernel.org
Message-ID: <20241218184433.1930532-1-l.stach@pengutronix.de>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/core.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/pmdomain/core.c
+++ b/drivers/pmdomain/core.c
@@ -2141,6 +2141,11 @@ static int genpd_set_default_power_state
 	return 0;
 }
 
+static void genpd_provider_release(struct device *dev)
+{
+	/* nothing to be done here */
+}
+
 static int genpd_alloc_data(struct generic_pm_domain *genpd)
 {
 	struct genpd_governor_data *gd = NULL;
@@ -2172,6 +2177,7 @@ static int genpd_alloc_data(struct gener
 
 	genpd->gd = gd;
 	device_initialize(&genpd->dev);
+	genpd->dev.release = genpd_provider_release;
 
 	if (!genpd_is_dev_name_fw(genpd)) {
 		dev_set_name(&genpd->dev, "%s", genpd->name);


