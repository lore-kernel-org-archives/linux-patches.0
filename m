Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6C4311967;
	Sat, 12 Sep 2026 14:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222102; cv=none; b=CGz64prSiTo7kPW5ds61sE7ZlkbE5jpLLL+lYTD+6TLDx+kGV3goC9NMfhz+kqiFO+YZY94m2cmOX8rNZvPhIw0ayDAoIPvWX24TtPQNyhmVlH29YeSmWy2dD/634Mz5WcLtCyvdxG05Bos23jGTPUhhhz+hM9hnPFOHuE17gBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222102; c=relaxed/simple;
	bh=aGdMf9tRwARpYjTObBLUJg0ExeXbTzUuD9I8nfRiVdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AhYxyMXCcYz12n3EJb8Cm3uO40mmYd2hYhcHHyu+UQDxBZn9bFMU41mKVJAYEQ27Fw+4mJArfX71fZyu221PehwNILtDjXeJax1D/vrn71mLHWTR0SdCrwjn+H362fyypqxzyVyOemzhtZoYdEuE4BZ3+xScAk9FSQ4ZmsLsWSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FhfgAbVu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FhfgAbVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D589E1F000FF;
	Sat, 12 Sep 2026 14:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222101;
	bh=zdCHmc++wCV+szsXHdzY177NfLZs85Gem9W5RWroptQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FhfgAbVuOB3IXB6T7dCbJWvFN+r9QMOcGq2TOcyVZ5raFJ2n5lPHiMicJRy3ZNrbG
	 BGOw8ZxILYDpp2dBsGLO4GQ2MG9yrUJ9wSs71/dZPAAs/6DsA5srOw9cZMQ/XwXrKR
	 EuRrpucMQohtzbZOT4iH4NZo+8jgeso7RE5RZUgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Mack <daniel@zonque.org>,
	Kavan Smith <kavansmith82@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH 6.6 0519/1424] drm/msm/dsi: round 6G byte clock rate to the PLL-achievable value
Date: Sat, 12 Sep 2026 08:49:11 +0200
Message-ID: <20260912065618.914838924@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Kavan Smith <kavansmith82@gmail.com>

commit 6cd33b6f4155efc20485929fd0b56bb704641db9 upstream.

MSM8916 runtime DSI commands still go through
msm_dsi_host_xfer_prepare(), which re-applies the link clock rate before
enabling the link clocks. That is fine in principle, but on DSI 6G the
requested byte clock rate often does not exactly match the DSI PHY PLL's
realizable rate. For example, the driver can request 56250000 Hz while the
PLL actually runs at 56246337 Hz.

Because the requested and actual rates differ slightly, every later
link_clk_set_rate() call is treated as a real clock change and re-locks
the PLL. On a video-mode panel without an internal timing generator, such
as samsung,s6d7aa0 / lsl080al03 on MSM8916, that live-clock glitch makes
the panel lose pixel lock and visibly corrupts scanout on each runtime DCS
command, including backlight writes.

Fix this by rounding the computed 6G byte clock rate up front, before it is
stored in msm_host->byte_clk_rate and reused by later transfers. Once the
host carries the PLL-achievable rate instead of the idealized one,
repeated link_clk_set_rate() calls become no-ops in the common clock
framework and no longer re-lock the PLL.

This keeps the normal transfer callback sequencing intact, preserves the
OPP vote path in link_clk_set_rate(), and matches the fix direction
suggested in the original 2018 discussion.

Reported-by: Daniel Mack <daniel@zonque.org>
Closes: https://lore.kernel.org/all/1a682c5b-7fc9-3aaa-120b-64b239a355a3@zonque.org/
Fixes: 6b16f05aa39f ("drm/msm/dsi: Split clk rate setting and enable")
Cc: stable@vger.kernel.org
Signed-off-by: Kavan Smith <kavansmith82@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/738234/
Link: https://lore.kernel.org/r/20260707013240.681012-1-kavansmith82@gmail.com
[DB: dropped extra chunk from the patch]
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -635,12 +635,24 @@ static void dsi_calc_pclk(struct msm_dsi
 
 int dsi_calc_clk_rate_6g(struct msm_dsi_host *msm_host, bool is_bonded_dsi)
 {
+	long rounded_byte_clk_rate;
+
 	if (!msm_host->mode) {
 		pr_err("%s: mode not set\n", __func__);
 		return -EINVAL;
 	}
 
 	dsi_calc_pclk(msm_host, is_bonded_dsi);
+
+	rounded_byte_clk_rate = clk_round_rate(msm_host->byte_clk,
+					       msm_host->byte_clk_rate);
+	if (rounded_byte_clk_rate < 0) {
+		pr_err("%s: failed to round byte clock rate, %ld\n",
+		       __func__, rounded_byte_clk_rate);
+		return rounded_byte_clk_rate;
+	}
+
+	msm_host->byte_clk_rate = rounded_byte_clk_rate;
 	msm_host->esc_clk_rate = clk_get_rate(msm_host->esc_clk);
 	return 0;
 }


