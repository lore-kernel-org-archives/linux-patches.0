Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32EB92248BF;
	Mon,  2 Jun 2025 14:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874190; cv=none; b=JswGrkmHD8Fss8GrJNm/f3Wkh/XC1+a95brlXyaIND/BUdX0SK35sK/Z8bLnVX9PiCyBd22GYgiOYrrcUh+6lHXYOv0UD6gwJL4RpQI3iap5EfS3nfkuRywSl9C7UgCb7aCJSz1fK5Cr6iZPt0pE2URD5zuy6xYwfaQBKZ7WQAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874190; c=relaxed/simple;
	bh=YDDY2OozsnRD1puk4lm86axl98AwVhtRmoRFMjRO2EI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lFpAcCAiWYCjzxkCjIWo3CGhVs70zBLRrK5UZ20Y4YgXXD/uIIvC2FQx7hthJT9L6VbwfVMnBEeOiaDFsUM+XjGpbtXtB7dmIUVn0gNK6VgxRW1e4zOD7DBMvNbL3BuGeXAEPhaPOxfOEjkqGNAnifSyohijp5M2uO1KvbcZNbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MuccScZi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MuccScZi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56279C4CEEB;
	Mon,  2 Jun 2025 14:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874189;
	bh=YDDY2OozsnRD1puk4lm86axl98AwVhtRmoRFMjRO2EI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MuccScZi4LpEthB5JKCUD5sIk8GeTRY6JmKxQgWB7AURXtG3cC7CsrduCo6SkWPNN
	 39GMFNWD5/S2LTABW+EillLKDtnmimOEIwTpNmqz4um8/dT71HLnnN1uMCkaSNy51R
	 u2XnpZmjBfuuwTPW622OtDB3CzKFiR5rczc4r+HQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"feijuan.li" <feijuan.li@samsung.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.6 370/444] drm/edid: fixed the bug that hdr metadata was not reset
Date: Mon,  2 Jun 2025 15:47:14 +0200
Message-ID: <20250602134355.936785348@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6471,6 +6471,7 @@ static void drm_reset_display_info(struc
 	info->has_hdmi_infoframe = false;
 	info->rgb_quant_range_selectable = false;
 	memset(&info->hdmi, 0, sizeof(info->hdmi));
+	memset(&connector->hdr_sink_metadata, 0, sizeof(connector->hdr_sink_metadata));
 
 	info->edid_hdmi_rgb444_dc_modes = 0;
 	info->edid_hdmi_ycbcr444_dc_modes = 0;


