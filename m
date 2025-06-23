Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1B32628C;
	Mon, 23 Jun 2025 21:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713845; cv=none; b=uNiQfKDdbkhfcFSTHR6EpOnEgkMV1JS79yM5gxIZdEkbGJzLwXNNdDCHAcg5Jo+JDBRWb3MSpyUkQP6+iCxKjccr33ei/MJ9RZktppLli/wWAszY7GfRkGS6P8E51E+ONYA8Oowkvi71FjA013y+7K8yeCEEj2bgG8JJ3NrgQMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713845; c=relaxed/simple;
	bh=KPnpjJphfUVIqvRRyOsV1aAg1p2r099oEeyt/z3EnCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pijDWGr3R8eAwld43eZ6OshiEhoXKtnJ51JqurABbslGZ/J7wEOOiL09aLvSVCrHMXjiZI6dolleWerrQUrG4wenTQIZOsqXWaYd/BlftbenmolVAL7wdnW/TH4Se0M0fFTYXpJ2khDEFIjkOh+z2aB6uOigMPx4Udz/ihE1JNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VHtduYUb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VHtduYUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9916FC4CEEA;
	Mon, 23 Jun 2025 21:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713844;
	bh=KPnpjJphfUVIqvRRyOsV1aAg1p2r099oEeyt/z3EnCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHtduYUbJxn4nqCEolix3AofiMwWehLDlQRIeMYn/yq8Ko+J0xl9aSSX4LQsY/tXh
	 pcurBYGx2+tELw82gyTCk4v4OrAxLDSXuCB2aeX0sDX7DlLWmPh0YuHFnphJSsYpTF
	 e4WQjRp/fLNZ4qBnhHfNn+N+Qt+40eFcZk8y9d1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 150/508] rtc: sh: assign correct interrupts with DT
Date: Mon, 23 Jun 2025 15:03:15 +0200
Message-ID: <20250623130648.972893089@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 8f2efdbc303fe7baa83843d3290dd6ea5ba3276c ]

The DT bindings for this driver define the interrupts in the order as
they are numbered in the interrupt controller. The old platform_data,
however, listed them in a different order. So, for DT based platforms,
they are mixed up. Assign them specifically for DT, so we can keep the
bindings stable. After the fix, 'rtctest' passes again on the Renesas
Genmai board (RZ-A1 / R7S72100).

Fixes: dab5aec64bf5 ("rtc: sh: add support for rza series")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://lore.kernel.org/r/20250227134256.9167-11-wsa+renesas@sang-engineering.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-sh.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-sh.c b/drivers/rtc/rtc-sh.c
index cd146b5741431..341b1b776e1a3 100644
--- a/drivers/rtc/rtc-sh.c
+++ b/drivers/rtc/rtc-sh.c
@@ -485,9 +485,15 @@ static int __init sh_rtc_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	rtc->periodic_irq = ret;
-	rtc->carry_irq = platform_get_irq(pdev, 1);
-	rtc->alarm_irq = platform_get_irq(pdev, 2);
+	if (!pdev->dev.of_node) {
+		rtc->periodic_irq = ret;
+		rtc->carry_irq = platform_get_irq(pdev, 1);
+		rtc->alarm_irq = platform_get_irq(pdev, 2);
+	} else {
+		rtc->alarm_irq = ret;
+		rtc->periodic_irq = platform_get_irq(pdev, 1);
+		rtc->carry_irq = platform_get_irq(pdev, 2);
+	}
 
 	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
 	if (!res)
-- 
2.39.5



