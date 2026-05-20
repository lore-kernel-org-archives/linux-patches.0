Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D627233933;
	Wed, 20 May 2026 16:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295185; cv=none; b=auk9GZjahdXHMF0rXjB42foDHOfB500SWozJ0tlvNNGFyjbcOGKTrATDTfW/fOMZ6U+O3oiqRPGhDWc9dxJtbkK5zzdmXp1iGS5a8nkVzVRWE9q1EeCF0ALaeAhFKnxfROVe7qAYeLg9/H51VRULcC5pvFqAzRlnGMOTfd61gnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295185; c=relaxed/simple;
	bh=n+Yr8AZtceA25GTou57WQ1rlB0QdjV4bxMgvBGxBhFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TrSpEfCLNXi0yuVO4hX8znTh/71C0RBJZgLmbpcHXFw764J5neDRiRV2HnZeX4hMQYKssvFY9li6X7NFHMxFdgIsKMZpblV7jdDKE3dNT42yFr+8WjFtYpiFRcLzDS2LsxFS0lpmsFCPF3nRhxIW7Xc1TQIyo8oKujZO2kFr1Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NBjgeHzd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NBjgeHzd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7A61F00893;
	Wed, 20 May 2026 16:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295182;
	bh=af0Z/FtizL7ovlOLeOc6+KgLs1BwOTslE+563TZ5JsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NBjgeHzdLRbOe5rJ0rncePiRE4OkPRh7EgYj4zCEqFhNkpsc3SWlQGYiRTNM/ndV1
	 neLHi2EpE3uXbn8YFQNj3wv+kSLX9FkO1tNKIMV+a8EkANAnCcdHa3IfpnNVizf6HM
	 UiSYhIJbntUjUjZp5qIJcH623kgKu9EvH+HTVuNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengyu Luo <mitltlatltl@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0322/1146] drm/msm/dsi: fix bits_per_pclk
Date: Wed, 20 May 2026 18:09:32 +0200
Message-ID: <20260520162155.487380772@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengyu Luo <mitltlatltl@gmail.com>

[ Upstream commit 2d51cfb77daa30b10bc68c403f8ace35783d2922 ]

mipi_dsi_pixel_format_to_bpp return dst bpp not src bpp, dst bpp may
not be the uncompressed data size. use src bpc * 3 to get src bpp,
this aligns with pclk rate calculation.

Fixes: ac47870fd795 ("drm/msm/dsi: fix hdisplay calculation when programming dsi registers")
Signed-off-by: Pengyu Luo <mitltlatltl@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/709916/
Link: https://lore.kernel.org/r/20260307111250.105772-1-mitltlatltl@gmail.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index 6cb634590e7a7..3efcc3f6c381c 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1048,7 +1048,7 @@ static void dsi_timing_setup(struct msm_dsi_host *msm_host, bool is_bonded_dsi)
 		 */
 		h_total -= hdisplay;
 		if (wide_bus_enabled)
-			bits_per_pclk = mipi_dsi_pixel_format_to_bpp(msm_host->format);
+			bits_per_pclk = dsc->bits_per_component * 3;
 		else
 			bits_per_pclk = 24;
 
-- 
2.53.0



