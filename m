Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265EA25CC40;
	Tue, 16 Dec 2025 12:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888108; cv=none; b=EdFOlzjhuz6m/O96KcjzjcXIzd7ggYhewO/wfOljuylCL3sPSqY0uY9bkOxKiZbwjuKHT7SpvBJKVXa5P+R7rPPmZyyDIQyffiQqWLRLFOKohMH1hOA/KeWN4fRQnuLwVIiClS9glBrp6mRfKg2h0SHD4wErdfJJEqWulUufPqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888108; c=relaxed/simple;
	bh=PnAGG4HJq3yz7LfEr55nI74CHq9ghrhXtEVli+E62zA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfRDLtMw21MCq2Xyb28LOtXeu8QC1FWv7Hyheg3Sfka8eQ8o7eShq8wSawHv3Xf6t+iAXPXYMHLtXzcjz9wqF1PdCyAiQhG4mQZU4BAOX1HS2q0XNdhztA4LOCfCZtUwbCTZEwTS+3bZFohJJvj2Pswep7n21F5jmWB7pImbgaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uc6rTAPv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uc6rTAPv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF41C4CEF1;
	Tue, 16 Dec 2025 12:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888108;
	bh=PnAGG4HJq3yz7LfEr55nI74CHq9ghrhXtEVli+E62zA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uc6rTAPvKCo8p9/2KPUC2TKKga0RZS2vNVQ89AulCd3WNua2j3o2nsFlG7qRP+StE
	 2mGRalb+sGhVDVjGoFU1lXoGEo8OGbOVlxXMK//drpe+yclSpEc6VbQS9cEMw/wNEv
	 +JdsazRjgxFdtUIQS11y2r6pMTHPNUhzzDEP8WpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 435/614] clocksource/drivers/nxp-pit: Prevent driver unbind
Date: Tue, 16 Dec 2025 12:13:22 +0100
Message-ID: <20251216111417.133900325@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit e25f964cf414dafa6bee5c9c2c0b1d1fb041dc92 ]

The driver does not support unbinding (e.g. as clockevents cannot be
deregistered) so suppress the bind attributes to prevent the driver from
being unbound and rebound after registration (and disabling the timer
when reprobing fails).

Even if the driver can currently only be built-in, also switch to
builtin_platform_driver() to prevent it from being unloaded should
modular builds ever be enabled.

Fixes: bee33f22d7c3 ("clocksource/drivers/nxp-pit: Add NXP Automotive s32g2 / s32g3 support")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://patch.msgid.link/20251111153226.579-3-johan@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-nxp-pit.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clocksource/timer-nxp-pit.c b/drivers/clocksource/timer-nxp-pit.c
index 2d0a3554b6bf7..d1740f18f7180 100644
--- a/drivers/clocksource/timer-nxp-pit.c
+++ b/drivers/clocksource/timer-nxp-pit.c
@@ -374,9 +374,10 @@ static struct platform_driver nxp_pit_driver = {
 	.driver = {
 		.name = "nxp-pit",
 		.of_match_table = pit_timer_of_match,
+		.suppress_bind_attrs = true,
 	},
 	.probe = pit_timer_probe,
 };
-module_platform_driver(nxp_pit_driver);
+builtin_platform_driver(nxp_pit_driver);
 
 TIMER_OF_DECLARE(vf610, "fsl,vf610-pit", pit_timer_init);
-- 
2.51.0



