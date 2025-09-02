Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B3C320A08;
	Tue,  2 Sep 2025 13:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820485; cv=none; b=b6jayTi7YeJXcfMTDyUF6ExpB/CBUfcBHTF/MB0Y5pkNsPTXkuctmFvPDlUHQgDXgQdBrEDmJE1E64VoyCxrD7JUm1QdjQiYdJIVAxA3mlE8cvWgCNTlI/+OzWGcqlVe4R+Mf2+KOrcduQefxg8HGPn1gIFjcIAMOn/f7yc8fD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820485; c=relaxed/simple;
	bh=swc1nllWYG2kaozmra8krB09lZoKzleds9ckQ79E34w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/z9BqnkzwHyX+OZIfb7jv0H6kkPh2RnRI6bDCRC377qVrYKjOEuD3zmf71HD9VgIFFphb87TrNmalSvBBa8+pq7vz/Ie9aVGUTHwDs5YQnyT1Mb2TUOC3x+Th2ys3Sdl56hk5s73A4/CAAuGoaH08UuQFjqE7+XsmZA5G99szc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HZgs90i+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HZgs90i+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A238EC4CEF7;
	Tue,  2 Sep 2025 13:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820485;
	bh=swc1nllWYG2kaozmra8krB09lZoKzleds9ckQ79E34w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HZgs90i+d/4R3hIF1czWWEGBnYnrwpCLvPq4fUKqx3eUx5QNDQsf7xHoPPzcO22sF
	 F9C1hMf21C7H62v+KsG9NF3YZ0n6bu6573F2DXx8NXSaGxgUEFOLAekcS/lf1L37XA
	 qrD06A5+zvpDzHnvODkbB9ccZD1Fs4CxG0mumw+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Jones <jajones@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.1 45/50] drm/nouveau/disp: Always accept linear modifier
Date: Tue,  2 Sep 2025 15:21:36 +0200
Message-ID: <20250902131932.304162550@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131930.509077918@linuxfoundation.org>
References: <20250902131930.509077918@linuxfoundation.org>
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


