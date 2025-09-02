Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34AF2DD5EB;
	Tue,  2 Sep 2025 13:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820602; cv=none; b=u+CHOo7ldTFOUl47LD4UbRaLr0+joUVPFvkIlEGTd+EguS/M1UepW8aYS42sPcZqdp3dqbaZ1/kP/C3ZzN7I3ECbAR3+G751Z6z5xukx0tAQAF6hjtbQ0lcPuWPjhybd05jgbYWLeBsi8qVxFN+C71hagYGHSvcvpj4SICA2Tds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820602; c=relaxed/simple;
	bh=VtlV8m1XPiOYzQF0RKTqfcd3pJmWplXIE20l9qVFnA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aiUzbeKldxKJr37QjntDvryO4XbogIHNZw76bweP/D+AQNTLhDul18RP94Ri949UzyE/5OJ49hGA73ckEq1xOXkxCilFtObkValNB/RiccDXzZ6KO69cGL/a/lGq4kodw1eubOOXVjxe8XXxyyDUCAZXUKAqyMB7oo5QJaNQGjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Q6NDxC3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Q6NDxC3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DEB9C4CEED;
	Tue,  2 Sep 2025 13:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820602;
	bh=VtlV8m1XPiOYzQF0RKTqfcd3pJmWplXIE20l9qVFnA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Q6NDxC3H91rf+LU5MgbaD7/m4f9SXVOtO1t3O2iILggY21L7ao6Nu8oWnc41vOwA
	 ypMixBNLUD6lkD7iNr7BjAhQsivQFVOYC99s6XsALPff3nsWErl040U1wOr/EZ9zMi
	 KNwkCTZOWns40IgPqFmBvrw9B/vddozKloIV8FbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Jones <jajones@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 5.15 29/33] drm/nouveau/disp: Always accept linear modifier
Date: Tue,  2 Sep 2025 15:21:47 +0200
Message-ID: <20250902131928.203913935@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131927.045875971@linuxfoundation.org>
References: <20250902131927.045875971@linuxfoundation.org>
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
@@ -664,6 +664,10 @@ static bool nv50_plane_format_mod_suppor
 	struct nouveau_drm *drm = nouveau_drm(plane->dev);
 	uint8_t i;
 
+	/* All chipsets can display all formats in linear layout */
+	if (modifier == DRM_FORMAT_MOD_LINEAR)
+		return true;
+
 	if (drm->client.device.info.chipset < 0xc0) {
 		const struct drm_format_info *info = drm_format_info(format);
 		const uint8_t kind = (modifier >> 12) & 0xff;


