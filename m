Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1630231282C;
	Tue,  2 Sep 2025 13:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819745; cv=none; b=udDj6p41uA2LooHCedwmOVBrd+oTLoFPPhmrXSBAZEbIHjQRwD8Vc7IAb/ZuLurx1R7tL6rwK70ql6LSjGl9Sb0NlwcVNrdzIIXY3sU61PUVNEvPvJ1N+nSKDI6GOpMDfkEmmtB0wepmaCKzjK7VW8aeGeU0xWpLI47f/dvX+pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819745; c=relaxed/simple;
	bh=YsX5QlkR0c1ywN9Wq9AZY2OFJN7vqtsHDrg2M/+P3fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E3sjulFMlT9wls8I+sZlJdqulZkBkbMmUYxLP3TYEB2XEHueVPkRXV2JrhiT8lW/DG/E0v27+jNbYPp5bWOKWeeen+Vq/OZCrb2aEXnAteM4/CwX+ysF22QFZtZdO2He7fF98tjE80CJcbYuwRt9PvJmWYhTyt4ep20PVbTeVwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vz2J0pZu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vz2J0pZu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74371C4CEF4;
	Tue,  2 Sep 2025 13:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819744;
	bh=YsX5QlkR0c1ywN9Wq9AZY2OFJN7vqtsHDrg2M/+P3fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vz2J0pZuCZs9YRd6sXqA7BQZZBfzPdzgqkS/q9GvtaXbVCc7/aDsm72tCfqxoPQej
	 NSpmoTLLxo5MwjewAYINgRS+lBggtxGo0lxLlw6PuDRE6qlQgEf0pC4tNvN4mu+fwK
	 q9U0oGpiFscaMyDq7Khd9wzfpIg4Roxk+fHlyhOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Jones <jajones@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.16 125/142] drm/nouveau/disp: Always accept linear modifier
Date: Tue,  2 Sep 2025 15:20:27 +0200
Message-ID: <20250902131953.074302374@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Jones <jajones@nvidia.com>

commit e2fe0c54fb7401e6ecd3c10348519ab9e23bd639 upstream.

On some chipsets, which block-linear modifiers are
supported is format-specific. However, linear
modifiers are always be supported. The prior
modifier filtering logic was not accounting for
the linear case.

Cc: stable@vger.kernel.org
Fixes: c586f30bf74c ("drm/nouveau/kms: Add format mod prop to base/ovly/nvdisp")
Signed-off-by: James Jones <jajones@nvidia.com>
Link: https://lore.kernel.org/r/20250811220017.1337-3-jajones@nvidia.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/dispnv50/wndw.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/nouveau/dispnv50/wndw.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/wndw.c
@@ -795,6 +795,10 @@ static bool nv50_plane_format_mod_suppor
 	struct nouveau_drm *drm = nouveau_drm(plane->dev);
 	uint8_t i;
 
+	/* All chipsets can display all formats in linear layout */
+	if (modifier == DRM_FORMAT_MOD_LINEAR)
+		return true;
+
 	if (drm->client.device.info.chipset < 0xc0) {
 		const struct drm_format_info *info = drm_format_info(format);
 		const uint8_t kind = (modifier >> 12) & 0xff;


