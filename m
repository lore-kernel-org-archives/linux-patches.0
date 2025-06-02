Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA7322D9E7;
	Mon,  2 Jun 2025 15:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876448; cv=none; b=DHC8T591lHyHjgDFhqmBDdDY/HPVdDpWLx8uynNdqEFK6bp4AG9uKcZnehIUPdIG0jCTMAuK2pSAn7pTArNDEHc6pu6di4L67+no/vamNAUAG9cBTGI+jFSgRGV/vOoVWRG3EWVv3rCgjpJFNkuGuW16HVITfh2nKFltINjqHdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876448; c=relaxed/simple;
	bh=no9o5Sr86GQCLXqRtmtYfH0aUmMOCiUmzYSFJnoaguE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TQ6yAUuWjrSsL2vl4J+56Ydskm2b2pIHmPf14D2+IoFcHYlO2VvFqvXAnUIiLz3P3M6JctWA7UG4Rxk/Ds29wyEqe808FHuIdydjTXFT/ozvF0o02oIzwVtJkXdot/wb7vQh1khT2JO++h7bFzEsic88cG9q/Iak4bRSk5wZIVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kBG+wzj3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBG+wzj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0BBC4CEEB;
	Mon,  2 Jun 2025 15:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876448;
	bh=no9o5Sr86GQCLXqRtmtYfH0aUmMOCiUmzYSFJnoaguE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kBG+wzj3vPaptF1m47nCVRMzvMz5FpKzf+xseRM8/4ctTLbTy0p+dDW+zFW2woWUY
	 nPHUWG7+QfSVxCNSTVFYHR202YFptgm2sdQZH+zExmhsEkuhi0Ob4YF91zEaCLvSgH
	 ELH42fhdRNHGGW7DF8nhkCKllSAeA4MpcD6gjhL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"feijuan.li" <feijuan.li@samsung.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.15 177/207] drm/edid: fixed the bug that hdr metadata was not reset
Date: Mon,  2 Jun 2025 15:49:09 +0200
Message-ID: <20250602134305.682724801@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5172,6 +5172,7 @@ drm_reset_display_info(struct drm_connec
 	info->has_hdmi_infoframe = false;
 	info->rgb_quant_range_selectable = false;
 	memset(&info->hdmi, 0, sizeof(info->hdmi));
+	memset(&connector->hdr_sink_metadata, 0, sizeof(connector->hdr_sink_metadata));
 
 	info->non_desktop = 0;
 	memset(&info->monitor_range, 0, sizeof(info->monitor_range));


