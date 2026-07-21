Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E984B269D18;
	Tue, 21 Jul 2026 18:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659204; cv=none; b=qt+bHjP14wZEcRpNacfrL+Jns5sSsE05rlbfExswo1VgPIRshpt4BZZxptIa7IYwZo1qtO8rvw2+zWTPU+SmzLmMR3M6wb48+1raeR1hORZsFaI9N+EJTxl4503EY1UCMJ3WZdBF1TWajLEh53BLSTc3Z/84Xmb9njpM9KXFdzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659204; c=relaxed/simple;
	bh=T6IRKWjdsskIJTBxwNXSITrUb+zlahPtoaSnm0HpBas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lqddJDmlAnfUvxKLNTMLl8P6zCJqrWa9J0enYwLb1U7mVMt+3VQzicYSYkpbdRvF+GiNiWYzA1OdGkVxnxSGCKtgmRdrF9dnlL7RUOkAB92UjMCX+4Zh4oFbToLDJbjJnyuhp+E9M5JxTBGYE9Bun7PbyQCjjxD/qdXrMpc2J4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sgAhnrXT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sgAhnrXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431351F000E9;
	Tue, 21 Jul 2026 18:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659202;
	bh=GVCv9Uy5bRTW/cE4Gq8HIrzJej5uC93diaRqHuS8hEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sgAhnrXTIegNKmOwFN8bUonSMxvcc1iwr0D4NK8S1l33d+jneLQyImIXXDIIFU7f7
	 B5VLwlMuD+zH8yGSTC9KTxKKmyNC8L+fJbsmLKahVy/pMhEpaQNe8OvVA12rvmmIsM
	 U4Hl36sc5GgKrMNJEhh3C0LaNNXgkeE6WfTmlIMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Valentina Fernandez <valentina.fernandezalanis@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.18 1430/1611] rtc: mpfs: fix counter upload completion condition
Date: Tue, 21 Jul 2026 17:25:46 +0200
Message-ID: <20260721152547.604901016@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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


