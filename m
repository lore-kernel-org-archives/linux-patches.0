Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76749227BA4;
	Mon,  2 Jun 2025 14:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875796; cv=none; b=NwJkQSH+v+kET114o7+IUOE9LhXTGAEfcfuf9hsPr4nNzdOCSIjMD3ogKKXgrotFILuhz+cviHFP/6l3QyWngrnvk2OlHnd+gMCIYaWmFufAyLfleJsy+QbcI/Csel6FTkznEQKhCzosE8kyMBkIbfaN3fhkbwnDGaR5wAgM5FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875796; c=relaxed/simple;
	bh=04tNniGgxJOJJyBGRUDzSkgRp0iuwmLxa/d+Syr7JV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PoynK7dBQ3wZ+cdA3UmA+Q7FbsgkQMZGMHvBONKAG/VQxf4BnLZ7bAnRuEBK9ry89/jpEgr7PaIIV7id2ffppqFnhmmcvihDCI9E2gfn/kErRntS+tGGy7uf/x6QgfmaBhEMxn7T8pCc+NvHnmUk00SvoFH/1RtG2qTsbbN6Ifc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HdbDmkw7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HdbDmkw7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C25C4CEEE;
	Mon,  2 Jun 2025 14:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875796;
	bh=04tNniGgxJOJJyBGRUDzSkgRp0iuwmLxa/d+Syr7JV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HdbDmkw7QcTgmQsCSQUKYDC1v6UMKMDOm/4ZCoiL7BaatA8t+1WqnysAustuodb5h
	 Jo5R4p5NaHBjPvaC/85gQ1+bn6tIBDg7nhKxl7MsWNTC2MO3zQDyXYbg/2PAQRUexr
	 ESVthiEWM0mXmessg53FtBvNcxfxx4JZTO71AeCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"feijuan.li" <feijuan.li@samsung.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.10 246/270] drm/edid: fixed the bug that hdr metadata was not reset
Date: Mon,  2 Jun 2025 15:48:51 +0200
Message-ID: <20250602134317.389221279@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5097,6 +5097,7 @@ drm_reset_display_info(struct drm_connec
 	info->has_hdmi_infoframe = false;
 	info->rgb_quant_range_selectable = false;
 	memset(&info->hdmi, 0, sizeof(info->hdmi));
+	memset(&connector->hdr_sink_metadata, 0, sizeof(connector->hdr_sink_metadata));
 
 	info->non_desktop = 0;
 	memset(&info->monitor_range, 0, sizeof(info->monitor_range));


