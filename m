Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D903D5647;
	Wed, 20 May 2026 18:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300534; cv=none; b=l+I7RxClk38NmxXWcgiLivAIRVyuCSf165Wytk9BQzWlACSoba/A1q1svoIL7C+gzjZE3pmh20YSBagBjogBu5RnPzdLggHlKFnszcxwAfFa54swIz0UzX4MvukmyhN49NgHRmnkvsvSoyE5HYAS9KMUSVzmpRVKn0fcn/jWmbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300534; c=relaxed/simple;
	bh=mCdXCsHsJOQJULQr5pdPFdGx1nTe0PwJe/t8QDNyt+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gwz4eu6sbEknup8VpnEMq40L11A1tyFlgYSEQEm1vv+dVeAhfcCNIOpQDYkdY6eIK27IY0kcjLQuBKzU8tNmOL4tprNnQOrHG3aF8EqKLnC66Gng9lKUQMUvGdNQmU7lFQUed1qdZ17xwqjNwqydpti2IV7UVP5xDO+EJGDomis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZdprIBi0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZdprIBi0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4CD61F000E9;
	Wed, 20 May 2026 18:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300533;
	bh=LKzHm0TrqJPwpDsjGINN4NIK5wNvwP+KQjuB8Lw/v6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZdprIBi0SQdssSl1L73Eyrabf5i1zUC4ZfuGRJBLVjZ6yP1ZnIq8Mfn+Z0wFhJbQP
	 0wLWDJGC66Cghek5wDNdvRxeFLrvFA6PfmiJ5dq0oCdWKZbxvxILgS2ggdUlHlGOyu
	 qqw9Dg8E0Hq+ozcEYP9VrENEPvgSM1MnAFu4KnAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengyu Luo <mitltlatltl@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 169/666] drm/msm/dsi: fix bits_per_pclk
Date: Wed, 20 May 2026 18:16:20 +0200
Message-ID: <20260520162114.866875994@linuxfoundation.org>
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
index 1027434b72620..d0cc9ad58c140 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -999,7 +999,7 @@ static void dsi_timing_setup(struct msm_dsi_host *msm_host, bool is_bonded_dsi)
 		 */
 		h_total -= hdisplay;
 		if (wide_bus_enabled)
-			bits_per_pclk = mipi_dsi_pixel_format_to_bpp(msm_host->format);
+			bits_per_pclk = dsc->bits_per_component * 3;
 		else
 			bits_per_pclk = 24;
 
-- 
2.53.0



