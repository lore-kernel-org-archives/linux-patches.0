Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E991DF27F;
	Wed, 19 Feb 2025 09:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955977; cv=none; b=uWML4EoPo99WGe/g1yd7fgt2nb+a9kMTO8830oYlFED1IdPZFld+GPb+OqNjzJtELdABn9gr2nOVavFC/1JAAsMrZqQfC/MQiQs5WJwCRx8R+ecMSMvOOyCi56aMqFZ0xzmQmDOCLc6diM+bfK84RUCcgSE6Luj2ULHNjSZ7P/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955977; c=relaxed/simple;
	bh=BhgF2acxXK9E45bUT8Owo96z6up0pmC6n4QIlXW8aTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8eCIB1UU2vORLV07v4huhevjyGbzBqNBPlaDNzikT2TIDKCao3uzm9G5Y8CN9pu7Cux9Ac9SjYZY1joGBoQYxGvFfJQWT/7qjS4qBswLgtvW7yiSJ+KP26AQL0Sxx8d6W/X8cvZxeZKyaYcvAZVMk3SfddoBU8kB3F/3N/WxF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1qCdqPeY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1qCdqPeY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C15AC4CED1;
	Wed, 19 Feb 2025 09:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955977;
	bh=BhgF2acxXK9E45bUT8Owo96z6up0pmC6n4QIlXW8aTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1qCdqPeYeqAmqDLpA4MA2bQp5m3i086wtXfQuADeeob4uSKl9RARBifYm51qDhzu4
	 bTYVOw5DfHl1aUdJik8XOzE3sVpJQdT6Oxn+/uzuYNozjo0wYFfh/I5KTTlY2b+qY5
	 dkj6KMTZOA2HTc6J1JD5CVUdkmEe7lO5vjDqJfcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/578] drm/rockchip: vop2: Check linear format for Cluster windows on rk3566/8
Date: Wed, 19 Feb 2025 09:20:28 +0100
Message-ID: <20250219082653.844306710@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

From: Andy Yan <andy.yan@rock-chips.com>

[ Upstream commit df063c0b8ffbdca486ab2f802e716973985d8f86 ]

The Cluster windows on rk3566/8 only support afbc mode.

Fixes: 604be85547ce ("drm/rockchip: Add VOP2 driver")
Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20241214081719.3330518-6-andyshrk@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
index 7619a0c42aada..955ef2caac89f 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -463,6 +463,16 @@ static bool rockchip_vop2_mod_supported(struct drm_plane *plane, u32 format,
 	if (modifier == DRM_FORMAT_MOD_INVALID)
 		return false;
 
+	if (vop2->data->soc_id == 3568 || vop2->data->soc_id == 3566) {
+		if (vop2_cluster_window(win)) {
+			if (modifier == DRM_FORMAT_MOD_LINEAR) {
+				drm_dbg_kms(vop2->drm,
+					    "Cluster window only supports format with afbc\n");
+				return false;
+			}
+		}
+	}
+
 	if (modifier == DRM_FORMAT_MOD_LINEAR)
 		return true;
 
-- 
2.39.5



