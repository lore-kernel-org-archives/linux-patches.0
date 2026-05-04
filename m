Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AEBA3A7F4C;
	Mon,  4 May 2026 14:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903323; cv=none; b=DWtehonZq9gLuGIYg5kByMus0BMq6rMS3M7w4OwFJW+qTtJ3led1HPg29Avp0/js3zwsF3BXQrZvptSASiXuXieItQhJVgnPjEURyJUrZZpcmkX7zgYa6xmhBdmC7q/g65ykyh9NIPd6sf+vzzwcz5BS9+w2z01AXJNq3fInDBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903323; c=relaxed/simple;
	bh=huE577MSsQeB8NgQFD+0TobeTrxUDADB+z0Kjwg2Qhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hUSbIkwecOy1uVBa2O3Z+0QS6DNGZx4M1+7i2UvGZRdztVM+CLiHrpaOZiawEyUKVoHcuhkpX6NhOuYEvspZCLx5uvVvjcXzM2A02t+WlCcinvB2WVd75vnGzXdo276+snDaLkWmJB3Vu0r2YDChqNxL3Ssd85j0TBE67DeYwYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j21i4uyN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j21i4uyN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF9BC2BCB8;
	Mon,  4 May 2026 14:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903323;
	bh=huE577MSsQeB8NgQFD+0TobeTrxUDADB+z0Kjwg2Qhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j21i4uyNxnA72u3LvKpjN+7v+eBBhuQOQeU6lH8vPUQKF3zPTNqWIgfXnMyQvGQG4
	 Pj5+OKuWK5CckC57lvrsj+vpW/WGc9C+7Wc6eQ2Okntkg1O0COHrcLS9zaCBx9YCyy
	 S+3UF6bf3KwcYp7uvRG9e69I3TixdDPNjg3oLc3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
	Johan Hovold <johan@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 7.0 189/307] rtc: ntxec: fix OF node reference imbalance
Date: Mon,  4 May 2026 15:51:14 +0200
Message-ID: <20260504135149.992174091@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


