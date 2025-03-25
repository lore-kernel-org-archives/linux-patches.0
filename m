Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4315426B094;
	Tue, 25 Mar 2025 12:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906207; cv=none; b=nWkBZNzdAcQri7V0ehmIs3+gGuVrGWyS/yWegNsgoLC9laMTFjRp6shfXTba07emu6XP2SDJblh13ShLbNaYhtlxR3zM8v5h+OicIVgWXohl3J2GeFv+DyUrFg2tmmn0dc3UPYPrEX9xsLKpwHxMOvjhzQo0rvD3V7NterKhpN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906207; c=relaxed/simple;
	bh=aN9MofoiC+YrmFZKshQ0umxkyv1ULrYyfIksVW925lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0KZBnfuAJAhzUfAhU3aq8TotV/Nn73aK3iV9JszvKj5bqb4A1Uc67bw3vqu/DosTsqxMdQFmpV+/l1hu9gcMpQYRcp7tX2br4IgEP3INHf+Y8aA3wTZZQ4GBEVnEromai0+LSXOCQPOFMcqNg5cw4LCVQssYRvHDtdUp3oCELs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wNRfggKO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wNRfggKO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF34C4CEE9;
	Tue, 25 Mar 2025 12:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906207;
	bh=aN9MofoiC+YrmFZKshQ0umxkyv1ULrYyfIksVW925lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wNRfggKOzs/yS7IdcarWr3ZPnKTfBsYaKeijdO7T7TJvaFQ0WaEQvEdrp7awW8+fh
	 VpIMpzDIOImkmQpVkeb7Z/e4fm8iP15WHXwnGTH03RP+gx0e8kq4j8UVBTDWenTeBO
	 TvyAWlAZa/+Bq9ECPfYlo/OYjbxeUWWJ+hYEhZY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <frank.li@nxp.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.6 33/77] can: flexcan: disable transceiver during system PM
Date: Tue, 25 Mar 2025 08:22:28 -0400
Message-ID: <20250325122145.219777946@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haibo Chen <haibo.chen@nxp.com>

commit 5a19143124be42900b3fbc9ada3c919632eb45eb upstream.

During system PM, if no wakeup requirement, disable transceiver to
save power.

Fixes: 4de349e786a3 ("can: flexcan: fix resume function")
Cc: stable@vger.kernel.org
Reviewed-by: Frank Li <frank.li@nxp.com>
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Link: https://patch.msgid.link/20250314110145.899179-2-haibo.chen@nxp.com
[mkl: add newlines]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/flexcan/flexcan-core.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/net/can/flexcan/flexcan-core.c
+++ b/drivers/net/can/flexcan/flexcan-core.c
@@ -2245,6 +2245,10 @@ static int __maybe_unused flexcan_suspen
 
 			flexcan_chip_interrupts_disable(dev);
 
+			err = flexcan_transceiver_disable(priv);
+			if (err)
+				return err;
+
 			err = pinctrl_pm_select_sleep_state(device);
 			if (err)
 				return err;
@@ -2277,10 +2281,16 @@ static int __maybe_unused flexcan_resume
 			if (err)
 				return err;
 
-			err = flexcan_chip_start(dev);
+			err = flexcan_transceiver_enable(priv);
 			if (err)
 				return err;
 
+			err = flexcan_chip_start(dev);
+			if (err) {
+				flexcan_transceiver_disable(priv);
+				return err;
+			}
+
 			flexcan_chip_interrupts_enable(dev);
 		}
 


