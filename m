Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDDB343D88;
	Tue, 16 Dec 2025 11:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884473; cv=none; b=Cu0213N0pV+/josVF8GTxAHt4X691OG6rDj8tUwaa/niPjBfRoGntIbFgnpwS4mEQxQsEpWl7+EnXfZyMun1CdGB++L7wLR2yKkc9GN1TalwFHMZBUn36VsKetsZOHfAeWqyRUrmi9BD1NihXsJz3K/q6NYaeca55cK6dgPXsvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884473; c=relaxed/simple;
	bh=Q/rA4KPPnkqMuJ+t/1ud/J3pErHJcgt0jBHE+96cF3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oXk6evGFnLmJudls0ptXzm5pF6GwoklXsGJEentffHKlXME1JGSmZBsTsn98NvkHPebvrl28PE7B2YS28oTkTdMgjedPCKv7sK5SbHZR6bXuXD0FSkZ9g5v6m5fg+C8nx47OXAreBqwa3b961T9I2+BLjfBj8E8XcyKFwo7hxck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aCROORMU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aCROORMU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE71C4CEF1;
	Tue, 16 Dec 2025 11:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884473;
	bh=Q/rA4KPPnkqMuJ+t/1ud/J3pErHJcgt0jBHE+96cF3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aCROORMUHMGbaPDKsWF6NUxYzBlca17dKh03UbeOgYpMf3CP553yDTzEnas9Ib09W
	 sEiXdV8qhgx/Nq8gmLXfIkjWbi9iBmocSW5mQWMnKI9fFUxjw5t/Rk/b6FomesVhMa
	 b76b/40BexFnr95xjDuuFWNbmjCZn/VL9+GYz8F8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Minas Harutyunyan <hminas@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 203/354] usb: dwc2: disable platform lowlevel hw resources during shutdown
Date: Tue, 16 Dec 2025 12:12:50 +0100
Message-ID: <20251216111328.274492945@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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
index c1b7209b94836..79ce88b5f07d9 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -371,6 +371,9 @@ static void dwc2_driver_shutdown(struct platform_device *dev)
 
 	dwc2_disable_global_interrupts(hsotg);
 	synchronize_irq(hsotg->irq);
+
+	if (hsotg->ll_hw_enabled)
+		dwc2_lowlevel_hw_disable(hsotg);
 }
 
 /**
-- 
2.51.0



