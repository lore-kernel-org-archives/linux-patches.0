Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB012DEA6F;
	Fri,  9 Jan 2026 11:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959829; cv=none; b=JCrySLo3UC3bVfcWvcwJDQAbq3X4/1xJIV0u3rgD7dBPzOVEC1TH+FvazPKf08LZuCMF9kRG9XsfloCLbxzg07cWpsnK/B38nty1tuhpLUT6j5+c9KVbzm3e/7ok3Z901ZdywqlS5w/TM53SR7Vs1UYP+fLaCJgrrPQfvjlSsfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959829; c=relaxed/simple;
	bh=rMG5CGc6jE/YEx1tLuJwYjtqpB52Csa48sxm5qtDWdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfcMtK3Kf8FUh0VIR4MU1E0bMcv6LLfV2ODTPMmGtWN7VQgZF+suKk7AXnuCm09w9KnqlxBO69WAK2mc0tGRGoj0pJifvGrGUPNpZfNawRUngDmHtgP1CySTommFaAesPRWCGrBLyKzVpfJ3/em75/h61P0p2wvMke1TIgTY5Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J4Tg3HN7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J4Tg3HN7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA80C4CEF1;
	Fri,  9 Jan 2026 11:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959829;
	bh=rMG5CGc6jE/YEx1tLuJwYjtqpB52Csa48sxm5qtDWdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J4Tg3HN75pchSnGKnVLSS3OVJXD/pZbo07Qg1zCRxrFIDloPgP3BBkTSZU1wtlirg
	 MUg1NkUKsMiLwcb4bHbQwJiRzPDBvmT8hEAuz5Jjy9ypFA43bDe9NLXbhJq+YyakI3
	 88VoUtlWtLWHcJBfKiEOVC/z1lHbPPTXnEjJLIHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Minas Harutyunyan <hminas@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 190/737] usb: dwc2: disable platform lowlevel hw resources during shutdown
Date: Fri,  9 Jan 2026 12:35:29 +0100
Message-ID: <20260109112141.143162014@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



