Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1024F220687;
	Mon, 23 Jun 2025 13:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684640; cv=none; b=E/WggC596azJkFLVrCxm3tPhpdB2M0d43sj8bUVYfSRxy2qUup8Ua/k1eb5uRe2HFYLjUcnwyA6JoPS+8apVXThYuA7VnY+602yXxityUZsTqrep/bRyfZsIVylfp8f6hkw/AdOeW0rrAmiSFyTNwsePF4TNir6bh6rI2I5JOmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684640; c=relaxed/simple;
	bh=ux+7a5KHQNBGttvBUolboEQf1KAsEMYxbwQpLaiXRs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emX27AHDUEcRqRgLpWWOPsZf85yrs85CDFkzHWBgru6UbDbWugBYuSsla+atolWiCL+L7aoBweLP0WfimgZsuNLH5D9NC70BI9O+qWAH1NHSHfiDc17BIuiKZ9Jc3PCPMOMEB6ZXnWJK0tT9MvPQn+i6PugX7P78VIYXP9lM4kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u1a5izYO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u1a5izYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CCD9C4CEEA;
	Mon, 23 Jun 2025 13:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684639;
	bh=ux+7a5KHQNBGttvBUolboEQf1KAsEMYxbwQpLaiXRs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u1a5izYOgPVzDYwICyJxZdADogitGHOpQsNtxGasKkWEPk1QFdn58S5G2a+V/iNsc
	 9zSU2fubvi6ssTcnFsZ6vdccgS6jts0lutngwMzL3qPjpFKZ5C05U97DsIMszdfux7
	 9xKmYS3rX8OymRaSjsM/Eb95bx5RaagQT4xaTY3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kendall Willis <k-willis@ti.com>,
	Nishanth Menon <nm@ti.com>
Subject: [PATCH 6.15 144/592] firmware: ti_sci: Convert CPU latency constraint from us to ms
Date: Mon, 23 Jun 2025 15:01:42 +0200
Message-ID: <20250623130703.703393985@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kendall Willis <k-willis@ti.com>

commit 9b808f7f395ae375a26e32046b680cf898dacc21 upstream.

Fix CPU resume latency constraint units sent to device manager through the
TI SCI API. The device manager expects CPU resume latency to be in msecs
which is passed in with the TI SCI API [1]. CPU latency constraints are
set in userspace using the PM QoS framework which uses usecs as the unit.
Since PM QoS uses usecs for units and the device manager expects msecs as
the unit, TI SCI needs to convert from usecs to msecs before passing to
device manager.

[1] https://software-dl.ti.com/tisci/esd/latest/2_tisci_msgs/pm/lpm.html#tisci-msg-lpm-set-latency-constraint

Cc: stable@vger.kernel.org
Fixes: a7a15754c7f7 ("firmware: ti_sci: add CPU latency constraint management")
Signed-off-by: Kendall Willis <k-willis@ti.com>
Link: https://lore.kernel.org/r/20250428205336.2947118-1-k-willis@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/ti_sci.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/firmware/ti_sci.c
+++ b/drivers/firmware/ti_sci.c
@@ -2,7 +2,7 @@
 /*
  * Texas Instruments System Control Interface Protocol Driver
  *
- * Copyright (C) 2015-2024 Texas Instruments Incorporated - https://www.ti.com/
+ * Copyright (C) 2015-2025 Texas Instruments Incorporated - https://www.ti.com/
  *	Nishanth Menon
  */
 
@@ -3670,6 +3670,7 @@ static int __maybe_unused ti_sci_suspend
 	struct ti_sci_info *info = dev_get_drvdata(dev);
 	struct device *cpu_dev, *cpu_dev_max = NULL;
 	s32 val, cpu_lat = 0;
+	u16 cpu_lat_ms;
 	int i, ret;
 
 	if (info->fw_caps & MSG_FLAG_CAPS_LPM_DM_MANAGED) {
@@ -3682,9 +3683,16 @@ static int __maybe_unused ti_sci_suspend
 			}
 		}
 		if (cpu_dev_max) {
-			dev_dbg(cpu_dev_max, "%s: sending max CPU latency=%u\n", __func__, cpu_lat);
+			/*
+			 * PM QoS latency unit is usecs, device manager uses msecs.
+			 * Convert to msecs and round down for device manager.
+			 */
+			cpu_lat_ms = cpu_lat / USEC_PER_MSEC;
+			dev_dbg(cpu_dev_max, "%s: sending max CPU latency=%u ms\n", __func__,
+				cpu_lat_ms);
 			ret = ti_sci_cmd_set_latency_constraint(&info->handle,
-								cpu_lat, TISCI_MSG_CONSTRAINT_SET);
+								cpu_lat_ms,
+								TISCI_MSG_CONSTRAINT_SET);
 			if (ret)
 				return ret;
 		}


