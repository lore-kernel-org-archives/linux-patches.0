Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD6022172A;
	Wed, 19 Mar 2025 14:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395216; cv=none; b=I4ka9fMfKfIZd4Fk2pAdYOOOPDBuhiqO3dgnbC96D5qpdW6zZXH218t2zMAw1K3X3JOUSsy8Ea+rhYN7AmuOFiw2CRAkfY3ooMCszXbaYgHrPETq1VYeZt7ARAwLcMrdNh3QKff5t/KrOudRCXgkSIDUOppN6oVVEpnE5aSr2Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395216; c=relaxed/simple;
	bh=y7NqKHt3dlfom78hRyGl8LTntbtVkN4RaMnmSOG6GzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGI9vCDtnuvwlU4vgf62LytdwlMMMcIPWZMt9tX7Cm/hoSzyRPJz6vGVwo3SU/6QnhVcK6pRxw3XXdHxDQlm9O7ZeLNuxvsj8AzttSdUYAA3AClully0bNm4AGEhZuGbpM0RbgNZW/f0EDzf86tM/j+ZEt44lgINJ8YEr3rnMbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jw5fVumI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jw5fVumI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F324BC4CEE4;
	Wed, 19 Mar 2025 14:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395216;
	bh=y7NqKHt3dlfom78hRyGl8LTntbtVkN4RaMnmSOG6GzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jw5fVumI2nLYOc/KO15684etvshNQOYWCzh9czt9tAuwhwhI/t+B2C1ez9l3aXw1E
	 4k0os1KVCVoUfROKPDJqVCP0nFpjuALjSVAZVwOBFKIJVPI0Ejq1syvKPRg1ccdTGf
	 B6CznPUi75KV/1vHBqi5+SLQXth5AaaHUtU/VBiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Louis Chauvet <louis.chauvet@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 087/166] drm/vkms: Round fixp2int conversion in lerp_u16
Date: Wed, 19 Mar 2025 07:30:58 -0700
Message-ID: <20250319143022.377348832@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



