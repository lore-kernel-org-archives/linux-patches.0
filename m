Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073FB280A4F;
	Wed, 23 Apr 2025 15:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422246; cv=none; b=kg+AqkYKnM5r1u4OK2OhAUcy/vGaxfFu/dIuHUPPM3Xv3IeVLEfzJrlcfZvVTvYTOjJZNHCKWFHRw7sL4KaS8lvyyCFnepaUANT0qZ4A0b54spvchDKQDaQBF73SjStNX9KnU1EIBd+iztBFX8uKo4dYl4TvLil7l/wxzIhRIZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422246; c=relaxed/simple;
	bh=afC0hah5jFWKhLQvh9eYGmFkDkZ9XLQ2KjGlMvJ18R0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XbXo4X2l/87yYSD+MN98KR46cmUyNSVhDYPAoKxI+kawzuzxODbyeDEPDBCuHzYnDNRuV48IGOUrZQiAbrZLRENuGt0IYHitmYCDdMkBXWSwQVeT6onyqE1KaMd9yVvId9qWtlWbtiX83okYayNE0et5I/spz0mPjRGaKtrE40s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=esaG+NAu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="esaG+NAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B13C4CEE2;
	Wed, 23 Apr 2025 15:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422243;
	bh=afC0hah5jFWKhLQvh9eYGmFkDkZ9XLQ2KjGlMvJ18R0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=esaG+NAu7SdXooWzGLLJ3nt27W2R53FnnvT1VYkODNDPXxwoa4srjH7wdibxwP76s
	 Nm8t+dFGeIbwJ/nMXRCoCsaA+m1i7R146BjDfN0nSniPiDT3cC+ocfPOqJLNl/jGcM
	 ShoRbVCCRVaY0/Y/ng1woGrbM2YKfLz99FtWKXNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 234/291] drm/amd/pm: Prevent division by zero
Date: Wed, 23 Apr 2025 16:43:43 +0200
Message-ID: <20250423142633.977587135@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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
@@ -1273,6 +1273,9 @@ static int arcturus_set_fan_speed_rpm(st
 	uint32_t crystal_clock_freq = 2500;
 	uint32_t tach_period;
 
+	if (!speed || speed > UINT_MAX/8)
+		return -EINVAL;
+
 	tach_period = 60 * crystal_clock_freq * 10000 / (8 * speed);
 	WREG32_SOC15(THM, 0, mmCG_TACH_CTRL_ARCT,
 		     REG_SET_FIELD(RREG32_SOC15(THM, 0, mmCG_TACH_CTRL_ARCT),


