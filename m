Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099765678D8;
	Wed,  9 Sep 2026 14:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963039; cv=none; b=ZQxuvy7MNc6+iGDw1bjzbBGQ4iVe4l0SbFH2x8hAm4347Cn0S0p+SNC59gzVaBJt9MSfZI1xCdr7X4yh+t/2k/tl54Rci22OXYKEOzB6e7HcKKlNrPTSsCEryZrOEd/Siu3m8x+dXoqwEhRIT9esmBa7ZDnEThZo7I1vTIGmu2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963039; c=relaxed/simple;
	bh=gwJ5ARAOPgHyfWtrWsL/w3N3ULyHZvGHTuI6+NqB2t8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cerwd6+xo4FfCrXGL/yKejNuatVomd4Jf4EBQf/cXI6PcWGLROR2av5LP0dPpwO/KrR5gz7B2t8noCXj1Ah2EGACXGmesHWqHtF/8lEWRKoCKgpq8Ix0pYSeEw/ZbLfRb8TZagee2JhYqaXtemLIzl2p3BKKh7aPr9Xy7+oPThs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sysaTsPI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sysaTsPI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533C91F00A3A;
	Wed,  9 Sep 2026 14:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963037;
	bh=kKVBcL7JNlMHuTg0qZ4CUPuvlNTs63IISLQLp3wuPzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sysaTsPIyFl7Z+Fq5e1PYUKh5EQsEHYOEZUzvf+jT5TnHaMxZ+GLGtlU6t0OBAKo/
	 o4SHzAsPSnj/d4IFenbzeKx4copcyugqsSW5ivrxFl+y+KZdUzR3t7NB9+jHWx2Pju
	 FQz3Qcf5jhQ0xaXuPfjnyU8sAJBKIKnkLwuPp/A4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Mack <daniel@zonque.org>,
	Kavan Smith <kavansmith82@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH 7.2 498/556] drm/msm/dsi: round 6G byte clock rate to the PLL-achievable value
Date: Wed,  9 Sep 2026 15:42:58 +0200
Message-ID: <20260909134247.996585509@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -670,12 +670,24 @@ static void dsi_calc_pclk(struct msm_dsi
 
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


