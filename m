Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A154E3E7BC0;
	Fri, 15 May 2026 16:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862077; cv=none; b=pZw1dRI29GimIUvqfxVOXB7uDzniy+tUoMxCGZKyqWQVkmzaBYcflfEl/f/yo3BVSBnQk7E0oVS9GKuFOh3jT0m3IckZY0ecvqOXQnYeyQCyYPSMmO7Nammg4i0TSyjJUcqTW/Dq+H3rD623wANd24Wjh4YiEFHTxA+AQkcIogY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862077; c=relaxed/simple;
	bh=1tBme09asz1jHym2B6PeUAHe0NNol1xgraM4+CUqRdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cbe7AVqEUS8U/+qmxl4KOPU8QMbnGNP7lm8LVCLADGwWms2ISAGSQRF5LrAKRoXu7lLxuH+JKjm+QJ58aSPW8WTUTag1cNNCl+GOWqgxqQuNWeLpHnsy/Bgxu+brwM7Qhol7ZbHzJj4fAsnVGxaYGplLHGn7+hRRv/0oSNhR5pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EuJKQ2jJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EuJKQ2jJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB46C2BCB0;
	Fri, 15 May 2026 16:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862077;
	bh=1tBme09asz1jHym2B6PeUAHe0NNol1xgraM4+CUqRdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EuJKQ2jJ3buP8NYsvi57jAxR70NBD3TOlISoz2NrPQZOy5wLewWEhBP1l6PpmSWpk
	 WR/aqUMCIc7XBT/Qgv05QVcUTlmr1YQZqIgvWJBgH2VnVK8RUqQ5MZ0BT/wx5DzWsK
	 SNQSSD0y3N2hZp6JU8F877GjHrtgjqrnaGXEsJUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@nabladev.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 6.18 098/188] drm/imx: parallel-display: Prefer bus format set via legacy "interface-pix-fmt" DT property
Date: Fri, 15 May 2026 17:48:35 +0200
Message-ID: <20260515154659.456009104@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

From: Marek Vasut <marex@nabladev.com>

commit cdf26e1462c220629bb79d487263b66f8b679eab upstream.

Prefer bus format set via legacy "interface-pix-fmt" DT property
over panel bus format. This is necessary to retain support for
DTs which configure the IPUv3 parallel output as 24bit DPI, but
connect 18bit DPI panels to it with hardware swizzling.

This used to work up to Linux 6.12, but stopped working in 6.13,
reinstate the behavior to support old DTs.

Cc: stable@vger.kernel.org
Fixes: 5f6e56d3319d ("drm/imx: parallel-display: switch to drm_panel_bridge")
Signed-off-by: Marek Vasut <marex@nabladev.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://patch.msgid.link/20260110171510.692666-1-marex@nabladev.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/imx/ipuv3/parallel-display.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/imx/ipuv3/parallel-display.c
+++ b/drivers/gpu/drm/imx/ipuv3/parallel-display.c
@@ -110,8 +110,7 @@ imx_pd_bridge_atomic_get_input_bus_fmts(
 		output_fmt = imxpd->bus_format ? : MEDIA_BUS_FMT_RGB888_1X24;
 
 	/* Now make sure the requested output format is supported. */
-	if ((imxpd->bus_format && imxpd->bus_format != output_fmt) ||
-	    !imx_pd_format_supported(output_fmt)) {
+	if (!imx_pd_format_supported(output_fmt)) {
 		*num_input_fmts = 0;
 		return NULL;
 	}
@@ -121,7 +120,17 @@ imx_pd_bridge_atomic_get_input_bus_fmts(
 	if (!input_fmts)
 		return NULL;
 
-	input_fmts[0] = output_fmt;
+	/*
+	 * Prefer bus format set via legacy "interface-pix-fmt" DT property
+	 * over panel bus format. This is necessary to retain support for
+	 * DTs which configure the IPUv3 parallel output as 24bit, but
+	 * connect 18bit DPI panels to it with hardware swizzling.
+	 */
+	if (imxpd->bus_format && imxpd->bus_format != output_fmt)
+		input_fmts[0] = imxpd->bus_format;
+	else
+		input_fmts[0] = output_fmt;
+
 	return input_fmts;
 }
 


