Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF183DE45B;
	Mon,  4 May 2026 14:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904633; cv=none; b=b8+NgGofXnW3r4/6efPIzOpU8RJJYo1Lbiqngd7TVrQDuXfj/p2HnBu15/ZrWmifNZRiziDBhITN5IFuYNaqFYEtT8gJxGfxtihelHDQ8io5j7pKxXS13OaEpf/jI7TJGtKyCTqPy59g9J/t2oFf0AEIPNR7YCFBHRBROGACucM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904633; c=relaxed/simple;
	bh=o0EvhjJOPCVCSX8EtpokkI30wG3VG0ozP7Qedapq6kE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s7oEdMWCMLw1mHvF59Vco5YtVA2AYaKBisaqL7Xfcj8Zyc3dGyWWj7Vae8/baSYj3f89O8gzfupJ9YjHqsCX5uMoEXWkFdqVhmG9JqzCgYdRFaXIRWXWMBpNqZceGulbcjfjmPGSNzv5EsdXJNXEpJIlc8t/NNgiV4UEJw0k6/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hsNZJJdP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hsNZJJdP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C23C2BCF5;
	Mon,  4 May 2026 14:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904633;
	bh=o0EvhjJOPCVCSX8EtpokkI30wG3VG0ozP7Qedapq6kE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hsNZJJdP+R4z4ewCKTI1BrLrfr6W5ZhppkXZuCxqaVxiErSsp2BHVO7hgrUAGtYm0
	 Af1wkFaRfaFICP8GfFvYhkFSL/59BblTV+xPNjbJcZqKWLLrrcwB46eWzsn0ahFciq
	 FMwDMr2ZIRlX/a1przA+zR/ZU1rMZwUIwNWvbTvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
	Johan Hovold <johan@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.12 115/215] rtc: ntxec: fix OF node reference imbalance
Date: Mon,  4 May 2026 15:52:14 +0200
Message-ID: <20260504135134.353550699@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


