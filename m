Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64BB650E5A6;
	Thu, 17 Sep 2026 17:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666352; cv=none; b=q/M1Ielyvp3iBTbQBfXeu533ebC5eFtNCFA9NU+zDRGnNOCpWgfJgKMMnw9B7Ym67dOEYeVpMz4vC33UpZqBtb4VRb/Jae0M3BlLUQmhoS8NPC7ekjJdX5BskBZ04lbJ5CmT1QhgiRuemPh4+D6+PkCV5VUCaslAzRUqaJ3DnQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666352; c=relaxed/simple;
	bh=bCXbghBO2mLEEOH8MH348K9m0VqmGZQXdWa54zyTACU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p5XITCMGhUuD7t0OCEiAVHHJsnPjydg5+aJ/JouE6TXWgtQDf/oRhXB6UN4kPSp1gfcm4sK7D9bW2Y1TIgYaLHVZI5OxCv8UVqPq4yh3cJCq0WqpgK/p9bI2V1P4x7pBH+XndcOhEmcjzHCpwfmB5U/tFg5YeLe6OY2u7oTPUN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NlOXds11; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NlOXds11"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20381F000FF;
	Thu, 17 Sep 2026 17:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666351;
	bh=J0kTT4bLWIWX+mSCdaG/OMe2fsnlNiTiuzlzswHIQog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NlOXds11MmiVwi6pLDCTrIFQzN5dM3IpcxGAPs01TRnLQU8Ll+wvL/iUkmYjtahYZ
	 fDZU2m7rcJzzlvJW2lPKH7YNxWKDAhE234XhC+oKhv+H/dkCLuGguQWTmif+H370CV
	 zpNXTQUbgICKNyVgJKGh6Aj8asVOMUOjxCFGsqYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yudi Yang <2000jedi@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.18 1008/1250] drm/rockchip: analogix_dp: fix unchecked bound endpoint name length
Date: Thu, 17 Sep 2026 16:13:23 +0100
Message-ID: <20260917151619.364726282@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yudi Yang <2000jedi@gmail.com>

commit bc69439d983cc491cc86e01fafc1deb94e1bb85e upstream.

rockchip_dp_drm_encoder_enable() uses sprintf() to format a device tree
path into a 32-byte stack buffer. Device tree paths are not limited to
this size, so a sufficiently long path can overflow the buffer.

Use snprintf() with the destination size to truncate the generated name
and keep the writes within bounds.

Fixes: 729f8eefdcad ("drm/rockchip: analogix_dp: Add support for RK3588")
Cc: stable@vger.kernel.org
Signed-off-by: Yudi Yang <2000jedi@gmail.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20260901195511.2761251-1-2000jedi@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/rockchip/analogix_dp-rockchip.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/rockchip/analogix_dp-rockchip.c
+++ b/drivers/gpu/drm/rockchip/analogix_dp-rockchip.c
@@ -258,10 +258,11 @@ static void rockchip_dp_drm_encoder_enab
 				of_graph_get_remote_port(endpoint.local_node);
 
 			of_property_read_u32(remote_port, "reg", &port_id);
-			sprintf(name, "%s vp%d", remote_port_parent->full_name, port_id);
+			snprintf(name, sizeof(name), "%s vp%d",
+				 remote_port_parent->full_name, port_id);
 		} else {
-			sprintf(name, "%s %s",
-				remote_port_parent->full_name, endpoint.id ? "vopl" : "vopb");
+			snprintf(name, sizeof(name), "%s %s",
+				 remote_port_parent->full_name, endpoint.id ? "vopl" : "vopb");
 		}
 
 		DRM_DEV_DEBUG(dp->dev, "vop %s output to dp\n", (ret) ? "LIT" : "BIG");


