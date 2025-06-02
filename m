Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECD1221DBD;
	Mon,  2 Jun 2025 15:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877380; cv=none; b=rNvNGJRrf8VWr/vrb+TOESF+EGGk46B+YtImKj9MjLU0uDUNF90+Nh+n8VhHwDhdqMs74AsVNK0ZpaZv5z52uoZDFSauv9VJARASL7FdJi+viV2fioAolFa8PjGLJIuo0E+8ovYkUuQ1hREQHY9ugS3SIisUS2kMUv8ZFvd/bko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877380; c=relaxed/simple;
	bh=7wSnjBXveqwBg6AgAj4QOjN6u7NbBfqmsttfxRJfXYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=psgCU+gzzJ/CPGFspSAZ1PxBj1HYODHmRuW7YuFzR06aYtDrQA7WDn+iitIIQycNwkmtcHDJf/otT0PEAYcDPF+CBOgnX8ZciUe9dvtahSaFUPYLAgA3RMhTaW7ecu7/LgmiLrU+rABUeiRT0mVzSbuzUMRHO/XKzbJ2A2fLHxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VPqgEL8R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VPqgEL8R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EAE4C4CEEB;
	Mon,  2 Jun 2025 15:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877379;
	bh=7wSnjBXveqwBg6AgAj4QOjN6u7NbBfqmsttfxRJfXYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VPqgEL8RItTF3qhz4hxPOCgHpHJg4buMPD9aUG2Y0dHyMQcVLpVu8xGLhYrqzg+No
	 XQt8NTUvNZo7T7qSGNL3WWNpxgG6N29ZHjd1bW+k1NJF8HpKLri9JAZoGQngIIr9YJ
	 3d1nxtFrZVjjEQ6apUbbUSxK7KW1epKtk4Dtr/ZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"feijuan.li" <feijuan.li@samsung.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.1 259/325] drm/edid: fixed the bug that hdr metadata was not reset
Date: Mon,  2 Jun 2025 15:48:55 +0200
Message-ID: <20250602134330.300282965@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6164,6 +6164,7 @@ static void drm_reset_display_info(struc
 	info->has_hdmi_infoframe = false;
 	info->rgb_quant_range_selectable = false;
 	memset(&info->hdmi, 0, sizeof(info->hdmi));
+	memset(&connector->hdr_sink_metadata, 0, sizeof(connector->hdr_sink_metadata));
 
 	info->edid_hdmi_rgb444_dc_modes = 0;
 	info->edid_hdmi_ycbcr444_dc_modes = 0;


