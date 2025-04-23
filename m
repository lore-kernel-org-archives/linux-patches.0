Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D244288CBC;
	Wed, 23 Apr 2025 15:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420749; cv=none; b=ATDyrfFEpjhZKKppf/8zd7KSfdCZaQ4ctvVxO1gnb6aYQaLUUVNm/odX9vX24D6cxWiYDzkTPggdTT8ojokXGdZXtlxGslBgUEDw+eNm2QfNEiv2Y8+pYkn7zvfV4NoXuDNCFk5NwPeqg3EIhn2NUej/hwHtL0WeF73VgieLGhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420749; c=relaxed/simple;
	bh=EmKcxj/MbhSoIoFpDf4VaWRB9a+TV5WnYS/tXzeZpbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8DZKsZ2GKA+puis20KRGkG6jSOYSDsEPqV+2ayxcmORRbncSJAexYHeTNa7TY2mLw3qRw45oVSNvmwmErJIkEovtgD/8wiNwp1KqKf3Gu79JaxG28YN1mY1+QN2UnQWyXQsb5jyPMd0D0HdST+u8UJJSfbZv2t+difQwbwq46c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lq4uFLuX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lq4uFLuX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8FF9C4CEE8;
	Wed, 23 Apr 2025 15:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420748;
	bh=EmKcxj/MbhSoIoFpDf4VaWRB9a+TV5WnYS/tXzeZpbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lq4uFLuX3frp7s/hTm/ji2G6CxIfmxLW9aq6uM3wDkLosKxVayMmyFXAhhxQNDzHX
	 a5WBAyxlVd6L0jGodcdpiGHut+2KbGJB6KdCTVNvstdRolUBBMAAm8dZ6NX1r6uhMn
	 cRLXE4yJECZIwiVR0utdgIJBdqmMSQpQIipQ74ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 159/223] drm/amd/pm/smu11: Prevent division by zero
Date: Wed, 23 Apr 2025 16:43:51 +0200
Message-ID: <20250423142623.647754155@linuxfoundation.org>
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

commit 7ba88b5cccc1a99c1afb96e31e7eedac9907704c upstream.

The user can set any speed value.
If speed is greater than UINT_MAX/8, division by zero is possible.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 1e866f1fe528 ("drm/amd/pm: Prevent divide by zero")
Signed-off-by: Denis Arefev <arefev@swemel.ru>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit da7dc714a8f8e1c9fc33c57cd63583779a3bef71)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
@@ -1199,7 +1199,7 @@ int smu_v11_0_set_fan_speed_rpm(struct s
 	uint32_t crystal_clock_freq = 2500;
 	uint32_t tach_period;
 
-	if (speed == 0)
+	if (!speed || speed > UINT_MAX/8)
 		return -EINVAL;
 	/*
 	 * To prevent from possible overheat, some ASICs may have requirement


