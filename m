Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088D04F5E0;
	Wed, 20 May 2026 18:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300537; cv=none; b=uzzoKVrlTdeyS22P3UjUF1NQunodw0gw3qJ6d3SGdXGXiR7DUwE1AWX7uOq9WJbFhd0Qu2hFhwk99WBZa/hzq//dfyJaNAdewLerDRsEFbLrUCmdVZq90YLAWTkps4bC4c4GEHw06CLdMUN+ZwnIxsSw6G0cMyDv/nOn25R92Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300537; c=relaxed/simple;
	bh=2T3h7hczgF2vzUO8/Zu0kCaEAXMUvf1f0LJ4RIH57wA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hu4b6uJCKfw/CSGzKRKb3iFx24h7PEZ5WUBT9CHlOh7O0B7YSI4sCWNYSbZoFgED196ddF8jOdPsZuvZp7UHZsIbuvdpvZJCvPDjD+a/cnKyLsgE1acaGuruxx3xQ46+nxNiv0sp9O43NDFdh7Utwb7H/uf/zzRFFr4yqoENKeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RddJlikp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RddJlikp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3731F000E9;
	Wed, 20 May 2026 18:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300535;
	bh=J3HeAa4Db3igAabQ0ec3XVdNXKh16ZXyi0B+RAqCoDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RddJlikpzHiHtmO9YEJyTUQ8kWNm7j82x7MI2YvCJ2VOMNP92ZIZLDcSYhINwdz+q
	 wtU9ayCjRG/18d4z04CF2AflSe/l1IYYw+DQy2+yfky3mgd7YNc7X44YBeDSmlA8PM
	 R6a3ZQ77JU5AEXLNs5y8D8cIK4pJlTd0dNIubbcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengyu Luo <mitltlatltl@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 170/666] drm/msm/dsi: fix hdisplay calculation for CMD mode panel
Date: Wed, 20 May 2026 18:16:21 +0200
Message-ID: <20260520162114.887997176@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Pengyu Luo <mitltlatltl@gmail.com>

[ Upstream commit 82159db4371f5cef56444ebd0b8f96e2a6d709ff ]

Commit ac47870fd795 ("drm/msm/dsi: fix hdisplay calculation when
programming dsi registers") incorrecly broke hdisplay calculation for
CMD mode by specifying incorrect number of bytes per transfer, fix it.

Fixes: ac47870fd795 ("drm/msm/dsi: fix hdisplay calculation when programming dsi registers")
Signed-off-by: Pengyu Luo <mitltlatltl@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/709917/
Link: https://lore.kernel.org/r/20260307111250.105772-2-mitltlatltl@gmail.com
[DB: fixed commit message]
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index d0cc9ad58c140..6f538c578f740 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -985,8 +985,9 @@ static void dsi_timing_setup(struct msm_dsi_host *msm_host, bool is_bonded_dsi)
 		/*
 		 * DPU sends 3 bytes per pclk cycle to DSI. If widebus is
 		 * enabled, MDP always sends out 48-bit compressed data per
-		 * pclk and on average, DSI consumes an amount of compressed
-		 * data equivalent to the uncompressed pixel depth per pclk.
+		 * pclk and on average, for video mode, DSI consumes only an
+		 * amount of compressed data equivalent to the uncompressed
+		 * pixel depth per pclk.
 		 *
 		 * Calculate the number of pclks needed to transmit one line of
 		 * the compressed data.
@@ -998,10 +999,14 @@ static void dsi_timing_setup(struct msm_dsi_host *msm_host, bool is_bonded_dsi)
 		 * unused anyway.
 		 */
 		h_total -= hdisplay;
-		if (wide_bus_enabled)
-			bits_per_pclk = dsc->bits_per_component * 3;
-		else
+		if (wide_bus_enabled) {
+			if (msm_host->mode_flags & MIPI_DSI_MODE_VIDEO)
+				bits_per_pclk = dsc->bits_per_component * 3;
+			else
+				bits_per_pclk = 48;
+		} else {
 			bits_per_pclk = 24;
+		}
 
 		hdisplay = DIV_ROUND_UP(msm_dsc_get_bytes_per_line(msm_host->dsc) * 8, bits_per_pclk);
 
-- 
2.53.0



