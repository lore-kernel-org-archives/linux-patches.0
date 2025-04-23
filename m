Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A404D2820BC;
	Wed, 23 Apr 2025 15:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421560; cv=none; b=AroRJvGuki7rb/6rIrUAEC6QzQ7Rd0KUEtpxWlM0kR9qX6blxgdtC4TKsHkMr1iNnCkM7zrMQQu4bz/VvhrpGalFruF/6aGW5COCE+1Rd6Vnr667OQZ8PGhShgew248+ZHLNCOZY9/uFiALKpHRa3r6LXr5hkD+reC4qbznu9lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421560; c=relaxed/simple;
	bh=m5u7Tpv+H5nUDl4EEa68gVkNGLsExaDiRte8HEfwhyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6e/z7YbhDidf+z/DvEgad6k7++D7RATFvQJcCN2BcbjJy/W8cRn8S6gR2NoU+5ebvLG7Z0XLB/4bmjfzmoiYJ0TrLJJN4hsrDSG5PWsYVWLa404DUIEm7C34ffHWzKnbKJzYFOc+5EBovRSMHlJaPPJuFZLOojKK4mYzECZNuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0eOrXTqX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0eOrXTqX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 369C7C4CEE2;
	Wed, 23 Apr 2025 15:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421560;
	bh=m5u7Tpv+H5nUDl4EEa68gVkNGLsExaDiRte8HEfwhyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0eOrXTqX/yP5AeSChs6NZZymKRzciZ/j6HUlFiksKWCPb5kCZDNJT3LuD2/NRp6+H
	 RDACoV93vDblnB/+Beg230FI1vDvDmlPSeamIhogrDq/9bunfQFuGFbC9syNcOL1zz
	 ftvKALbdFuTAIyDnXgfw3qCnUYh6WbJvwb8+oOvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.14 181/241] drm/amd/pm: Prevent division by zero
Date: Wed, 23 Apr 2025 16:44:05 +0200
Message-ID: <20250423142627.915564516@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Arefev <arefev@swemel.ru>

commit 7d641c2b83275d3b0424127b2e0d2d0f7dd82aef upstream.

The user can set any speed value.
If speed is greater than UINT_MAX/8, division by zero is possible.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: b64625a303de ("drm/amd/pm: correct the address of Arcturus fan related registers")
Signed-off-by: Denis Arefev <arefev@swemel.ru>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
@@ -1267,6 +1267,9 @@ static int arcturus_set_fan_speed_rpm(st
 	uint32_t crystal_clock_freq = 2500;
 	uint32_t tach_period;
 
+	if (!speed || speed > UINT_MAX/8)
+		return -EINVAL;
+
 	tach_period = 60 * crystal_clock_freq * 10000 / (8 * speed);
 	WREG32_SOC15(THM, 0, mmCG_TACH_CTRL_ARCT,
 		     REG_SET_FIELD(RREG32_SOC15(THM, 0, mmCG_TACH_CTRL_ARCT),


