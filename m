Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D061E8322;
	Wed, 19 Mar 2025 14:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395116; cv=none; b=ALXyI7M65kmrmS7jLEpbGoKnLSruJZ/+7VcxNTVp32vG9dVaT7vQAb23sC9zYtxpKvBhGqkGxsj/oK26Uocq8tANvctUfAU4VyDofcuo2a66l/rXBjVWqJaZ3UYKqR1MUPJcWZg6KWaTrklKEQRj1KK3auz5hdf6Q1qJEUSwKH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395116; c=relaxed/simple;
	bh=WJ4VoFhyce+voy4fwTsARW7DSstEXwzlGGZBxS53ujg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GbLPtxEFZIF2RnBH+YKDrRAEZDKLlkygo/OSG8NrvccPS+FSXvElaxHa0Y3n5ysb4cL1U3YOSAnm9DMYrVdTgmP1p10JDKpYJKhADoUwltUxmmGauhux+maSrF+E4aLHQ+UTxS2BCb8E46/H72S8l1enHtPZxOGTNYbm8lB86nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2IUbVkqM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2IUbVkqM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D659C4CEE4;
	Wed, 19 Mar 2025 14:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395116;
	bh=WJ4VoFhyce+voy4fwTsARW7DSstEXwzlGGZBxS53ujg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2IUbVkqMIQNMD30ShUkOBUxDdUl2fptfk5heIXPh+El4t6e3qBXXUG88FzoqFo3uq
	 A6oC5dMgYaFYobH2M+DicXZOnuX7+YCVJ/eSIoBfUK8KOlNY8eX18uwAlOEfXZyJYU
	 Rf8I/BRGv6iJ/dQbSnvA1oK6vlH6Rb1q0J0rwWFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Louis Chauvet <louis.chauvet@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 134/231] drm/vkms: Round fixp2int conversion in lerp_u16
Date: Wed, 19 Mar 2025 07:30:27 -0700
Message-ID: <20250319143030.143860079@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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
index e7441b227b3ce..3d6785d081f2c 100644
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



