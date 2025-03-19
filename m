Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF511D8DE4;
	Wed, 19 Mar 2025 14:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394927; cv=none; b=EEXOOYmVEUGLgSMlCd1xO4gb6vfYzgM5F2zf+rDhEtF+C0Q/BZOSMvrrMyJ608bYg3yf6reYCdVvsGXgg513uCmceDryMendrCDcSjg5youmyQq4aiEUUN9759IBFEm4gzj2RXPqGIB28yV2WN0nZIGGLsNCCicwienQWdaR04U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394927; c=relaxed/simple;
	bh=3l+3xV29Nzg26NWbYitWV3YkAV4fW1nFGfpwdt0J4t4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HgHxkCohFD9TaJDxQMjjejlBuU4a1g8exS2jaVIRcbqDeNNP0f0aA4E9LD+7XDfabBubHu8m9MVxuAs1i6PmywM3/a/Nk+Qy5J7g9TuhahXMGQOD6LW53KTf0fyI4GpbKkYdsYqjNbCrwGTtJAq/vmOA390gm8Hjtt72Eumi2QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EMA1gToH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EMA1gToH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72FF8C4CEE4;
	Wed, 19 Mar 2025 14:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394927;
	bh=3l+3xV29Nzg26NWbYitWV3YkAV4fW1nFGfpwdt0J4t4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EMA1gToH+9gAy9Axg3es4FSsye/znD/I7BqiYJ+L3nix+CTDgfILviO/mU3kDMY2F
	 x/VTfQlHs4x4VR/eQw5XJBxQAMdXxxsYvoDK1qwP6RclSbLHjXtE/q5m94sCfZjNXk
	 C/eRoeT+NZLrG3UNAA+rs05AuXHB5LNM+7U7B//k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Louis Chauvet <louis.chauvet@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 140/241] drm/vkms: Round fixp2int conversion in lerp_u16
Date: Wed, 19 Mar 2025 07:30:10 -0700
Message-ID: <20250319143031.186117442@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Wentland <harry.wentland@amd.com>

[ Upstream commit 8ec43c58d3be615a71548bc09148212013fb7e5f ]

fixp2int always rounds down, fixp2int_ceil rounds up. We need
the new fixp2int_round.

Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Louis Chauvet <louis.chauvet@bootlin.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241220043410.416867-3-alex.hung@amd.com
Signed-off-by: Louis Chauvet <louis.chauvet@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vkms/vkms_composer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vkms/vkms_composer.c b/drivers/gpu/drm/vkms/vkms_composer.c
index 3f0977d746bee..87dfb9f69ee5b 100644
--- a/drivers/gpu/drm/vkms/vkms_composer.c
+++ b/drivers/gpu/drm/vkms/vkms_composer.c
@@ -98,7 +98,7 @@ static u16 lerp_u16(u16 a, u16 b, s64 t)
 
 	s64 delta = drm_fixp_mul(b_fp - a_fp,  t);
 
-	return drm_fixp2int(a_fp + delta);
+	return drm_fixp2int_round(a_fp + delta);
 }
 
 static s64 get_lut_index(const struct vkms_color_lut *lut, u16 channel_value)
-- 
2.39.5



