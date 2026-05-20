Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159743D75DA;
	Wed, 20 May 2026 17:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298008; cv=none; b=oCt+QAGHy79tebMHEyDezxtslIja5kNQhgtkFHUTh9gKljDRAhPn3kEA8ou8hS6yljiOepp8e5vgsIFqYFBWYnjawjCZibrXk4bzrc4tGKAgqANfbw+ZS4VXtyY3rwh442Wwpfn7vUfTQ98HBAYnitWahxUcfJhiKiJV6aG/1vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298008; c=relaxed/simple;
	bh=1TTLxWDJwBOn8jL2CKJjfuVdPCJTMg+LIir/DBgX8Jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tjCgZNQX6X5vtDnddget1DfM67JFt1Mq1Yh6eULB1kJpM18YE1vh7GQYjTJ5i8OoH7n6qNn6CSAUlAajGf5TYBNJandsJH9Bs+GmDt2z8c2R4x4N1E4j4KpTkQtzy6nVkcbePpk18vyDHIrTUDWd++fc2GcaMCwMLlKMV1FMLJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rpdhMuBl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rpdhMuBl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E381F000E9;
	Wed, 20 May 2026 17:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298007;
	bh=wlaBd2vbL8MqXMRze+chCM7aQhargFXWqZ+e5+BP1DQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rpdhMuBlWv9ZasAhjlQQSGSB54bNSspX0fY/oHQEe4DSAQ1wMu6UF2nEZCOGNQmXV
	 BON9+bbCbq31rH8TEIyfl5tpPs24sGL3sq7Z3mYZxrbCyJ+FUlBOk08tm7BSofdEpJ
	 itR1v09uOrAN/lk4NlHykiZ2zAd6rMk9rN/swt+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengyu Luo <mitltlatltl@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 246/957] drm/msm/dsi: fix hdisplay calculation for CMD mode panel
Date: Wed, 20 May 2026 18:12:09 +0200
Message-ID: <20260520162139.878227174@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index 3efcc3f6c381c..1c0841a1c1013 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1034,8 +1034,9 @@ static void dsi_timing_setup(struct msm_dsi_host *msm_host, bool is_bonded_dsi)
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
@@ -1047,10 +1048,14 @@ static void dsi_timing_setup(struct msm_dsi_host *msm_host, bool is_bonded_dsi)
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



