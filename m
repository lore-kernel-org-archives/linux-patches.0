Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDEF239085;
	Wed, 23 Apr 2025 15:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420783; cv=none; b=FrE9bhXywwx6HUf5GQAH6n7d5qJWjgewynedDe/tKlB3qRfoaSN786QgSA6S3/WH5CHV26T0dk32TN2e8UnxBZanztVCSe4DhBdWfQX++oVV3UmN/3FiYRjwmtcZFmF2IbU1moXDqtLpGe+i2GsIqt8vKpYWogsLwnIxdNk4mzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420783; c=relaxed/simple;
	bh=7iNR0lGjnr6rFgC7Qw4Bz75+XhbgjSamWyikW6B01yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LMcq2wbVs2M69efbI0rU/pDOt1MTLQ96dXy6ZGH9NeAkx8/kjo6PHZGtTGP2RDGIrczpFvlyIEytGns7ZaUs9Og27QGgS2sT2gGFDS9fHJGSca/llvtytbA9m+xZAAP6nwLpswr/2qncJ4tyQfQ+IcilQgIyWu05RLSYkh5Wzas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=utpIB1uV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="utpIB1uV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76732C4CEE2;
	Wed, 23 Apr 2025 15:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420782;
	bh=7iNR0lGjnr6rFgC7Qw4Bz75+XhbgjSamWyikW6B01yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=utpIB1uVDJ2XrSJ82Lx1qa0L+fhymUraZAnrtFR7jAgYiJ5CjUKNaLGh9Rq/B96S2
	 L8DrrPweS5pHOGC2fk64OOswDOBm//1DrpFS67jcvjBXSm6nS5T3zXNMXNlH9WnCTx
	 6o/wALPahWR1EPBNnQsvyUiEYx7057K9vhUpBTjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 162/223] drm/amd/pm/powerplay/hwmgr/vega20_thermal: Prevent division by zero
Date: Wed, 23 Apr 2025 16:43:54 +0200
Message-ID: <20250423142623.767645702@linuxfoundation.org>
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

commit 4e3d9508c056d7e0a56b58d5c81253e2a0d22b6c upstream.

The user can set any speed value.
If speed is greater than UINT_MAX/8, division by zero is possible.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 031db09017da ("drm/amd/powerplay/vega20: enable fan RPM and pwm settings V2")
Signed-off-by: Denis Arefev <arefev@swemel.ru>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_thermal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_thermal.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_thermal.c
@@ -191,7 +191,7 @@ int vega20_fan_ctrl_set_fan_speed_rpm(st
 	uint32_t tach_period, crystal_clock_freq;
 	int result = 0;
 
-	if (!speed)
+	if (!speed || speed > UINT_MAX/8)
 		return -EINVAL;
 
 	if (PP_CAP(PHM_PlatformCaps_MicrocodeFanControl)) {


