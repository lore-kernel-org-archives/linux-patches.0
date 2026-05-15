Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C079F3C4B72;
	Fri, 15 May 2026 16:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862645; cv=none; b=H8ur+KqkgfFtC3bSd2M4rumSnALu5qODzSHn4XwZzH3ecBl0goN1oqmWoxgEGwhLf5p+QoiU2uUUwYMqdo25ny6bY0hgyzwvWAww9rK6A3KX0uOnYfRo38Q/NrixXWX8iFL56W0Sq+9Yt0hhRzWS3cxYeXgWOHxOnxQ8Bfz0+hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862645; c=relaxed/simple;
	bh=DIfUSFQZB6rH9zSHQR2JhPZr58faq/WxFqOonbk76cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=urWnH9YhBEc5GEcW1qFwXMvS5iayUheXm9go2N96iQUwSmCE+yli7hLrKnfH5GJmMgE6shV/k6+aWzorgCCBiT9MJN1t/39SHfxn8CVgO1yLTeg16gLIlHwZ+0u6iR6u8kbUyCUxlusmzWN2p7gTCbDU69Y35LMb1qZRKRmkgGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b2+uaN0q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b2+uaN0q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49FD1C2BCB0;
	Fri, 15 May 2026 16:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862645;
	bh=DIfUSFQZB6rH9zSHQR2JhPZr58faq/WxFqOonbk76cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b2+uaN0qtSf58f0ojyRT1UzzR2/el3sYzi14lgFhUc46ETKgrMF9T8Yc7j0cp4n1i
	 0tVhrLXVWaN/D61n4sXpHzv36rVaL3Ql3YZzR+IiznYCfaiNnO01l5L9b/0B8BQj+v
	 isVrZ6lTcpRL7/l5utuUMQ1Dgw3tNJb1nwYwyEXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@nabladev.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 7.0 126/201] drm/imx: parallel-display: Prefer bus format set via legacy "interface-pix-fmt" DT property
Date: Fri, 15 May 2026 17:49:04 +0200
Message-ID: <20260515154701.292634744@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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
 


