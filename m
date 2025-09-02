Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A741261593;
	Tue,  2 Sep 2025 13:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820074; cv=none; b=cIAs3LF/wo3xug9UCumkUV0G0vjYqXKPRa/ogTpOS/h34QVPqeQwL4riE6UI++HDzYKPX7D4jPF7r5LooPNnAtuLgqVv3mHCC2n6332bgznPNbO6WfOsNPAA9x8BSsXYHLSoZ4+rYi6gtf46Qn2Zig0M6UE6VRDFXtF2Vaayfuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820074; c=relaxed/simple;
	bh=eipAaaxDNSxtyolOXqC5rb7fgUomLVwgV3Yg1C0OVVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bhv8GQPupd9Lj1hMVtq2hpHPzMNMBJAwpQ8OocTVE+vYI52Gf1FuOKKZ8vGgr1V7w9mTUQD7ZREwI09WeU03+UQPsdWVqr2EqW6p4AVzzeEp4VFZdSQbIwCP1gnVU/7LEow5y6VbH++9KC7qRq2OUOphszMcFegBMcTUmujCCew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MYlihkNX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MYlihkNX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7816CC4CEED;
	Tue,  2 Sep 2025 13:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820073;
	bh=eipAaaxDNSxtyolOXqC5rb7fgUomLVwgV3Yg1C0OVVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MYlihkNX7bcR+MQiVubv6KOQ0O6nRzTyiUcX/vb6cXv1NymGunaYH6cVEI0c9BVTS
	 qbLGcGh5WjBOMmTjxLOm3XYNcuh7bT9a1BPTj/pV1RFqSusGa8PCVxfBSIZztlV1mO
	 YkagGw++QVXh6pDF5ckwjymHW0wYNKgOAFnyZIBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Jones <jajones@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.12 85/95] drm/nouveau/disp: Always accept linear modifier
Date: Tue,  2 Sep 2025 15:21:01 +0200
Message-ID: <20250902131942.866505428@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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
@@ -663,6 +663,10 @@ static bool nv50_plane_format_mod_suppor
 	struct nouveau_drm *drm = nouveau_drm(plane->dev);
 	uint8_t i;
 
+	/* All chipsets can display all formats in linear layout */
+	if (modifier == DRM_FORMAT_MOD_LINEAR)
+		return true;
+
 	if (drm->client.device.info.chipset < 0xc0) {
 		const struct drm_format_info *info = drm_format_info(format);
 		const uint8_t kind = (modifier >> 12) & 0xff;


