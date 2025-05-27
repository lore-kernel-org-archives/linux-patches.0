Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9B125DAE1;
	Tue, 27 May 2025 17:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366096; cv=none; b=KY3hKS69/uoik16LSKxFjMakXirOU5p4yZ8QzGfp0+AqVbWkOi/aAHLUlpkuqOpD8z4D6nxNq9FuzZw+QTvRFQUiOlEJDl5ldU72x5HhK/bRIpJFvACYJEWpeyq6ZgigBWsGdX+ZTSWgGDyzkn89Fze1Moc4GKKPms/0igMMqLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366096; c=relaxed/simple;
	bh=xXnoscB+zhlCsp/+AoawZzG+dWShtLlqK0a6ko0GD9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eoy71pWYkoBYNGQpWeLk51DwR1m5jltJ5YXDpaCAwgHuukqyDjSuerd+qQ2i6PMcJHl+VK5U4WGrWnftMirwqHVwMNX8uijWZvcHZhksBdvIkGaMXH+QGnSENzM1CZB5UXeWiag3uYPXWM66KNONNtQ7sFlc3fNpHTvzYPHWE/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g5fXjWG/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g5fXjWG/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC0BBC4CEE9;
	Tue, 27 May 2025 17:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366096;
	bh=xXnoscB+zhlCsp/+AoawZzG+dWShtLlqK0a6ko0GD9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g5fXjWG/ea6LB4BOrqfqdBOZtUl+kIqb2uDiWYFJ7JicXmPlsjQqKJm8O2248DBRf
	 hPkBU3G5+JgI68wJuD2x3NW9FrI3/BV2ohpDhtL1mOwyce+dr+JLF1NOofaUUtw8oe
	 cIq+RG5ErH43YRKE7zB3FsPSNYkxBdkpcwd2oPqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"feijuan.li" <feijuan.li@samsung.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.12 590/626] drm/edid: fixed the bug that hdr metadata was not reset
Date: Tue, 27 May 2025 18:28:03 +0200
Message-ID: <20250527162508.955484486@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: feijuan.li <feijuan.li@samsung.com>

commit 6692dbc15e5ed40a3aa037aced65d7b8826c58cd upstream.

When DP connected to a device with HDR capability,
the hdr structure was filled.Then connected to another
sink device without hdr capability, but the hdr info
still exist.

Fixes: e85959d6cbe0 ("drm: Parse HDR metadata info from EDID")
Cc: <stable@vger.kernel.org> # v5.3+
Signed-off-by: "feijuan.li" <feijuan.li@samsung.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Link: https://lore.kernel.org/r/20250514063511.4151780-1-feijuan.li@samsung.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_edid.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -6596,6 +6596,7 @@ static void drm_reset_display_info(struc
 	info->has_hdmi_infoframe = false;
 	info->rgb_quant_range_selectable = false;
 	memset(&info->hdmi, 0, sizeof(info->hdmi));
+	memset(&connector->hdr_sink_metadata, 0, sizeof(connector->hdr_sink_metadata));
 
 	info->edid_hdmi_rgb444_dc_modes = 0;
 	info->edid_hdmi_ycbcr444_dc_modes = 0;


