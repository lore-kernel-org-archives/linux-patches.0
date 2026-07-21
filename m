Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B152447254B;
	Tue, 21 Jul 2026 20:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664208; cv=none; b=ZsjBN93om0QDqg/UplvCRmmBcvyCmXzqmB/4WYYdClBYdBXdodu37R045M5vV/gO76yt2MGzUdxnKegPE8T7vt4fEFFgcjnuIBMrJSV3wwOcNRUg10TPZlwvrDMG+WFCtIYIr7WzFJFeBH980V8FunUbLxXO1Q2KlXMSqkBkewA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664208; c=relaxed/simple;
	bh=00oRzPWUXtH+rekbmyl6yZ6RrbrVFlOzTQTU+7CiAMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NvuRsodOJGgBsZmbJSpQmmCjgSWLNE78I+arSOtNLnMSRppm+VR7jYz0VlHkf12e/s1krZ398ykbkFlltJgBHk5AEfcKp27LwjyFKgqwrOAXp2vYDgrAA2G11KcrnUos86Si9dR+DPuPQkdO6I4pxvpligwk3sWbhMYsA2JM9bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MM8xmuP8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MM8xmuP8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596BB1F000E9;
	Tue, 21 Jul 2026 20:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664204;
	bh=Nj2QcixDxlOT7T/E2Hasv+RXXt29u0Vs0WfS1tUZD+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MM8xmuP8Qwt3veXqEhNGWHh3BQRfnfnMXdShZ3LjS0RlRMDnoauxQ9nEhRFp2Wn69
	 inF0YK8afe6ZGq4p+jrupI/RTVA3hQFtRjRknt+UV5BWdXP6m7rQsw5gFdT00yUH4b
	 1lTr+4d0OQuHA6Ygj91Laqhq3k+N+2/ZhNGRKRvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Valentina Fernandez <valentina.fernandezalanis@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.12 1069/1276] rtc: mpfs: fix counter upload completion condition
Date: Tue, 21 Jul 2026 17:25:12 +0200
Message-ID: <20260721152509.907493627@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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


