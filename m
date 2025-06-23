Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232E02F24;
	Mon, 23 Jun 2025 13:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686007; cv=none; b=kM0/e3QfyZE95aR/NGh9u31wJFWaejUlZriBDHQoqYwTWzp8VPOZqxeD2Ftw1Fs8TVGHbmUelLAHZ+zYtK5wsb2gEQ+jJTCpRxOcTJtRbXa6HQa7Mtou/9RNLJDv3oYeYFhbzH3S1W3U73GEZKj6/vXH+Yq7YxFdEHCoomWqTeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686007; c=relaxed/simple;
	bh=4XMTqRrXYWr2Oq0J883Wv4pIC2n7ymTk1OjmxuBKCL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XB6/OaT1+FpOKeVfu8OYKwWCpV54tfZsyi0EIkGlKkPxmUc9vKLD90+tbHe6jJzD28roCsP9rI7iwWP070QwiroYbZN7WqxXY/KaEhIUcEOZu31vhVikWLviiFXbFF92kzh2ADFKuXVSyUjBpYa9xojhh3DkX/jLnB4i/oCwSOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H36jh7z/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H36jh7z/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8FAC4CEEA;
	Mon, 23 Jun 2025 13:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686007;
	bh=4XMTqRrXYWr2Oq0J883Wv4pIC2n7ymTk1OjmxuBKCL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H36jh7z/DUL3IX7vgxdnW/VPq0CjEkMk57lYgfKWYodeShnqMa0OiLzYkP4mJ5xgT
	 6b9nPrFo1DibucGcLIe30BjhdkT+iz50ygHxBe0KbJEv//tTcx70VZEtu6JTjxMwcE
	 6Va0BrugkHQvweIvqVF+TCp2gZ/znv8z7djrWNDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 085/355] rtc: sh: assign correct interrupts with DT
Date: Mon, 23 Jun 2025 15:04:46 +0200
Message-ID: <20250623130629.362877162@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9167b48014a15..7d2367104a9bf 100644
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



