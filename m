Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF8429ACC5;
	Mon, 23 Mar 2026 16:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282926; cv=none; b=SZXFhsgafTxYnu2E/pCAhIYXHHZOm2/usLFlaoVVF4ETieUef6tOWBm4a+NAvjTmythFx+ytw0JPYplt1Dn2i3bYyHzEOlMeckR4oSWgMAM7Xr+ppsmwXi2HgOiJZStikLbEWB0Gg6cpVs2MHKN5DmHNflMUYrCnqJD1TKHSrZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282926; c=relaxed/simple;
	bh=siaixflRppTMf9O51d7axVebS605EvTA/MoiUX10c/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QUbGd3uWd6LEsXNBetnTRMi55MbbvjDYSgi3rQPg/He94Gupon8lZNTMkLU4ORhylYuD+hTb7sP+GQdITC2SyxA6aKqQ8VnF51GcFffwjvmlaVFkZB/sinlAiGLE7jxOVuq64DgNyq2wkuFiHgLDk/HVpSchZefhIDdEIyw8W0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LrIjkCL/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LrIjkCL/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4CBC4CEF7;
	Mon, 23 Mar 2026 16:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282926;
	bh=siaixflRppTMf9O51d7axVebS605EvTA/MoiUX10c/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LrIjkCL/XLsMlX+RrOM9CnGoURawI6pUp/aBe0R0bTBv9QPT3nxMhWj+6pVoZ8K64
	 CuvnfzJfsIjPQkNMcV7/7uuQR7D1VoevZEocYEQjVdPz+/lOMoanAEEqD0yNLL3qzz
	 1/Zr/Z1kN+1RZYgJC1R+08K8IYzWbYxXZZiaroV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 338/481] pmdomain: bcm: bcm2835-power: Fix broken reset status read
Date: Mon, 23 Mar 2026 14:45:20 +0100
Message-ID: <20260323134533.334156019@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit 550bae2c0931dbb664a61b08c21cf156f0a5362a ]

bcm2835_reset_status() has a misplaced parenthesis on every PM_READ()
call. Since PM_READ(reg) expands to readl(power->base + (reg)), the
expression:

    PM_READ(PM_GRAFX & PM_V3DRSTN)

computes the bitwise AND of the register offset PM_GRAFX with the
bitmask PM_V3DRSTN before using the result as a register offset, reading
from the wrong MMIO address instead of the intended PM_GRAFX register.
The same issue affects the PM_IMAGE cases.

Fix by moving the closing parenthesis so PM_READ() receives only the
register offset, and the bitmask is applied to the value returned by
the read.

Fixes: 670c672608a1 ("soc: bcm: bcm2835-pm: Add support for power domains under a new binding.")
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Stefan Wahren <wahrenst@gmx.net>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/bcm/bcm2835-power.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/soc/bcm/bcm2835-power.c
+++ b/drivers/soc/bcm/bcm2835-power.c
@@ -580,11 +580,11 @@ static int bcm2835_reset_status(struct r
 
 	switch (id) {
 	case BCM2835_RESET_V3D:
-		return !PM_READ(PM_GRAFX & PM_V3DRSTN);
+		return !(PM_READ(PM_GRAFX) & PM_V3DRSTN);
 	case BCM2835_RESET_H264:
-		return !PM_READ(PM_IMAGE & PM_H264RSTN);
+		return !(PM_READ(PM_IMAGE) & PM_H264RSTN);
 	case BCM2835_RESET_ISP:
-		return !PM_READ(PM_IMAGE & PM_ISPRSTN);
+		return !(PM_READ(PM_IMAGE) & PM_ISPRSTN);
 	default:
 		return -EINVAL;
 	}


