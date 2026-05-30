Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDF933F5A3;
	Sat, 30 May 2026 16:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160145; cv=none; b=Z+qvbuowlb+kzAAQGJf0cFQpCQwmNAgn9juHsH4FodxzZIQWC3ZoxxgTQSj7I2TBW3QAleaiJB1MzI0i6uKl9n579+QYXO7+lsrTlafZUUwW15vEqc5KJefTWO6BF1Jxk/c08WMxEKBXOSpLuxHr7BDlmL1i/Wn5AQSLy0JVZ0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160145; c=relaxed/simple;
	bh=1NGRMOoMKDerxh/oAXuD+4E5cKnkD+ov5lsjCS2u8U4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h0I8jh59Jd0+xVSzVmXzkAX8hVWUDGmcMyjy3smgk7v2kGCQZGqxpn7JbNFzTfrmn0GB0Th8KFtsrNAnVoK+AG2xGXBtUxpi74YJvyjcNW+drYQh3goIdnTX2sOvHYPDHjT8jai3R8S0kLeuhfBRapSeLddKfgqXyD5kSUzVUY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yPq2ndF2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yPq2ndF2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D616C1F00893;
	Sat, 30 May 2026 16:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160144;
	bh=1AAEvI0LcTq+LFD6I+J2NeAXWWRsR8N2nFaepU2HgqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yPq2ndF2btWQWFip5RN6j+HDrbXPtbvYvJqFc40eSb+I76lHRE3BWKeZCqoLs8BuQ
	 OPpMwvnQEtjLfqQKUDEW/9yz2mARaVpmxvTe3FfAJu6U70/v/3BUvAyqMKVHPRcUIE
	 pZwp0gl7yztxwYiiCtu+YhnBwN9tAxWd1sarD8nM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
	Johan Hovold <johan@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.1 230/969] rtc: ntxec: fix OF node reference imbalance
Date: Sat, 30 May 2026 17:55:54 +0200
Message-ID: <20260530160306.809597492@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 30c4d2f26bb3538c328035cea2e6265c8320539e upstream.

The driver reuses the OF node of the parent multi-function device but
fails to take another reference to balance the one dropped by the
platform bus code when unbinding the MFD and deregistering the child
devices.

Fix this by using the intended helper for reusing OF nodes.

Fixes: 435af89786c6 ("rtc: New driver for RTC in Netronix embedded controller")
Cc: stable@vger.kernel.org	# 5.13
Cc: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260407122717.2676774-1-johan@kernel.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-ntxec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rtc/rtc-ntxec.c
+++ b/drivers/rtc/rtc-ntxec.c
@@ -110,7 +110,7 @@ static int ntxec_rtc_probe(struct platfo
 	struct rtc_device *dev;
 	struct ntxec_rtc *rtc;
 
-	pdev->dev.of_node = pdev->dev.parent->of_node;
+	device_set_of_node_from_dev(&pdev->dev, pdev->dev.parent);
 
 	rtc = devm_kzalloc(&pdev->dev, sizeof(*rtc), GFP_KERNEL);
 	if (!rtc)


