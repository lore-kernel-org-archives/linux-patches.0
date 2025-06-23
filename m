Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4017424678E;
	Mon, 23 Jun 2025 13:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685034; cv=none; b=QvZStSm4DdXfHsC/W3cOaYpGs5gW6GULTntKHNoaLs1vo1QGxqLYSvL8ZvauqxbI/SlkFaBBFPnM+zUpjte6m+oHpnumyjwz9r9FOxZ4AXagDl9wtCj7xKaX+SCy7NgC0CSwnnU7qwnTi2nigBElDfZ5Jz1DlwekCMI2ZKncR8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685034; c=relaxed/simple;
	bh=a8bEXEi/nWtUake6V7kRvo1Dsp1i/uvld0ZciqjP4yM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5MiYou8QEN72xlb6Myj+ZRCABnfFMEcSp4d23MDcAcSNoAIXFzekfpMoof5WbzcCxNMWYCr6hvfW+5NwYkExDgGseL/xFOI5Ye6wEsnUmfc/BP3boNXJ8jk5DISnflkoZQomjhFk5HXlJJ/JUG3ncqYimiWrJpBX7xnR0gZtoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t8cDUcTB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t8cDUcTB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E1BC4CEEA;
	Mon, 23 Jun 2025 13:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685034;
	bh=a8bEXEi/nWtUake6V7kRvo1Dsp1i/uvld0ZciqjP4yM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t8cDUcTBqkW7jSiuL2fR42e8s/PmSn9SUVPdZqTwQ7NtNto3JuWWdAoeFeU8kb2/X
	 kv5FmXKzFWBpuQXvqKPfU6i7xOcTjp+aT5DPoqDuMMH7XG3VHjgyH444aqvkNYNBxl
	 5pn+kXIYg8V7Tu/JiiIUOiT2tc/kJx8MQWccMp6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 062/222] rtc: sh: assign correct interrupts with DT
Date: Mon, 23 Jun 2025 15:06:37 +0200
Message-ID: <20250623130613.976451746@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 579b3ff5c644f..8b4a2ef59e609 100644
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



