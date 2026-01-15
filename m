Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778002C11EF;
	Thu, 15 Jan 2026 17:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497569; cv=none; b=tROxfGhU4D/ZoeFYYKYorbqJf0zdn405hZDnh6glbAkmvNIAvTV7MlNB+f8JLHF+g2PF+NTv1f/WoiFfnaf7ufNuHs53emqTaO0//2kFcITqmVUyIbk6HUAlIpV8jU3gbqtckQrsle/uGrDyZYE3S03NxUiD8FkYHf1EDmL1roE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497569; c=relaxed/simple;
	bh=WWEcdLoEN3rg2NZdBSAoSxBGaTqS+HYbHkaTwCK8im4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y51GZ7Vo0C6RmLfcZqiB1hjwFhDsIWZKBLgqKX2YE+gNITpKZZYzh5y9jmdMo5p3WC1OU9hf3IVy1mfvEe3Q5V5P5P9nFLPwAdJCAegRpH6JbYOXhMTFu9zKsnTRbr5HRMMXyrNOVSUhv5vsqH6vTGpDV26+2CFdI4rtsjufU5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZDkRnNzA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZDkRnNzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02643C116D0;
	Thu, 15 Jan 2026 17:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497569;
	bh=WWEcdLoEN3rg2NZdBSAoSxBGaTqS+HYbHkaTwCK8im4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZDkRnNzAw8edSVz5prg4Q/K2gTUhobBtfnws9rMmqzbJ9QEC8PffxC4+hfE6RnWSX
	 W71wL5cjCK6itOLQNIY1whz+RiER98Ol7X284CfVxg6LxKNGuAWnhq1ScJKWn5JQtU
	 fsCVUxZlQj92Ab2n09Fxbjm0TOivUmEVdbkcxBuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Minas Harutyunyan <hminas@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 126/554] usb: dwc2: disable platform lowlevel hw resources during shutdown
Date: Thu, 15 Jan 2026 17:43:12 +0100
Message-ID: <20260115164250.807351135@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5ff8186936790..8bdbae4c77b0a 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -386,6 +386,9 @@ static void dwc2_driver_shutdown(struct platform_device *dev)
 
 	dwc2_disable_global_interrupts(hsotg);
 	synchronize_irq(hsotg->irq);
+
+	if (hsotg->ll_hw_enabled)
+		dwc2_lowlevel_hw_disable(hsotg);
 }
 
 /**
-- 
2.51.0



