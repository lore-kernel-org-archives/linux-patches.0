Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1CF2D73AB;
	Thu, 15 Jan 2026 17:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499147; cv=none; b=RQxhnohZc7jqIJupmWU9Csjkli+L9aUJB/JoExBWTpYY62YwE8Y2jHUOTKnOAR5pX4zI7Id1icg4KxFT0e14zun0YHaBwAql03R9dOknaxi/HlRIrNAg/coYwpmB+41chBR8ebG6PEmkBXrWnRvhY8kDFCkztNC5J3gur3qFseM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499147; c=relaxed/simple;
	bh=NqxF7irkJJ94Ta3EUfu9jaKOg96l+oSTLX5ePlfy8Cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iss8pgGlBAVawCjVyDm33mHPus+tNd8266eo0HmjJqEgAEYpI2czcSccrbI8j6yQ4s2bw+xU3Ep5RuJaai1WOGyj3MWDwpswvD+C3B+RIeC9KZE0HFyKGqF7EKbMfz4io4qEFSgjLJSy/iFHkolvnLcb39u9iTg+bxQKBlxwcb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2p1bNy66; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2p1bNy66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EEAAC116D0;
	Thu, 15 Jan 2026 17:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499146;
	bh=NqxF7irkJJ94Ta3EUfu9jaKOg96l+oSTLX5ePlfy8Cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2p1bNy664B8IT+EMSzR6j2SVKax3OtDb2JeTDv+fVbf9UpuLAB9towQZzup8poSZJ
	 ichMRgyAfJoSWQcQEgWGo68smO+luHsRr0HlwH+WvsLWNthcp4i3O0B6Y9KRmLVv8I
	 QqW4HLzj08LsHp2f3fGqDrv5Q8kwP8lGteuTg7U0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Minas Harutyunyan <hminas@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 091/451] usb: dwc2: disable platform lowlevel hw resources during shutdown
Date: Thu, 15 Jan 2026 17:44:52 +0100
Message-ID: <20260115164234.210177943@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f421650cfa03e..57ef6dcb489b8 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -343,6 +343,9 @@ static void dwc2_driver_shutdown(struct platform_device *dev)
 
 	dwc2_disable_global_interrupts(hsotg);
 	synchronize_irq(hsotg->irq);
+
+	if (hsotg->ll_hw_enabled)
+		dwc2_lowlevel_hw_disable(hsotg);
 }
 
 /**
-- 
2.51.0



