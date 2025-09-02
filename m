Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C56324B11;
	Tue,  2 Sep 2025 13:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820752; cv=none; b=qwhTwWBdJDfANVlVehXzoco81WiiewP8Hu7cUHbOV1CXmRsrQKcg4osL6ciaDYN5TfZMWLLkIuaXEMnVo72QUPPZVu10dEYOaIGOe0UGyUykw4ClMHrHLa78ahoGFDijVR8SxChxD248bk1cLoSq/DuFCbS4mnSLKcbPtRICRM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820752; c=relaxed/simple;
	bh=xh86wPrn0eQDrYCuCBiptHuAqyOqp4TPgPp2IhxGEeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EJokH/R6h739dkWmadFbiWrRzg66BmAWRG483m2jh+IQalWW/3+e3cpEe5Sv+23m+J/UHdXX02B2pVKO7HLW0o+J8Iq8IFIPXLj9G34HE3X7NjMabYI4qLSQbPmaVShXrTEwyl9fNZptQ413rNMBiHGhx9OZVl/1NL5fRjkmKlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SEm8zmHu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SEm8zmHu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CAD4C4CEF7;
	Tue,  2 Sep 2025 13:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820751;
	bh=xh86wPrn0eQDrYCuCBiptHuAqyOqp4TPgPp2IhxGEeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SEm8zmHuU25hQdVwETEClULOrHZCpGMlAez0k67RsHhp1CBcnH9P0JOBtJMO1Ogvs
	 mYu6dTVS6i8UYoVQ1ZXi3q6BSnMe+p3mbNxLzJ0YISXK6s1PQIS3KwMhZXKYeanqPd
	 z6CxXmE8FIMV9oHIrW1GnhQpHLa65vGh9Kn8PAMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Jones <jajones@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 5.10 26/34] drm/nouveau/disp: Always accept linear modifier
Date: Tue,  2 Sep 2025 15:21:52 +0200
Message-ID: <20250902131927.657801976@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131926.607219059@linuxfoundation.org>
References: <20250902131926.607219059@linuxfoundation.org>
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
@@ -660,6 +660,10 @@ static bool nv50_plane_format_mod_suppor
 	struct nouveau_drm *drm = nouveau_drm(plane->dev);
 	uint8_t i;
 
+	/* All chipsets can display all formats in linear layout */
+	if (modifier == DRM_FORMAT_MOD_LINEAR)
+		return true;
+
 	if (drm->client.device.info.chipset < 0xc0) {
 		const struct drm_format_info *info = drm_format_info(format);
 		const uint8_t kind = (modifier >> 12) & 0xff;


