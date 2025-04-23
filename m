Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9B128A403;
	Wed, 23 Apr 2025 15:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420724; cv=none; b=euTWgbBscUkQv5WbPMdrE7n+G3Yvc5Xmkrxumsx8XDFMT1n78Fu+Vc5PdWmJTcHrUYApAsfkwfCQskbptbt1tPR60fZF0L8vMB+8jcrpnT7kQ0Lj9AnfBYRGywTV3p94NDA1LjXPL8WMq3bXlVjEBqcZnbclSr09IPc71Bu04wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420724; c=relaxed/simple;
	bh=oBNyR0V/j00QpJiWX0QwqfyBgWNK0uY2CLE8lS1ujlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/QiFuJ17jGjoT0Z17MKJQbNCHkoOuVHxGQIxnh564OuuPgtjta/L8SyyErIlJZYRUBqGYfv5/PKcgs63u9JRRdSEXlz1x+PYWo2Q/Uni0YmSeUj4ngLeFq5+zfiXN+EE8wrIfYRa1iYUX88URffxxV2g+N1fY6V/R4TiqGtgnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MBqpyHWz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MBqpyHWz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103A2C4CEE2;
	Wed, 23 Apr 2025 15:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420724;
	bh=oBNyR0V/j00QpJiWX0QwqfyBgWNK0uY2CLE8lS1ujlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MBqpyHWzYrDEEhaD2rwIi6JXjnnkrBec9klbkLDtAajObCoaFXcCWBJ5ZOt8D8jT2
	 6/UVYFDM3+RL6TsllpXGQxsDyIQvYlPczVPhYNw+H8lSSE6eSoL/61znWwrDUztZTK
	 swbntbeQ4782HL1nQMESclpOxE5x6VjZzRVN7w9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 157/223] drm/amd/pm: Prevent division by zero
Date: Wed, 23 Apr 2025 16:43:49 +0200
Message-ID: <20250423142623.568622871@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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


