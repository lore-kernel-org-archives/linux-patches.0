Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8FB284685;
	Wed, 23 Apr 2025 15:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421463; cv=none; b=TD/aS159tqGIH/ct8KklZSXVVT0poQcb3kE/DxV7D3MhRkAMFNYrpSaayu6G7IHKMEFV2mCvWftkhzqLm5ucxhpJA7cwObo5VeTaVhC0YMbwY7YEkl+ScBEIt8gGfQFVIq0vi84Cakr3kMhAyt9Zoi2llksJYnLleENCv+DPyiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421463; c=relaxed/simple;
	bh=hObvrcN80T0pdg7hf1Aak3GIPqL/gMDr32qJY5DhXCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/xvh2LY0GLDFqB8X+ilh7TA+3vr5YWLtRu9ZGI3SC/o7UOZ8ypSPx+zN91xDhLb25iAGdc0MhpcCCyHT/ma6sZoYpPruKcA5NQtG4GBDOjse0sRrGg8TFC6ltGdo+3CH0D0hwAQZP8v7lpg8qh0yyntyaNodr1i74XIVPvll0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hc5HiMLn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hc5HiMLn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D1DC4CEE3;
	Wed, 23 Apr 2025 15:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421463;
	bh=hObvrcN80T0pdg7hf1Aak3GIPqL/gMDr32qJY5DhXCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hc5HiMLnA2NA9Oqp5wPsbMBxGMLOehJA0NaJQEkDodRgonlNVS95Q5KjVT6M85HKE
	 2f8LHxXmbDugsfV5YlYwYGXIgsUAifUzE0VOYJTfCH8sPR+P86krkX9p/r9PiFZMpd
	 5zxw+lTDzYTgjSO+k02lzxdVPsOLFtyf6v7FOPxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.14 184/241] drm/amd/pm/smu11: Prevent division by zero
Date: Wed, 23 Apr 2025 16:44:08 +0200
Message-ID: <20250423142628.036580856@linuxfoundation.org>
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
@@ -1200,7 +1200,7 @@ int smu_v11_0_set_fan_speed_rpm(struct s
 	uint32_t crystal_clock_freq = 2500;
 	uint32_t tach_period;
 
-	if (speed == 0)
+	if (!speed || speed > UINT_MAX/8)
 		return -EINVAL;
 	/*
 	 * To prevent from possible overheat, some ASICs may have requirement


