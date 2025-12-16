Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68EB5355041;
	Tue, 16 Dec 2025 12:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888117; cv=none; b=ZUmwgH3F14Jgf9TKyjqtI+r0jSx40uKTq1GiiKaDwsT4XCALtRdL+IPebHB+0wWkWA0htjjmDTB5xTSZdHk1jY/Q9Mltthif8oSiFqduUM/6iML1IvM8BEpFQMK+UUJReFd08M1YbkFBNZjLdCm4/7K8MOtsg0p7PZMeh4ThsH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888117; c=relaxed/simple;
	bh=nJ/w4O/qsr5BMs8X05a/hdUYRO+kXYYGW4KVRPS58Lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hllri71UKjE4D+uUzYuDIRKqfpjo216PDDwbIOqwoakPSJiK8gCv5Hzck7xKa6CquRsmckeYyS773wHpiJ+fojohvpVPc+QG0ElRud2bz2n1lsm9avmbMcd/4AjNPNj4lBhfL7d9PJwz4BhyZzG6A8mP3m09XdBLmr1qxTtZsrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yAgQ2M90; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yAgQ2M90"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB179C4CEF1;
	Tue, 16 Dec 2025 12:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888117;
	bh=nJ/w4O/qsr5BMs8X05a/hdUYRO+kXYYGW4KVRPS58Lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yAgQ2M900ZRL6Jo/0G0g9RywYXucujo2Wu7tflKu/E+gSycDUBv74jRqMNUdeHINN
	 NFUastrAdLPu88GaQrBhR7PbaYGe/ilk3GNO6jdwLNVBs2ccsDMbpC8F1wYU/x+6Ed
	 8Z1DfDt7sfJtGlywtQXC6wItw+aOsLc5XDJwr4sI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 437/614] clocksource/drivers/nxp-stm: Prevent driver unbind
Date: Tue, 16 Dec 2025 12:13:24 +0100
Message-ID: <20251216111417.208220289@linuxfoundation.org>
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

[ Upstream commit 6a2416892e8942f5e2bfe9b85c0164f410a53a2d ]

Clockevents cannot be deregistered so suppress the bind attributes to
prevent the driver from being unbound and releasing the underlying
resources after registration.

Even if the driver can currently only be built-in, also switch to
builtin_platform_driver() to prevent it from being unloaded should
modular builds ever be enabled.

Fixes: cec32ac75827 ("clocksource/drivers/nxp-timer: Add the System Timer Module for the s32gx platforms")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://patch.msgid.link/20251111153226.579-4-johan@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-nxp-stm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clocksource/timer-nxp-stm.c b/drivers/clocksource/timer-nxp-stm.c
index c320d764b12e2..1ab907233f481 100644
--- a/drivers/clocksource/timer-nxp-stm.c
+++ b/drivers/clocksource/timer-nxp-stm.c
@@ -487,9 +487,10 @@ static struct platform_driver nxp_stm_driver = {
 	.driver	= {
 		.name		= "nxp-stm",
 		.of_match_table	= nxp_stm_of_match,
+		.suppress_bind_attrs = true,
 	},
 };
-module_platform_driver(nxp_stm_driver);
+builtin_platform_driver(nxp_stm_driver);
 
 MODULE_DESCRIPTION("NXP System Timer Module driver");
 MODULE_LICENSE("GPL");
-- 
2.51.0



