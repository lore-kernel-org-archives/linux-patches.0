Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4158135B120;
	Fri,  9 Jan 2026 12:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961837; cv=none; b=mXfCYMdYMXBP1qMFoFU/wm3YDr99ysA+n6o0uHepebygzthJIhCoi10/gG04hY36Hybii8ZJ3KV6qOY4gr2x6llE1/vDqcTQNz9QAePZSEbgXF1t/RgHREvENbJWWX6SQIWSX5/LQsOlke6OABRVV43XKPTAvw9Njpu2BO2NIv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961837; c=relaxed/simple;
	bh=FEkmLOl/Z1wQXn5W5GtCWsfHZuEkXomkV0JbSxBEdn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q7evqUJrZY+WkoVdZZuS0Mcx5fasbyqGbvN6sdxQ+cBfijwNZqz0eeRFbqMCvuEz5nwR9NLvoVuKmKP/oeTmMYKPtaNut/dkj37MWkzto98cCdTo5yy/wXqAg2+ITsJnoaLyJVDGh3vwJVIv0YejzCIoH8ks6VNWvEmFrV+RMec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yd+dJK/8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yd+dJK/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A0AC4CEF1;
	Fri,  9 Jan 2026 12:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961837;
	bh=FEkmLOl/Z1wQXn5W5GtCWsfHZuEkXomkV0JbSxBEdn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yd+dJK/8ra5V+LD4IkLMXLHU9RTYHUgtvngvGMnwVjJEHQb7aytuKSN4lLjlGVsLV
	 AkKSPg40Wljfy8oVep7/6y66EXdFDF0EdnGvWFsvSaaCjVq7MDE7+NlMEUPpSG6dye
	 8r8R5oc0OCo2WDD+02itb7oG21zUo5cWXmZj4lcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Minas Harutyunyan <hminas@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 136/634] usb: dwc2: disable platform lowlevel hw resources during shutdown
Date: Fri,  9 Jan 2026 12:36:54 +0100
Message-ID: <20260109112122.572021408@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 7481a97c5f49f10c7490bb990d0e863f23b9bb71 ]

On some SoC platforms, in shutdown stage, most components' power is cut
off, but there's still power supply to the so called always-on
domain, so if the dwc2's regulator is from the always-on domain, we
need to explicitly disable it to save power.

Disable platform lowlevel hw resources such as phy, clock and
regulators etc. in device shutdown hook to reduce non-necessary power
consumption when the platform enters shutdown stage.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Acked-by: Minas Harutyunyan <hminas@synopsys.com>
Link: https://lore.kernel.org/r/20250629094655.747-1-jszhang@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: b6ebcfdcac40 ("usb: dwc2: fix hang during shutdown if set as peripheral")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/platform.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
index 9de5a1be4a0ae..5e8c74e20bffa 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -340,6 +340,9 @@ static void dwc2_driver_shutdown(struct platform_device *dev)
 
 	dwc2_disable_global_interrupts(hsotg);
 	synchronize_irq(hsotg->irq);
+
+	if (hsotg->ll_hw_enabled)
+		dwc2_lowlevel_hw_disable(hsotg);
 }
 
 /**
-- 
2.51.0



