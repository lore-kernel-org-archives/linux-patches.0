Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC603B8BA4;
	Tue, 21 Jul 2026 20:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667548; cv=none; b=LceeCFf8SI5eav2rgkvOEn5zrzE+3uVcIujHee/w7XHHxjbFosm0gdZ117mi7CS4iBVJqhg7kl9qAgU0hmzQ5uI7Lh2XKFPoDSR+TE6jQtuZ8HRk2VPuxH5w7reM4eZKhKzA2sQZt+pEpHc6aYi9I4YmgBQQtciuV0A0ciA69FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667548; c=relaxed/simple;
	bh=gCUTgluiT3rPyJnSkjmHkWukfz9v4X2nzl3PG4WNues=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O3lyt++coCwsREm1JyMxMwc80c6qbL/m3MUaE6dyiPRskyt9jasV5xsNngaxg3FlrgdZcwkIh4d4q3h5MUAvlQgwH4zi48bQYZgmwtaJja3o9m1K54yzCrmIFrgERxETgosNRC3xO8aO24KhD1CqwdQjZoHCrAp8CF2Keozzs/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D+Y8Ezo/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D+Y8Ezo/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00FB1F000E9;
	Tue, 21 Jul 2026 20:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667546;
	bh=dzMl7lyN3ScY4blHPOAw3F9CelNzI0WxeUiGF2cjV4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D+Y8Ezo/NM9wc+pazhDdMUp8AZtHGIojVFGPgEWLDHnDetJETScs0kjUjCEyl08FO
	 ViuNznqGv456R93FSa7VtLdyqVCRtSR67pswWMYKNofAT+PaiyRVS4lUi2oTEy4NJo
	 YtxxlRmr1zxU6NFys7ceSiCdNk1bsisRWem7VJ1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Valentina Fernandez <valentina.fernandezalanis@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.6 1100/1266] rtc: mpfs: fix counter upload completion condition
Date: Tue, 21 Jul 2026 17:25:37 +0200
Message-ID: <20260721152506.416283641@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Conor Dooley <conor.dooley@microchip.com>

commit 9792ff8afa9017fe14f436f3ef3cd75f41f9f145 upstream.

The condition that needs to be checked for upload completion is the
UPLOAD bit in the completion register going low. The original iterations
of this driver used a do-while and this was converted to a
read_poll_timeout() during upstreaming without the condition being
inverted as it should have been.

I suspect that this went unnoticed until now because a) the first read
was done when the bit was still set, immediately completing the
read_poll_timeout() and b) because the RTC doesn't hold time when power
is removed from the SoC reducing its utility (I for one keep it
disabled). If my first suspicion was true when the driver was
upstreamed, it's not true any longer though, hence the detection of the
problem.

Fixes: 0b31d703598dc ("rtc: Add driver for Microchip PolarFire SoC")
CC: stable@vger.kernel.org
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Tested-by: Valentina Fernandez <valentina.fernandezalanis@microchip.com>
Link: https://patch.msgid.link/20260513-panhandle-ashy-70c6abf84d59@spud
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-mpfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rtc/rtc-mpfs.c
+++ b/drivers/rtc/rtc-mpfs.c
@@ -112,7 +112,7 @@ static int mpfs_rtc_settime(struct devic
 	ctrl |= CONTROL_UPLOAD_BIT;
 	writel(ctrl, rtcdev->base + CONTROL_REG);
 
-	ret = read_poll_timeout(readl, prog, prog & CONTROL_UPLOAD_BIT, 0, UPLOAD_TIMEOUT_US,
+	ret = read_poll_timeout(readl, prog, !(prog & CONTROL_UPLOAD_BIT), 0, UPLOAD_TIMEOUT_US,
 				false, rtcdev->base + CONTROL_REG);
 	if (ret) {
 		dev_err(dev, "timed out uploading time to rtc");


